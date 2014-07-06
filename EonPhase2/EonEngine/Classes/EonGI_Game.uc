/* =============================================================================
:: File Name	::	EonGI_Game.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonGI_Game extends EonGI_Base;

// = INVENTORY =================================================================





// = DAMAGE ====================================================================

function Killed( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
	if( Killer != None && Killer.bIsPlayer && Killed != None && Killed.bIsPlayer)
	{
		DamageType.static.IncrementKills(Killer);
	}
	Super.Killed(Killer, Killed, KilledPawn, damageType);
}


function int ReduceDamage( int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	local TeamInfo InjuredTeam, InstigatorTeam;

	if( instigatedBy == None )
		return Super.ReduceDamage( Damage,injured,instigatedBy,HitLocation,Momentum,DamageType );

	InjuredTeam = Injured.GetTeam();
	InstigatorTeam = InstigatedBy.GetTeam();
	if( instigatedBy != injured )
	{
		if( InjuredTeam != None && InstigatorTeam != None )
		{
			if( InjuredTeam == InstigatorTeam )
			{
				Momentum *= FriendlyFireMomentum;
				if( Bot(injured.Controller) != None )
					Bot(Injured.Controller).YellAt(instigatedBy);
				if( FriendlyFireDamage == 0 )
				{
					if( GameRulesModifiers != None )	return GameRulesModifiers.NetDamage( Damage, 0,injured,instigatedBy,HitLocation,Momentum,DamageType );
					else								return 0;
				}
				Damage *= FriendlyFireDamage;
			}
		}
	}
	Damage = Super.ReduceDamage( Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType );

	return (Damage * instigatedBy.DamageScaling);
}


// = SPECTATING ================================================================

function bool CanSpectate( PlayerController Viewer, bool bOnlySpectator, actor ViewTarget )
{
	if( ViewTarget == None )
		return false;

	if( Controller(ViewTarget) != None )
		return((Controller(ViewTarget).PlayerReplicationInfo != None) && !Controller(ViewTarget).PlayerReplicationInfo.bOnlySpectator );

	return( Level.NetMode == NM_Standalone || bOnlySpectator );
}


// = TEAM ======================================================================

function bool ChangeTeam(Controller Other, int num, bool bNewTeam)
{
	local TeamInfo	NewTeam;
	local Eon_PRI	PRI;

	PRI = Eon_PRI(Other.PlayerReplicationInfo);

	if( Other.IsA('PlayerController') && ( PRI.bOnlySpectator || num == TEAM_Neutral ))
	{
		if( PRI.Team != None )
			PRI.Team.RemoveFromTeam(Other);

		PRI.bIsSpectator = true;
		PRI.Team = None;
		return true;
	}

	NewTeam = Teams[ PickTeam(num,Other) ];

	if( NewTeam.Size >= MaxTeamSize )		return false;	// no room on either team
	if( PRI.Team == NewTeam )				return false;	// yeah right

	if( PRI.Team != None )
		PRI.Team.RemoveFromTeam(Other);

	if( NewTeam.AddToTeam(Other) )
	{
		PRI.bIsSpectator = false;
		BroadcastLocalizedMessage( GameMessageClass, 3, PRI, None, NewTeam );
	}

	return true;
}

function byte PickTeam( byte num, Controller C )
{
	local Eon_TeamInfo	SmallTeam, BigTeam, NewTeam;
	local Controller	B;
	local bool			bForceSmall;

	// Deathmatch.PickTeam

	SmallTeam = Teams[0];
	BigTeam = Teams[1];

	if( SmallTeam.Size > BigTeam.Size )
	{
		SmallTeam = Teams[1];
		BigTeam = Teams[0];
	}

	if( num < TEAM_Neutral )
		NewTeam = Teams[num];

	if( bPlayersBalanceTeams && SmallTeam.Size < BigTeam.Size && (Level.NetMode != NM_Standalone || PlayerController(C) == None) )
	{
		bForceSmall = true;
		// if any bots on big team, no need to go on small team
		for( B=Level.ControllerList; B!=None; B=B.NextController )
		{
			if( B.PlayerReplicationInfo != None
			&&  B.PlayerReplicationInfo.bBot
			&&  B.PlayerReplicationInfo.Team == BigTeam )
			{
				bForceSmall = false;
				break;
			}
		}
		if( bForceSmall )
			NewTeam = SmallTeam;
	}

	if( NewTeam == None || NewTeam.Size >= MaxTeamSize )
		NewTeam = SmallTeam;

	return NewTeam.TeamIndex;
}

function bool ShouldRespawn(Pickup Other)
{
	return false;
}


// = LIFESPAN ==================================================================

event PreBeginPlay()
{
	SetGameSpeed(GameSpeed);
	GameReplicationInfo = Spawn(GameReplicationInfoClass);
	InitGameReplicationInfo();
	InitLogging();
	InitKarma();
}

event PostBeginPlay()
{
	Teams[0] = Spawn( TeamHumanClass );
	Teams[1] = Spawn( TeamBeastClass );

	Teams[0].AI = Spawn( TeamAIClass[0] );
	Teams[1].AI = Spawn( TeamAIClass[1] );

	Teams[0].AI.Team = Teams[0];
	Teams[1].AI.Team = Teams[1];

	Teams[0].AI.EnemyTeam = Teams[1];
	Teams[1].AI.EnemyTeam = Teams[0];

	GameReplicationInfo.Teams[0] = Teams[0];
	GameReplicationInfo.Teams[1] = Teams[1];

//	KPManager.SetTimer(5, true);

	Super.PostBeginPlay();
}

function StartMatch()
{
	local Actor A;
	local Controller P;

	GotoState('GAME_Running');

	// Notify GameStats
	if( GameStats != None)
		GameStats.StartGame();

	// Notify All Actors
	ForEach AllActors(class'Actor', A)
		A.MatchStarting();

	// Start Players
	for( P = Level.ControllerList; P!=None; P=P.nextController )
		if( P.IsA('PlayerController') && (P.Pawn == None) )
		{
			if( PlayerController(P).CanRestartPlayer()  )
				RestartPlayer(P);
		}

	bWaitingToStartMatch = false;
	GameReplicationInfo.bMatchHasBegun = true;
}

function RestartGame()
{
	local string NextMap;
	local MapList MyList;

	LogGame("Restart");

	if((GameRulesModifiers != None) && GameRulesModifiers.HandleRestartGame())
		return;

	// still showing end screen
	if( EndTime > Level.TimeSeconds )
		return;

	// called only once
	if( bGameRestarted )	return;
	else					bGameRestarted = true;

	// next level
	// these server travels should all be relative to the current URL
	if( bChangeLevels && !bAlreadyChanged && (MapListType != "") )
	{
		// open a the nextmap actor for this game type and get the next map
		bAlreadyChanged = true;
		MyList = GetMapList(MapListType);
		if( MyList != None )
		{
			NextMap = MyList.GetNextMap();
			MyList.Destroy();
		}
		if( NextMap == "" )
			NextMap = GetMapName(MapPrefix, NextMap,1);

		if( NextMap != "" )
		{
			Level.ServerTravel(NextMap, false);
			return;
		}
	}

	// restart level
	Level.ServerTravel( "?Restart", false );
}

function EndGame(PlayerReplicationInfo Winner, string Reason )
{
	LogGame("End");

	// don't end game if not really ready
	if( !CheckEndGame(Winner, Reason) )
	{
		bOverTime = true;
		return;
	}

	bGameEnded = true;
	TriggerEvent('EndGame', self, None);
	EndLogging(Reason);

	GotoState('GAME_Ended');
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	local Controller P;

	if( GameRulesModifiers != None && !GameRulesModifiers.CheckEndGame(Winner, Reason))
		return false;

	EndTime = Level.TimeSeconds + EndTimeDelay;

	for( P=Level.ControllerList; P!=None; P=P.NextController )
	{
		P.ClientGameEnded();
		P.GameHasEnded();
	}

	return true;
}

function Reset()
{
	LogGame("Reset");

	bGameEnded = false;
	bOverTime = false;
	bWaitingToStartMatch = true;
	InitGameReplicationInfo();

	GameReplicationInfo.ElapsedTime = 0;
	CountDown = Default.Countdown;

	GotoState('GAME_Starting');
}



// = RI ========================================================================

function InitGameReplicationInfo()
{
	local int i;

	GRI = Eon_GRI(GameReplicationInfo);
	GRI.bTeamGame = bTeamGame;
	GRI.GameName = GameName;
	GRI.GameClass = string(Class);
	GRI.MaxLives = MaxLives;

	for(i=0; i<PositionPrimary.Length; i++)	GRI.AddKP( PositionPrimary[i] );
}




// = KARMA =====================================================================

function InitKarma()
{
	Level.MaxRagdolls = 255;
}







// = PLAYER LIFESPAN ===========================================================

/* =============================================================================
:: Name		::	Login
:: Comments	::	Fails login if you set the Error string
:: Comments	::	Significant game time may pass between PreLogin and Login calls
============================================================================= */
event PlayerController Login( string Portal, string Options, out string Error )
{
	local string			InName, InAdminName, InPassword, InChecksum;
	local byte				InTeam;
	local bool				bSpectator, bAdmin;
	local vector			StartLocation;
	local rotator			StartRotation;
	local EonKP_KeyPosition	StartPosition;
	local PlayerController	NewPlayer;

//	bSpectator = ( ParseOption( Options, "SpectatorOnly" ) ~= "true" );
	bAdmin = AccessControl.CheckOptionsAdmin(Options);

	// Make sure there is capacity except for admins. (This might have changed since the PreLogin call).
	if( !bAdmin && AtCapacity(bSpectator) )
	{
		Error = GameMessageClass.Default.MaxedOutMessage;
		return None;
	}

	// If admin and server is already full of reg. players, force spectate mode
	if( bAdmin && AtCapacity(false) )
		bSpectator = true;

	BaseMutator.ModifyLogin(Portal, Options);

	// Get URL options.
	InName     	= Left(ParseOption ( Options, "Name"), 20);
	InAdminName	= ParseOption ( Options, "AdminName");
	InPassword 	= ParseOption ( Options, "Password" );
	InChecksum 	= ParseOption ( Options, "Checksum" );
	InTeam		= TEAM_Neutral;

	if( bAdmin )	LogGame( "Login Admin [" $ InName $ "]" );
	else			LogGame( "Login Player [" $ InName $ "]" );

	// Find a start spot.
	StartPosition = StartPositionFind( None, InTeam, Portal );
	StartLocation = StartPosition.GetStartLocation( None );
	StartRotation = StartPosition.GetStartRotation();

	// Spawn PlayerController
	NewPlayer = spawn(PlayerControllerClass,,, StartLocation, StartRotation );
	if( NewPlayer == None )
	{
		LogError("Couldn't spawn player controller of class" @ PlayerControllerClass);
		Error = GameMessageClass.Default.FailedSpawnMessage;
		return None;
	}

	// Init player
	NewPlayer.GameReplicationInfo = GameReplicationInfo;

	// Apply security to this controller
	NewPlayer.PlayerSecurity = Spawn(InitSecurityClass,NewPlayer);
	if( NewPlayer.PlayerSecurity == None )
		LogError("Could not spawn security for player "$NewPlayer);

	// Set default state
	if( bAttractCam )	NewPlayer.GotoState('AttractMode');
	else				NewPlayer.GotoState('Spectating');

	// Init player's name
	if( InName == "" )
		InName = DefaultPlayerName;

	if( Level.NetMode != NM_Standalone || NewPlayer.PlayerReplicationInfo.PlayerName == DefaultPlayerName )
		ChangeName( NewPlayer, InName, false );

	if( bSpectator || NewPlayer.PlayerReplicationInfo.bOnlySpectator )
	{
		NewPlayer.PlayerReplicationInfo.bOnlySpectator = true;
		NewPlayer.PlayerReplicationInfo.bIsSpectator = true;
		NewPlayer.PlayerReplicationInfo.bOutOfLives = true;
		NewPlayer.PlayerReplicationInfo.PlayerID = CurrentID++;
		NumSpectators++;
		return NewPlayer;
	}

	// Init player's administrative privileges and log it
	if( AccessControl.AdminLogin(NewPlayer, InAdminName, InPassword) )
		AccessControl.AdminEntered(NewPlayer, InAdminName);

	// Set the player's ID.
	NewPlayer.PlayerReplicationInfo.PlayerID = CurrentID++;

	NumPlayers++;
	bWelcomePending = true;

	// everyone starts as waiting player
	NewPlayer.GotoState('Spectating');

	return NewPlayer;
}

//
// Called after a successful login. This is the first place
// it is safe to call replicated functions on the PlayerPawn.
//
event PostLogin( PlayerController NewPlayer )
{
	local class<HUD> HudClass;
	local class<Scoreboard> ScoreboardClass;
	local String SongName;

	// Log player's login.
	if (GameStats != None)
	{
		GameStats.ConnectEvent(NewPlayer.PlayerReplicationInfo);
		GameStats.GameEvent("NameChange",NewPlayer.PlayerReplicationInfo.playername,NewPlayer.PlayerReplicationInfo);
	}

	if( !bDelayedStart )
	{
		// start match, or let player enter, immediately
		bRestartLevel = false;  // let player spawn once in levels that must be restarted after every death
		if( bWaitingToStartMatch )	StartMatch();
		else						RestartPlayer(newPlayer);
		bRestartLevel = Default.bRestartLevel;
	}

	// Start player's music.
	SongName = Level.Song;
	if( SongName != "" && SongName != "None" )
//        NewPlayer.ClientSetMusic( SongName, MTRAN_Fade );
		NewPlayer.ClientSetInitialMusic( SongName, MTRAN_Fade );

	// tell client what hud and scoreboard to use

	if( HUDType == "" )
		log( "No HUDType specified in GameInfo", 'Log' );
	else
	{
		HudClass = class<HUD>(DynamicLoadObject(HUDType, class'Class'));
		if( HudClass == None )
			log( "Can't find HUD class "$HUDType, 'Error' );
	}

	if( ScoreBoardType == "" )
		log( "No ScoreBoardType specified in GameInfo", 'Log' );
	else
	{
		ScoreboardClass = class<Scoreboard>(DynamicLoadObject(ScoreBoardType, class'Class'));

		if( ScoreboardClass == None )
			log( "Can't find ScoreBoard class "$ScoreBoardType, 'Error' );
	}
	NewPlayer.ClientSetHUD( HudClass, ScoreboardClass );
	SetWeaponViewShake(NewPlayer);
	if ( bForceClassicView )
		NewPlayer.ClientSetClassicView();
	if ( NewPlayer.Pawn != None )
		NewPlayer.Pawn.ClientSetRotation(NewPlayer.Pawn.Rotation);

	NewPlayer.ClientCapBandwidth(NewPlayer.Player.CurrentNetSpeed);


	LogGame("New Player" @ NewPlayer.PlayerReplicationInfo.PlayerName @ "ID=" $ NewPlayer.GetPlayerIDHash());
}

function RestartPlayer( Controller C )
{
	local int					TeamNum;
	local vector				StartLocation;
	local rotator				StartRotation;
	local Eon_PRI				PRI;
	local EonPC_Base			PC;
	local EonKP_KeyPosition		KP;
	local class<Eon_Pawn>		NewPawn;

	LogGame("RestartPlayer" @ C);

	// do not respawn while restarting level in sp
	if( bRestartLevel
	&&	Level.NetMode != NM_DedicatedServer
	&&	Level.NetMode != NM_ListenServer )
		return;

	// do not respawn spectators
	if( C.PlayerReplicationInfo == None
	||	C.PlayerReplicationInfo.Team == None
	||	C.PlayerReplicationInfo.Team.TeamIndex == TEAM_Neutral )
	{
		TeamNum = TEAM_Neutral;
		return;
	}
	else
	{
		PRI		= Eon_PRI(C.PlayerReplicationInfo);
		TeamNum = PRI.Team.TeamIndex;
		PC		= EonPC_Base(C);
		NewPawn	= PC.PawnClassGet();
	}


	if( C.PreviousPawnClass != None && C.PawnClass != C.PreviousPawnClass )
		BaseMutator.PlayerChangedClass(C);

	if( PC.bSquadSpawn )
	{
	}
	else
	{
		// Use selected position for respawning or find new one
		KP = PC.StartPosition;
		if( KP == None )
		{
			KP = StartPositionFind( C, TeamNum,, NewPawn );
			PC.StartPosition = KP;
		}

		// Make sure there's enough supplies
		if( !KP.SuppliesAvailable( NewPawn.default.SpawnCost ) )
		{
			LogError("Not enough supplies for" @ NewPawn @ "at" @ KP);
			C.GotoState('Dead');
			return;
		}

		StartLocation = KP.GetStartLocation( NewPawn );
		StartRotation = KP.GetStartRotation();
	}

	// Spawn the pawn
	C.Pawn = Spawn( NewPawn,,, StartLocation, StartRotation);
	if( C.Pawn == None )
	{
		LogError("Couldn't spawn player of type" @ NewPawn @ "at" @ KP);
		C.GotoState('Dead');
		return;
	}

	KP.UseSupplies( NewPawn.default.SpawnCost );

	C.Pawn.LastStartTime = Level.TimeSeconds;
	C.PreviousPawnClass = C.Pawn.Class;
	C.Possess(C.Pawn);
	C.PawnClass = C.Pawn.Class;
	C.Pawn.PlayTeleportEffect(true, true);
	C.ClientSetRotation(C.Pawn.Rotation);

	AddDefaultInventory(C.Pawn);
}


// = PLAYER ====================================================================

function ChangeName(Controller Other, string S, bool bNameChange)
{
	if( S == "" )												return;
	if( Other.PlayerReplicationInfo.PlayerName ~= S )			return;

	S = Left(S,20);				// max 20 chars
	ReplaceText(S, " ", "_");	// replace spaces with underscores

	// change the name
	Other.PlayerReplicationInfo.SetPlayerName(S);
}

function class<Pawn> GetDefaultPlayerClass(Controller C)
{
	return( class<Pawn>( DynamicLoadObject( DefaultPlayerClassName, class'Class' ) ) );
}




/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	GameName="Eon"
	Acronym="EON"
	MapPrefix="EON"
	Description="Eon"

	// EonEngine.GameBase
	CountDown=1
	RestartWait=30
	EndTimeDelay=4

	// EonEngine.GameInfo

	TeamHumanClass=class'EonEngine.Eon_TeamHuman'
	TeamBeastClass=class'EonEngine.Eon_TeamBeast'
	TeamAIClass(0)=class'EonEngine.Eon_TeamAIHuman'
	TeamAIClass(1)=class'EonEngine.Eon_TeamAIBeast'

	MaxTeamSize=16

	FriendlyFireDamage=1
	FriendlyFireMomentum=1
}
