/* =============================================================================
:: File Name	::	Eon_ScrollTextBox.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_ScrollTextBox extends GUIScrollTextBox;


/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	DefaultListClass="EonGUI.Eon_ScrollText"

	Begin Object Class=Eon_ScrollBarVert Name=oScrollbar
		bVisible=False
		OnPreDraw=oScrollbar.GripPreDraw
	End Object
	MyScrollBar=oScrollbar

	ToolTip=None
	bVisibleWhenEmpty=true

	WinLeft=0.0
	StyleName="EonScrollTextBox"
	FontScale=FNS_Small
}
