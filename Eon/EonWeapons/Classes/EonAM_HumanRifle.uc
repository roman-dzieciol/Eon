/* =============================================================================
:: File Name	::	EonAM_HumanRifle.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonAM_HumanRifle extends Eon_Ammunition;


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	ItemName="Rifle Bullets"

	bTryHeadShot=true
	PickupClass=class'EonAP_HumanRifle'
	MaxAmmo=1000
	InitialAmount=1000
}
