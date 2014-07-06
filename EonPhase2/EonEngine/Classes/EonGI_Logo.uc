/* =============================================================================
:: File Name	::	EonGI_Intro.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonGI_Logo extends EonGI_Base
	HideDropDown
	CacheExempt
	config;


var config bool bPreviouslyViewed;		// If True, this intro is interruptable

function PostBeginPlay()
{
	Super.PostBeginPlay();
}

event Trigger( Actor Other, Pawn EventInstigator )
{
	local controller C;
	for(C=Level.ControllerList; C!=None; C=C.NextController)
	{
		if( EonPC_Base(C) != None )
		{
			EonPC_Base(C).ClientOpenMenu(EonPC_Base(C).MainMenu);
		}
	}
}

function AddDefaultInventory( pawn PlayerPawn )
{
	return;
}

function SetGameSpeed( Float T )
{
	GameSpeed = 1.0;
	Level.TimeDilation = 1.0;
	SetTimer(Level.TimeDilation, true);
}

function Logout( Controller Exiting )
{
	local PlayerController PC;

	PC = PlayerController(Exiting);
	if ( (PC!=None) && (PC.Player!=None) && (PC.Player.Console!=None) )
		PC.Player.Console.TimeTooIdle = PC.Player.Console.Default.TimeTooIdle;

	Super.Logout(Exiting);
}

// = PLAYER LIFESPAN ===========================================================

/* =============================================================================
:: Name		::	Login
:: Comments	::	Fails login if you set the Error string
:: Comments	::	Significant game time may pass between PreLogin and Login calls
============================================================================= */
event PlayerController Login( string Portal, string Options, out string Error )
{
	local vector			StartLocation;
	local rotator			StartRotation;
	local PlayerController	NewPlayer;

	// Find a start spot.
	StartLocation = Level.NavigationPointList.Location;
	StartRotation = Level.NavigationPointList.Rotation;

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

	return NewPlayer;
}

//
// Called after a successful login. This is the first place
// it is safe to call replicated functions on the PlayerPawn.
//
event PostLogin( PlayerController NewPlayer )
{
	local class<HUD> HudClass;

	StartMatch();

	HudClass = class<HUD>(DynamicLoadObject(HUDType, class'Class', true));
	if( HudClass == None )
		LogError( "Can't find HUD class" % HUDType );

	if( NewPlayer.Player != None && NewPlayer.Player.Console != None )
		NewPlayer.Player.Console.TimeTooIdle = 0;

	NewPlayer.ClientSetHUD( HudClass, None );
	NewPlayer.ClientCapBandwidth(NewPlayer.Player.CurrentNetSpeed);
	TriggerEvent('StartGame', NewPlayer, None);

	LogGame("New Player" @ NewPlayer.PlayerReplicationInfo.PlayerName @ "ID=" $ NewPlayer.GetPlayerIDHash());
}

function RestartPlayer( Controller C )
{
	return;
}

// = NAVIGATION NETWORK ========================================================


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	HUDType="EonEngine.EonHD_Logo"
	PlayerControllerClassName="EonEngine.EonPC_Cinematic"
	Tag=BackToMenu
}
