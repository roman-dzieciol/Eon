/* =============================================================================
:: File Name	::	Eon_PageMenu.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageMenu extends Eon_PageBase;

#exec OBJ LOAD FILE=InterfaceContent.utx

const CFG_LoadingScreens = class'EonConfig.ECFG_LoadingScreens';

var() GUIImage			MenuBG;
var() Eon_ButtonMenu	ButtonQuit;
var() Eon_ButtonMenu	ButtonOptions;
var() Eon_ButtonMenu	ButtonAbout;
var() Eon_ButtonMenu	ButtonPlay;
var() Eon_Button		ButtonBrowser;

var() bool				bIgnoreEsc;
var() bool				AllowClose;

var() string			PageAbout;
var() string			PageOptions;
var() string			PageQuit;
var() string			PageBrowser;
var() string			PagePlay;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	if( Eon_GUIController(MyController) == None )
	{
		Controller.OpenMenu("EonGUI.Eon_PageError", "1001");
	}

	MenuBG			= GUIImage(Controls[0]);
	ButtonQuit		= Eon_ButtonMenu(Controls[3]);
	ButtonOptions	= Eon_ButtonMenu(Controls[4]);
	ButtonAbout		= Eon_ButtonMenu(Controls[5]);
	ButtonPlay		= Eon_ButtonMenu(Controls[6]);
	ButtonBrowser	= Eon_Button(Controls[7]);

	Background		= CFG_LoadingScreens.static.GetRandomScreen();
}

function OnClose(optional Bool bCanceled)
{
}

function bool MyKeyEvent(out byte Key, out byte State, float delta)
{
	if(Key == 0x1B && State == 1)	// Escape pressed
	{
		AllowClose = true;
		return true;
	}
	else
		return false;
}

function bool CanClose(optional Bool bCanceled)
{
	if( AllowClose )
		Controller.OpenMenu(PageQuit);
	return false;
}

function bool ButtonClick(GUIComponent Sender)
{
	return true;
}

function bool InternalOnClick(GUIComponent Sender)
{
	switch( Sender )
	{
		case ButtonPlay:		Controller.OpenMenu(PagePlay);		break;
		case ButtonAbout:		Controller.OpenMenu(PageAbout);		break;
		case ButtonOptions:		Controller.OpenMenu(PageOptions);	break;
		case ButtonQuit:		Controller.OpenMenu(PageQuit);		break;
		case ButtonBrowser:		Controller.OpenMenu(PageBrowser);	break;
	}
	return true;
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
		ImageColor=(R=255,G=255,B=255,A=224);
		ImageRenderStyle=MSTY_Alpha
		ImageStyle=ISTY_Scaled
	End Object

	Begin Object class=GUIImage Name=oTextEon
		WinWidth=0.518555
		WinHeight=0.679688
		WinLeft=0.0351562
		WinTop=0.046875
		Image=Material'EonTX_Menu.Logo.text-eon'
		ImageColor=(R=255,G=255,B=255,A=224);
		ImageRenderStyle=MSTY_Alpha
		ImageStyle=ISTY_Scaled
	End Object

	Begin Object Class=Eon_Button Name=oBTNServerBrowser
		Hint="Server Browser"
		Caption="Server Browser"
		WinWidth=0.28125
		WinLeft=0.0351562
		WinTop=0.465885
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_ButtonMenu Name=oBTNPlay
		Hint="Play"
		WinWidth=0.28125
		WinHeight=0.09375
		WinLeft=0.0351562
		WinTop=0.565885
		StyleName="EonButtonPlay"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_ButtonMenu Name=oBTNAbout
		Hint="About"
		WinWidth=0.28125
		WinHeight=0.09375
		WinLeft=0.0351562
		WinTop=0.665885
		StyleName="EonButtonAbout"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_ButtonMenu Name=oBTNOptions
		Hint="Options"
		WinWidth=0.28125
		WinHeight=0.09375
		WinLeft=0.0351562
		WinTop=0.765885
		StyleName="EonButtonOptions"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_ButtonMenu Name=oBTNQuit
		Hint="Quit"
		WinWidth=0.281250
		WinHeight=0.093750
		WinLeft=0.035156
		WinTop=0.865885
		StyleName="EonButtonQuit"
		OnClick=InternalOnClick
	End Object

	Controls(0)=oMenuBG
	Controls(1)=oMenuChar
	Controls(2)=oTextEon
	Controls(3)=oBTNQuit
	Controls(4)=oBTNOptions
	Controls(5)=oBTNAbout
	Controls(6)=oBTNPlay
	Controls(7)=oBTNServerBrowser

	WinWidth=1.0
	WinHeight=1.0
	WinTop=0.0
	WinLeft=0.0
	OnCanClose=CanClose
	OnKeyEvent=MyKeyEvent
	AllowClose=False
	bAllowedAsLast=true
	bDisconnectOnOpen=true

	PageQuit="EonInterface.Eon_PageQuitAlt"
	PageAbout="EonInterface.Eon_PageAbout"
	PageOptions="EonInterface.Eon_PageOptions"
	PageBrowser="EonInterface.Eon_ServerBrowser"
	PagePlay="EonInterface.Eon_PagePlay"
}
