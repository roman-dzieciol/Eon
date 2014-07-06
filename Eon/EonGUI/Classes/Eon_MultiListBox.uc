/* =============================================================================
:: File Name	::	Eon_MultiListBox.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_MultiListBox extends GUIMultiColumnListBox;


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=Eon_MultiListHeader Name=oMultiListHeader
	End Object

	DefaultListClass="EonGUI.Eon_MultiList"
	Header=oMultiListHeader

	StyleName="EonMultiListBox"
}
