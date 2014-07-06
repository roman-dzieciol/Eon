/* =============================================================================
:: File Name	::	Eon_TabTextBase.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabTextBase extends Eon_TabMenuBase;

var() localized string		Contents;
var() Eon_ScrollTextBox		TextBox;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	TextBox = Eon_ScrollTextBox(Controls[0]);
	TextBox.SetContent(Contents);
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=Eon_ScrollTextBox Name=oTextBox
		WinWidth=1.0
		WinHeight=1.0
		WinLeft=0.0
		WinTop=0.0
		bVisibleWhenEmpty=true
		bNoTeletype=true
	End Object

	Controls(0)=oTextBox
}
