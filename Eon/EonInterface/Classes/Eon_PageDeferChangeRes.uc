/* =============================================================================
:: File Name	::	Eon_PageDeferChangeRes.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageDeferChangeRes extends Eon_PageImportant;

function bool InternalOnClick(GUIComponent Sender)
{
	Controller.CloseMenu(false);
	return true;
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

	Begin Object Class=Eon_Button Name=oOKButton
		Caption="OK"
		WinWidth=0.2
		WinHeight=0.065000
		WinLeft=0.4
		WinTop=0.55
		OnClick=InternalOnClick
	End Object

	Begin Object class=GUILabel Name=oDialogTextA
		Caption="The resolution you have chosen is lower than the minimum menu resolution."
		TextALign=TXTA_Center
		WinWidth=1
		WinLeft=0
		WinTop=0.4
		WinHeight=0.065000
		StyleName="EonLabelQuestion"
	End Object

	Begin Object class=GUILabel Name=oDialogTextB
		Caption="It will be applied when you next enter gameplay."
		TextALign=TXTA_Center
		WinWidth=1
		WinLeft=0
		WinTop=0.45
		WinHeight=0.065000
		StyleName="EonLabelQuestion"
	End Object

	Controls(0)=oBGImage
	Controls(1)=oOKButton
	Controls(2)=oDialogTextA
	Controls(3)=oDialogTextB

	WinLeft=0.0175781
	WinWidth=0.96484375
	WinTop=0.375
	WinHeight=0.25
	bRequire640x480=false
}
