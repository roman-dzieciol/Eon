/* =============================================================================
:: File Name	::	EonPG_MainMenu.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPG_MainMenu extends EonPG_Page;

var() automated GUIImage			Logo;
var() automated GUIImage			Officer;
var() automated Eon_ButtonMenu		ButtonQuit;
var() automated Eon_ButtonMenu		ButtonOptions;
var() automated Eon_ButtonMenu		ButtonAbout;
var() automated Eon_ButtonMenu		ButtonPlay;
var() automated Eon_ButtonMenu		ButtonBrowser;
var() automated Eon_ButtonMenu		ButtonHostGame;
var() automated Eon_Label			Build;

var() bool		bIgnoreEsc;
var() bool		AllowClose;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float	X,Y,W,H,M;
	local int	T;

	X = 0.25;
	Y = 0.0;
	W = 0.75;
	H = 1.0;
	SetupComponent( Officer, W, H, X, Y, M, T );

	X = 0.0351562;
	Y = 0.046875;
	W = 0.518555;
	H = 0.679688;
	SetupComponent( Logo, W, H, X, Y, M, T );

	X = 0.0351562;
	Y = 0.465885;
	W = 0.28125;
	H = 0.09375;
	M = 0.00625;
	SetupComponent( ButtonPlay, W, H, X, Y, M, T );

	W = 0.5625;
	SetupComponent( ButtonBrowser, W, H, X, Y, M, T );
	SetupComponent( ButtonHostGame, W, H, X, Y, M, T );
	SetupComponent( ButtonOptions, W, H, X, Y, M, T );

	W = 0.28125;
	//SetupComponent( ButtonAbout, W, H, X, Y, M, T );
	SetupComponent( ButtonQuit, W, H, X, Y, M, T );

	X = 0.0;
	Y = 0.98;
	W = 1.0;
	H = 0.02;
	SetupComponent( Build, W, H, X, Y, M, T );


	Super.InitComponent(MyController, MyOwner);

	Background	= CFG_LoadingScreens.static.GetRandomScreen();
	Build.Caption = class'ECFG_Build'.default.Build;
}

function bool IKeyEvent(out byte Key, out byte State, float delta)
{
	if( Key == 0x1B && State == 1 )	// Escape pressed
	{
		AllowClose = true;
		return true;
	}
	else
		return false;
}

function bool ICanClose(optional bool bCanceled)
{
	if( AllowClose )	PlayerOwner().ConsoleCommand("exit");
	return false;
}

function bool IClick(GUIComponent Sender)
{
	switch( Sender )
	{
		case ButtonPlay:
		case ButtonAbout:
		case ButtonOptions:
		case ButtonHostGame:
		case ButtonBrowser:		Controller.OpenMenu(Sender.INIOption);		break;
		case ButtonQuit:		PlayerOwner().ConsoleCommand("exit");		break;
	}
	return true;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

	Begin Object class=GUIImage Name=oMenuChar
		Image=Material'EonTX_Backgrounds.Character.char-officer'
		ImageColor=(R=255,G=255,B=255,A=224);
		ImageRenderStyle=MSTY_Alpha
		ImageStyle=ISTY_Scaled
	End Object

	Begin Object class=GUIImage Name=oTextEon
		Image=Material'EonTX_Menu.Logo.text-eon'
		ImageColor=(R=255,G=255,B=255,A=224);
		ImageRenderStyle=MSTY_Alpha
		ImageStyle=ISTY_Scaled
	End Object


	Begin Object Class=Eon_ButtonMenu Name=oPlay
		INIOption="EonInterface.EonPG_Play"
		Hint="Play"
		StyleName="EonButtonPlay"
		OnClick=IClick
	End Object

	Begin Object Class=Eon_ButtonMenu Name=oServerBrowser
		INIOption="EonInterface.EonPG_ServerBrowser"
		StyleName="EonButtonJoinGame"
		OnClick=IClick
		Hint="Join Game"
	End Object

	Begin Object Class=Eon_ButtonMenu Name=oButtonHostGame
		INIOption="EonInterface.EonPG_HostGame"
		StyleName="EonButtonHostGame"
		OnClick=IClick
		Hint="Host Game"
	End Object

	Begin Object Class=Eon_ButtonMenu Name=oOptions
		INIOption="EonInterface.EonPG_Options"
		Hint="Options"
		StyleName="EonButtonOptions"
		OnClick=IClick
	End Object

	Begin Object Class=Eon_ButtonMenu Name=oAbout
		INIOption="EonInterface.EonPG_About"
		Hint="About"
		StyleName="EonButtonAbout"
		OnClick=IClick
	End Object

	Begin Object Class=Eon_ButtonMenu Name=oQuit
		Hint="Quit"
		StyleName="EonButtonQuit"
		OnClick=IClick
	End Object

	Begin Object Class=Eon_Label Name=oBuild
		TextFont="EonDefaultFont"
		StyleName=""
		TextAlign=TXTA_Center
		TextColor=(R=153,G=146,B=136,A=192)
	End Object

	Logo			= oTextEon
	Officer			= oMenuChar
	ButtonQuit		= oQuit
	ButtonOptions	= oOptions
	//ButtonAbout		= oAbout
	ButtonPlay		= oPlay
	ButtonBrowser	= oServerBrowser
	ButtonHostGame	= oButtonHostGame
	Build			= oBuild

	OnCanClose=ICanClose
	OnKeyEvent=IKeyEvent

	AllowClose=False
	bAllowedAsLast=true
	bDisconnectOnOpen=true


}
