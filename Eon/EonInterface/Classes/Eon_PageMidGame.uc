/* =============================================================================
:: File Name	::	Eon_PageMidGame.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageMidGame extends Eon_PageIngame;


var() Eon_TabControl	TabControl;

var() GUIImage		MenuBG;
var() Eon_Button	Back;
var() Eon_Button	Options;
var() Eon_Button	EndGame;
var() Eon_Button	ExitGame;
var() Eon_Button	Browser;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float	ButtonWidth, ButtonTop, PageMargin;
	local int	i, ButtonNumber;

	Super.InitComponent(MyController, MyOwner);

	MenuBG			= GUIImage(Controls[0]);
	TabControl		= Eon_TabControl(Controls[3]);
	Back			= Eon_Button(Controls[4]);
	Options			= Eon_Button(Controls[5]);
	Browser			= Eon_Button(Controls[6]);
	EndGame			= Eon_Button(Controls[7]);
	ExitGame		= Eon_Button(Controls[8]);

	ButtonNumber		= 5;
	ButtonWidth			= 0.96484375 / ButtonNumber;
	ButtonTop			= 0.911563;
	PageMargin			= 0.0175781;

	Back.WinWidth		= ButtonWidth;
	Back.WinTop			= ButtonTop;
	Back.WinLeft		= PageMargin+ButtonWidth*i++;

	Options.WinWidth	= ButtonWidth;
	Options.WinTop		= ButtonTop;
	Options.WinLeft		= PageMargin+ButtonWidth*i++;

	Browser.WinWidth	= ButtonWidth;
	Browser.WinTop		= ButtonTop;
	Browser.WinLeft		= PageMargin+ButtonWidth*i++;

	EndGame.WinWidth	= ButtonWidth;
	EndGame.WinTop		= ButtonTop;
	EndGame.WinLeft		= PageMargin+ButtonWidth*i++;

	ExitGame.WinWidth	= ButtonWidth;
	ExitGame.WinTop		= ButtonTop;
	ExitGame.WinLeft	= PageMargin+ButtonWidth*i++;

	CreateTabs();
}

function CreateTabs()
{
	TabControl.AddTab("Map",				"EonInterface.Eon_TabGameMap",,		"Map",			true);
	TabControl.AddTab("Player",				"EonInterface.Eon_TabGameAvatar",,	"Player",		false);
	TabControl.AddTab("Help",				"EonInterface.Eon_TabGameHelp",,	"Help",			false);
}

function InternalOnReOpen()
{
//	if( TabControl.ActiveTab != None && TabControl.ActiveTab.MyPanel != None )
//		TabControl.ActiveTab.MyPanel.Refresh();
}

function bool InternalOnClick(GUIComponent Sender)
{
	switch( Sender )
	{
		case Back:		TabControl.ActiveTab.OnDeActivate();
						Controller.CloseMenu();
						break;

		case Options:	TabControl.ActiveTab.OnDeActivate();
						Controller.OpenMenu("EonInterface.Eon_PageMidOptions");
						break;

		case Browser:	TabControl.ActiveTab.OnDeActivate();
						Controller.ReplaceMenu("EonInterface.Eon_ServerBrowserIngame");
						break;

		case EndGame:	TabControl.ActiveTab.OnDeActivate();
						PlayerOwner().ConsoleCommand( "DISCONNECT" );
						Controller.ReplaceMenu("EonInterface.Eon_PageMenu");
						break;

		case ExitGame:	TabControl.ActiveTab.OnDeActivate();
						PlayerOwner().ConsoleCommand("exit");
						break;
	}

	return true;
}

function InternalOnClose(optional Bool bCanceled)
{
	Super.OnClose(bCanceled);
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

	Begin Object Class=Eon_TabControl Name=oTabControl
		WinHeight=0.065
		WinWidth=0.96484375
		WinLeft=0.0175781
		WinTop=0.0234375
		TabHeight=0.065
		bAcceptsInput=true
		bDockPanels=false
	End Object

	Begin Object Class=Eon_Button Name=oContinue
		WinWidth=0.18593751
		WinTop=0.911563
		WinLeft=0.04
		Caption="Continue"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_Button Name=oOptions
		Caption="Options"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_Button Name=oServerBrowser
		Caption="Server Browser"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_Button Name=oEndGame
		Caption="End Game"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_Button Name=oExitGame
		Caption="Exit Game"
		OnClick=InternalOnClick
	End Object

	Controls(0)=oMenuBG
	Controls(1)=oMenuChar
	Controls(2)=oTextEon
	Controls(3)=oTabControl
	Controls(4)=oContinue
	Controls(5)=oOptions
	Controls(6)=oServerBrowser
	Controls(7)=oEndGame
	Controls(8)=oExitGame

	OnClose=InternalOnClose
	OnDeActivate=InternalOnDeActivate
	OnActivate=InternalOnActivate
	OnKeyEvent=InternalOnKeyEvent
	OnReOpen=InternalOnReOpen

}
