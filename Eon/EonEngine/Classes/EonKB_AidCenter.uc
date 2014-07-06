/* =============================================================================
:: File Name	::	EonKB_AidCenter.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonKB_AidCenter extends EonKB_KeyBuilding;

simulated function RegisterSelf()
{
	if( KeyPosition != None )
	{
		KeyPosition.Buildings[KeyPosition.Buildings.Length] = self;
		KeyPosition.AidCenter = self;
	}
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	StaticMesh=StaticMesh'EonSM_Structures.AidCenter'

	BuildingName="Aid Center"
	BuildingPanel="EonInterface.Eon_TabBuildAidCenter"
}
