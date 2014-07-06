/* =============================================================================
:: File Name	::	Eon_PageServerBrowser.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageServerBrowser extends Eon_PageBase;

var Browser_Page MOTDPage;

var Eon_TabServerNews		TabServerNews;
var Eon_TabServerFilter		TabServerFilter;
var Eon_TabServerListLAN	TabServerListLAN;
var Eon_TabServerListEon	TabServerListEon;

var() Eon_Button		ButtonBack;
var() Eon_TabControl	TabControl;
var() Eon_TitleBar		TitleBar;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	Background	= class'EonConfig.ECFG_LoadingScreens'.static.GetRandomScreen();
	ButtonBack	= Eon_Button(Controls[3]);
	TabControl	= Eon_TabControl(Controls[4]);
	TitleBar	= Eon_TitleBar(Controls[5]);

	AddBrowserPage(TabServerNews);
	TabServerNews.OnMOTDVerified = MOTDVerified;
}

function MOTDVerified()
{
	AddBrowserPage(TabServerFilter);
	AddBrowserPage(TabServerListLAN);
	AddBrowserPage(TabServerListEon);
}

function AddBrowserPage( Eon_TabServerBase NewPage )
{
	NewPage.Browser = Self;
	TabControl.AddTab( NewPage.PageCaption, "", NewPage );
}

function bool InternalOnClick(GUIComponent Sender)
{
	switch( Sender )
	{
		case ButtonBack:
			TabControl.ActiveTab.OnDeActivate();
			Controller.CloseMenu(true);
			return true;
	}
	return true;
}

function InternalOnReOpen()
{
	if( TabControl.ActiveTab != None && TabControl.ActiveTab.MyPanel != None )
		TabControl.ActiveTab.MyPanel.Refresh();
}

function LevelChanged()
{
	Super.LevelChanged();
	Controller.CloseMenu(true);
}

function InternalOnClose(optional Bool bCanceled)
{
	local int i;

	for(i=0; i<TabControl.TabStack.Length; i++)
		Eon_TabServerBase(TabControl.TabStack[i].MyPanel).OnCloseBrowser();

	Super.OnClose(bCanceled);
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.

	bCheckResolution=true
	bCreatedQueryTabs=False
	bPersistent=true

	MutantTypeName="Mutant"
	MutantType="xMutantGame"

	InvasionTypeName="Invasion"
	InvasionType="Invasion"

	LMSTypeName="Last Man Standing"
	LMSType="xLastManStanding"

	//Filtering
	StatsServerView=SSV_Any
	ViewMutatorMode=VMM_AnyMutators
	WeaponStayServerView=WSSV_Any
	TranslocServerView=TSV_Any
	bOnlyShowStandard=false
	bOnlyShowNonPassword=false
	bDontShowFull=false
	bDontShowEmpty=false
	bDontShowWithBots=false;
	DesiredMutator=""
	CustomQuery=""
	MinGamespeed=0
	MaxGamespeed=200
		GameType="Eon"
============================================================================= */
DefaultProperties
{
	Begin Object Class=Eon_TabServerNews Name=oTabServerNews
		PageCaption="News"
	End Object

	Begin Object Class=Eon_TabServerFilter Name=oTabServerFilter
		PageCaption="Filter"
	End Object

	Begin Object Class=Eon_TabServerListLAN Name=oTabServerListLAN
		PageCaption="LAN Servers"
	End Object

	Begin Object Class=Eon_TabServerListEon Name=oTabServerListEon
		PageCaption="Internet Servers"
	End Object

	Begin Object class=GUIImage Name=oMenuBG
		WinWidth=0.96484375
		WinHeight=0.953125
		WinLeft=0.0175781
		WinTop=0.0234375
		Image=Material'EonTS_GUI.Background.Dark'
		ImageColor=(R=255,G=255,B=255,A=255);
		ImageRenderStyle=MSTY_Modulated
		ImageStyle=ISTY_Stretched
	End Object

	Begin Object class=GUIImage Name=oMenuChar
		WinWidth=0.75
		WinHeight=1
		WinLeft=0.25
		WinTop=0
		Image=Material'EonTX_Backgrounds.Character.char-officer'
		ImageColor=(R=255,G=255,B=255,A=64);
		ImageRenderStyle=MSTY_Alpha
		ImageStyle=ISTY_Scaled
	End Object

	Begin Object class=GUIImage Name=oTextEon
		WinWidth=0.518555
		WinHeight=0.679688
		WinLeft=0.0351562
		WinTop=0.046875
		Image=Material'EonTX_Menu.Logo.text-eon'
		ImageColor=(R=255,G=255,B=255,A=64);
		ImageRenderStyle=MSTY_Alpha
		ImageStyle=ISTY_Scaled
	End Object

	Begin Object Class=Eon_Button Name=oBTNBack
		Hint="Back"
		Caption="Back"
		WinWidth=0.097656
		WinHeight=0.065000
		WinLeft=0.017578
		WinTop=0.911563
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_TabControl Name=oTabControl
		WinHeight=0.065
		WinWidth=0.96484375
		WinLeft=0.0175781
		WinTop=0.0234375
		TabHeight=0.065
		bAcceptsInput=true
		bDockPanels=false
	End Object

	Begin Object class=Eon_TitleBar name=oTitleBar
		Caption="Options"
		WinWidth=0.86718775
		WinHeight=0.065000
		WinLeft=0.1152341
		WinTop=0.911563
	End Object

	TabServerNews=oTabServerNews
	TabServerFilter=oTabServerFilter
	TabServerListLAN=oTabServerListLAN
	TabServerListEon=oTabServerListEon

	Controls(0)=oMenuBG
	Controls(1)=oMenuChar
	Controls(2)=oTextEon
	Controls(3)=oBTNBack
	Controls(4)=oTabControl
	Controls(5)=oTitleBar

	OnReOpen=InternalOnReOpen
	OnClose=InternalOnClose


	WinWidth=1.0
	WinHeight=1.0
	WinTop=0.0
	WinLeft=0.0
}
