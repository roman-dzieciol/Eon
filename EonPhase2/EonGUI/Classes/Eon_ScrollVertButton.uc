/* =============================================================================
:: File Name	::	Eon_VertScrollButton.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_ScrollVertButton extends GUIVertScrollButton;

var() Material TXComboUp;
var() Material TXComboDown;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super(GUIGFXButton).InitComponent(MyController, MyOwner);

	if( bIncreaseButton )	Graphic = TXComboUp;
	else					Graphic = TXComboDown;
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	StyleName="EonScrollButton"
	TXComboUp=Material'EonTX_Menu.Arrows.arrow-up'
	TXComboDown=Material'EonTX_Menu.Arrows.arrow-down'
	ToolTip=None
}
