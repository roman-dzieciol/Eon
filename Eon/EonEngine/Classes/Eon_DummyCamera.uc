/* =============================================================================
:: File Name	::	Eon_DummyCamera.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_DummyCamera extends Actor;


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bAlwaysTick=True
	DrawType=DT_None

	bStasis=False
	bBlockZeroExtentTraces=false
	bBlockNonZeroExtentTraces=false
	CollisionRadius=0
	CollisionHeight=0
	bIgnoreOutOfWorld=true
}
