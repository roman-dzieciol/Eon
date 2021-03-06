/* =============================================================================
:: File Name	::	Eon_PageMidQuit.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright � 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageMidQuit extends Eon_PageBase;


function bool InternalOnClick(GUIComponent Sender)
{
	if( Sender == Controls[1] )
	{
		Controller.CloseMenu();
	}
	else if( Sender == Controls[2] )
	{
		PlayerOwner().ConsoleCommand("exit");
	}
	return true;
}

/* =============================================================================
:: Copyright � 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
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

	Begin Object Class=Eon_Button Name=oBack
		WinWidth=0.2
		WinTop=0.4675
		WinLeft=0.52
		Caption="Back"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_Button Name=oExitGame
		WinWidth=0.2
		WinTop=0.4675
		WinLeft=0.76
		Caption="Exit Game"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_Label Name=oLabel
		WinWidth=0.44
		WinTop=0.4675
		WinLeft=0.04
		Caption="Are you sure?"
		TextAlign=TXTA_Center
	End Object


	Controls(0)=oBGImage
	Controls(1)=oBack
	Controls(2)=oExitGame
	Controls(3)=oLabel

	WinWidth=1.0
	WinHeight=0.1
	WinTop=0.45
	WinLeft=0.0

	bRequire640x480=false
	bAllowedAsLast=false
	bDisconnectOnOpen=false
}
