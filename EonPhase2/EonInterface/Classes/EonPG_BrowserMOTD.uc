/* =============================================================================
:: File Name	::	EonPG_BrowserMOTD.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPG_BrowserMOTD extends UT2k4Browser_MOTD;

event Opened(GUIComponent Sender)
{
	l_Version.Caption = VersionString @ PlayerOwner().Level.EngineVersion @ class'EonConfig.ECFG_Build'.default.Build;
	if ( !GotMOTD )
	{
		DisableComponent(b_QuickConnect);
		Refresh();
	}

	Super(UT2k4Browser_Page).Opened(Sender);
}
/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

}
