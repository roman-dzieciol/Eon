/* =============================================================================
:: File Name	::	EonGI_GameBase.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonGI_Base extends GameInfo
	HideDropDown
	CacheExempt
	config;

#include ../_inc/const/teams.uc

// Timing
var() int							RestartWait, CountDown;
var() float							EndTime, EndTimeDelay;

// Gameplay
var() float							FriendlyFireDamage, FriendlyFireMomentum;

// Helper Classes
var() class<AccessControl>			InitAccessControlClass;
var() class<BroadcastHandler>		InitBroadcastHandlerClass;
var() class<GameRules>				InitGameRulesClass;
var() class<HUD>					InitHUDClass;
var() class<ScoreBoard>				InitScoreBoardClass;
var() class<Security>				InitSecurityClass;
var() class<Eon_AIManager>			InitAIManagerClass;
var() class<Eon_KPManager>			InitKPManagerClass;

// Cache
var() array<EonKP_KeyPosition>		PositionHuman;
var() array<EonKP_KeyPosition>		PositionBeast;
var() array<EonKP_KeyPosition>		PositionAll;
var() array<EonKP_KeyPosition>		PositionPrimary;
var() array<Eon_CameraMan>			Cameras;

var() string						AIManagerClass;
var() string						KPManagerClass;

// Helper actors
var() Eon_AIManager					AIManager;
var() Eon_KPManager					KPManager;


var() Eon_TeamInfo					Teams[2];

var() class<Eon_TeamInfo>			TeamHumanClass;
var() class<Eon_TeamInfo>			TeamBeastClass;
var() class<Eon_TeamAI>				TeamAIClass[2];


var() int							MaxTeamSize;
var() bool							bPlayersBalanceTeams;

var() Eon_GRI						GRI;


// = LIFESPAN ==================================================================

event InitGame( string Options, out string Error )
{

	InitClasses( Options, Error );							// DLO Classes
	AddMutator(MutatorClass);								// Spawn Base Mutator
	BroadcastHandler = Spawn(InitBroadcastHandlerClass);	// Spawn Broadcast Handler
	AIManager = Spawn(InitAIManagerClass);					// Spawn AI Manager
	InitURL( Options, Error );								// Parse URL
}

function InitClasses( string Options, out string Error )
{
	// Security
	InitSecurityClass = class<Security>(DynamicLoadObject(SecurityClass,class'class'));
	vLog("Security", SecurityClass, true);
	Assert( InitSecurityClass != None );

	// HUD
	InitHUDClass = class<HUD>(DynamicLoadObject(HUDType,class'class'));
	vLog("HUD", HUDType, true);
	Assert( InitHUDClass != None );

	// ScoreBoard
	InitScoreBoardClass = class<Scoreboard>(DynamicLoadObject(ScoreBoardType,class'class'));
	vLog("ScoreBoard", ScoreBoardType, true);
	Assert( InitScoreBoardClass != None );

	// PlayerController
	PlayerControllerClass = class<PlayerController>(DynamicLoadObject(PlayerControllerClassName, class'Class'));
	vLog("PlayerController", PlayerControllerClassName, true);
	Assert( PlayerControllerClass != None );

	// BroadcastHandler
	InitBroadcastHandlerClass = class<BroadcastHandler>(DynamicLoadObject(BroadcastHandlerClass,Class'Class'));
	vLog("BroadcastHandler", BroadcastHandlerClass, true);
	Assert( InitBroadcastHandlerClass != None );

	// AccessControl
	InitAccessControlClass = class<AccessControl>(DynamicLoadObject(AccessControlClass, class'Class'));
	vLog("AccessControl", AccessControlClass, true);
	Assert( InitAccessControlClass != None );

	// AIManager
	InitAIManagerClass = class<Eon_AIManager>(DynamicLoadObject(AIManagerClass,class'class'));
	vLog("AIManager", AIManagerClass, true);
	Assert( InitAIManagerClass != None );
}

function InitURL( string Options, out string Error )
{
	local string InOpt, LeftOpt;
	local int pos;

	if( ParseURL( Options, "MaxPlayers", InOpt) )		MaxPlayers = Clamp(int(InOpt),0,32);		//#URL MaxPlayers
	if( ParseURL( Options, "MaxSpectators", InOpt) )	MaxSpectators = Clamp(int(InOpt),0,32);		//#URL MaxSpectators
	if( ParseURL( Options, "Difficulty", InOpt) )		GameDifficulty = FMax(0,int(InOpt));		//#URL Difficulty
	if( ParseURL( Options, "GameSpeed", InOpt) )		SetGameSpeed(float(InOpt));					//#URL GameSpeed

	//#URL AdminName
	//#URL AdminPassword
	if( ParseURL( Options, "AdminName", LeftOpt, true )
	&&  ParseURL( Options, "AdminPassword", InOpt, true ))
		InitAccessControlClass.default.bDontAddDefaultAdmin = true;

	AccessControl = Spawn(InitAccessControlClass);
	if( AccessControl != None && LeftOpt!="" && InOpt!="" )
		AccessControl.SetAdminFromURL(LeftOpt, InOpt);

	//#URL GamePassword
	if( ParseURL( Options, "GamePassword", InOpt) )
		AccessControl.SetGamePassWord(InOpt);

	//#URL GameRules
	if( ParseURL( Options, "GameRules", InOpt) )
	{
		while( InOpt != "" )
		{
			pos = InStr(InOpt,",");
			if( pos > 0 )
			{
				LeftOpt = Left(InOpt, pos);
				InOpt = Right(InOpt, Len(InOpt) - pos - 1);
			}
			else
			{
				LeftOpt = InOpt;
				InOpt = "";
			}

			vLog("add game rules", LeftOpt, true);
			InitGameRulesClass = class<GameRules>(DynamicLoadObject(LeftOpt, class'Class'));
			if( InitGameRulesClass != None )
			{
				if( GameRulesModifiers == None )	GameRulesModifiers = Spawn(InitGameRulesClass);
				else								GameRulesModifiers.AddGameRules(Spawn(InitGameRulesClass));
			}
		}
	}

	//#URL Mutator
	if( ParseURL( Options, "Mutator", InOpt) )
	{
		while( InOpt != "" )
		{
			pos = InStr(InOpt,",");
			if( pos > 0 )
			{
				LeftOpt = Left(InOpt, pos);
				InOpt = Right(InOpt, Len(InOpt) - pos - 1);
			}
			else
			{
				LeftOpt = InOpt;
				InOpt = "";
			}
			vLog("Add mutator", LeftOpt);
			AddMutator(LeftOpt, true);
		}
	}
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

function AddDefaultInventory( Pawn P )
{
	local Weapon		NewWeapon;
	local class<Weapon>	WeapClass;

	LogClass("AddDefaultInventory" @ P);
	Eon_Pawn(P).AddDefaultInventory();

	// Spawn default weapon.
	WeapClass = BaseMutator.GetDefaultWeapon();
	if( WeapClass != None && P.FindInventoryType( WeapClass ) == None )
	{
		NewWeapon = Spawn(WeapClass,,,P.Location);
		if( NewWeapon != None )
		{
			NewWeapon.GiveTo(P);
			NewWeapon.BringUp();
		}
	}
	SetPlayerDefaults(P);
}

// = NAVIGATION NETWORK ========================================================

function EonKP_KeyPosition StartPositionFind
(
	Controller					Player,
	optional byte				InTeam,
	optional string				IncomingName,
	optional class<Eon_Pawn>	P
)
{
	local array<EonKP_KeyPosition>	Positions;
	local EonKP_KeyPosition			BestPosition;
	local float						BestRating, NewRating;
	local int 						i;

//	Log(Player @ InTeam @ IncomingName @ Player.PlayerReplicationInfo @ Player.PlayerReplicationInfo.Team );
	if( Player == None
	||	Player.PlayerReplicationInfo == None
	||	Player.PlayerReplicationInfo.Team == None )
		InTeam = TEAM_Neutral;

	switch( InTeam )
	{
		case TEAM_Human:		Positions = PositionHuman;		break;
		case TEAM_Beast:		Positions = PositionBeast;		break;
		case TEAM_Neutral:		Positions = PositionPrimary;	break;
		default:				LogError("FindPlayerStart InTeam =" @ InTeam);
	}

	for(i=0; i<Positions.Length; i++)
	{
		if( StartPositionRate(Positions[i], InTeam, NewRating, P) && NewRating > BestRating )
		{
			BestPosition = Positions[i];
			BestRating = NewRating;
		}
	}

	if( BestPosition == None )
		LogError("No available positions for team" @ InTeam);

	return BestPosition;
}

function bool StartPositionRate( EonKP_KeyPosition KP, byte InTeam, out float Rating, optional class<Eon_Pawn> P )
{
	if( InTeam != TEAM_Neutral && InTeam != KP.Ownership )		return false;
	if( !KP.ValidPawnClass(P) )									return false;

	Rating = 0;
	Rating += FRand();
	Rating += KP.SpawnPriority;

	return true;
}


// == GAME_Starting ============================================================

auto state GAME_Starting
{
	function RestartPlayer( Controller aPlayer )
	{
		//if( GameReplicationInfo.bMatchHasBegun )
		//	Super.RestartPlayer(aPlayer);
	}

	function Timer()
	{
		Global.Timer();

		GameReplicationInfo.ElapsedTime++;
		CountDown--;

		if( CountDown <= 0 )
			StartMatch();
	}

	function BeginState()
	{
		bWaitingToStartMatch = true;
		CountDown = Default.CountDown;
	}
}


// == GAME_Running =============================================================

state GAME_Running
{
	function Timer()
	{
		Global.Timer();
		GameReplicationInfo.ElapsedTime++;
	}

	function BeginState()
	{
		local PlayerReplicationInfo PRI;

		ForEach DynamicActors(class'PlayerReplicationInfo',PRI)
			PRI.StartTime = 0;

		GameReplicationInfo.ElapsedTime = 0;
		bWaitingToStartMatch = false;
	}
}

// == GAME_Ended ===============================================================

state GAME_Ended
{
	function RestartPlayer( Controller aPlayer ) {}
	function ScoreKill(Controller Killer, Controller Other) {}
	function int ReduceDamage( int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
	{
		return 0;
	}

	function bool ChangeTeam(Controller Other, int num, bool bNewTeam)
	{
		return false;
	}

	function Timer()
	{
		Global.Timer();
		if( !bGameRestarted && (Level.TimeSeconds > EndTime + RestartWait) )
			RestartGame();
	}

	function BeginState()
	{
		GameReplicationInfo.bStopCountDown = true;
	}
}


// = URL =======================================================================

function bool ParseURL( string Options, string InKey, out string Result, optional bool bQuiet )
{
	local string Pair, Key, Value;
	while( GrabOption( Options, Pair ) )
	{
		GetKeyValue( Pair, Key, Value );
		if( Key ~= InKey )
		{
			Result = Value;
			if( !bQuiet )
				vLog("URL"@InKey, Value);
			return true;
		}
	}
	return false;
}


// = CACHE =====================================================================

function Register( Actor A )
{
	if( EonKP_KeyPosition(A) != None )
	{
		PositionAll[PositionAll.Length] = EonKP_KeyPosition(A);
		if( EonKP_PositionPrimary(A) != None )				PositionPrimary[PositionPrimary.Length]	= EonKP_PositionPrimary(A);
		if( EonKP_KeyPosition(A).Ownership == TEAM_Human )	PositionHuman[PositionHuman.Length]		= EonKP_KeyPosition(A);
		if( EonKP_KeyPosition(A).Ownership == TEAM_Beast )	PositionBeast[PositionBeast.Length]		= EonKP_KeyPosition(A);

		return;
	}

	//LogError("Register() ::" @ A.class.name);
}

function RegisterCameraMan( Eon_CameraMan A )
{
	Cameras[Cameras.Length] = A;
}


// = INC =======================================================================


simulated final function LogClass	( coerce string S ){ Log(S@"["$Name$"]", 'GI');}
#include ../_inc/func/string.uc
#include ../_inc/debug/Log.uc
#include ../_inc/func/rand.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	// Engine.GameInfo
	bRestartLevel=false
	bPauseable=false
	bWeaponStay=false
	bCanChangeSkin=false
	bTeamGame=true
	bCanViewOthers=true
	bDelayedStart=false
	bWaitingToStartMatch=false
	bChangeLevels=false
	bLoggingGame=false
	bEnableStatLogging=false
	bAllowWeaponThrowing=false
	bAllowBehindView=true
	bAdminCanPause=true
	bWeaponShouldViewShake=false
	bModViewShake=false
	bForceClassicView=false

	GameDifficulty=6
	GoreLevel=0
	AutoAim=1
	GameSpeed=1

	MutatorClass="EonEngine.Eon_MutBase"
	AccessControlClass="EonEngine.Eon_AccessControl"
	BroadcastHandlerClass="EonEngine.Eon_BroadcastHandler"
	PlayerControllerClassName="EonEngine.EonPC_Player"
	DefaultPlayerClassName="EonEngine.Eon_Pawn"
	ScoreBoardType="EonEngine.Eon_ScoreBoard"
	MapListType="EonEngine.Eon_MapList"
	HUDType="EonEngine.Eon_HUD"
	SecurityClass="EonEngine.Eon_Security"
	AIManagerClass="EonEngine.Eon_AIManager"

	MaxSpectators=32
	MaxPlayers=32

	MapPrefix="EON"
	BeaconName="EON"
	GameName"Eon Game"
	OtherMesgGroup="EonGame"
	DefaultPlayerName="EonPlayer"

	GameMessageClass=class'Engine.GameMessage'
	DeathMessageClass=class'Engine.LocalMessage'
	GameReplicationInfoClass=class'EonEngine.Eon_GRI'

	// EonGI_GameBase
}
