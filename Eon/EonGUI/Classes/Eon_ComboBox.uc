/* =============================================================================
:: File Name	::	Eon_ComboBox.uc
:: Description	::	none
:: Bug 			::	Pressing the ComboButton again won't really hide the Listbox
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_ComboBox extends GUIComboBox;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
	MyShowListBtn.FocusInstead = Edit;
}

function bool ShowListBox(GUIComponent Sender)
{
	if( bDebugging )
		log(Name @ "ShowListBox MyListBox.bVisible:" $ MyListBox.bVisible);

	OnShowList();
	MyListBox.SetVisibility(!MyListBox.bVisible);
	//if( MyListBox.bVisible )	MyShowListBtn.Graphic = Controller.ImageList[2];
	//else						MyShowListBtn.Graphic = Controller.ImageList[7];

	if( MyListBox.bVisible )
	{
		List.SetFocus(none);
		List.SetTopItem(List.Index);
	}
	return true;
}

function HideListBox()
{
	if( bDebugging )
		log(Name @ "HideListBox");

	OnHideList();
	//if( Controller != None )
	//	MyShowListBtn.Graphic = Controller.ImageList[7];

	MyListBox.Hide();
	List.SilentSetIndex( List.FindIndex(TextStr) );
}

function SetIndexText( int i )
{
	List.SetIndex(i);
	Edit.SetText( List.GetItemAtIndex(i) );
	TextStr = Edit.TextStr;
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=Eon_EditBox Name=oEditBox
		OnActivate=oEditBox.InternalActivate
		OnDeActivate=oEditBox.InternalDeactivate
		OnKeyType=oEditBox.InternalOnKeyType
		OnKeyEvent=oEditBox.InternalOnKeyEvent
		RenderWeight=0.5
		FontScale=FNS_Small
		StyleName="EonComboEditBox"
	End Object

	Begin Object Class=Eon_ComboButton Name=oComboButton
		OnKeyEvent=oComboButton.InternalOnKeyEvent
		bRepeatClick=false
		bTabStop=False
		RenderWeight=0.6
		FontScale=FNS_Small
		StyleName="EonComboButton"
	End Object

	Begin Object Class=Eon_ListBox Name=oListBox
		OnCreateComponent=oListBox.InternalOnCreateComponent
		bVisible=false
		bTabStop=False
		RenderWeight=0.7
		FontScale=FNS_Small
		StyleName="EonComboListBox"
	End Object

	ToolTip=None

	Edit			= oEditBox
	MyShowListBtn	= oComboButton
	MyListBox		= oListBox

	WinHeight=0.05

	Index=-1
	MaxVisibleItems=10
	bReadOnly=true
	PropagateVisibility=True
	bAcceptsInput=True

	FontScale=FNS_Small
}
