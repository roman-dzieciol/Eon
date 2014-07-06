/* =============================================================================
:: File Name	::	Eon_AnimController.uc
:: Description	::	FSM Design
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_AnimControl extends Object
	within Eon_Pawn;

const CHAN_Base		= 0;
const CHAN_RunTurn	= 1;
const CHAN_Aiming	= 2;
const CHAN_Firing	= 3;

var() float		AnimDeltaTime;
var() int		FootLimit, FreeLookLimit;
var() rotator	FootDirection, LastFootDirection;

var() int		FootYawAbs;
var() rotator	FootDesired;
var() rotator	FootDesiredLast;
var() rotator	FootCurrent;
var() rotator	FootCurrentInv;
var() rotator	FootDelta;

var() int		TwistLimit;

var() float		AnimRate;
var() float		AnimFrame;
var() name		AnimName;
var() name		AnimNameNew;

var() name		AnimAir;
var() name		AnimAirOld;

var() float		TweenTime;
var() byte		AirState;


var() rotator	TwistFeet;
var() rotator	TwistBody;
var() rotator	TwistBodyA;
var() rotator	TwistBodyB;



var() float		OptWalkDiv;
var() float		OptRunDiv;
var() float		OptCrouchDiv;
var() float		OptRunSpeed;

// = INIT ======================================================================

simulated function Setup()
{
	LogAnim("Setup");

	StopAnimating();

	OptRunSpeed		= 1.1 * GroundSpeed * WalkingPctDef;
	OptWalkDiv		= 1 / (1.1 * GroundSpeed * WalkingPctDef);
	OptRunDiv		= 1 / (1.1 * GroundSpeed);
	OptCrouchDiv	= 1 / (1.1 * GroundSpeed * CrouchedPct);
}


// = BASE FUNCTIONS ============================================================

simulated function Update( float DT );
simulated function NotifyAnimEnd( int Channel );
simulated function PlayFiring(optional float Rate, optional name FiringMode);

// = FOOT ROTATION =============================================================
/*
void APawn::UpdateTwistLook( float DeltaTime )
{
	if ( !bDoTorsoTwist || (Level->TimeSeconds - LastRenderTime > 0.5f) )
	{
		SmoothViewPitch = ViewPitch;
		SmoothViewYaw = Rotation.Yaw;
		FootRot = Rotation.Yaw;
		FootTurning = false;
		FootStill = false;
	}
	else
	{
		INT YawDiff = (Rotation.Yaw - SmoothViewYaw) & 65535;
		if ( YawDiff != 0 )
		{
			if ( YawDiff > 32768 )
				YawDiff -= 65536;

			INT Update = INT(YawDiff * 15.f * DeltaTime);
			if ( Update == 0 )
				Update = (YawDiff > 0) ? 1 : -1;
			SmoothViewYaw = (SmoothViewYaw + Update) & 65535;
		}
		INT t = (SmoothViewYaw - FootRot) & 65535;
		if (t > 32768)
			t -= 65536;

		if ((Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) < 1000 && Physics == PHYS_Walking)
		{
			if (!FootStill)
			{
				FootStill = true;
				SmoothViewYaw = Rotation.Yaw;
				FootRot = Rotation.Yaw;
				t = 0;
			}
		}
		else
		{
			if (FootStill)
			{
				FootStill = false;
				FootTurning = true;
			}
		}

		if (FootTurning)
		{
			if (t > 12000)
			{
				FootRot = SmoothViewYaw - 12000;
				t = 12000;
			}
			else if (t > 2048)
			{
				FootRot += 16384*DeltaTime;
			}
			else if (t < -12000)
			{
				FootRot = SmoothViewYaw + 12000;
				t = -12000;
			}
			else if (t < -2048)
			{
				FootRot -= 16384*DeltaTime;
			}
			else
			{
				if (!FootStill)
				t = 0;
				FootTurning = false;
			}
			FootRot = FootRot & 65535;
		}
		else if (FootStill)
		{
			if (t > 10923)
			{
				TurnDir = 1;
				FootTurning = true;
			}
			else if (t < -10923)
			{
				TurnDir = -1;
				FootTurning = true;
			}
		}
		else
		{
			t = 0;
		}
		INT PitchDiff = (256*ViewPitch - SmoothViewPitch) & 65535;
		if ( PitchDiff != 0 )
		{
			if ( PitchDiff > 32768 )
			PitchDiff -= 65536;

			INT Update = INT(PitchDiff * 5.f * DeltaTime);
			if ( Update == 0 )
			Update = (PitchDiff > 0) ? 1 : -1;
			SmoothViewPitch = (SmoothViewPitch + Update) & 65535;
		}
		INT look = SmoothViewPitch;
		if (look > 32768)
		look -= 65536;
		SetTwistLook(t, look);
	}
}
*/
function UpdateTwist()
{
	local int T;

	T = Rotation.Yaw & 0xFFFF;	if( T > 0x7FFF ) T -= 0x10000;


	// get foot rotation
	//T = Rotation.Yaw;

	TwistFeet.Yaw	= T;
	TwistBody.Yaw	= -T;




	// adjust bone rotation

	SetBoneDirection('Bip01 Pelvis', TwistFeet, vect(0,0,0), 1, 0);
	SetBoneDirection('Bip01 Spine1', TwistBody, vect(0,0,0), 1, 0);
//	SetBoneDirection('Bip01 Neck', TwistBodyB, vect(0,0,0), 1, 0);

	LastFootDirection = FootDirection;


//	HUD_Monitor("FootDirection.Yaw",FootDirection.Yaw,0,192,255,255,1);
	HUD_Monitor("TwistFeet",TwistFeet.Yaw,0,255,255,255,1);
	HUD_Monitor("TwistBody",TwistBody.Yaw,0,212,255,255,1);
//	HUD_Monitor("TwistBodyA",TwistBodyA.Yaw,0,212,255,255,1);
//	HUD_Monitor("TwistBodyB",TwistBodyB.Yaw,0,212,255,255,1);
}


function SetTwist( int Twist )
{
/*	local rotator R;
	R.Yaw = -Twist;
	SetBoneRotation( RootBone, R, 0, 1 );*/
}


/*




void APawn::SetTwistLook( int twist, int look )
{
	FRotator r;

	if (!bDoTorsoTwist)
		return;

	r.Yaw = -twist;
	r.Pitch = 0;
	r.Roll = 0;
	MeshInstance->SetBoneRotation(RootBone, r, 0, 1.0f);

	r.Yaw = -twist / 3;
	r.Pitch = 0;
	r.Roll = look / 4;
	((USkeletalMeshInstance*)MeshInstance)->SetBoneDirection(HeadBone, =, FVector(0.0f,0.0f,0.0f), 1.0f, 0);
	((USkeletalMeshInstance*)MeshInstance)->SetBoneDirection(SpineBone1, =, FVector(0.0f,0.0f,0.0f), 1.0f, 0);
	((USkeletalMeshInstance*)MeshInstance)->SetBoneDirection(SpineBone2, =, FVector(0.0f,0.0f,0.0f), 1.0f, 0);
}*/


/*
////////////////////////////////////////////////////////////////////////////////
// ANIM UPDATE
function AnimFootRotation()
{
	local float xd, yd;
	local vector X,Y,Z;
	local int t;

	GetAxes(Rotation,X,Y,Z);
	xd = X dot normal(velocity);
	yd = Y dot normal(velocity);

	MoveDir.F = 0;
	MoveDir.B = 0;
	MoveDir.R = 0;
	MoveDir.L = 0;

	if( xd > 0 )		MoveDir.F = xd*xd;
	else if( xd < 0 )	MoveDir.B = xd*xd;
	if( yd > 0 )		MoveDir.R = yd*yd;
	else if( yd < 0 )	MoveDir.L = yd*yd;

//	if( FootRotationAbsYaw > FreeLookLimit )
//		FootRotation.Yaw = FootRotation.Yaw * (1 - AnimDeltaTime*0.75);

//	FootRotation = Normalize(FootRotation + Normalize(( FootDirection - LastFootDirection )/2));
//	FootRotation.Yaw = Clamp(FootRotation.Yaw, -FootLimit, FootLimit);
//	FootRotationAbsYaw = Abs(FootRotation.Yaw);
//	FootRotationInv.Yaw = -FootRotation.Yaw;

	t = (Rotation.Yaw - FootRot) & 65535;
	if (t > 32768) t -= 65536;


	HUD_Monitor("FreeLookLimit",FreeLookLimit,0,128,255,255,1);
	HUD_Monitor("FootLimit",FootLimit,0,128,255,255,1);
	HUD_Monitor("FootDirection.Yaw",FootDirection.Yaw,0,128,255,255,1);
	HUD_Monitor("FootRotation.Yaw",FootRotation.Yaw,0,128,255,255,1);
	HUD_Monitor("FootCurrent.Yaw",FootCurrent.Yaw,0,128,255,255,1);
	HUD_Monitor("FootRotationInv.Yaw",FootRotationInv.Yaw,0,128,255,255,1);

	// get foot rotation
	FootDirection.Yaw = Rotation.Yaw;

	FootDelta = Normalize(FootDirection - LastFootDirection);

	FootRotation = Normalize( FootRotation + FootDelta );
	FootRotationInv = Normalize( FootRotationInv - FootDelta );
	FootCurrent = Normalize((FootRotation - FootDirection)*0.5);



	// adjust bone rotation

	SetBoneDirection('Bip01 Pelvis', FootRotation, vect(0,0,0), 1, 0);
	SetBoneDirection('Bip01 Spine1', FootRotationInv, vect(0,0,0), 1, 0);
//	SetBoneDirection('Bip01 Spine2', FootRotationInv, vect(0,0,0), 1, 0);

	LastFootDirection = FootDirection;
}
function AnimTickB( float DeltaTime )
{
	AnimDeltaTime = DeltaTime;
	AnimFootRotation();

	Switch( Physics )
	{
		case PHYS_None:				break;
		case PHYS_Walking:			ANIM_Walking();
		case PHYS_Falling:			break;
		case PHYS_Swimming:			break;
		case PHYS_Flying:			break;
		case PHYS_Rotating:			break;
		case PHYS_Projectile:		break;
		case PHYS_Interpolating:	break;
		case PHYS_MovingBrush: 		break;
		case PHYS_Spider:			break;
		case PHYS_Trailer:			break;
		case PHYS_Ladder:			break;
		case PHYS_RootMotion:		break;
		case PHYS_Karma:			break;
		case PHYS_KarmaRagDoll:		break;
		case PHYS_Hovering:			break;
		case PHYS_CinMotion:		break;
		default:					break;
	}

	LastFootDirection = FootDirection;
	LastAcceleration = Acceleration;
	LastAnimState = AnimState;
	LastVelocity = Velocity;
	LastPhysics = Physics;
}

function ANIM_Walking()
{

	Switch( LastPhysics )
	{
		case PHYS_None:				break;
		case PHYS_Walking:			break;
		case PHYS_Falling:			break;//ANIM_WalkingFromFalling();	return;
		case PHYS_Swimming:			break;
		case PHYS_Flying:			break;//ANIM_WalkingFromFlying();	return;
		case PHYS_Rotating:			break;
		case PHYS_Projectile:		break;
		case PHYS_Interpolating:	break;
		case PHYS_MovingBrush: 		break;
		case PHYS_Spider:			break;
		case PHYS_Trailer:			break;
		case PHYS_Ladder:			break;
		case PHYS_RootMotion:		break;
		case PHYS_Karma:			break;
		case PHYS_KarmaRagDoll:		break;
		case PHYS_Hovering:			break;
		case PHYS_CinMotion:		break;
		default:					break;
	}

	if( VSize(Acceleration) != 0.0 )	ANIM_Walking_Accelerating();
	else								ANIM_Walking_Stopping();
}

function ANIM_WalkingFromFalling();
function ANIM_WalkingFromFlying();

function ANIM_Walking_Accelerating()
{
	if( bIsWalking )
	{
		AnimState = AS_Walk;
		AnimSpeed = VSize(Velocity) / (GroundSpeed * Default.WalkingPct);

		Switch( LastAnimState )
		{
			case AS_Walk:
				AnimBlendToAlpha(8, MoveDir.F, 0.3);
				AnimBlendToAlpha(9, MoveDir.B, 0.3);
				AnimBlendToAlpha(10, MoveDir.R, 0.3);
				AnimBlendToAlpha(11, MoveDir.L, 0.3);
				LoopAnim(WalkAnims[0], AnimSpeed, 0.0, 8);
				LoopAnim(WalkAnims[1], AnimSpeed, 0.0, 9);
				LoopAnim(WalkAnims[2], AnimSpeed, 0.0, 10);
				LoopAnim(WalkAnims[3], AnimSpeed, 0.0, 11);
				break;
			case AS_Crouch:
				AnimBlendToAlpha(4, 0.0, 0.3);
				AnimBlendToAlpha(5, 0.0, 0.3);
				AnimBlendToAlpha(6, 0.0, 0.3);
				AnimBlendToAlpha(7, 0.0, 0.3);
				AnimBlendToAlpha(8, MoveDir.F, 0.3);
				AnimBlendToAlpha(9, MoveDir.B, 0.3);
				AnimBlendToAlpha(10, MoveDir.R, 0.3);
				AnimBlendToAlpha(11, MoveDir.L, 0.3);
				LoopAnim(WalkAnims[0], AnimSpeed, 0.1, 8);
				LoopAnim(WalkAnims[1], AnimSpeed, 0.1, 9);
				LoopAnim(WalkAnims[2], AnimSpeed, 0.1, 10);
				LoopAnim(WalkAnims[3], AnimSpeed, 0.1, 11);
				break;
			case AS_Run:
				AnimBlendToAlpha(8, MoveDir.F, 0.3);
				AnimBlendToAlpha(9, MoveDir.B, 0.3);
				AnimBlendToAlpha(10, MoveDir.R, 0.3);
				AnimBlendToAlpha(11, MoveDir.L, 0.3);
				AnimBlendToAlpha(12, 0.0, 0.3);
				AnimBlendToAlpha(13, 0.0, 0.3);
				AnimBlendToAlpha(14, 0.0, 0.3);
				AnimBlendToAlpha(15, 0.0, 0.3);
				LoopAnim(WalkAnims[0], AnimSpeed, 0.0, 8);
				LoopAnim(WalkAnims[1], AnimSpeed, 0.0, 9);
				LoopAnim(WalkAnims[2], AnimSpeed, 0.0, 10);
				LoopAnim(WalkAnims[3], AnimSpeed, 0.0, 11);
				break;
			case AS_Idle:
				AnimBlendToAlpha(1, 0.0, 0.3);
				AnimBlendToAlpha(8, MoveDir.F, 0.3);
				AnimBlendToAlpha(9, MoveDir.B, 0.3);
				AnimBlendToAlpha(10, MoveDir.R, 0.3);
				AnimBlendToAlpha(11, MoveDir.L, 0.3);
				LoopAnim(WalkAnims[0], AnimSpeed, 0.1, 8);
				LoopAnim(WalkAnims[1], AnimSpeed, 0.1, 9);
				LoopAnim(WalkAnims[2], AnimSpeed, 0.1, 10);
				LoopAnim(WalkAnims[3], AnimSpeed, 0.1, 11);
				break;
			default:
				break;
		}

	}
	else if( bIsCrouched )
	{
		AnimState = AS_Crouch;
		AnimSpeed = VSize(Velocity) / (GroundSpeed * CrouchedPct);

		Switch( LastAnimState )
		{
			case AS_Walk:
				AnimBlendToAlpha(4, MoveDir.F, 0.3);
				AnimBlendToAlpha(5, MoveDir.B, 0.3);
				AnimBlendToAlpha(6, MoveDir.R, 0.3);
				AnimBlendToAlpha(7, MoveDir.L, 0.3);
				AnimBlendToAlpha(8, 0.0, 0.3);
				AnimBlendToAlpha(9, 0.0, 0.3);
				AnimBlendToAlpha(10, 0.0, 0.3);
				AnimBlendToAlpha(11, 0.0, 0.3);
				LoopAnim(CrouchAnims[0], AnimSpeed, 0.1, 4);
				LoopAnim(CrouchAnims[1], AnimSpeed, 0.1, 5);
				LoopAnim(CrouchAnims[2], AnimSpeed, 0.1, 6);
				LoopAnim(CrouchAnims[3], AnimSpeed, 0.1, 7);
				break;
			case AS_Crouch:
				AnimBlendToAlpha(4, MoveDir.F, 0.3);
				AnimBlendToAlpha(5, MoveDir.B, 0.3);
				AnimBlendToAlpha(6, MoveDir.R, 0.3);
				AnimBlendToAlpha(7, MoveDir.L, 0.3);
				LoopAnim(CrouchAnims[0], AnimSpeed, 0.1, 4);
				LoopAnim(CrouchAnims[1], AnimSpeed, 0.1, 5);
				LoopAnim(CrouchAnims[2], AnimSpeed, 0.1, 6);
				LoopAnim(CrouchAnims[3], AnimSpeed, 0.1, 7);
				break;
			case AS_Run:
				AnimBlendToAlpha(4, MoveDir.F, 0.3);
				AnimBlendToAlpha(5, MoveDir.B, 0.3);
				AnimBlendToAlpha(6, MoveDir.R, 0.3);
				AnimBlendToAlpha(7, MoveDir.L, 0.3);
				AnimBlendToAlpha(12, 0.0, 0.3);
				AnimBlendToAlpha(13, 0.0, 0.3);
				AnimBlendToAlpha(14, 0.0, 0.3);
				AnimBlendToAlpha(15, 0.0, 0.3);
				LoopAnim(CrouchAnims[0], AnimSpeed, 0.1, 4);
				LoopAnim(CrouchAnims[1], AnimSpeed, 0.1, 5);
				LoopAnim(CrouchAnims[2], AnimSpeed, 0.1, 6);
				LoopAnim(CrouchAnims[3], AnimSpeed, 0.1, 7);
				break;
			case AS_Idle:
				AnimBlendToAlpha(1, 0.0, 0.3);
				AnimBlendToAlpha(4, MoveDir.F, 0.3);
				AnimBlendToAlpha(5, MoveDir.B, 0.3);
				AnimBlendToAlpha(6, MoveDir.R, 0.3);
				AnimBlendToAlpha(7, MoveDir.L, 0.3);
				LoopAnim(CrouchAnims[0], AnimSpeed, 0.1, 4);
				LoopAnim(CrouchAnims[1], AnimSpeed, 0.1, 5);
				LoopAnim(CrouchAnims[2], AnimSpeed, 0.1, 6);
				LoopAnim(CrouchAnims[3], AnimSpeed, 0.1, 7);
				break;
			default:
				break;
		}
	}
	else
	{
		AnimState = AS_Run;
		AnimSpeed = VSize(Velocity) / GroundSpeed;

		Switch( LastAnimState )
		{
			case AS_Walk:
				AnimBlendToAlpha(8, 0.0, 1.6);
				AnimBlendToAlpha(9, 0.0, 1.6);
				AnimBlendToAlpha(10, 0.0, 0.6);
				AnimBlendToAlpha(11, 0.0, 0.6);
				AnimBlendToAlpha(12, MoveDir.F, 0.6);
				AnimBlendToAlpha(13, MoveDir.B, 0.6);
				AnimBlendToAlpha(14, MoveDir.R*1.5, 0.6);
				AnimBlendToAlpha(15, MoveDir.L*1.5, 0.6);
				LoopAnim(MovementAnims[0], AnimSpeed, 0.1, 12);
				LoopAnim(MovementAnims[1], AnimSpeed, 0.1, 13);
				LoopAnim(MovementAnims[2], AnimSpeed, 0.1, 14);
				LoopAnim(MovementAnims[3], AnimSpeed, 0.1, 15);
				break;
			case AS_Crouch:
				AnimBlendToAlpha(4, 0.0, 0.3);
				AnimBlendToAlpha(5, 0.0, 0.3);
				AnimBlendToAlpha(6, 0.0, 0.3);
				AnimBlendToAlpha(7, 0.0, 0.3);
				AnimBlendToAlpha(12, MoveDir.F, 0.3);
				AnimBlendToAlpha(13, MoveDir.B, 0.3);
				AnimBlendToAlpha(14, MoveDir.R*1.5, 0.3);
				AnimBlendToAlpha(15, MoveDir.L*1.5, 0.3);
				LoopAnim(MovementAnims[0], AnimSpeed, 0.1, 12);
				LoopAnim(MovementAnims[1], AnimSpeed, 0.1, 13);
				LoopAnim(MovementAnims[2], AnimSpeed, 0.1, 14);
				LoopAnim(MovementAnims[3], AnimSpeed, 0.1, 15);
				break;
			case AS_Run:
				AnimBlendToAlpha(12, MoveDir.F, 0.6);
				AnimBlendToAlpha(13, MoveDir.B, 0.6);
				AnimBlendToAlpha(14, MoveDir.R*1.5, 0.6);
				AnimBlendToAlpha(15, MoveDir.L*1.5, 0.6);
				LoopAnim(MovementAnims[0], AnimSpeed, 0.1, 12);
				LoopAnim(MovementAnims[1], AnimSpeed, 0.1, 13);
				LoopAnim(MovementAnims[2], AnimSpeed, 0.1, 14);
				LoopAnim(MovementAnims[3], AnimSpeed, 0.1, 15);
				break;
			case AS_Idle:
				AnimBlendToAlpha(1, 0.0, 0.3);
				AnimBlendToAlpha(12, MoveDir.F, 0.3);
				AnimBlendToAlpha(13, MoveDir.B, 0.3);
				AnimBlendToAlpha(14, MoveDir.R*1.5, 0.3);
				AnimBlendToAlpha(15, MoveDir.L*1.5, 0.3);
				LoopAnim(MovementAnims[0], AnimSpeed, 0.1, 12);
				LoopAnim(MovementAnims[1], AnimSpeed, 0.1, 13);
				LoopAnim(MovementAnims[2], AnimSpeed, 0.1, 14);
				LoopAnim(MovementAnims[3], AnimSpeed, 0.1, 15);
				break;
			default:
				break;
		}
	}
}

function ANIM_Walking_Stopping()
{
	AnimState = AS_Idle;
	AnimSpeed = 1.0;

	Switch( LastAnimState )
	{
		case AS_Walk:
			AnimBlendToAlpha(1, 1.0, 0.3);
			AnimBlendToAlpha(1, 1.0, 0.3);
			AnimBlendToAlpha(4, 0.0, 0.3);
			AnimBlendToAlpha(5, 0.0, 0.3);
			AnimBlendToAlpha(6, 0.0, 0.3);
			AnimBlendToAlpha(7, 0.0, 0.3);
			AnimBlendToAlpha(8, 0.0, 0.3);
			AnimBlendToAlpha(9, 0.0, 0.3);
			AnimBlendToAlpha(10, 0.0, 0.3);
			AnimBlendToAlpha(11, 0.0, 0.3);
			AnimBlendToAlpha(12, 0.0, 0.3);
			AnimBlendToAlpha(13, 0.0, 0.3);
			AnimBlendToAlpha(14, 0.0, 0.3);
			AnimBlendToAlpha(15, 0.0, 0.3);
			LoopAnim(IdleRestAnim, AnimSpeed, 0.1, 1);
			break;
		case AS_Crouch:
			AnimBlendToAlpha(1, 1.0, 0.3);
			AnimBlendToAlpha(1, 1.0, 0.3);
			AnimBlendToAlpha(4, 0.0, 0.3);
			AnimBlendToAlpha(5, 0.0, 0.3);
			AnimBlendToAlpha(6, 0.0, 0.3);
			AnimBlendToAlpha(7, 0.0, 0.3);
			AnimBlendToAlpha(8, 0.0, 0.3);
			AnimBlendToAlpha(9, 0.0, 0.3);
			AnimBlendToAlpha(10, 0.0, 0.3);
			AnimBlendToAlpha(11, 0.0, 0.3);
			AnimBlendToAlpha(12, 0.0, 0.3);
			AnimBlendToAlpha(13, 0.0, 0.3);
			AnimBlendToAlpha(14, 0.0, 0.3);
			AnimBlendToAlpha(15, 0.0, 0.3);
			LoopAnim(IdleRestAnim, AnimSpeed, 0.1, 1);
			break;
		case AS_Run:
			AnimBlendToAlpha(1, 1.0, 0.3);
			AnimBlendToAlpha(1, 1.0, 0.3);
			AnimBlendToAlpha(4, 0.0, 0.3);
			AnimBlendToAlpha(5, 0.0, 0.3);
			AnimBlendToAlpha(6, 0.0, 0.3);
			AnimBlendToAlpha(7, 0.0, 0.3);
			AnimBlendToAlpha(8, 0.0, 0.3);
			AnimBlendToAlpha(9, 0.0, 0.3);
			AnimBlendToAlpha(10, 0.0, 0.3);
			AnimBlendToAlpha(11, 0.0, 0.3);
			AnimBlendToAlpha(12, 0.0, 0.3);
			AnimBlendToAlpha(13, 0.0, 0.3);
			AnimBlendToAlpha(14, 0.0, 0.3);
			AnimBlendToAlpha(15, 0.0, 0.3);
			LoopAnim(IdleRestAnim, AnimSpeed, 0.1, 1);
			break;
		case AS_Idle:
			AnimBlendToAlpha(1, 1.0, 0.0);
			if( FootRotation.Yaw > 0 &&  FootRotation.Yaw > FreeLookLimit )
				LoopAnim(TurnRightAnim, AnimSpeed, 0.1, 1);
			else if( FootRotation.Yaw < 0 &&  FootRotation.Yaw < -FreeLookLimit )
				LoopAnim(TurnLeftAnim, AnimSpeed, 0.1, 1);
			else
				LoopAnim(IdleRestAnim, AnimSpeed, 0.3, 1);
			break;
		default:
			break;
	}
}*/


// = INC =======================================================================

function LogAnim		( coerce string S ){ Log(S@"["$Name$"]", 'AC');}
function LogClass		( coerce string S ){ Log(S@"["$Name$"]", 'AC');}

#include ../_inc/func/String.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	FreeLookLimit=2000
	FootLimit=6000
	FootYawAbs=6000
	TwistLimit=4000
}
