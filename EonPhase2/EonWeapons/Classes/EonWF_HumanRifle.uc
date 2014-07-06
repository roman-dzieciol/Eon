/* =============================================================================
:: File Name	::	EonWF_HumanRifle.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonWF_HumanRifle extends EonWF_TraceRifle;


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	AmmoClass	= class'EonWeapons.EonAM_HumanRifle'
	DamageType	= class'EonWeapons.EonDT_HumanRifle'

	ReloadSound	= Sound'EonSP_Weapons.HumanRifle.Reload'
	FireSound	= Sound'EonSP_Weapons.HumanRifle.Fire4'
	FireForce	= "NewSniperShot"

	DamageMin	= 60
	DamageMax	= 60
	AmmoPerFire	= 1

	TraceRange		= 16384
	FireRate		= 1.0
	FireAnimRate	= 1.0
	ClipReload		= 1.66
}
