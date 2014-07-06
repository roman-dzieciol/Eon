/* =============================================================================
:: File Name	::	EonKB_Storage.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonKB_Storage extends EonKB_KeyBuilding;

var() float	SuppliesMultiplier;


simulated function RegisterSelf()
{
	if( KeyPosition != None )
	{
		KeyPosition.Buildings[KeyPosition.Buildings.Length] = self;
		KeyPosition.Storage = self;
		KeyPosition.SuppliesMax = KeyPosition.default.SuppliesMax * SuppliesMultiplier;
	}
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	StaticMesh=StaticMesh'EonSM_Structures.Storage'

	BuildingName="Storage"
	BuildingPanel="EonInterface.Eon_TabBuildStorage"

	SuppliesMultiplier=2
}
