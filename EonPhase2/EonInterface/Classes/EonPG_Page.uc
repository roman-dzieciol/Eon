/* =============================================================================
:: File Name	::	EonPG_Page.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPG_Page extends GUIPage;

var() class<ECFG_LoadingScreens>	CFG_LoadingScreens;

final function SetupComponent( GUIComponent G, float W, float H, float X, out float Y, float M, out int T )
{
	G.WinWidth	= W;
	G.WinHeight	= H;
	G.WinLeft	= X;
	G.WinTop	= Y;	Y += H+M;

	if( G.bTabStop )
		G.TabOrder	= T++;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	CFG_LoadingScreens=class'EonConfig.ECFG_LoadingScreens'

	WinWidth=1.0
	WinHeight=1.0
	WinTop=0.0
	WinLeft=0.0
}
