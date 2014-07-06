/* =============================================================================
:: File Name	::	EonKP_PositionSecondary.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonKP_PositionSecondary extends EonKP_KeyPosition;

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

		Supplies				-= Sendable;
		Positions[i].Supplies	+= Sendable;
		//LogKP( Available @ Receivable @ Sendable );
	}
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Texture=Material'EonTX_GUI.Map.SecondaryNeutral'
	OwnershipTexture(0)=Material'EonTX_GUI.Map.SecondaryHuman'
	OwnershipTexture(1)=Material'EonTX_GUI.Map.SecondaryBeast'
	OwnershipTexture(2)=Material'EonTX_GUI.Map.SecondaryNeutral'
	PositionName="Secondary"

	Supplies=64
	SuppliesOut=16
	SuppliesMax=256

	SpawnPriority=2
}
