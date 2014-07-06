/* =============================================================================
:: File Name	::	EonWA_HumanRifle.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonWA_HumanRifle extends Eon_WeaponAttachment;


simulated function UpdateHitClient(Actor HitActor, vector HitLocation, vector HitNormal)
{
	Spawn(HitEffectClass,,, HitLocation, Rotator(HitNormal));

}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Mesh				= SkeletalMesh'EonAN_Weapons.EonPSK_HumanRifle'
	MuzzleFlashClass	= class'XEffects.AssaultMuzFlash3rd'
	MuzzleBone			= Bone03
	HitEffectClass		= class'XEffects.xHeavyWallHitEffect'
}
