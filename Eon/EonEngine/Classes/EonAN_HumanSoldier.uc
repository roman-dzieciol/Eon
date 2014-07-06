/* =============================================================================
:: File Name	::	EonAN_Rifleman.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonAN_HumanSoldier extends EonAN_Human;

var() sound		SDLanding;
var() int		AimingStateLast;


// = BASE FUNCTIONS ============================================================

simulated function Update( float DT )
{
	AnimDeltaTime	= DT;
	AnimMoveDir		= Get4WayDirection();
	Speed			= VSize(Velocity);

	if( !bWaitForAnim )
	{
		if( Physics == PHYS_Walking )
		{
			UpdateGround( DT );
		}
		else if( Physics == PHYS_Falling || Physics == PHYS_Flying )
		{
			UpdateAir( DT );
		}
	}
	else if( !IsAnimating(CHAN_Base) )
	{
		bWaitForAnim = false;
	}

	// Aiming Anim
	UpdateAiming( DT );


	LastSpeed		= Speed;
	LastPhysics		= Physics;
	LastVelocity	= Velocity;
	AimingStateLast	= AimingState;
	bWasCrouched	= bIsCrouched;
}

final simulated function UpdateAir( float DT )
{
	// Fly up
	if( Velocity.Z > 100 )
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
		LoopAnim( ANIM_Crouching, 1, 0.3, CHAN_Base );
	}

	// Moving
	else if( Speed > WalkingThresh )
	{
		// Run
		if( !bIsWalking && Speed > RunningThresh )
		{
			AnimSpeed = Speed * OptRunDiv;
			LoopAnim( ANIM_Run[AnimMoveDir], AnimSpeed, 0.1, CHAN_Base );
		}

		// Run
		else
		{
			AnimSpeed = Speed * OptWalkDiv;
			LoopAnim( ANIM_Walk[AnimMoveDir], AnimSpeed, 0.1, CHAN_Base );
		}
	}

	// Idle
	else
	{
		LoopAnim( ANIM_Idle, 1, 0.25, CHAN_Base );
	}
}

final simulated function UpdateAiming( float DT )
{
	local rotator R;

	if( Controller != None )	R.Roll = GetViewRotation().Pitch;
	else						R.Roll = ViewPitch * 256;
	if( R.Roll > 32767 )		R.Roll -= 65535;

	if( AimingStateLast != AimingState )
	{
		switch( AimingState )
		{
		case 0:
			SetBoneDirection( 'Bip01 Neck', rot(0,0,0), vect(0,0,0), 1, 0 );
			AnimBlendToAlpha( CHAN_Aiming, 0.0, 0.33 );
			break;

		case 1:
			AnimBlendParams( CHAN_Aiming, 1.0, 0.66, 0.0, 'Bip01 Spine1', false );
			PlayAnim( ANIM_Aiming, 1, 0.1, CHAN_Aiming );
			break;
		}
	}
	else
	{
		switch( AimingState )
		{
		case 0:
			break;

		case 1:
			SetBoneDirection( 'Bip01 Neck', R, vect(0,0,0), 1, 0 );
			break;
		}
	}
}

simulated function PlayFiring( optional float Rate, optional name FiringMode )
{
	if( FiringMode == 'Reload' )
	{
		AnimBlendParams( CHAN_Firing, 1.0, 0.1, 0.0, 'Bip01 Spine1', false  );
		PlayAnim( ANIM_Reload, 1, 0.1, CHAN_Firing );
	}
	else if( Physics == PHYS_Walking )
	{
		if( bIsCrouched )
		{
			// Crouch Move
			if( Speed > CrouchingThresh )
			{
				AnimBlendParams( CHAN_Firing, 1.0, 0.1, 0.0, 'Bip01 Spine1', false  );
				PlayAnim( ANIM_FireCrouch, 1, 0.1, CHAN_Firing );
			}

			// Crouch Idle
			else
			{
				AnimBlendParams( CHAN_Firing, 1.0, 0.1, 0.0, 'Bip01 Spine1', false  );
				PlayAnim( ANIM_FireCrouch, 1, 0.1, CHAN_Firing );
			}
		}
		else
		{
			AnimBlendParams( CHAN_Firing, 1.0, 0.1, 0.0, 'Bip01 Spine1', false  );
			PlayAnim( ANIM_Fire, 1, 0.1, CHAN_Firing );
		}
	}
	else
	{
		AnimBlendParams( CHAN_Firing, 1.0, 0.1, 0.0, 'Bip01 Spine1', false  );
		PlayAnim( ANIM_Fire, 1, 0.1, CHAN_Firing );
	}
}

simulated function NotifyAnimEnd( int Channel )
{
	if( Channel == CHAN_Firing )
	{
		AnimBlendToAlpha( CHAN_Firing, 0.0, 0.25 );
	}

}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	SDLanding=Sound'EonSP_BeastShrike.PStepGroundHard'
}
