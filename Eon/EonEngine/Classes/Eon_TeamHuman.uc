/* =============================================================================
:: File Name	::	Eon_TeamHuman.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TeamHuman extends Eon_TeamInfo;


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	TeamIndex=0
	TeamName="Human"

	PlayerClasses(0)=class'EonEngine.EonPW_HumanLegionnaire'
	PlayerClasses(1)=class'EonEngine.EonPW_HumanMedic'
	PlayerClasses(2)=class'EonEngine.EonPW_HumanScout'
}
