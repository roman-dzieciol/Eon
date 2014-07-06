/* =============================================================================
:: File Name	::	Eon_MapInfo.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_MapInfo extends Info
	placeable;

var() Material	MapTexture;
var() float		MapSize;

simulated event PostNetBeginPlay()
{
	if( Texture(MapTexture) == None )
		MapTexture = default.MapTexture;

	class'EonEngine.EonIN_Map'.default.TXMap	= Texture(MapTexture);
	class'EonEngine.EonIN_Map'.default.MapRange	= MapSize;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	MapSize=32768
	MapTexture=Texture'Engine.DefaultTexture'
	RemoteRole=ROLE_SimulatedProxy
	bStatic=False
	bNoDelete=True
}
