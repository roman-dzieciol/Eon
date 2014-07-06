/* =============================================================================
:: File Name	::	Eon_Collision.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_Collision extends Actor;


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	DrawType=DT_Sprite
	StaticMesh=StaticMesh'EonSM_Editor.EditorTree'

	CullDistance=0
	DrawScale=1
	bHidden=True
	bStatic=True
	bStaticLighting=False
	bShadowCast=True
	bCollideActors=False
	bBlockActors=False
	bBlockPlayers=False
	bBlockKarma=True
	bWorldGeometry=False
	bMovable=False
	CollisionHeight=0
	CollisionRadius=0
	bAcceptsProjectors=False
	MaxLights=0
	bLightingVisibility=False
}
