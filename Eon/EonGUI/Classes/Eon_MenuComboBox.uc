/* =============================================================================
:: File Name	::	Eon_MenuComboBox.uc
:: Description	::	Deprecated, GUIMenuOption needs some work first
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_MenuComboBox extends moComboBox;

function Clear()
{
	if( MyComboBox.ItemCount() > 0 )
		MyComboBox.RemoveItem( 0, MyComboBox.ItemCount() );
}

function SetContents( array<GUIListElem> A )
{
	MyComboBox.List.Elements = A;
	MyComboBox.List.ItemCount = A.Length;
}

function SetIndexText( int i )
{
	Eon_ComboBox(MyComboBox).SetIndexText(i);
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	ComponentClassName="EonGUI.Eon_ComboBox"
	LabelStyleName="EonLabel"
	bStandardized=False
	WinHeight=0.05
	bReadOnly=True
}
