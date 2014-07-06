/* =============================================================================
:: File Name	::	Eon_PageMidOptions.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageMidGameSmall extends Eon_PageBase;

var bool			bIgnoreEsc;

var() GUIImage		MenuBG;
var() Eon_Button	Back;
var() Eon_Button	Options;
var() Eon_Button	EndGame;
var() Eon_Button	ExitGame;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	MenuBG		= GUIImage(Controls[0]);
	Back		= Eon_Button(Controls[1]);
	Options		= Eon_Button(Controls[2]);
	EndGame		= Eon_Button(Controls[3]);
	ExitGame	= Eon_Button(Controls[4]);

}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
	// Swallow first escape key event (key up from key down that opened menu)
	if( bIgnoreEsc && Key == 0x1B )
	{
		bIgnoreEsc = false;
		return true;
	}
}

function InternalOnClose(optional Bool bCanceled)
{
	local PlayerController pc;

	pc = PlayerOwner();

	// Turn pause off if currently paused
	if( pc != None && pc.Level.Pauser != None )
		pc.SetPause(false);

	Super.OnClose(bCanceled);
}

function bool InternalOnClick(GUIComponent Sender)
{
	switch( Sender )
	{
		case Back:		Controller.CloseMenu();									break;
		case Options:	Controller.OpenMenu("EonInterface.Eon_PageMidOptions");	break;
		case EndGame:	Controller.OpenMenu("EonInterface.Eon_PageMidEnd");		break;
		case ExitGame:	Controller.OpenMenu("EonInterface.Eon_PageMidQuit");	break;
	}

	return true;
}

function InternalOnDeActivate()
{
	bVisible = false;
}

function InternalOnActivate()
{
	bVisible = true;
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=GUIImage name=oBGImage
		WinWidth=1.0
		WinHeight=1.0
		WinTop=0
		WinLeft=0
		Image=Material'EonTX_Menu.Buttons.btn-d-none-50'
		ImageColor=(R=255,G=255,B=255,A=255);
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Stretched
		bAcceptsInput=false
		bNeverFocus=true
		bBoundToParent=true
		bScaleToParent=true
	End Object

	Begin Object Class=Eon_Button Name=oContinue
		WinWidth=0.2
		WinTop=0.4675
		WinLeft=0.04
		Caption="Continue"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_Button Name=oOptions
		WinWidth=0.2
		WinTop=0.4675
		WinLeft=0.28
		Caption="Options"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_Button Name=oEndGame
		WinWidth=0.2
		WinTop=0.4675
		WinLeft=0.52
		Caption="End Game"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_Button Name=oExitGame
		WinWidth=0.2
		WinTop=0.4675
		WinLeft=0.76
		Caption="Exit Game"
		OnClick=InternalOnClick
	End Object


	Controls(0)=oBGImage
	Controls(1)=oContinue
	Controls(2)=oOptions
	Controls(3)=oEndGame
	Controls(4)=oExitGame

	WinWidth=1.0
	WinHeight=0.1
	WinTop=0.45
	WinLeft=0.0

	OnKeyEvent=InternalOnKeyEvent
	OnClose=InternalOnClose
	OnDeActivate=InternalOnDeActivate
	OnActivate=InternalOnActivate

	bIgnoreEsc=true
	bRequire640x480=false
	bAllowedAsLast=true
	bDisconnectOnOpen=false
}
