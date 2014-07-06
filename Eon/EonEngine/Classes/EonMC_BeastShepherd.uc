/* =============================================================================
:: File Name	::	EonMC_BeastOfficer.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonMC_BeastShepherd extends EonMC_Beast;



function AdjustWalking( float DeltaTime, out vector NewAccel, Eon_Pawn P )
{
	local vector	X,Y,Z;
	local float		Speed, AccelCurve, AccelRatio, BrakeRatio;

	GetAxes(P.Rotation,X,Y,Z);

	if( P.Physics == PHYS_Walking )
	{
		//# Momentum -----------------------------------------------------------
		aForward = Clamp(aForward, -1, 1);
		aStrafe = Clamp(aStrafe, -1, 1);
		Speed = VSize(P.Velocity);

		if( aForward != 0 )
		{
			AccelRatio	= AccelF / P.AccelRate;								// Non-linear acceleration
			AccelCurve	= -loge(AccelRatio)*3;								//
			AccelCurve	= FClamp(AccelCurve, 0, 3);							//
			AccelF += aForward * P.AccelRate * DeltaTime * AccelCurve;		// Accelerate
			aForwardLast = aForward;										// Save direction
		}
		else if( AccelF != 0 )
		{
			BrakeRatio =  P.BrakingRate / P.AccelRate;
			aForward = aForwardLast;										// Preserve moving direction
			AccelF  -= aForward * P.BrakingRate * DeltaTime * BrakeRatio;	// Brake
			if((aForward > 0 && AccelF < 0 )								// Stop.
			||( aForward < 0 && AccelF > 0))	AccelF = 0;					//
		}

		if( aStrafe != 0 )
		{
			AccelRatio	= AccelS / P.AccelRate;								// Non-linear acceleration
			AccelCurve	= -loge(AccelRatio)*3;								//
			AccelCurve	= FClamp(AccelCurve, 0, 3);							//
			AccelS += aStrafe * P.AccelRate * DeltaTime * AccelCurve;		// Accelerate
			aStrafeLast = aStrafe;											// Save Direction
		}
		else if( AccelS != 0 )
		{
			BrakeRatio =  P.BrakingRate / P.AccelRate;
			aStrafe	= aStrafeLast;											// Preserve moving direction
			AccelS -= aStrafe * P.BrakingRate * DeltaTime * BrakeRatio;		// Brake
			if((aStrafe > 0 && AccelS < 0 )									// Stop.
			||( aStrafe < 0 && AccelS > 0))		AccelS = 0;					//
		}

		AccelF = FClamp(AccelF, -P.AccelRate, P.AccelRate);
		AccelS = FClamp(AccelS, -P.AccelRate, P.AccelRate);
		NewAccel += AccelF*X + AccelS*Y;


		//# Turn Rate ----------------------------------------------------------
		if		( Speed > P.RunningThresh )						MaxTurn = MaxTurnRun;
		else if	( P.bIsWalking && Speed > P.WalkingThresh )		MaxTurn = MaxTurnWalk;
		else if	( P.bIsCrouched )								MaxTurn = MaxTurnCrouch;
		else													MaxTurn = MaxTurnIdle;
		aTurn = FClamp(aTurn, -MaxTurn, MaxTurn);

	}
	else if( P.Physics == PHYS_Falling )
	{
		//# Momentum -----------------------------------------------------------
		if( Abs(AccelF) > P.AccelRate * 0.75 )	AccelF -= aStrafeLast * P.BrakingRate * DeltaTime;
		if( Abs(AccelS) > P.AccelRate * 0.75 )	AccelS -= aStrafeLast * P.BrakingRate * DeltaTime;
		NewAccel += aForward*X + aStrafe*Y;
	}
	else
	{
		NewAccel += aForward*X + aStrafe*Y;
	}


	//# Cleanup Accel ----------------------------------------------------------
	if( VSize(NewAccel) < 1.0 )
		NewAccel = vect(0,0,0);
	NewAccel.Z = 0;
}

function bool AdjustHitWall( vector HitNormal, Actor Wall )
{
	AccelF = 0;
	AccelS = 0;
	return false;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	MaxTurnRun		= 1024
	MaxTurnWalk		= 1280
	MaxTurnCrouch	= 768
	MaxTurnIdle		= 4096
}
