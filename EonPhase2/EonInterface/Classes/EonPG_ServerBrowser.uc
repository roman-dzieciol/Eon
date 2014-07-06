/* =============================================================================
:: File Name	::	EonPG_ServerBrowser.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPG_ServerBrowser extends UT2k4ServerBrowser;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super(UT2K4MainPage).InitComponent(MyController, MyOwner);

	f_Browser = UT2K4Browser_Footer(t_Footer);

	f_Browser.p_Anchor = Self;
	f_Browser.ch_Standard.OnChange = StandardOptionChanged;
	f_Browser.ch_Standard.SetComponentValue(bStandardServersOnly, False);
	f_Browser.ch_Standard.DisableMe();

	if (FilterMaster == None)
	{
		FilterMaster = new(Self) class'GUI2K4.BrowserFilters';
		FilterMaster.InitCustomFilters();
	}

	if (FilterInfo == None)
		FilterInfo = new(None) class'Engine.PlayInfo';

	Background=MyController.DefaultPens[0];

	InitializeGameTypeCombo();
	co_GameType.MyComboBox.Edit.bCaptureMouse = True;
	CreateTabs();
}

function SetStandardServersOption( bool bOnlyStandard )
{
	bOnlyStandard = False;
	if ( bOnlyStandard != bStandardServersOnly )
	{
		bStandardServersOnly = bOnlyStandard;
		SaveConfig();

		Refresh();
	}
}

event HandleParameters(string Param1, string Param2)
{
	if( Param1 == "NOBG" )
	{
		bAllowedAsLast = true;
	}
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bStandardServersOnly=False
	CurrentGameType="EonGame.EonGI_Game"
	PanelClass(0)="EonInterface.EonPG_BrowserMOTD"
	PanelClass(1)="GUI2K4.UT2K4Browser_IRC"
	PanelClass(2)="GUI2K4.UT2K4Browser_ServerListPageFavorites"
	PanelClass(3)="GUI2K4.UT2K4Browser_ServerListPageLAN"
	PanelClass(4)="GUI2K4.UT2K4Browser_ServerListPageBuddy"
	PanelClass(5)="GUI2K4.UT2K4Browser_ServerListPageInternet"
}
