/* =============================================================================
:: File Name	::	Eon_PagePlay.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PagePlay extends Eon_PageBase;


var() Eon_Button		ButtonBack;
var() Eon_Button		ButtonPlay;
var() Eon_TabControl	TabControl;
var() Eon_TitleBar		TitleBar;
var() Eon_TabMenuPlay	TabMenuPlay;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	Background	= class'EonConfig.ECFG_LoadingScreens'.static.GetRandomScreen();
	ButtonBack	= Eon_Button(Controls[3]);
	TabControl	= Eon_TabControl(Controls[4]);
	TitleBar	= Eon_TitleBar(Controls[5]);
	ButtonPlay	= Eon_Button(Controls[6]);

	TabMenuPlay = Eon_TabMenuPlay(TabControl.AddTab("Map","EonInterface.Eon_TabMenuPlay",,"Map",false));
}

function bool InternalOnClick(GUIComponent Sender)
{
	switch( Sender )
	{
		case ButtonBack:
			TabControl.ActiveTab.OnDeActivate();
			Controller.CloseMenu(true);
		return true;

		case ButtonPlay:
			Console(Controller.Master.Console).DelayedConsoleCommand("start" @ TabMenuPlay.PlayURL);
			Controller.CloseAll(false);
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

event ChangeHint(string NewHint)
{
	TitleBar.Caption = NewHint;
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
		Caption="Play"
		WinWidth=0.769531
		WinHeight=0.065000
		WinLeft=0.1152341
		WinTop=0.911563
	End Object

	Begin Object Class=Eon_Button Name=oBTNPlay
		Hint="Play"
		Caption="Play"
		WinWidth=0.097656
		WinHeight=0.065000
		WinLeft=0.88476585
		WinTop=0.911563
		OnClick=InternalOnClick
	End Object

	Controls(0)=oMenuBG
	Controls(1)=oMenuChar
	Controls(2)=oTextEon
	Controls(3)=oBTNBack
	Controls(4)=oTabControl
	Controls(5)=oTitleBar
	Controls(6)=oBTNPlay

	OnReOpen=InternalOnReOpen

	WinWidth=1.0
	WinHeight=1.0
	WinTop=0.0
	WinLeft=0.0

}
