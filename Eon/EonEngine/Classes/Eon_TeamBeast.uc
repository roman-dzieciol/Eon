/* =============================================================================
:: File Name	::	Eon_TeamBeast.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TeamBeast extends Eon_TeamInfo;


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	TeamIndex=1
	TeamName="Beast"

	PlayerClasses(0)=class'EonEngine.EonPW_BeastShrike'
	PlayerClasses(1)=class'EonEngine.EonPW_BeastShepherd'
}
