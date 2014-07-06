/* =============================================================================
:: File Name	::	EonDT_HumanRifle.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonDT_HumanRifle extends Eon_DamageType;


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	DeathString="%k put a hole in %o"
	MaleSuicide="%o shot himself in the foot."
	FemaleSuicide="%o shot herself in the foot."

	bNeverSevers=true
	bBulletHit=True
}
