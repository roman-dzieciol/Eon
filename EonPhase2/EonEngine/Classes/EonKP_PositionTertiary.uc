/* =============================================================================
:: File Name	::	EonKP_PositionTertiary.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonKP_PositionTertiary extends EonKP_KeyPosition;


// = LIFESPAN ==================================================================

simulated function Timer()
{
	RestartPlayers();
}

// = SPAWNING ==================================================================

delegate vector TryStartLocation( class<Actor> A )
{
	return CRand( Location, SpawnRadius );
}

function bool ValidPawnClass( class<Eon_Pawn> P )
{
	if( P == None )								return true;
	if( P.default.TeamIndex != Ownership )		return false;
	if( class<EonPW_BeastOfficer>(P) != None )	return false;
	return true;
}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Texture=Material'EonTX_GUI.Map.TertiaryNeutral'
	OwnershipTexture(0)=Material'EonTX_GUI.Map.TertiaryHuman'
	OwnershipTexture(1)=Material'EonTX_GUI.Map.TertiaryBeast'
	OwnershipTexture(2)=Material'EonTX_GUI.Map.TertiaryNeutral'
	PositionName="Tertiary"

	Supplies=8
	SuppliesOut=0
	SuppliesMax=32

	SpawnPriority=4
}
