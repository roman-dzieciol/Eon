/* =============================================================================
:: File Name	::	Eon_FloatEdit.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_FloatEdit extends GUIFloatEdit;


/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=Eon_EditBox Name=oEditBox
		bFloatOnly=True
		bNeverScale=True
		OnActivate=oEditBox.InternalActivate
		OnDeActivate=oEditBox.InternalDeactivate
		OnKeyType=oEditBox.InternalOnKeyType
		OnKeyEvent=oEditBox.InternalOnKeyEvent
	End Object
	MyEditBox=oEditBox

	Begin Object Class=Eon_SpinnerButton Name=oSpinner
		bTabStop=False
		bNeverScale=False
		OnClick=oSpinner.InternalOnClick
		OnKeyEvent=oSpinner.InternalOnKeyEvent
	End Object
	MySpinner=oSpinner

	WinHeight=0.05
	FontScale=FNS_Small
}
