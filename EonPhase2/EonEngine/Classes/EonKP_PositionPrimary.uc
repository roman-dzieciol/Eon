/* =============================================================================
:: File Name	::	EonKP_PositionPrimary.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonKP_PositionPrimary extends EonKP_KeyPosition;

// = SUPPLIES ==================================================================

function SendSupplies()
{
	local int	i;
	local int	Available, Receivable, Sendable;

	//LogKP("Sending Supplies");
	for(i=0; i<Positions.Length; i++)
	{
		Available	= Min(Supplies, SuppliesOut);
		Receivable	= Positions[i].SuppliesMax - Positions[i].Supplies;
		Sendable	= Min(Available, Receivable);

		Positions[i].Supplies += Sendable;
	}
}

function UseSupplies( float Amount )
{
}

function bool SuppliesAvailable( float Amount )
{
	return true;
}

// = CACHE =====================================================================

simulated function RegisterParent()
{
	ParentPosition = self;
}

function Automate()
{
	ParentPosition = self;
	if( Ownership == TEAM_Neutral )
	{
		LogMapError("Ownership == TEAM_Neutral", "2003");
		Texture = TXError;
	}
	else
	{
		Texture = OwnershipTexture[Ownership];
	}
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Texture=Material'EonTX_GUI.Map.PrimaryNeutral'
	OwnershipTexture(0)=Material'EonTX_GUI.Map.PrimaryHuman'
	OwnershipTexture(1)=Material'EonTX_GUI.Map.PrimaryBeast'
	OwnershipTexture(2)=Material'EonTX_GUI.Map.PrimaryNeutral'

	PositionName="Primary"

	Supplies=64
	SuppliesOut=64
	SuppliesMax=64

	SpawnPriority=0
}
