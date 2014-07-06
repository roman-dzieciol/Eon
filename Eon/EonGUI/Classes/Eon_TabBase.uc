/* =============================================================================
:: File Name	::	Eon_TabBase.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabBase extends GUITabPanel;

#include ../Eon/_inc/const/teams.uc

function NotifyOnClose();


// = INC =======================================================================

#include ../Eon/_inc/debug/Log.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	WinWidth=0.92
	WinHeight=0.725469
	WinLeft=0.04
	WinTop=0.105365

	bOldStyleMenus=True
}
