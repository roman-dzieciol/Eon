/* =============================================================================
:: File Name	::	Eon_ListBox.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_ListBox extends GUIListBox;

function bool MoveUp()
{
	return Eon_List(List).MoveUp();
}

function bool MoveDown()
{
	return Eon_List(List).MoveDown();
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	DefaultListClass="EonGUI.Eon_List"

	Begin Object Class=Eon_ScrollBarVert Name=oScrollbar
		bVisible=False
		OnPreDraw=oScrollbar.GripPreDraw
	End Object
	MyScrollBar=oScrollbar

	ToolTip=None
	bVisibleWhenEmpty=true

	StyleName="EonListBox"
	SelectedStyleName="EonListSelection"
	SectionStyleName="EonListSection"
	OutlineStyleName="EonListOutline"
}
