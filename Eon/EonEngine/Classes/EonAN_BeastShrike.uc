/* =============================================================================
:: File Name	::	EonAN_BeastShrike.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonAN_BeastShrike extends EonAN_Beast;


var() Sound		SDLanding;
var() vector	X,Y,Z, AccelVect;
var() float		AccelAlpha;
var() float		AccelDir;
var() float		TurnDir;
var() float		TurnDirLast;

var() float		OptRunDot;
var() float		RunDotMin;

var() name		CHAN_BaseName;
var() float		CHAN_BaseFrame;
var() float		CHAN_BaseRate;


var() float		YawDelta;
var() float		YawSmooth;
var() float		YawUpdate;
var() float		YawFoot;
var() float		YawLast;

var() bool		bFootTurning;
var() bool		bFootStill;
var() bool		bRoot;



simulated function Setup()
{
	Super.Setup();

	OptRunDot	= 1 / (1 - RunDotMin);
	YawLast		= Rotation.Yaw;
}


// = BASE FUNCTIONS ============================================================

simulated function Update( float DT )
{
	AnimDeltaTime	= DT;
	AnimMoveDir		= Get4WayDirection();
	Speed			= VSize(Velocity);

	GetAnimParams( CHAN_Base, CHAN_BaseName, CHAN_BaseFrame, CHAN_BaseRate );
	AnimBlendParams(CHAN_RunTurn, 0.0, 0.0);

	if( !bWaitForAnim )
	{
		if( Physics == PHYS_Walking )
		{
			UpdateGround(DT);
		}
		else if( bIsMantling )
		{
			UpdateLadder(DT);
		}
		else if( Physics == PHYS_Falling || Physics == PHYS_Flying )
		{
			UpdateAir(DT);
		}
	}
	else if( !IsAnimating(CHAN_Base) )
	{
		bWaitForAnim = false;
	}


	LastSpeed		= Speed;
	LastPhysics		= Physics;
	LastVelocity	= Velocity;
	bWasCrouched	= bIsCrouched;
}


simulated function NotifyAnimEnd( int Channel )
{
	if( Channel == CHAN_RunTurn && !AnimIsInGroup(Channel,'RunTurn') && IsAnimating(CHAN_RunTurn) )
	{
		AnimStopLooping(CHAN_RunTurn);
	}
}


final simulated function UpdateAir( float DT )
{
	// Jumped
	if( LastPhysics == PHYS_Walking )
	{
		PlayAnim( ANIM_JumpUTakeOff, 1, 0.05, CHAN_Base );
		bWaitForAnim = true;
	}

	// Fly up
	else if( Velocity.Z > 100 )
	{
		LoopAnim( ANIM_AirU, 1, 0.1, CHAN_Base );
	}

	// Fly down
	else if( Velocity.Z < 100 )
	{
		LoopAnim( ANIM_AirD, 1, 0.3, CHAN_Base );
	}
}


final simulated function UpdateGround( float DT )
{
	// Landed
	if((LastPhysics == PHYS_Falling || LastPhysics == PHYS_Flying)
	&& !bIsCrouched && LastSpeed > LandingThresh )
	{
		PlayOwnedSound( SDLanding,,2 );
		PlayAnim( ANIM_Land, 1, 0.2, CHAN_Base );
		bWaitForAnim = true;
	}

	// Crouching
	else if( bIsCrouched )
	{
		// Crouch Move
		if( Speed > CrouchingThresh )
		{
			AnimSpeed = Speed * OptCrouchDiv;
			LoopAnim( ANIM_Crouch[AnimMoveDir], AnimSpeed, 0.2, CHAN_Base );
		}

		// Crouch Idle
		else
		{
			LoopAnim( ANIM_Crouching, 1, 0.3, CHAN_Base );
		}
	}

	// Moving
	else if( Speed > WalkingThresh )
	{
		// Run
		if( !bIsWalking && Speed > RunningThresh )
		{
			// Play Run Forward
			AnimSpeed = Speed * OptRunDiv;
			LoopAnim( ANIM_Run[0], AnimSpeed, 0.1, CHAN_Base );

			// Turn Alpha
			AccelAlpha = Normal(Velocity) dot Normal(Acceleration);
			AccelAlpha = (1 - FClamp(AccelAlpha, RunDotMin, 1)) * OptRunDot;
			AnimBlendParams( CHAN_RunTurn, AccelAlpha, 0.0 );
			if( AccelAlpha > 0.000001 )
			{

				// Turn Dir
				GetAxes(Rotation,X,Y,Z);
				TurnDir = Y dot Normal(Acceleration);

				// Smooth Turn
				if( Abs(TurnDir) < 0.000001 )
				{
					TurnDirLast *= 0.9;
					TurnDir = TurnDirLast;
				}
				else
				{
					TurnDirLast = TurnDir;
				}

				// Play Turn
				if( TurnDir > 0.000001 )
				{
					LoopAnim( ANIM_Run[2], AnimSpeed, 0.1, CHAN_RunTurn );
					SetAnimFrame( CHAN_BaseFrame, CHAN_RunTurn, 0 );
				}
				else if( TurnDir < -0.000001 )
				{
					LoopAnim( ANIM_Run[3], AnimSpeed, 0.1, CHAN_RunTurn );
					SetAnimFrame( CHAN_BaseFrame, CHAN_RunTurn, 0 );
				}
			}
		}

		// Walk
		else
		{
			AnimSpeed = Speed * OptWalkDiv;
			LoopAnim( ANIM_Walk[AnimMoveDir], AnimSpeed, 0.2, CHAN_Base );
		}
	}


	// Idle
	else
	{
		LoopAnim( ANIM_Idle, 1, 0.25, CHAN_Base );
	}
}


final simulated function UpdateLadder( float DT )
{
	local rotator r;
	// Landed
	if( Physics == PHYS_Ladder
	&&( LastPhysics == PHYS_Falling || LastPhysics == PHYS_Flying ))
	{
		PlayAnim( ANIM_GrabAir, 3, 0.1, CHAN_Base );
		bWaitForAnim = true;
	}

	// Idle
	else
	{
		LoopAnim( ANIM_GrabIdle, 1, 0.1, CHAN_Base );
	}


	if( !bRoot )
	{
		SetBoneDirection('Bip01', r, GetBoneCoords('Bip01').Origin - Location, 1, 0);
		bRoot = true;
	}
	r.yaw = MantleRotation.yaw - Rotation.yaw;
	SetBoneRotation('Bip01', r,  0, 1);
}



/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	SDLanding=Sound'EonSP_BeastShrike.PStepGroundHard'
	RunDotMin = 0.95
}
