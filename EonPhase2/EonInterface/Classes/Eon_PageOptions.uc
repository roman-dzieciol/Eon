/* =============================================================================
:: File Name	::	Eon_PageOptions.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageOptions extends Eon_PageBase;

var() Eon_Button		ButtonBack;
var() GUITabControl	TabControl;
var() Eon_TitleBar		TitleBar;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	Background	= class'EonConfig.ECFG_LoadingScreens'.static.GetRandomScreen();
/*	ButtonBack	= Eon_Button(Controls[3]);
	TabControl	= Eon_TabControl(Controls[4]);
	TitleBar	= Eon_TitleBar(Controls[5]);*/

	TabControl.AddTab("Video"		,"EonInterface.Eon_TabVideo"		,,"Video Options"	,true);
	TabControl.AddTab("Detail"		,"EonInterface.Eon_TabVideoDetails"	,,"Detail Options"	,false);
	TabControl.AddTab("Audio"		,"EonInterface.Eon_TabAudio"		,,"Audio Options"	,false);
	TabControl.AddTab("Controls"	,"EonInterface.Eon_TabControls"		,,"Controls"		,false);
	TabControl.AddTab("Input"		,"EonInterface.Eon_TabInput"		,,"Input Options"	,false);
}

function bool IClick(GUIComponent Sender)
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

function IReOpen()
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
		OnClick=IClick
		TabOrder=0
	End Object

	Begin Object Class=GUITabControl Name=oTabControl
		WinHeight=0.065
		WinWidth=0.96484375
		WinLeft=0.0175781
		WinTop=0.0234375
		TabHeight=0.065
		TabOrder=1
	End Object

	Begin Object class=Eon_TitleBar name=oTitleBar
		Caption="Options"
		WinWidth=0.86718775
		WinHeight=0.065000
		WinLeft=0.1152341
		WinTop=0.911563
	End Object

		//bAcceptsInput=true
		//bDockPanels=false
/*
	Controls(0)=oMenuBG
	Controls(1)=oMenuChar
	Controls(2)=oTextEon
	Controls(3)=oBTNBack
	Controls(4)=oTabControl
	Controls(5)=oTitleBar*/

	ButtonBack=oBTNBack;
	TabControl=oTabControl;
	TitleBar=oTitleBar;

	OnReOpen=IReOpen

	WinWidth=1.0
	WinHeight=1.0
	WinTop=0.0
	WinLeft=0.0
}
