/* =============================================================================
:: File Name	::	EonWP_HumanRifle.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonWP_HumanRifle extends Eon_WeaponPickup;


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	 MaxDesireability=0.400000
	 InventoryType=Class'EonWeapons.EonWN_HumanRifle'
	 PickupMessage="You got the Assault Rifle."
	 PickupSound=Sound'PickupSounds.AssaultRiflePickup'
	 PickupForce="AssaultRiflePickup"
	 DrawType=DT_StaticMesh
	 StaticMesh=StaticMesh'NewWeaponPickups.AssaultPickupSM'
	 DrawScale=0.500000
}
