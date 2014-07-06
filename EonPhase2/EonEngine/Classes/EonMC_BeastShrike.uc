/* =============================================================================
:: File Name	::	EonMC_BeastShrike.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonMC_BeastShrike extends EonMC_Beast;


var() vector	TraceHead;		// Head location
var() vector	HeadOffset;		// Head offset from pawn location
var() float		HeadDist;		// Distance for head collision monitoring
var() float		HeadStop;		// Distance for head collision reaction
var() bool		bHitWall;

var() vector	TraceEnd;
var() vector	TraceStart;
var() vector	TraceDist;
var() vector	TraceStop;
var() vector	TraceMove;
var() vector	HitLocation;
var() vector	HitNormal;


function AdjustWalking( float DeltaTime, out vector NewAccel, Eon_Pawn P )
{
	local vector	X,Y,Z;
	local float		Speed, AccelCurve, AccelRatio, BrakeRatio;
	local Actor		TraceActor;

	GetAxes(P.Rotation,X,Y,Z);
	Speed = VSize(P.Velocity);


	//# Adjust head from wall --------------------------------------------------
	TraceHead		= P.GetBoneCoords(P.CamBone).Origin;
	HeadOffset		= TraceHead - P.Location;
	TraceStart		= P.Location;
	TraceStart.Z	= TraceHead.Z;
	TraceEnd		= TraceStart + HeadOffset + X*HeadDist;
	TraceActor		= Trace( HitLocation, HitNormal, TraceEnd, TraceStart, false, vect(8,8,8) );

	if( TraceActor != None )
	{
		TraceDist	= HitLocation - TraceStart;
		TraceStop	= TraceEnd - TraceStart - X*HeadStop;

		if( VSize(TraceDist) < VSize(TraceStop) )			// if head is way too close to a wall
		{													//
			bHitWall	= true;								// move limitation kicks in
			TraceMove	= -X * VSize(TraceDist);			// calc new acceleration
			NewAccel	= TraceMove / DeltaTime;			// set new acceleration
			if( aForward > 0 )	aForward = 0;				// prevent running into wall
			if( AccelF > 0 )	AccelF = 0;					//

		}
		else if( bHitWall )									// if wall is close and limitation is working
		{													//
			if( aForward > 0 )	aForward = 0;				// prevent running into wall
			if( AccelF > 0 )	AccelF = 0;					//
		}
	}
	else
	{
		bHitWall = false;	// we're in a safe distance from wall, turn off the limitation
	}


	if( P.Physics == PHYS_Walking )
	{
		//# Running only forward -----------------------------------------------
		if( !P.bIsWalking )
		{
			if( aForward > 0 )
			{
				if( aStrafe != 0 )
				{
					aTurn += FClamp(aStrafe, -1024, 1024);
					aStrafe = 0;
				}
			}
			else
			{
				if( !Region.Zone.IsA('WarpZoneInfo') )
					Pawn.SetWalking( true );
			}
		}


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


function AdjustMantling( float DeltaTime, out vector NewAccel, Eon_Pawn P )
{
	local float YawDelta, YawPC, YawPW;

	YawPC		= Rotation.Yaw & 0xFFFF;			if( YawPC > 0x7FFF )	YawPC -= 0x10000;
	YawPW		= P.MantleRotation.Yaw & 0xFFFF;	if( YawPW > 0x7FFF )	YawPW -= 0x10000;
	YawDelta	= (YawPC-YawPW) & 0xFFFF;			if( YawDelta > 0x7FFF )	YawDelta -= 0x10000;

	if( aTurn > 0 )	aTurn = Min(aTurn,16384-YawDelta);
	if( aTurn < 0 ) aTurn = Max(aTurn,-16384-YawDelta);
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

	HeadDist = 40
	HeadStop = 24

}
