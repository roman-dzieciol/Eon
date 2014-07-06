/* =============================================================================
:: File Name	::	EonKB_Armory.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonKB_Armory extends EonKB_KeyBuilding;

simulated function RegisterSelf()
{
	if( KeyPosition != None )
	{
		KeyPosition.Buildings[KeyPosition.Buildings.Length] = self;
		KeyPosition.Armory = self;
	}
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	StaticMesh=StaticMesh'EonSM_Structures.Armory'

	BuildingName="Armory"
	BuildingPanel="EonInterface.Eon_TabBuildArmory"
}
