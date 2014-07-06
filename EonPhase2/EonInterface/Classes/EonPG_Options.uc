/* =============================================================================
:: File Name	::	EonPG_Options.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPG_Options extends EonPG_Page;

var() automated GUIImage			MenuBG;
var() automated GUIImage			MenuChar;
var() automated GUIImage			MenuLogo;
var() automated Eon_Button			Back;
var() automated Eon_TitleBar		TitleBar;
var() automated Eon_TabControl		TabControl;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	Background	= CFG_LoadingScreens.static.GetRandomScreen();

	TabControl.AddTab("Video"		,"EonInterface.EonTB_Video"			,,"Video Options"	,true);
	TabControl.AddTab("Audio"		,"EonInterface.EonTB_Audio"			,,"Audio Options"	,false);
	TabControl.AddTab("Input"		,"EonInterface.EonTB_Input"			,,"Input Options"	,false);
}

function bool IClick(GUIComponent Sender)
{
	switch( Sender )
	{
	case Back:
		Controller.CloseMenu(true);
		return true;
	}
	return true;
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

event HandleParameters(string Param1, string Param2)
{
	if( Param1 == "NOBG" )
	{
		BackgroundRStyle = MSTY_None;
		bRenderWorld = True;
		bAllowedAsLast = true;
	}
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

	Begin Object class=GUIImage Name=oMenuLogo
		WinWidth=0.518555
		WinHeight=0.679688
		WinLeft=0.0351562
		WinTop=0.046875
		Image=Material'EonTX_Menu.Logo.text-eon'
		ImageColor=(R=255,G=255,B=255,A=64);
		ImageRenderStyle=MSTY_Alpha
		ImageStyle=ISTY_Scaled
	End Object

	Begin Object Class=Eon_Button Name=oBack
		Hint="Back"
		Caption="Back"
		WinWidth=0.097656
		WinHeight=0.065000
		WinLeft=0.017578
		WinTop=0.911563
		OnClick=IClick
	End Object

	Begin Object Class=Eon_TabControl Name=oTabControl
		WinHeight=0.065
		WinWidth=0.96484375
		WinLeft=0.0175781
		WinTop=0.0234375
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
	MenuLogo	= oMenuLogo
	Back		= oBack
	TitleBar	= oTitleBar
	TabControl	= oTabControl
}
