/* =============================================================================
:: File Name	::	Eon_ServerBrowser.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_ServerBrowser extends ServerBrowser;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	Background	= class'EonGUI.Eon_LoadingVignette'.static.GetRandomScreen();
}

function MOTDVerified(bool bMSVerified)
{
	local Browser_ServerListPageMS NewPage;

	if( bCreatedQueryTabs )
		return;

	bCreatedQueryTabs = true;

	AddBrowserPage(BuddiesPage);

	NewPage = new(None) class'Browser_ServerListPageMS';
	NewPage.GameType = "EON";
	NewPage.PageCaption = "Eon Servers";
	AddBrowserPage(NewPage);
}

function bool HaveBonusPack()
{
	return false;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Background=Material'EonTS_GUI.Background.Dark'
	BackgroundRStyle=MSTY_Modulated

	bAllowedAsLast=true
}
