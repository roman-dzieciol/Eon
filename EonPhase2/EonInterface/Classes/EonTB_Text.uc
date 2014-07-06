/* =============================================================================
:: File Name	::	EonTB_Text.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonTB_Text extends EonTB_MenuBase;

var() automated Eon_ScrollTextBox		TextBox;

function InitPanel()
{
	TextBox.SetContent( Localize(MyButton.Caption, "Contents", "EonInterface") );
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=Eon_ScrollTextBox Name=oTextBox
		WinWidth=0.98
		WinHeight=0.887773
		WinLeft=0.01
		WinTop=0.01
		bVisibleWhenEmpty=true
		bNoTeletype=true
	End Object

	TextBox=oTextBox
}
