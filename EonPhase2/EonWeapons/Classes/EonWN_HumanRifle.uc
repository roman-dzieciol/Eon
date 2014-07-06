/* =============================================================================
:: File Name	::	EonWP_HumanRifle.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonWN_HumanRifle extends Eon_Weapon;


// ============================================================================
// AI Interface
// no need for it atm
// ============================================================================

function float SuggestAttackStyle()
{
	return 0;
}

function float GetAIRating()
{
	return 0;
}

function byte BestMode()
{
	return 0;
}

function float SuggestDefenseStyle()
{
	return 0;
}

// ============================================================================
// HUD
// ============================================================================



simulated function DrawWeaponInfo(Canvas Canvas)
{
}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	PickupClass=class'EonWeapons.EonWP_HumanRifle'
	AttachmentClass=class'EonWeapons.EonWA_HumanRifle'
	FireModeClass(0)=class'EonWeapons.EonWF_HumanRifle'
	FireModeClass(1)=class'EonWeapons.EonWF_HumanRifle'

	ItemName="Human Rifle"
	Description="This high muzzle velocity sniper rifle with a 10X scope is a lethal weapon at any range, especially if you can land a head shot."
	HudColor=(r=255,g=128,b=192,a=255)

	DefaultPriority=2
	InventoryGroup=2

	bCanThrow=false


	SelectForce="SwitchToAssaultRifle"
}
