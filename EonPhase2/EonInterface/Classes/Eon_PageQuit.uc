/* =============================================================================
:: File Name	::	Eon_PageQuit.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageQuit extends Eon_PageImportant;

function bool InternalOnClick(GUIComponent Sender)
{
	if( Sender == Controls[1] )
	{
		PlayerOwner().ConsoleCommand("exit");
	}
	else
		Controller.CloseMenu();

	return true;
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=GUIImage name=oBG
		WinWidth=1.0
		WinHeight=1.0
		WinTop=0
		WinLeft=0
		Image=Material'EonTS_GUI.Background.Dark'
		ImageColor=(R=255,G=255,B=255,A=255);
		ImageRenderStyle=MSTY_Modulated
		ImageStyle=ISTY_Stretched
		bAcceptsInput=false
		bNeverFocus=true
		bBoundToParent=true
		bScaleToParent=true
	End Object

	Begin Object Class=GUIButton Name=YesButton
		Caption="QUIT"
		WinWidth=0.2
		WinHeight=0.065
		WinLeft=0.125
		WinTop=0.5
		bBoundToParent=true
		OnClick=InternalOnClick
		StyleName="EonButtonA"
		bNeverFocus=True
	End Object

	Begin Object Class=GUIButton Name=NoButton
		Caption="BACK"
		WinWidth=0.2
		WinHeight=0.065
		WinLeft=0.65
		WinTop=0.5
		bBoundToParent=true
		OnClick=InternalOnClick
		StyleName="EonButtonA"
		bNeverFocus=True
	End Object

	Begin Object class=GUILabel Name=QuitDesc
		Caption="Are you sure?"
		TextALign=TXTA_Center
		TextColor=(R=120,G=105,B=85,A=255)
		TextFont="FontMorpheus"
		WinWidth=1
		WinHeight=32
		WinLeft=0
		WinTop=0.4
	End Object

	Controls(0)=oBG
	Controls(1)=GUIButton'YesButton'
	Controls(2)=GUIButton'NoButton'
	Controls(3)=GUILabel'QuitDesc'

	WinWidth=1.0
	WinHeight=0.175
	WinTop=0.55
	WinLeft=0
}
