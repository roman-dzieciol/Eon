/* =============================================================================
:: File Name	::	EonTB_Tab.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonTB_Tab extends GUITabPanel;

#include ../Eon/_inc/const/teams.uc

final function SetupComponent( GUIComponent G, float W, float H, float X, out float Y, float M, out int T )
{
	G.WinWidth	= W;
	G.WinHeight	= H;
	G.WinLeft	= X;
	G.WinTop	= Y;	Y += H+M;

	if( G.bTabStop )
		G.TabOrder	= T++;
}

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
}
