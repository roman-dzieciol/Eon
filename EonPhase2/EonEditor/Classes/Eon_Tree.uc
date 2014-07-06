/* =============================================================================
:: File Name	::	Eon_Tree.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_Tree extends Actor
	abstract;

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	CullDistance=0
	DrawScale=1
	bStatic=True
	bMovable=False
	bLightingVisibility=False

	bWorldGeometry=False
	bCollideActors=False
	bBlockActors=False
	bBlockPlayers=False
	bBlockKarma=True
	bBlockZeroExtentTraces=False
	bBlockNonZeroExtentTraces=False
	CollisionHeight=+000000.000000
	CollisionRadius=+000000.000000

}
