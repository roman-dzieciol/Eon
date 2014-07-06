/* =============================================================================
:: File Name	::	EonKB_Barracks.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonKB_Barracks extends EonKB_KeyBuilding;

simulated function RegisterSelf()
{
	if( KeyPosition != None )
	{
		KeyPosition.Buildings[KeyPosition.Buildings.Length] = self;
		KeyPosition.TryStartLocation = TryStartLocation;
		KeyPosition.Barracks = self;
	}
}

function vector TryStartLocation( class<Actor> A )
{
	//return Location + vect(1,1,0)*SpawnRadius;
	return CRand( Location, SpawnRadius );
}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

	StaticMesh=StaticMesh'EonSM_Structures.Barracks'

	BuildingName="Barracks"
	BuildingPanel="EonInterface.Eon_TabBuildBarracks"
}
