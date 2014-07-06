/* =============================================================================
:: File Name	::	Eon_List.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_List extends GUIList;

function bool MoveUp()
{
	local int i;

	i = Index;
	if( i == 0 )
		return true;

	Swap( i, i-1 );
	Index = i-1;
	return true;
}

function bool MoveDown()
{
	local int i;

	i = Index;
	if( i == ItemCount - 1)
		return true;

	Swap( i, i+1 );
	Index = i+1;
	return true;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	SelectedImage=Material'EonTS_GUI.Background.Dark'
	StyleName="EonList"
	SelectedStyleName="EonListSelection"
	SectionStyleName="EonListSection"
	OutlineStyleName="EonListOutline"
}
