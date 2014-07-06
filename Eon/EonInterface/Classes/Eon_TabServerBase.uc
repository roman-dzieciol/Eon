/* =============================================================================
:: File Name	::	Eon_TabServerBase.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabServerBase extends Eon_TabBase;

var Eon_PageServerBrowser	Browser;
var() localized string		PageCaption;

function OnCloseBrowser();

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	WinWidth=0.8945314
	WinHeight=0.790469
	WinLeft=0.0527343
	WinTop=0.105365

	bAcceptsInput=false
}
