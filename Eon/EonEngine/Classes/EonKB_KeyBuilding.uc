/* =============================================================================
:: File Name	::	EonKB_KeyBuilding.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonKB_KeyBuilding extends EonKP_Keypoint;

var() edfindable EonKP_KeyPosition	KeyPosition;
var() float							SpawnRadius;

var() string						BuildingName;
var() string						BuildingPanel;
var() string						BuildingMenu;


// = LIFESPAN ==================================================================

simulated function BeginPlay()
{
	RegisterSelf();
}

function Automate()
{
}

simulated function RegisterSelf()
{
	if( KeyPosition != None )
	{
		KeyPosition.Buildings[KeyPosition.Buildings.Length] = self;
	}
}

// = INTERACTION ===============================================================

function Used( EonPC_Base P )
{
	Log("Used");
	P.ClientMessage(class.name);
	if( BuildingMenu != "" )
		P.ClientOpenMenu( BuildingMenu, false, BuildingPanel, BuildingName );
}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	DrawType=DT_StaticMesh
	bWorldGeometry=true
	PrePivot=(Z=-128)
	SpawnRadius=256
	DrawScale=1
	bHidden=false

	bCollideActors=True
	bBlockActors=True
	bBlockPlayers=True
	bBlockKarma=True
	bBlockZeroExtentTraces=True
	bBlockNonZeroExtentTraces=True

	BuildingMenu="EonInterface.Eon_PageBuilding"
}
