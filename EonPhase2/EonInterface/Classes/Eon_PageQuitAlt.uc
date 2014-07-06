/* =============================================================================
:: File Name	::	Eon_PageQuitAlt.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageQuitAlt extends Eon_PageImportant;

function bool InternalOnClick(GUIComponent Sender)
{
	if (Sender==Controls[1])
	{
		if(PlayerOwner().Level.IsDemoBuild())
			Controller.ReplaceMenu("XInterface.UT2DemoQuitPage");
		else
			PlayerOwner().ConsoleCommand("exit");
	}
	else
		Controller.CloseMenu(false);

	return true;
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=GUIImage name=oQuitQ
		WinWidth=0.28125
		WinHeight=0.09375
		WinLeft=0.0351562
		WinTop=0.865885
		Image=Material'EonTX_Menu.Text.text-quitQ-watched'
		ImageColor=(R=255,G=255,B=255,A=255);
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Scaled
		bAcceptsInput=false
		bNeverFocus=true
	End Object

	Begin Object Class=Eon_ButtonMenu Name=oYesButton
		Caption=""
		WinWidth=0.140625
		WinHeight=0.093750
		WinLeft=0.274414
		WinTop=0.865885
		OnClick=InternalOnClick
		StyleName="EonButtonYes"
	End Object

	Begin Object Class=Eon_ButtonMenu Name=oNoButton
		Caption=""
		WinWidth=0.140625
		WinHeight=0.093750
		WinLeft=0.45
		WinTop=0.865885
		OnClick=InternalOnClick
		StyleName="EonButtonNo"
	End Object

	Controls(0)=oQuitQ
	Controls(1)=oYesButton
	Controls(2)=oNoButton

	WinWidth=1.0
	WinHeight=1.0
	WinTop=0
	WinLeft=0
}
