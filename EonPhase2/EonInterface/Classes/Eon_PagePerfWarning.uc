/* =============================================================================
:: File Name	::	Eon_PagePerfWarning.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PagePerfWarning extends Eon_PageImportant;

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

	Begin Object Class=Eon_Button Name=oOkButton
		Caption="OK"
		WinWidth=0.2
		WinHeight=0.065
		WinLeft=0.4
		WinTop=0.55
		OnClick=InternalOnClick
	End Object

	Begin Object class=Eon_Label Name=oDialogText
		Caption="WARNING"
		WinWidth=1
		WinLeft=0
		WinTop=0.4
		WinHeight=0.065
		TextALign=TXTA_Center
		StyleName="EonLabelQuestion"
	End Object

	Begin Object class=Eon_Label Name=oDialogTextB
		Caption="The change you are making may adversely affect your performance."
		WinWidth=1
		WinLeft=0
		WinTop=0.45
		WinHeight=0.065
		TextALign=TXTA_Center
		StyleName="EonLabelQuestion"
	End Object

	Controls(0)=oBGImage
	Controls(1)=oOkButton
	Controls(2)=oDialogText
	Controls(3)=oDialogTextB

	WinLeft=0.0175781
	WinWidth=0.96484375
	WinTop=0.375
	WinHeight=0.25
}
