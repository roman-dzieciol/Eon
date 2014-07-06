/* =============================================================================
:: File Name	::	Eon_DecoGen.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_DecoGen extends Actor
	placeable;

var() array<TerrainInfo.DecorationLayerData>	DecoData;
var() edfindable TerrainInfo					Terrain;

function UpdatePrecacheStaticMeshes()
{
	Super.UpdatePrecacheStaticMeshes();

	if( Terrain.DecoLayerData.Length == DecoData.Length )
		Terrain.DecoLayerData = DecoData;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

}
