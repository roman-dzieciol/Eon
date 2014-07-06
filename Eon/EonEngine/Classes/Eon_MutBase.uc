/* =============================================================================
:: File Name	::	Eon_MutBase.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_MutBase extends Mutator
	HideDropDown
	CacheExempt;

function bool CheckRelevance(Actor Other)
{
	LogClass("CheckRelevance" @ Other);
	return Super.CheckRelevance(Other);
}


simulated final function LogClass	( coerce string S ){ Log(S@"["$Name$"]", 'MT');}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	DefaultWeaponName=""
}
