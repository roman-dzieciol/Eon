/* =============================================================================
:: File Name	::	EonPG_About.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPG_About extends EonPG_Page config(EonGUI);


struct sTab
{
	var() config string	TabName;
	var() config string	TabHint;
};

var() automated GUIImage		MenuBG;
var() automated GUIImage		MenuChar;
var() automated GUIImage		TextEon;

var() automated Eon_Button		ButtonBack;
var() automated Eon_TabControl	TabControl;
var() automated Eon_TitleBar	TitleBar;

var() config array<sTab>		Tabs;
var() string					TabPage;



function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);
	Background = class'ECFG_LoadingScreens'.static.GetRandomScreen();

	while( Tabs.Length > 0 )
	{
		log("adding tab"@Tabs[0].TabName);
		TabControl.AddTab( Tabs[0].TabName, TabPage, , Tabs[0].TabHint, true );
		Tabs.Remove(0,1);
	}
}

function bool InternalOnClick(GUIComponent Sender)
{
	switch( Sender )
	{
		case ButtonBack:
			TabControl.ActiveTab.OnDeActivate();
			Controller.CloseMenu(true);
			return true;
		break;

	}
	return true;
}

function LevelChanged()
{
	Super.LevelChanged();
	Controller.CloseMenu(true);
}


/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
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

	Begin Object Class=Eon_Button Name=oButtonBack
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

	MenuBG		= oMenuBG
	MenuChar	= oMenuChar
	TextEon		= oTextEon
	ButtonBack	= oButtonBack
	TabControl	= oTabControl
	TitleBar	= oTitleBar

	WinWidth=1.0
	WinHeight=1.0
	WinTop=0.0
	WinLeft=0.0

	TabPage="EonInterface.EonTB_Text"
}
