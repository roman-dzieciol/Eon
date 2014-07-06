/* =============================================================================
:: File Name	::	Eon_MoveController.uc
:: Description	::	Pawn-specific local player input modifier
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_MoveControl extends Object
	within EonPC_Base;


var() byte		IS_WALKING;

var() float		MaxTurn;
var() float		MaxTurnRun;
var() float		MaxTurnWalk;
var() float		MaxTurnCrouch;
var() float		MaxTurnIdle;

var() float		aForwardLast;
var() float		aStrafeLast;
var() float		aTurnLast;

var() float		AccelF;
var() float		AccelS;
var() float		AccelT;
var() float		AccelDelta;


// = INIT ======================================================================

function Setup()
{
	LogClass("Setup");
}


// = NOTIFICATIONS =============================================================

function AdjustWalking( float DeltaTime, out vector NewAccel, Eon_Pawn P );
function AdjustMantling( float DeltaTime, out vector NewAccel, Eon_Pawn P );

function bool AdjustHitWall( vector HitNormal, Actor Wall );


// = INC =======================================================================

final function LogClass( coerce string S ){ Log(S@"["$Name$"]", 'MC');}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	IS_WALKING = 1
}
