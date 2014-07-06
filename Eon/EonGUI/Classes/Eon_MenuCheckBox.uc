/* =============================================================================
:: File Name	::	Eon_MenuCheckBox.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_MenuCheckBox extends moCheckBox;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
	MyLabel.TextFont = "";
	MyLabel.OnClick = InternalClick;
}


/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	ComponentClassName="EonGUI.Eon_CheckBoxButton"
	LabelStyleName="EonLabel"
	bStandardized=False
	WinHeight=0.05
}
