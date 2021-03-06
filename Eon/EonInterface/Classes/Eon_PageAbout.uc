/* =============================================================================
:: File Name	::	Eon_PageAbout.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright � 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageAbout extends Eon_PageBase config(EonGUI);

struct sTab
{
	var() config string	TabName;
	var() config string	TabPage;
	var() config string	TabHint;
};

var() Eon_Button		ButtonBack;
var() Eon_TabControl	TabControl;
var() Eon_TitleBar		TitleBar;

var() config array<sTab> Tabs;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local int i;
	Super.InitComponent(MyController, MyOwner);
	Background = class'Eon_LoadingVignette'.static.GetRandomScreen();

	ButtonBack	= Eon_Button(Controls[3]);
	TabControl	= Eon_TabControl(Controls[4]);
	TitleBar	= Eon_TitleBar(Controls[5]);

	for(i=0; i<Tabs.Length; i++)
	{
		Log(Tabs[i].TabName);
		TabControl.AddTab( Tabs[i].TabName, Tabs[i].TabPage, , Tabs[i].TabHint );
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

event ChangeHint(string NewHint)
{
	TitleBar.Caption = NewHint;
}

/* =============================================================================
:: Copyright � 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
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

	Controls(0)=oMenuBG
	Controls(1)=oMenuChar
	Controls(2)=oTextEon
	Controls(3)=oBTNBack
	Controls(4)=oTabControl
	Controls(5)=oTitleBar

	OnReOpen=InternalOnReOpen

	WinWidth=1.0
	WinHeight=1.0
	WinTop=0.0
	WinLeft=0.0
}
