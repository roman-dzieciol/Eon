/* =============================================================================
:: File Name	::	EonAN_BeastOfficer.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonAN_BeastOfficer extends EonAN_Beast;


var() Sound		SDLanding;

// = BASE FUNCTIONS ============================================================

function Update( float DT )
{
	AnimDeltaTime	= DT;
	AnimMoveDir		= Get4WayDirection();
	Speed			= VSize(Velocity);

	if( !bWaitForAnim )
	{
		if( Physics == PHYS_Walking )
		{
			UpdateGround();
		}
		else if( Physics == PHYS_Falling || Physics == PHYS_Flying )
		{
			UpdateAir();
		}
	}
	else if( !IsAnimating(CHAN_Base) )
	{
		bWaitForAnim = false;
	}

//	UpdateTwist();

	LastSpeed		= Speed;
	LastPhysics		= Physics;
	LastVelocity	= Velocity;
	bWasCrouched	= bIsCrouched;
}

final function UpdateAir()
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

final function UpdateGround()
{
	// Landed
	if((LastPhysics == PHYS_Falling || LastPhysics == PHYS_Flying)
	&& !bIsCrouched && LastSpeed > 50 )
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
	else if( Speed > 10 )
	{
		// Walk
		if( bIsWalking )
		{
			AnimSpeed = Speed / (1.1 * GroundSpeed * WalkingPct);
			LoopAnim( ANIM_Walk[AnimMoveDir], AnimSpeed, 0.1, CHAN_Base );
		}

		// Run
		else
		{
			AnimSpeed = Speed / (1.1 * GroundSpeed);
			LoopAnim( ANIM_Run[AnimMoveDir], AnimSpeed, 0.1, CHAN_Base );
		}
	}

	// Idle
	else
	{
		LoopAnim( ANIM_Idle, 1, 0.25, CHAN_Base );
	}
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	SDLanding=Sound'EonSP_BeastShrike.PStepGroundHard'
}
