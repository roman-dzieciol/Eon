/* =============================================================================
:: File Name	::	Eon_PanelMidGameBar.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PanelMidGameBar extends Eon_PanelMidGame;

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
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=GUIImage name=oBGImage
		WinWidth=1.0
		WinHeight=1.0
		WinTop=0
		WinLeft=0
		Image=Material'EonTX_Menu.Buttons.btn-d-none-100'
		ImageColor=(R=0,G=255,B=0,A=255);
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
		OnClick=Eon_PanelMidGameBar.InternalOnClick
	End Object

	Begin Object Class=Eon_Button Name=oOptions
		WinWidth=0.2
		WinTop=0.4675
		WinLeft=0.28
		Caption="Options"
		OnClick=Eon_PanelMidGameBar.InternalOnClick
	End Object

	Begin Object Class=Eon_Button Name=oEndGame
		WinWidth=0.2
		WinTop=0.4675
		WinLeft=0.52
		Caption="End Game"
		OnClick=Eon_PanelMidGameBar.InternalOnClick
	End Object

	Begin Object Class=Eon_Button Name=oExitGame
		WinWidth=0.2
		WinTop=0.4675
		WinLeft=0.76
		Caption="Exit Game"
		OnClick=Eon_PanelMidGameBar.InternalOnClick
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

	OnDeActivate=Eon_PanelMidGameBar.InternalOnDeActivate
	OnActivate=Eon_PanelMidGameBar.InternalOnActivate
}
