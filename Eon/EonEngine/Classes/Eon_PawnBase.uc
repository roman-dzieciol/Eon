/* =============================================================================
:: File Name	::	Eon_PawnBase.uc
:: Description	::	Base Pawn actor
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PawnBase extends Pawn
	config(User)
	abstract;

enum ERagdollDetail
{
	RDL_Low,
	RDL_Medium,
	RDL_High
};

enum EShadowDetail
{
	ST_None,
	ST_Blob,
	ST_Static,
	ST_SunBased
};


// = DEBUG VARS ================================================================

var() EPHysics				LastPhysics;
var() vector				LastVelocity, LastAcceleration;
var() vector				SuicideMomentum;

enum EJumpState
{
	JS_Ready,
	JS_Prepare,
	JS_Preparing,
	JS_DoJump,
	JS_Jumping
};

var EJumpState JumpState;

var() bool				bJumpPreparing;
var() bool				bJumpDeferred;
var() bool				bJumpReady;
var() bool				bJumpWait;

struct export SAnimDirection
{
	var float F, B, R, L;
};

var() SAnimDirection		MoveDir;

var() int					FootRotationAbsYaw;
var() rotator				FootRotation, FootRotationInv;
var() Eon_HUDBase			EonHUD;
var() vector				MantleTarget;


// =============================================================================

var() config float			MotionBlur;
var() config EShadowDetail			ShadowType;
var() config ERagdollDetail			RagdollDetail;

struct sKImpulse
{
	var() vector	Impulse;
	var() vector	Position;
	var() name		Bone;
};

var() array<sKImpulse>		KImpulses;				// Deferred data for KAddImpulse
var() string				RagSkelName;			// Karma Skeleton
var() bool					bRagFrozen;				// Ragdoll is frozen
var() int					RagRestTime;			// Freeze if not moved in last RagRestTime seconds
var() float					RagLifeSpan;			// Frozen ragdoll lifespan
var() float					RagMinSpeed;			// Below this speed ragdoll will be frozen
var() float					RagAvgSpeed;			// Internal
var() Sound					RagImpactSound;			// Impact Sound Group
var() float					RagImpactTime;			// Impact Sound Group
var() float					RagImpactInterval;		// Impact Sound Group
var() float					RagImpactVolume;		// Impact Sound Group

var() vector				MenuOffset;				// Offset for menu preview mesh
var() float					MenuFOV;				// FOV for menu preview mesh

var() int					TeamIndex;				// Team this pawn is supposed to be on
var() bool					bCommander;				// Commander class
var() int					SpawnCost;				// Cost in supplies

var() name					CamBone;				// Camera coords bone
var() Matrix				CamMatrix;				// For fixing bad bone rotations only!
var() vector				CamOffset;				// Camera offset
var() array<Material>		CamSkins;				// Certain skins need to be invisible

var() bool					bCanMantle;				// Allow Mantling
var() bool					bIsMantling;			// Is Mantling
var() bool					bMantleAdjusted;		// Was Mantle Location Adjusted
var() name					MantleMovementState;	// PlayerController mantling state
var() vector				MantleFootL;			// Offsets for ledge checks
var() vector				MantleFootR;			//
var() vector				MantleHandL;			//
var() vector				MantleHandR;			//
var() vector				MantleAdjust;			//
var() vector				MantleExtent;			//
var() float					MantleBack;				//
var() float					MantleDown;				//
var() float					MantleCollide;			//
var() float					MantleForward;			//
var() float					MantleTrace;			//
var() rotator				MantleForwardRot;		//
var() rotator				MantleCollideRot;		//
var() rotator				MantleDownRot;			//
var() rotator				MantleRotation;			//


var() Controller			LastController;			// Previous controller


var() class<Eon_AnimControl>	AnimControlClass;	// Used by Eon_Pawn
var() Eon_AnimControl			AnimControl;		// Pawn-specific animation code

var() class<Eon_MoveControl>	MoveControlClass;	// Used by EonPC_Base
var() Eon_MoveControl			MoveControl;		// Pawn-specific movement code


var() name	ANIM_Land;
var() name	ANIM_Idle;
var() name	ANIM_Walk[4];
var() name	ANIM_Run[4];

var() name	ANIM_GrabIdle;
var() name	ANIM_GrabAir;

var() name	ANIM_AirU;
var() name	ANIM_AirD;
var() name	ANIM_JumpUTakeOff;

var() name	ANIM_Crouching;
var() name	ANIM_Crouch[4];	// 0=forward, 1=backwards, 2=left, 3=right


var() name	ANIM_FireCrouch;
var() name	ANIM_Fire;
var() name	ANIM_Aiming;
var() name	ANIM_Reload;

var() int		AnimMoveDir;
var() float		AnimSpeed;
var() float		Speed;
var() float		LastSpeed;
var() float		BrakingRate;
var() float		WalkingPctDef;

var() float		RunningThresh;
var() float		WalkingThresh;
var() float		CrouchingThresh;
var() float		LandingThresh;

var() name			BoneGun;
var() int			AimingState;
var() vector		AimOffset;				// Camera offset

var() array<string>		DefaultInventory;


// = REPLICATION ===============================================================

replication
{
	reliable if ( Role == ROLE_Authority )
		NotifyBehindView
		;

	reliable if ( Role < ROLE_Authority )
		MantleBeginServer,
		MantleEndServer,
		AimingStateServer
		;

	reliable if ( bNetDirty && Role == ROLE_Authority )
		bIsMantling,
		MantleRotation,
		AimingState
		;
}

// = AIMING ====================================================================

exec function SetAimingState(int i)
{
	LogClass("AimingState" @ i);
	AimingState = i;
	AimingStateServer(i);
}

exec function ToggleAim()
{
	if( AimingState == 1 )
	{
		AimingState = 0;
		AimingStateServer(0);
		CamOffset = default.CamOffset;
	}
	else
	{
		AimingState = 1;
		AimingStateServer(1);
		CamOffset = AimOffset;
	}
}

function AimingStateServer(int i)
{
	AimingState = i;

	if( i == 1 )
	{
		CamOffset = AimOffset;
	}
	else
	{
		CamOffset = default.CamOffset;
	}
}


// = LIFESPAN ==================================================================

simulated event PostBeginPlay()
{
	LogClass("PostBeginPlay" @ Level.bStartup);

	Super.PostBeginPlay();
	if( Level.NetMode != NM_DedicatedServer )
	{
		bForceSkelUpdate = True;
		AnimControlCreate( AnimControlClass );
	}

	RunningThresh = default.RunningThresh * GroundSpeed * WalkingPctDef;
	WalkingThresh = default.WalkingThresh;
	CrouchingThresh = default.CrouchingThresh;
}

function AddDefaultInventory()
{
	local int i;
	//LogClass("AddDefaultInventory");

	for(i=0; i<DefaultInventory.Length; i++)
		if( DefaultInventory[i] != "" )
			CreateInventory( DefaultInventory[i] );

	Controller.ClientSwitchToBestWeapon();
}

function CreateInventory(string InventoryClassName)
{
	local Inventory Inv;
	local class<Inventory> InventoryClass;

	//LogClass("CreateInventory" @ InventoryClassName);

	InventoryClass = Level.Game.BaseMutator.GetInventoryClass(InventoryClassName);
	if( InventoryClass != None && FindInventoryType(InventoryClass) == None )
	{
		Inv = Spawn(InventoryClass);
		if( Inv != None )
		{
			Inv.GiveTo(self);
			if( Inv != None )
				Inv.PickupFunction(self);
		}
	}
}

simulated event Destroyed()
{
	//LogPawn("Destroyed");
	Super.Destroyed();
}

simulated event FellOutOfWorld(eKillZType KillType)
{
	//LogPawn("FellOutOfWorld" @ KillType);
	Super.FellOutOfWorld(KillType);
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	//LogPawn("Died" @ Killer @ damageType @ HitLocation);
	Super.Died(Killer, damageType, HitLocation);
}

static function bool ValidSpawnPoint( EonKP_KeyPoint K )
{
	return default.TeamIndex == K.Ownership;
}

// = CONTROLLER ================================================================

function PossessedBy(Controller C)
{
	LogPawn("PossessedBy" @ C);
	Super.PossessedBy(C);
}

function UnPossessed()
{
	LogPawn("UnPossessed" @ Controller);
	SetOwner(None);
	PlayerReplicationInfo	= None;
	LastController			= Controller;
	Controller				= None;
}

function ClientReStart()
{
	LogPawn("ClientReStart");
	Velocity = vect(0,0,0);
	Acceleration = vect(0,0,0);
	BaseEyeHeight = Default.BaseEyeHeight;
	EyeHeight = BaseEyeHeight;
	PlayWaiting();
}


// = MANTLING ==================================================================

function int MantleTry( rotator R, vector L )
{
	local vector	VForward, VDown, VBack, VExtentX, VExtentZ;
	local vector	APoint, ATemp, AForward, ADown, ATrace, HitAL, HitAN, HitAXL, HitAZL, AXS, AXE, AZS, AZE;
	local vector	BPoint, BTemp, BForward, BDown, BTrace, HitBL, HitBN, HitBXL, HitBZL, BXS, BXE, BZS, BZE;
	local float		DistL, DistR;
	local int		GrabPoints;

	if( !bCanMantle )				return -10;
	if( bIsMantling )				return -11;
	if( Controller == None )		return -20;
	if( Physics == PHYS_Ladder )	return -30;

	R.Pitch		= 0;												//
	R.Roll		= 0;												//
	VForward	= MantleForward * vector( MantleForwardRot + R );	// Forward empty space offset
	VDown		= MantleDown * vector( MantleDownRot + R );			// Down empty space offset
	VBack		= MantleBack * vector( R );							//

	APoint		= L + (MantleHandL >> R);							// Left hand location
	BPoint		= L + (MantleHandR >> R);							// Right hand location

	ATrace		= APoint + vector( R ) * MantleTrace;				//
	BTrace		= BPoint + vector( R ) * MantleTrace;				//



	//# Test desired mantle position -------------------------------------------

	if(	!FastTrace(APoint,	L))			return -100; 	// hands are not inside some colliding object
	if(	!FastTrace(BPoint,	L))			return -101; 	//
	if(	!FastTrace(APoint,	BPoint))	return -110; 	// empty space between hands


	//# Trace forward and check possible mantle position -----------------------

	if( Trace( HitAL, HitAN, ATrace, APoint, false, MantleExtent ) == None )	return -200;
	if( Trace( HitBL, HitBN, BTrace, BPoint, false, MantleExtent ) == None )	return -210;

	ATemp		= HitAL	- VBack;		// Left hand location
	ADown		= ATemp + VDown;		//
	AForward	= ATemp + VForward;		//

	BTemp		= HitBL	- VBack;		// Right hand location
	BDown		= BTemp + VDown;		//
	BForward	= BTemp + VForward;		//

	if(	!FastTrace(ATemp,		BTemp))	return -300;	// free space between hands
	if(	!FastTrace(ADown,		ATemp))	return -310;	// free space left down
	if(	!FastTrace(AForward,	ATemp))	return -311;	// free space left forward
	if(	!FastTrace(BDown,		BTemp))	return -320;	// free space right down
	if(	!FastTrace(BForward,	BTemp))	return -321;	// free space right forward

	AXS = ATemp	+ VDown*0.5;
	AXE = AXS	+ VForward*0.75;
	AZS = ATemp	+ VForward*0.5;
	AZE = AZS	+ VDown*0.75;
	BXS = BTemp	+ VDown*0.5;
	BXE = BXS	+ VForward*0.75;
	BZS = BTemp	+ VForward*0.75;
	BZE = BZS	+ VDown*0.75;

	VExtentX = vect(1,1,1) + VDown;
	VExtentZ = vect(1,1,1) + VForward;

	if( Trace( HitAXL, HitAN, AXE, AXS, false, VExtentX ) == None )	return -400;
	if( Trace( HitAZL, HitAN, AZE, AZS, false, VExtentZ ) == None )	return -401;
	if( Trace( HitBXL, HitBN, BXE, BXS, false, VExtentX ) == None )	return -410;
	if( Trace( HitBZL, HitBN, BZE, BZS, false, VExtentZ ) == None )	return -411;

	GrabPoints = 2;

	//# Snap body to wall ------------------------------------------------------


	DistL = VSize(ATemp-APoint) + VSize(HitAXL-AXS);
	DistR = VSize(BTemp-BPoint) + VSize(HitBXL-BXS);

	if( DistL < DistR )
	{
		MantleAdjust = ATemp - APoint + 2.25*vector(R) + (HitAXL-AXS) + (HitAZL-AZS) + vect(0,0,-1.5);
	}
	else
	{
		MantleAdjust = BTemp - BPoint + 2.25*vector(R) + (HitBXL-BXS) + (HitAZL-AZS) + vect(0,0,-1.5);
	}
	MantleAdjust += Location;
	log(MantleAdjust-Location);



	//# Debug ------------------------------------------------------------------

	ClearStayingDebugLines();

	HUD_DrawLine(L,		 APoint, 0,192,0,255,1,true);
	HUD_DrawLine(L,		 BPoint, 0,192,0,255,1,true);
	HUD_DrawLine(APoint, BPoint, 0,192,0,255,0,true);

	HUD_DrawLine(APoint, ATemp, 0,128,0,255,0,true);
	HUD_DrawLine(BPoint, BTemp, 0,128,0,255,0,true);

	HUD_DrawLine(ADown, ADown+VForward, 255,0,0,255,3,true);
	HUD_DrawLine(BDown, BDown+VForward, 255,0,0,255,3,true);
	HUD_DrawLine(AForward, AForward+VDown, 255,0,0,255,3,true);
	HUD_DrawLine(BForward, BForward+VDown, 255,0,0,255,3,true);

	HUD_DrawLine(AXS, AXE, 160,0,0,255,3,true);
	HUD_DrawLine(BXS, BXE, 160,0,0,255,3,true);
	HUD_DrawLine(AZS, AZE, 160,0,0,255,3,true);
	HUD_DrawLine(BZS, BZE, 160,0,0,255,3,true);

	HUD_DrawLine(ATemp, BTemp, 0,192,0,255,0,true);
	HUD_DrawLine(ATemp, ADown, 0,192,0,255,3,true);
	HUD_DrawLine(ATemp, AForward, 0,192,0,255,3,true);
	HUD_DrawLine(BTemp, BDown, 0,192,0,255,3,true);
	HUD_DrawLine(BTemp, BForward, 0,192,0,255,3,true);


	return GrabPoints;
}

function MantleBegin()
{
	if( Physics == PHYS_Ladder )
		return;

	LogPawn( "MantleBegin" @ Physics );
	bIsMantling = true;

	MantleBeginServer( MantleAdjust );
}

function MantleBeginServer( vector V )
{
	LogPawn( "MantleBeginServer" @ Physics );
	bIsMantling = true;								// replicate state
	Acceleration = vect(0,0,0);						// kill acceleration
	Velocity = vect(0,0,0);							// kill velocity
	SetLocation( V );								// relocate closer to wall
	SetBase( Level );								// set base
	SetPhysics( PHYS_Ladder );						// set physics
	MantleRotation = Rotation;
	Controller.GotoState( MantleMovementState );
}

function MantleEnd()
{
	if( !bIsMantling )
		return;

	LogPawn( "MantleEnd" @ Physics  );
	MantleEndServer();
}

function MantleEndServer()
{
	LogPawn( "MantleEndServer" @ Physics  );
	Controller.EndClimbLadder();
	SetPhysics(PHYS_Falling);
	bIsMantling = false;

	Controller.GotoState( LandMovementState );
}



// = MOVEMENT ==================================================================


event EndCrouch( float HeightAdjust )
{
	//LogPawn("EndCrouch" @ HeightAdjust);
}

event StartCrouch( float HeightAdjust )
{
	//LogPawn("StartCrouch" @ HeightAdjust);
}

simulated event ModifyVelocity( float DeltaTime, vector OldVelocity )
{
	if( bIsWalking )
	{
		WalkingPct -= DeltaTime * WalkingPctDef;
		WalkingPct = FClamp(WalkingPct, WalkingPctDef, 1);
	}
	else if( bIsCrouched )
	{
		WalkingPct -= DeltaTime;
		WalkingPct = FClamp(WalkingPct, CrouchedPct, 1);
	}
	else
	{
		WalkingPct += DeltaTime;
		WalkingPct = FClamp(WalkingPct, WalkingPctDef, 1);
	}


}

// = ANIM ======================================================================


simulated function AnimControlCreate( class<Eon_AnimControl> C );

// = HEADCAM ===================================================================

function vector GetHeadCamLocation()
{
	local coords	C;
	local vector	X,Y,Z;

	C = GetBoneCoords(CamBone);
	// subclass with fixed matrix code
	X = C.XAxis*CamMatrix.XPlane.X + C.YAxis*CamMatrix.Xplane.Y + C.ZAxis*CamMatrix.Xplane.Z;
	Y = C.XAxis*CamMatrix.YPlane.X + C.YAxis*CamMatrix.Yplane.Y + C.ZAxis*CamMatrix.Yplane.Z;
	Z = C.XAxis*CamMatrix.ZPlane.X + C.YAxis*CamMatrix.Zplane.Y + C.ZAxis*CamMatrix.Zplane.Z;
	C.Origin += X*CamOffset.X + Y*CamOffset.Y + Z*CamOffset.Z;
	return C.Origin;
}

function rotator GetHeadCamRotation()
{
	local coords	C;
	local vector	X,Y,Z;

	C = GetBoneCoords(CamBone);
	// subclass with fixed matrix code
	X = C.XAxis*CamMatrix.XPlane.X + C.YAxis*CamMatrix.Xplane.Y + C.ZAxis*CamMatrix.Xplane.Z;
	Y = C.XAxis*CamMatrix.YPlane.X + C.YAxis*CamMatrix.Yplane.Y + C.ZAxis*CamMatrix.Yplane.Z;
	Z = C.XAxis*CamMatrix.ZPlane.X + C.YAxis*CamMatrix.Zplane.Y + C.ZAxis*CamMatrix.Zplane.Z;
	return OrthoRotation(X, Y, Z);
}

// = CAMERA ====================================================================

simulated function rotator GetViewRotation()
{
	if( Controller == None )	return GetHeadCamRotation();
	else						return Controller.GetViewRotation();
}

simulated function vector EyePosition()
{
	return GetHeadCamLocation() - Location;
}

event UpdateEyeHeight( float DeltaTime )
{
	EyeHeight = EyePosition().Z;
	if( Controller != None )	Controller.AdjustView(DeltaTime);
	if( bTearOff )				bUpdateEyeHeight = false;
}

simulated function NotifyBehindView( bool bBehindView )
{
	//LogPawn("NotifyBehindView" @ bBehindView);
	if( bBehindView )	Skins = default.Skins;
	else				Skins = CamSkins;
}

simulated function vector CalcDrawOffset( inventory Inv)
{
	return vect(0,0,0);
}

simulated function bool PointOfView()
{
	DebugHUD();
	return false;
}

function BecomeViewTarget()
{
	bUpdateEyeHeight = true;
}

simulated function FaceRotation( rotator NewRotation, float DeltaTime )
{
	if( Physics == PHYS_Ladder )
	{
		if( OnLadder != None )
		SetRotation( OnLadder.Walldir );
	}
	else
	{
		if ( (Physics == PHYS_Walking) || (Physics == PHYS_Falling) || Physics == PHYS_Ladder)
			NewRotation.Pitch = 0;
		SetRotation(NewRotation);
	}
}


// = INVENTORY =================================================================

exec function NextItem()
{
	LogClass("NextItem" @ Inventory);
	if( Inventory != None ) Super.NextItem();
	else					return;
}

function name GetWeaponBoneFor(Inventory I)
{
	return BoneGun;
}

// =


// = INC =======================================================================

simulated final function LogClass		( coerce string S ){ Log(S@"["$Name$"]", 'PW');}
simulated function LogPawn		( coerce string S ){ Log(S@"["$Name$"]", 'PW');}
simulated function DebugHUD		()	{EonHUD = Eon_HUDBase(PlayerController(Controller).MyHud);}
simulated function HUD_DrawLine	( vector start, vector end, byte R, byte G, byte B, optional byte A, optional int DrawInfo, optional bool bStaying  )	{	if( EonHUD != none )	EonHUD.HUD_DrawLine(start, end, class'Canvas'.Static.MakeColor(R, G, B, A), DrawInfo, bStaying);}
simulated function HUD_Monitor	( coerce string Desc, coerce string Value, byte R, byte G, byte B, optional byte A, optional float DrawMode  )	{if( EonHUD != none )	EonHUD.HUD_Monitor( Desc, Value, class'Canvas'.Static.MakeColor(R, G, B, A), DrawMode );}
simulated function HUD_DrawAxes	( Coords CD, int size, int mode )	{HUD_DrawLine(CD.Origin, CD.Origin + CD.XAxis*size, 255, 0, 0,,mode);HUD_DrawLine(CD.Origin, CD.Origin + CD.YAxis*size, 0, 255, 0,,mode);HUD_DrawLine(CD.Origin, CD.Origin + CD.ZAxis*size, 0, 0, 255,,mode);}

delegate OnTick( float DT )
{
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	// Engine.Actor
	bDisturbFluidSurface=true
	bShouldBaseAtStartup=true
	bTravel=true
	bOwnerNoSee=false
	bAcceptsProjectors=true
	RotationRate=(Pitch=4096,Yaw=20000,Roll=3072)
	Texture=S_Pawn
	RemoteRole=ROLE_SimulatedProxy
	NetPriority=2.0
	bDirectional=true
	bCanTeleport=true
	bStasis=false
	SoundRadius=60
	SoundVolume=255
	Physics=PHYS_Falling
	bRotateToDesired=true
	DrawType=DT_Mesh
	bCanBeDamaged=true
	bNoRepMesh=true
	bUpdateSimulatedPosition=true
	ForceType=FT_DragAlong
	ForceRadius=100
	ForceScale=2.5
	LightBrightness=0
	LightHue=0
	LightSaturation=0
	LightRadius=0
	ScaleGlow=1.0
	AmbientGlow=0
	Mesh=SkeletalMesh'Bot.BotA'

	Begin Object Class=KarmaParamsSkel Name=oNewKParams
		KFriction=0.775
		KRestitution=0.3
		KAngularDamping=0.05
		KLinearDamping=0.10
		KBuoyancy=1
		KStartEnabled=true
		KImpactThreshold=300
		KVelDropBelowThreshold=48
		KConvulseSpacing=(Min=0.25,Max=0.75)
		bHighDetailOnly=false
		bKDoubleTickRate=false
		bKImportantRagdoll=true
		bDestroyOnSimError=true
		bKDoConvulsions=false
	End Object
	KParams=oNewKParams

	// Engine.Pawn
	bCanCrouch=true
	bJumpCapable=true
	bCanJump=true
	bCanWalk=true
	bCanSwim=true
	bCanFly=false
	bCanClimbLadders=false
	bCanStrafe=true
	bCanDoubleJump=false
	bAvoidLedges=true
	bStopAtLedges=false
	bIgnoreForces=false
	bCanWalkOffLedges=true
	bCanBeBaseForPawns=false

	bAutoActivate=true
	bCanPickupInventory=true
	bAmbientCreature=false
	bLOSHearing=true
	bSameZoneHearing=true
	bAdjacentZoneHearing=true
	bMuffledHearing=true
	bAroundCornerHearing=false
	bDontPossess=true

	bUseCompressedPosition=false
	bWeaponBob=false
	bHideRegularHUD=false
	bSpecialHUD=false
	bSpecialCalcView=false
	bNoTeamBeacon=true

	Visibility=128
	HearingThreshold=1024
	Alertness=1
	SightRadius=2048
	AvgPhysicsTime=0.1
	MeleeRange=20

	GroundSpeed=600.0
	WaterSpeed=600.0
	AirSpeed=600.0
	LadderSpeed=600.0
	AccelRate=2024.0
	JumpZ=600.0
	AirControl=0.35
	WalkingPct=1.0
	CrouchedPct=0.33
	MaxFallSpeed=1280.0

	BaseEyeHeight=+00064.000000
	EyeHeight=+00054.000000
	CrouchHeight=0
	CrouchRadius=0
	Health=100
	HealthMax=100
	UnderWaterTime=30.0
	HeadScale=1.0
	Bob=0.0
	SoundDampening=1.0
	DamageScaling=1.0

	MenuName="Spectator"

	BloodEffect=class'BloodJet'
	LowGoreBlood=class'AlienSmallHit'
	ControllerClass=class'EonEngine.Eon_AI'

	LandMovementState=PlayerWalking
	WaterMovementState=PlayerSwimming
	MantleMovementState=PlayerMantling

	DodgeSpeedFactor=0
	DodgeSpeedZ=0

	MovementAnims(0)=None
	MovementAnims(1)=None
	MovementAnims(2)=None
	MovementAnims(3)=None
	SwimAnims(0)=None
	SwimAnims(1)=None
	SwimAnims(2)=None
	SwimAnims(3)=None
	CrouchAnims(0)=None
	CrouchAnims(1)=None
	CrouchAnims(2)=None
	CrouchAnims(3)=None
	WalkAnims(0)=None
	WalkAnims(1)=None
	WalkAnims(2)=None
	WalkAnims(3)=None
	AirAnims(0)=None
	AirAnims(1)=None
	AirAnims(2)=None
	AirAnims(3)=None
	TakeoffAnims(0)=None
	TakeoffAnims(1)=None
	TakeoffAnims(2)=None
	TakeoffAnims(3)=None
	LandAnims(0)=None
	LandAnims(1)=None
	LandAnims(2)=None
	LandAnims(3)=None
	DoubleJumpAnims(0)=None
	DoubleJumpAnims(1)=None
	DoubleJumpAnims(2)=None
	DoubleJumpAnims(3)=None
	DodgeAnims(0)=None
	DodgeAnims(1)=None
	DodgeAnims(2)=None
	DodgeAnims(3)=None
	TurnRightAnim=None
	TurnLeftAnim=None
	AirStillAnim=None
	TakeoffStillAnim=None
	CrouchTurnRightAnim=None
	CrouchTurnLeftAnim=None
	IdleCrouchAnim=None
	IdleSwimAnim=None
	IdleWeaponAnim=None
	IdleRestAnim=None

	RootBone=""
	HeadBone=""
	SpineBone1=""
	SpineBone2=""

	bPhysicsAnimUpdate=false
	bDoTorsoTwist=false

	// EonEngine.Eon_Pawn
	AnimControlClass=class'Eon_AnimControl'
	MoveControlClass=class'Eon_MoveControl'

	CamBone="CamBone"
	CamMatrix=(XPlane=(X=1,Y=0,Z=0,W=0),YPlane=(X=0,Y=1,Z=0,W=0),ZPlane=(X=0,Y=0,Z=1,W=0),WPlane=(X=0,Y=0,Z=0,W=0))

	ANIM_AirD="AirD"
	ANIM_AirU="AirU"
	ANIM_JumpUTakeOff="JumpUTakeOff"

	ANIM_Idle="Idle"
	ANIM_Land="Land"
	ANIM_Walk(0)="WalkF"
	ANIM_Walk(1)="WalkB"
	ANIM_Walk(2)="WalkL"
	ANIM_Walk(3)="WalkR"
	ANIM_Run(0)="RunF"
	ANIM_Run(1)="RunB"
	ANIM_Run(2)="RunL"
	ANIM_Run(3)="RunR"

	ANIM_GrabIdle="Grab4Idle"
	ANIM_GrabAir="Grab4AirD"

	ANIM_Crouching="Crouch"
	ANIM_Crouch(0)="CrouchF"
	ANIM_Crouch(1)="CrouchB"
	ANIM_Crouch(2)="CrouchL"
	ANIM_Crouch(3)="CrouchR"

	BrakingRate=500


	MantleForward		= 32
	MantleDown			= 16
	MantleBack			= 0.5
	MantleTrace			= 48
	MantleForwardRot	=(Pitch=0)
	MantleDownRot		=(Pitch=-16384)
	MantleExtent		=(X=1,Y=4,Z=32)

	RunningThresh	= 1.1
	WalkingThresh	= 10
	CrouchingThresh	= 5
	LandingThresh	= 50

	RagdollDetail=RDL_Medium
}
