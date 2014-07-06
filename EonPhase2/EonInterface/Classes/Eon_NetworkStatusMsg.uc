/* =============================================================================
:: File Name	::	Eon_NetworkStatusMsg.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_NetworkStatusMsg extends Eon_PageIngame;

var() string	ServerBrowserClass;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(Mycontroller, MyOwner);
	PlayerOwner().ClearProgressMessages();
}

function bool InternalOnClick(GUIComponent Sender)
{
	if( Sender == Controls[1] ) // OK
	{
		Controller.ReplaceMenu( ServerBrowserClass );
	}

	return true;
}

event HandleParameters(string Param1, string Param2)
{
	GUILabel(Controls[2]).Caption = Param1 $ "|" $ Param2;
	PlayerOwner().ClearProgressMessages();
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
		Caption="Connect Failed"
		WinWidth=1
		WinLeft=0
		WinTop=0.45
		WinHeight=0.065
		TextALign=TXTA_Center
		StyleName="EonLabelQuestion"
		bMultiLine=true
	End Object

	Controls(0)=oBGImage
	Controls(1)=oOkButton
	Controls(2)=oDialogText

	WinLeft=0.0175781
	WinWidth=0.96484375
	WinTop=0.425
	WinHeight=0.25

	OnClose=InternalOnClose
	OnDeActivate=InternalOnDeActivate
	OnActivate=InternalOnActivate
	OnKeyEvent=InternalOnKeyEvent

	ServerBrowserClass="EonInterface.Eon_ServerBrowser"

	OpenSound=sound'MenuSounds.SelectDshort'
}
