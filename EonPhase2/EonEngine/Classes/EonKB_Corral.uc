/* =============================================================================
:: File Name	::	EonKB_Corral.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonKB_Corral extends EonKB_KeyBuilding;

simulated function RegisterSelf()
{
	if( KeyPosition != None )
	{
		KeyPosition.Buildings[KeyPosition.Buildings.Length] = self;
		KeyPosition.Corral = self;
	}
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	StaticMesh=StaticMesh'EonSM_Structures.Corral'


	BuildingName="Corral"
	BuildingPanel="EonInterface.Eon_TabBuildCorral"
}
