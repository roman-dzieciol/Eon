/* =============================================================================
:: File Name	::	EonAP_HumanRifle.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonAP_HumanRifle extends Eon_Ammo;


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	InventoryType=class'EonAM_HumanRifle'

	PickupMessage="You picked up Rifle ammo."
	PickupSound=Sound'PickupSounds.SniperAmmoPickup'
	PickupForce="SniperAmmoPickup"

	AmmoAmount=10
	CollisionHeight=16.000000
	PrePivot=(Z=16.0)

	StaticMesh=StaticMesh'NewWeaponStatic.ClassicSniperAmmoM'
	DrawType=DT_StaticMesh
}
