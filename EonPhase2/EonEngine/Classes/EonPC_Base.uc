/* =============================================================================
:: File Name	::	Eon_PlayerBase.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPC_Base extends PlayerController;

#include ../_inc/const/teams.uc
#include ../_inc/const/viewmodes.uc


var() private transient Eon_PlayerInput		EonPlayerInput;
var() private transient Eon_CheatManager	EonCheatManager;


var() bool					bEyeCam;
var() bool					bBehindViewLast;
var() bool					bBehindViewTemp;
var() transient Eon_Pawn	LastViewTarget;

var() string			MainMenu;
var() string			MidGameMenu;
var() string			ErrorMenu;
var() bool				bForceLoginMenu;
var() bool				bReadyToStart;
var() bool				bDontShowLoginMenu;


var() transient EonGI_Base			EonGame;
var() transient Eon_AIManager		AIManager;

var() transient EonIN_Map			EonMap;
var() transient EonIN_Cmd			EonCmd;
var() transient EonIN_Use			EonUse;
var() transient Eon_HUDBase			EonHUD;
var() transient EonIN_Camera		EonCam;

var() bool									bSquadSpawn;
var() transient EonKP_KeyPosition			StartPosition;
var() transient array< class<Eon_Pawn> >	PlayerClasses;
var() transient byte						PlayerClass;

var() class<Eon_MoveControl>		MoveControlDefaultClass;
var() transient Eon_MoveControl			MoveControl;


var() float			TurnLimit, aBaseYLast;
var() bool			bMantleAdjusted;




// = REPLICATION ===============================================================

replication
{
	reliable if ( Role == ROLE_Authority )
		PlayerClassesResetClient,
		PlayerClassesGetClient,
		PlayerClassSetClient
		;

	reliable if ( Role < ROLE_Authority )
		UseSelectedServer,
		PlayerClassSetServer
		;
}

simulated event PostNetReceive()
{
	if( PlayerReplicationInfo != None )
	{
		bNetNotify = false;
		bReadyToStart = true;
		ShowLoginMenu();
	}
}


// = LIFETIME ==================================================================

event PostBeginPlay()
{
	Super.PostBeginPlay();

	// Init references
	EonGame = EonGI_Base(Level.Game);
}


simulated event Destroyed()
{
	LogPlayer("Destroyed");
	PlayerClasses.Remove(0, PlayerClasses.Length);

	MoveControl	= None;

	//EonPlayerInput	= None;
	//EonCheatManager	= None;

	EonGame		= None;
	AIManager	= None;

	EonMap	= None;
	EonCmd	= None;
	EonUse	= None;

	EonHUD	= None;
	LastViewTarget	= None;

	Super.Destroyed();
}


// = PAWN ======================================================================

function Possess( Pawn P )
{
	if( PlayerReplicationInfo.bOnlySpectator )
		return;

	ResetFOV();
	P.PossessedBy(self);
	Pawn = P;
	Pawn.bStasis = false;
	TimeMargin = -0.1;
	CleanOutSavedMoves();
	ServerSetHandedness( Handedness );
	ServerSetAutoTaunt( bAutoTaunt );
	Restart();

	Eon_Pawn(P).Setup();
	Eon_Pawn(P).NotifyBehindView( bBehindView );
	bBehindViewLast = bBehindView;
}

function UnPossess()
{
	//LogPlayer("UnPossess" @ Pawn);
	if( Pawn != None )
	{
		SetLocation(Pawn.Location);
		Pawn.RemoteRole = ROLE_SimulatedProxy;
		Pawn.UnPossessed();
		CleanOutSavedMoves();
		if( Viewtarget == Pawn )
			SetViewTarget(self);
	}
	Pawn = None;
	GotoState('Spectating');
}


function PawnDied(Pawn P)
{
	if( P != Pawn )		return;
	if( Pawn != None )	Pawn.RemoteRole = ROLE_SimulatedProxy;
	EndZoom();
	Super(Controller).PawnDied(P);
}


// = TEAM ======================================================================

function ServerChangeTeam( int N )
{
	local TeamInfo OldTeam;

	OldTeam = PlayerReplicationInfo.Team;
	Level.Game.ChangeTeam(self, N, true);
	if( Level.Game.bTeamGame && PlayerReplicationInfo.Team != OldTeam )
	{
		if( Pawn != None )
			Pawn.PlayerChangedTeam();

		if( PlayerReplicationInfo.Team != None )
		{
			GotoState('PlayerWaiting');
			ServerRestartPlayer();
		}
	}
}


// = INPUT =====================================================================

event InitInputSystem()
{
	local PlayerInput PI;
	Super.InitInputSystem();

	//LogPlayer("InitInputSystem");
	foreach AllObjects(class'PlayerInput', PI)
	{
		EonPlayerInput = Eon_PlayerInput(PI);
		LogPlayer("Input" @ PI.class);
	}

	InitGUI();
}

function AddCheats()
{
	local CheatManager CM;
	Super.AddCheats();
	if( EonCheatManager == None && Level.NetMode == NM_Standalone )
	{
		foreach AllObjects(class'CheatManager', CM)
		{
			EonCheatManager = Eon_CheatManager(CM);
			LogPlayer("CheatManager" @ CM.class);
		}
	}
}

/*event PlayerTick( float DeltaTime )
{
	if( bForcePrecache )
	{
		if( Level.TimeSeconds > ForcePrecacheTime )
		{
			bForcePrecache = false;
			Level.FillPrecacheMaterialsArray( false );
			Level.FillPrecacheStaticMeshesArray( false );
		}
	}
	else if( !bShortConnectTimeOut )
	{
		bShortConnectTimeOut = true;
		ServerShortTimeout();
	}

	if( Pawn != AcknowledgedPawn )
	{
		if( Role < ROLE_Authority )
		{
			// make sure old pawn controller is right
			if( AcknowledgedPawn != None && AcknowledgedPawn.Controller == self )
				AcknowledgedPawn.Controller = None;
		}
		AcknowledgePossession(Pawn);
	}

	PlayerInput.PlayerInput(DeltaTime);

	//OnAdjustInput();

	if( bUpdatePosition )
		ClientUpdatePosition();

	if( !IsSpectating() && Pawn != None )
		Pawn.RawInput(DeltaTime, aBaseX, aBaseY, aBaseZ, aMouseX, aMouseY, aForward, aTurn, aStrafe, aUp, aLookUp);

	PlayerMove(DeltaTime);
}*/


// = MENU ======================================================================



exec function ShowMenu()
{
	if( !bReadyToStart )	return;
	//if( Level.Pauser == None )	SetPause(true);		// Pause if not already
	StopForceFeedback();  							// jdf - no way to pause feedback
	ClientOpenMenu( MidGameMenu );
}

simulated function ShowLoginMenu()
{
//	LogPlayer("ShowLoginMenu" @ MidGameMenu @ bReadyToStart );
	if( Level.NetMode == NM_DedicatedServer
	||( bDontShowLoginMenu && !bForceLoginMenu )
	||	MidGameMenu == ""
	|| !bReadyToStart )
		return;

	ClientOpenMenu(MidGameMenu);
}


// = CAMERA ====================================================================

simulated function ClientSetHUD(class<HUD> newHUDClass, class<Scoreboard> newScoringClass )
{
	Super.ClientSetHUD( newHUDClass, newScoringClass );
	EonHUD = Eon_HUDBase(MyHUD);
}

event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	local Eon_Pawn	PTarget;

	// Good idea.
	if( LastPlayerCalcView == Level.TimeSeconds && CalcViewActor != None && CalcViewActor.Location == CalcViewActorLocation )
	{
		ViewActor	= CalcViewActor;
		CameraLocation	= CalcViewLocation;
		CameraRotation	= CalcViewRotation;
		return;
	}


	// Find ViewTarget
	if( ViewTarget == None || ViewTarget.bDeleteMe )
	{
		if		( bViewBot && EonCheatManager != None )	EonCheatManager.ViewBot();
		else if	( Pawn != None && !Pawn.bDeleteMe )		SetViewTarget(Pawn);
		else if	( RealViewTarget != None )				SetViewTarget(RealViewTarget);
		else											SetViewTarget(self);
	}


	if( Pawn != None )	PTarget = Eon_Pawn(Pawn);
	else				PTarget = Eon_Pawn(ViewTarget);

	// Notify pawn if no longer ViewTarget
	if( PTarget != LastViewTarget && LastViewTarget != None )
	{
		LastViewTarget.NotifyBehindView(true);
	}
	LastViewTarget = PTarget;

	// Notify pawn if bBehindView has changed
	if( bBehindViewLast != bBehindView && PTarget != None )
	{
		PTarget.NotifyBehindView( bBehindView );
		bBehindViewLast = bBehindView;
	}


	ViewActor = ViewTarget;
	CameraLocation = ViewTarget.Location;

	// View my pawn
	if( ViewTarget == Pawn )
	{
		if( bBehindView )		CalcBehindView( CameraLocation, CameraRotation, CameraDist * Pawn.Default.CollisionRadius);
		else					CalcFirstPersonView( CameraLocation, CameraRotation );
		CacheCalcView( ViewActor, CameraLocation, CameraRotation );
		return;
	}

	// View self
	if( ViewTarget == self )
	{
		if( bCameraPositionLocked )	CameraRotation = EonCheatManager.LockedRotation;
		else						CameraRotation = Rotation;
		CacheCalcView( ViewActor, CameraLocation, CameraRotation );
		return;
	}

	// View projectile
	if( ViewTarget.IsA('Projectile') && !bBehindView )
	{
		CameraLocation += (ViewTarget.CollisionHeight) * vect(0,0,1);
		CameraRotation = Rotation;
		CacheCalcView( ViewActor, CameraLocation, CameraRotation );
		return;
	}

	CameraRotation = ViewTarget.Rotation;
	PTarget = Eon_Pawn(ViewTarget);

	// View unknown pawn
	if( PTarget != None )
	{
		if( Level.NetMode == NM_Client || (bDemoOwner && Level.NetMode != NM_Standalone) )
		{
			//HUD_Monitor("TargetViewRotation",TargetViewRotation,0,192,0,255,1);
			PTarget.SetViewRotation(TargetViewRotation);
			//HUD_Monitor("BlendedTargetViewRotation",BlendedTargetViewRotation,0,192,0,255,1);
			CameraRotation = BlendedTargetViewRotation;
			//HUD_Monitor("TargetEyeHeight",TargetEyeHeight,0,192,0,255,1);
			PTarget.EyeHeight = TargetEyeHeight;
		}
		else
		{
			CameraRotation = PTarget.GetViewRotation();
			//HUD_Monitor("CameraRotation",CameraRotation,0,192,0,255,1);
		}

		if( !bBehindView )
		{
			CameraLocation += PTarget.EyePosition();
			//HUD_Monitor("CameraLocation",CameraLocation,0,192,0,255,1);
		}
	}
	if( bBehindView )
	{
		CameraLocation = CameraLocation + (ViewTarget.Default.CollisionHeight - ViewTarget.CollisionHeight) * vect(0,0,1);
		CalcBehindView(CameraLocation, CameraRotation, CameraDist * ViewTarget.Default.CollisionRadius);
	}

	CacheCalcView( ViewActor, CameraLocation, CameraRotation );

//	if( PTarget != None )
//	{
		//CameraRotation = PTarget.GetViewRotation();
		//CameraLocation = CameraLocation + PTarget.EyePosition();

	/*	if ( Level.NetMode == NM_Client )
		{
			PTarget.SetViewRotation(TargetViewRotation);
			CameraRotation = BlendedTargetViewRotation;

			PTarget.EyeHeight = TargetEyeHeight;
			if ( PTarget.Weapon != None )
				PTarget.Weapon.PlayerViewOffset = TargetWeaponViewOffset;
		}
		else if ( PTarget.IsPlayerPawn() )
			CameraRotation = PTarget.GetViewRotation();
		if ( !bBehindView )
			CameraLocation += PTarget.EyePosition();*/

	/*	if( Level.NetMode == NM_Client )
		{
			PTarget.SetViewRotation(TargetViewRotation);
			CameraRotation = BlendedTargetViewRotation;
			PTarget.EyeHeight = TargetEyeHeight;
			if( PTarget.Weapon != None )
				PTarget.Weapon.PlayerViewOffset = TargetWeaponViewOffset;
		}
		else if( PTarget.IsPlayerPawn() )
			CameraRotation = PTarget.GetViewRotation();*/

	//	PTarget.SetRotation(Rotation);


	//	PTarget.SetViewRotation(PTarget.GetViewRotation());
		//TargetViewRotation = PTarget.GetViewRotation();
		//CameraRotation = PTarget.GetViewRotation();
		//TargetViewRotation = CameraRotation;
		//if( !bBehindView )
		//	CameraLocation += PTarget.EyePosition();
	//}

/*	if( bBehindView )
	{
		CameraLocation = CameraLocation + (ViewTarget.Default.CollisionHeight - ViewTarget.CollisionHeight) * vect(0,0,1);
		CalcBehindView(CameraLocation, CameraRotation, CameraDist * ViewTarget.Default.CollisionRadius);
	}*/
}



function CalcFirstPersonView( out vector CameraLocation, out rotator CameraRotation )
{
	CameraLocation = CameraLocation + Pawn.EyePosition();
}

function CalcBehindView(out vector CameraLocation, out rotator CameraRotation, float Dist)
{
	local vector View,HitLocation,HitNormal;
	local float ViewDist,RealDist;
	local vector globalX,globalY,globalZ;
	local vector localX,localY,localZ;

	CameraRotation = Rotation;
	if( Pawn != None )
	{
		Dist *= Pawn.Default.CollisionRadius;
		CameraLocation.Z += Pawn.EyePosition().Z;
	}

	// add view rotation offset to cameraview (amb)
	CameraRotation += CameraDeltaRotation;

	View = vect(1,0,0) >> CameraRotation;

	// add view radius offset to camera location and move viewpoint up from origin (amb)
	RealDist = Dist;
	Dist += CameraDeltaRad;

	if( Trace( HitLocation, HitNormal, CameraLocation - Dist * vector(CameraRotation), CameraLocation,false,vect(10,10,10) ) != None )
			ViewDist = FMin( (CameraLocation - HitLocation) Dot View, Dist );
	else	ViewDist = Dist;

	if ( !bBlockCloseCamera || !bValidBehindCamera || (ViewDist > 10 + FMax(ViewTarget.CollisionRadius, ViewTarget.CollisionHeight)) )
	{
		//Log("Update Cam ");
		bValidBehindCamera = true;
		OldCameraLoc = CameraLocation - ViewDist * View;
		OldCameraRot = CameraRotation;
	}
	else
	{
		//Log("Dont Update Cam "$bBlockCloseCamera@bValidBehindCamera@ViewDist);
		SetRotation(OldCameraRot);
	}

	CameraLocation = OldCameraLoc;
	CameraRotation = OldCameraRot;

	// add view swivel rotation to cameraview (amb)
	GetAxes(CameraSwivel,globalX,globalY,globalZ);
	localX = globalX >> CameraRotation;
	localY = globalY >> CameraRotation;
	localZ = globalZ >> CameraRotation;
	CameraRotation = OrthoRotation(localX,localY,localZ);
}

function UpdateRotation(float DeltaTime, float maxPitch)
{
	local rotator newRotation, ViewRotation;

	if ( bInterpolating || ((Pawn != None) && Pawn.bInterpolating) )
	{
		ViewShake(deltaTime);
		return;
	}

	// Added FreeCam control for better view control
	if (bFreeCam == True)
	{
		if (bFreeCamZoom == True)
		{
			CameraDeltaRad += DeltaTime * 0.25 * aLookUp;
		}
		else if (bFreeCamSwivel == True)
		{
			CameraSwivel.Yaw += 16.0 * DeltaTime * aTurn;
			CameraSwivel.Pitch += 16.0 * DeltaTime * aLookUp;
		}
		else
		{
			CameraDeltaRotation.Yaw += 32.0 * DeltaTime * aTurn;
			CameraDeltaRotation.Pitch += 32.0 * DeltaTime * aLookUp;
		}
	}
	else
	{
		ViewRotation = Rotation;

		if(Pawn != None && Pawn.Physics != PHYS_Flying) // mmmmm
		{
			// Ensure we are not setting the pawn to a rotation beyond its desired
			if(	Pawn.DesiredRotation.Roll < 65535 &&
				(ViewRotation.Roll < Pawn.DesiredRotation.Roll || ViewRotation.Roll > 0))
				ViewRotation.Roll = 0;
			else if( Pawn.DesiredRotation.Roll > 0 &&
				(ViewRotation.Roll > Pawn.DesiredRotation.Roll || ViewRotation.Roll < 65535))
				ViewRotation.Roll = 0;
		}

		DesiredRotation = ViewRotation; //save old rotation

		if ( bTurnToNearest != 0 )
			TurnTowardNearestEnemy();
		else if ( bTurn180 != 0 )
			TurnAround();
		else
		{
			TurnTarget = None;
			bRotateToDesired = false;
			bSetTurnRot = false;
			ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
			ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
		}
		if (Pawn != None)
	        ViewRotation.Pitch = Pawn.LimitPitch(ViewRotation.Pitch);

		SetRotation(ViewRotation);

		ViewShake(deltaTime);
		ViewFlash(deltaTime);

		NewRotation = ViewRotation;
		//NewRotation.Roll = Rotation.Roll;

		if ( !bRotateToDesired && (Pawn != None) && (!bFreeCamera || !bBehindView) )
			Pawn.FaceRotation(NewRotation, deltatime);
	}
}

function vector GetViewLocation()
{
	if( Pawn != None )	return Pawn.Location;
	else				return Location;
}

/*function rotator GetViewRotation()
{
	if( Pawn(ViewTarget) != None )
		return Pawn(ViewTarget).Rotation;
	return Rotation;
}*/

function rotator GetViewRotation()
{
	return Rotation;
}

function CameraFog(float DeltaTime)
{
	if( false )
	{
		Region.Zone.DistanceFogStart	= 0;
		Region.Zone.DistanceFogEnd		= 10000 * (vector(rotation) dot normal(location));
		CurrentDistanceFogEnd = Region.Zone.DistanceFogEnd;
//		ClientMessage( CurrentDistanceFogEnd @ (vector(rotation) dot normal(location)));
	}
}

// = AI ========================================================================

exec function bbb()
{
	AIManager.SetOrders( self );
}

// = USE =======================================================================

exec function Use()
{
	if( Pawn != None && Eon_Pawn(Pawn) != None )
	{
		EonUse.OnKeyPress( Eon_Pawn(Pawn) );

		if( EonUse.Selected != None )
			UseSelectedServer( EonUse.Selected );
	}
}


function UseSelectedServer( Actor Selected )
{
	if( Level.Pauser == PlayerReplicationInfo )
	{
		SetPause(false);
		return;
	}

	if( Pawn == None )		return;
	if( Selected == None )	return;

	if( EonKB_KeyBuilding(Selected) != None
	&&	TEAM_Human == Eon_Pawn(Pawn).TeamIndex
	&&	TEAM_Human == EonKB_KeyBuilding(Selected).Ownership )
	{
		EonKB_KeyBuilding(Selected).Used( self );
	}

}

// = PLAYER CLASS ==============================================================

function PlayerClassesReset( byte TeamIndex )
{
	switch( TeamIndex )
	{
	case 0:		PlayerClasses = class'Eon_TeamHuman'.default.PlayerClasses;		break;
	case 1:		PlayerClasses = class'Eon_TeamBeast'.default.PlayerClasses;		break;
	default:	PlayerClasses = class'Eon_TeamNeutral'.default.PlayerClasses;	break;
	}
//	LogPlayer("PlayerClassesReset" @ TeamIndex @ PlayerClasses.Length);
}

function PlayerClassesResetClient( byte TeamIndex )
{
//	LogPlayer("PlayerClassesResetClient" @ TeamIndex );
	PlayerClassesReset( TeamIndex );
}

function PlayerClassSet( byte B )
{
	PlayerClass = B;
//	LogPlayer("PlayerClassSet" @ B);
}

function PlayerClassSetClient( byte B )
{
//	LogPlayer("PlayerClassSetClient" @ B);
	PlayerClassSet(B);
}

function PlayerClassSetServer( byte B )
{
//	LogPlayer("PlayerClassSetServer" @ B);
	PlayerClassSet(B);
}

function array< class<Eon_Pawn> > PlayerClassesGetClient()
{
//	LogPlayer("PlayerClassesGetClient" @ PlayerClasses.Length);
	return PlayerClasses;
}

function array< class<Eon_Pawn> > PlayerClassesGet()
{
//	LogPlayer("PlayerClassesGet" @ PlayerClasses.Length);
	return PlayerClasses;
}


function class<Eon_Pawn> PawnClassGet()
{
//	LogPlayer("PawnClassGet" @ PlayerClasses.Length @ PlayerClass);
	if( PlayerClasses.Length > 0 )	return PlayerClasses[PlayerClass];
	else							return None;
}



// = HUD =======================================================================

simulated function InitGUI()
{
	LogPlayer("InitInteractions");
}

exec function ToggleUse()
{
	if( EonUse != None )	EonUse.bVisible = !EonUse.bVisible;
}

exec function ToggleCmd()
{
	if( EonCmd != None )	ClientOpenMenu("EonInterface.Eon_PageCommand");
}

exec function ToggleMap()
{
	if( EonMap != None )	EonMap.bVisible = !EonMap.bVisible;
}

exec function ShowMap( bool B )
{
	if( EonMap != None )	EonMap.bVisible = B;
}


// = MOVEMENT ==================================================================

delegate OnCalcMovement( float DeltaTime, out vector NewAccel, Eon_Pawn P );

exec function Jump( optional float F )
{
	//LogPlayer("Jump" @ F);
	if( Level.Pauser == PlayerReplicationInfo )		SetPause(False);
	else											bPressedJump = true;
}

function MoveControlCreate( class<Eon_MoveControl> C )
{
	//Log("MoveControlCreate" @ C, 'Move');
	if( MoveControl == None || MoveControl.Outer != self || MoveControl.class != C )
		MoveControl = new(self) C;

	MoveControl.Setup();
}

function Eon_ObjectPool ObjectPoolGet()
{
	local ObjectPool L;
	if( Eon_ObjectPool(Level.ObjectPool) == None )
	{
		L = new(none) class'Eon_ObjectPool';	// create new
		L.Objects = Level.ObjectPool.Objects;	// mimic
		Level.ObjectPool.Shrink();				// clear old
		Level.ObjectPool = L;					// replace
	}
	return Eon_ObjectPool(Level.ObjectPool);
}


// = STATES ====================================================================

event bool NotifyHitWall(vector HitNormal, actor Wall)
{
	return MoveControl.AdjustHitWall( HitNormal, Wall);
}

state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;



	function PlayerMove( float DeltaTime )
	{
		local vector			NewAccel;
		local eDoubleClickDir	DoubleClickMove;
		local rotator			OldRotation, ViewRotation;
		local bool				bSaveJump;

		if( Pawn == None || Eon_Pawn(Pawn) == None )
		{
			GotoState('Dead');
			return;
		}

		// Apply pawn-specific movement features
		OnCalcMovement( DeltaTime, NewAccel, Eon_Pawn(Pawn) );

		GroundPitch = 0;
		ViewRotation = Rotation;

		// Update rotation.
		SetRotation(ViewRotation);
		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1);
		bDoubleJump = false;

		if( bPressedJump && Eon_Pawn(Pawn).JumpDeferred() )
		{
			bSaveJump = true;
			bPressedJump = false;
		}
		else
		{
			bSaveJump = false;
		}


		if( Role < ROLE_Authority ) // then save this move and replicate it
				ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
		else	ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);

		bPressedJump = bSaveJump;
	}




	function BeginState()
	{
		DoubleClickDir = DCLICK_None;
	   	bPressedJump = false;
	   	GroundPitch = 0;
		if( Pawn != None )
		{
		   	if( Level.NetMode != NM_DedicatedServer)
		   	{
		   		MoveControlCreate( Eon_Pawn(Pawn).MoveControlClass );
				OnCalcMovement = MoveControl.AdjustWalking;
			}

			if( Pawn.Mesh == None )
				Pawn.SetMesh();

			Pawn.ShouldCrouch(false);
			if( Pawn.Physics != PHYS_Falling && Pawn.Physics != PHYS_Karma ) // FIXME HACK!!!
				Pawn.SetPhysics(PHYS_Walking);
		}
	 }
}


auto state PlayerWaiting
{
ignores SeePlayer, HearNoise, NotifyBump, TakeDamage, PhysicsVolumeChange, NextWeapon, PrevWeapon, SwitchToBestWeapon;

	exec function Fire(optional float F)
	{
		LoadPlayers();
		if( !bForcePrecache && (Level.TimeSeconds > 0.2) && bReadyToStart )
			ServerReStartPlayer();
	}

	function bool CanRestartPlayer()
	{
		return (bReadyToStart || Super.CanRestartPlayer());
	}

	function BeginState()
	{
		bCollideWorld = true;

		if( PlayerReplicationInfo != None )
			PlayerReplicationInfo.SetWaitingPlayer(true);
	}
}


state Dead
{
ignores SeePlayer, HearNoise, KilledBy, SwitchWeapon;

	exec function Fire( optional float F )
	{
		if( bFrozen )
		{
			if( TimerRate <= 0.0 || TimerRate > 1.0 )
				bFrozen = false;
			return;
		}
		if( PlayerReplicationInfo.Team == None )
			ServerSpectate();
		else
			Super.Fire(F);
	}

	function FindGoodView()
	{
		//Pawn.SetRotation(rotation);
	}

	function BeginState()
	{

		if( Pawn != None && Pawn.Controller == self )
			Pawn.Controller = None;
		EndZoom();
		FOVAngle = DesiredFOV;
		Pawn = None;
		Enemy = None;
		//bBehindView = false;
		bFrozen = true;
		bJumpStatus = false;
		bPressedJump = false;
		bBlockCloseCamera = false;
		bValidBehindCamera = false;
		FindGoodView();
		SetTimer(1.0, false);
		StopForceFeedback();
		ClientPlayForceFeedback("Damage");  // jdf
		CleanOutSavedMoves();
	}

Begin:
	LogPlayer("DEAD Begin");
	Sleep(3.0);
	if( ViewTarget == None || ViewTarget == self || VSize(ViewTarget.Velocity) < 1.0 )
	{
		Sleep(1.0);
		MyHUD.bShowScoreBoard = true;
	}
	else
		Goto('Begin');
}


// player is climbing an obstacle
state PlayerMantling
{
ignores SeePlayer, HearNoise, Bump;

	function bool NotifyPhysicsVolumeChange( PhysicsVolume NewVolume )
	{
		if( NewVolume.bWaterVolume )	GotoState(Pawn.WaterMovementState);
		else							GotoState(Pawn.LandMovementState);
		return false;
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
	}

	function PlayerMove( float DeltaTime )
	{
		local vector			NewAccel;
		local rotator			OldRotation, ViewRotation;
		local eDoubleClickDir	DoubleClickMove;

		if( Pawn == None || Eon_Pawn(Pawn) == None )
		{
			GotoState('Dead');
			return;
		}

		// Apply pawn-specific movement features
		OnCalcMovement( DeltaTime, NewAccel, Eon_Pawn(Pawn) );

		// Update rotation.
		ViewRotation = Rotation;
		SetRotation(ViewRotation);
		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1);

		if( Role < ROLE_Authority )		// then save this move and replicate it
				ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
		else	ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
	}



	simulated event BeginState()
	{
		LogPlayer("MANTLE BeginState" @ Pawn.Physics);
	   	if( Level.NetMode != NM_DedicatedServer)
	   	{
	   		MoveControlCreate( Eon_Pawn(Pawn).MoveControlClass );
			OnCalcMovement = MoveControl.AdjustMantling;
		}

		Pawn.ShouldCrouch(false);
		bPressedJump = false;
	}

	function EndState()
	{
		LogPlayer("MANTLE EndState" @ Pawn.Physics);
		if( Pawn != None )
		{
			Pawn.ShouldCrouch(false);
			Eon_Pawn(Pawn).MantleEnd();
		}
	}
}


// = DEBUG =====================================================================

exec function DebugHUD()
{
	EonHUD = Eon_HUDBase(MyHud);
}

exec function Spider()
{
	GotoState('PlayerSpidering');
}

simulated function DisplayDebug(Canvas C, out float YL, out float Y)
{
	DisplayDebugController(C,YL,Y);
}

// = INC =======================================================================

#include ../_inc/debug/Log_GPT.uc
#include ../_inc/debug/EditDebug.uc
#include ../_inc/debug/DebugDraw.uc
#include ../_inc/func/String.uc
#include ../_inc/debug/DebugActor.uc
#include ../_inc/debug/DebugController.uc

simulated function Eon_Interaction AddEonInteraction( string S )
{
	LogPlayer("AddEonInteraction");
	return Eon_Interaction(Player.InteractionMaster.AddInteraction(S, Player));
}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	// Engine.Controller
	bAdrenalineEnabled=false
	PlayerReplicationInfoClass=Class'EonEngine.Eon_PRI'

	// Engine.PlayerController
	InputClass=class'Eon_PlayerInput'
	CheatClass=class'Eon_CheatManager'
	TurnLimit=1384
	CameraDist=0.3

	// EOnEngine.EonPlayerBase
	MidGameMenu="EonInterface.EonPG_MidGame"
	MainMenu="EonInterface.EonPG_MainMenu"
	ErrorMenu="EonGUI.Eon_PageError"

	MoveControlDefaultClass=class'EonMC_Spectator'
	bNetNotify=true

}
