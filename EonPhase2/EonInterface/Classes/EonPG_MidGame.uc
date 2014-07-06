/* =============================================================================
:: File Name	::	EonPG_MidGame.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPG_MidGame extends EonPG_Page;


var() automated Eon_TabControl	TabControl;

var() automated GUIImage	MenuBG;
var() automated GUIImage	MenuChar;
var() automated GUIImage	TextEon;
var() automated Eon_Button	Back;
var() automated Eon_Button	Options;
var() automated Eon_Button	Forfeit;
var() automated Eon_Button	ExitGame;
var() automated Eon_Button	Browser;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float	ButtonWidth, ButtonTop, PageMargin;
	local int	i, ButtonNumber, T;

	Super.InitComponent(MyController, MyOwner);


	ButtonNumber		= 5;
	ButtonWidth			= 0.96484375 / ButtonNumber;
	ButtonTop			= 0.911563;
	PageMargin			= 0.0175781;

	Back.WinWidth		= ButtonWidth;
	Back.WinTop			= ButtonTop;
	Back.WinLeft		= PageMargin+ButtonWidth*i++;
	Back.TabOrder		= T++;

	Options.WinWidth	= ButtonWidth;
	Options.WinTop		= ButtonTop;
	Options.WinLeft		= PageMargin+ButtonWidth*i++;
	Options.TabOrder		= T++;

	Browser.WinWidth	= ButtonWidth;
	Browser.WinTop		= ButtonTop;
	Browser.WinLeft		= PageMargin+ButtonWidth*i++;
	Browser.TabOrder		= T++;

	Forfeit.WinWidth	= ButtonWidth;
	Forfeit.WinTop		= ButtonTop;
	Forfeit.WinLeft		= PageMargin+ButtonWidth*i++;
	Forfeit.TabOrder		= T++;

	ExitGame.WinWidth	= ButtonWidth;
	ExitGame.WinTop		= ButtonTop;
	ExitGame.WinLeft	= PageMargin+ButtonWidth*i++;
	ExitGame.TabOrder		= T++;

	CreateTabs();
}



function CreateTabs()
{
	TabControl.AddTab("Map"		,"EonInterface.EonTB_Map"		,,"Map"		,true);
	TabControl.AddTab("Help"	,"EonInterface.EonTB_Help"		,,"Help"	,false);
	TabControl.AddTab("Player"	,"EonInterface.EonTB_Avatar"	,,"Player"	,false);
}

function LevelChanged()
{
	Super.LevelChanged();
	Controller.CloseMenu(true);
}


function bool IClick(GUIComponent Sender)
{
	switch( Sender )
	{
		case Back:		Controller.CloseMenu();
						break;

		case Options:	Controller.ReplaceMenu("EonInterface.EonPG_Options", "NOBG");
						break;

		case Browser:	Controller.ReplaceMenu("EonInterface.EonPG_ServerBrowser", "NOBG");
						break;

		case Forfeit:PlayerOwner().ConsoleCommand( "DISCONNECT" );
						Controller.ReplaceMenu("EonInterface.EonPG_MainMenu");
						break;

		case ExitGame:	PlayerOwner().ConsoleCommand("exit");
						break;
	}

	return true;
}

function IClose(optional Bool bCanceled)
{
	Super.OnClose(bCanceled);
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bAllowedAsLast=true
	bDisconnectOnOpen=false
	bRenderWorld=True

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
		ImageColor=(R=255,G=255,B=255,A=64)
		ImageRenderStyle=MSTY_Alpha
		ImageStyle=ISTY_Scaled
	End Object

	Begin Object Class=Eon_TabControl Name=oTabControl
		WinHeight=0.065
		WinWidth=0.96484375
		WinLeft=0.0175781
		WinTop=0.0234375
	End Object

	Begin Object Class=Eon_Button Name=oContinue
		WinWidth=0.18593751
		WinTop=0.911563
		WinLeft=0.04
		Caption="Continue"
		OnClick=IClick
	End Object

	Begin Object Class=Eon_Button Name=oOptions
		Caption="Options"
		OnClick=IClick
	End Object

	Begin Object Class=Eon_Button Name=oServerBrowser
		Caption="Server Browser"
		OnClick=IClick
	End Object

	Begin Object Class=Eon_Button Name=oForfeit
		Caption="Forfeit"
		OnClick=IClick
	End Object

	Begin Object Class=Eon_Button Name=oExitGame
		Caption="Exit Game"
		OnClick=IClick
	End Object

	MenuBG			= oMenuBG
	MenuChar		= oMenuChar
	TextEon			= oTextEon
	TabControl		= oTabControl
	Back			= oContinue
	Options			= oOptions
	Browser			= oServerBrowser
	Forfeit			= oForfeit
	ExitGame		= oExitGame

	OnClose=IClose
}
