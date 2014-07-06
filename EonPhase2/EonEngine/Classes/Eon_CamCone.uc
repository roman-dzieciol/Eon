/* =============================================================================
:: File Name	::	Eon_CamCone.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_CamCone extends Actor;

var() StaticMesh MeshLeft;
var() StaticMesh MeshRight;

function SetConeType( int i )
{
	if		( i == -1 )	SetStaticMesh( MeshLeft );
	else if	( i == 1 )	SetStaticMesh( MeshRight );
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	RemoteRole=ROLE_None
	bUnlit=false
	AmbientGlow=64

	DrawType=DT_StaticMesh
	MeshLeft=StaticMesh'EonSM_Camera.ConeL'
	MeshRight=StaticMesh'EonSM_Camera.ConeR'
	StaticMesh=StaticMesh'EonSM_Camera.ConeL'

	bLightingVisibility=false
	DrawScale=0.25

	bAlwaysTick=false
	bStasis=False
	bBlockZeroExtentTraces=false
	bBlockNonZeroExtentTraces=false
	CollisionRadius=0
	CollisionHeight=0
	bIgnoreOutOfWorld=true
}
