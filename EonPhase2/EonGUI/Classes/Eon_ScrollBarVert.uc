/* =============================================================================
:: File Name	::	Eon_ScrollBarVert.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_ScrollBarVert extends GUIVertScrollBar;


/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
:: =============================================================================
	Controls(0)=oScrollZone
	Controls(1)=oUp
	Controls(2)=oDown
	Controls(3)=oGrip
============================================================================= */
DefaultProperties
{
	Begin Object Class=GUIVertScrollZone Name=oScrollZone
		OnScrollZoneClick	= GUIVertScrollBar.ZoneClick
		OnClick				= oScrollZone.InternalOnClick
		StyleName			= "EonScrollZone"
	End Object

	Begin Object Class=Eon_ScrollVertButton Name=oUp
		OnClick			= GUIVertScrollBar.IncreaseClick
		OnKeyEvent		= oUp.InternalOnKeyEvent
		bIncreaseButton	= false
	End Object

	Begin Object Class=Eon_ScrollVertButton Name=oDown
		OnClick			= GUIVertScrollBar.DecreaseClick
		OnKeyEvent		= oDown.InternalOnKeyEvent
		bIncreaseButton	= true
	End Object

	Begin Object Class=Eon_GripVertButton Name=oGrip
		OnMousePressed	= GUIVertScrollBar.GripPressed
		OnKeyEvent		= oGrip.InternalOnKeyEvent
	End Object

	MyScrollZone		= oScrollZone
	MyIncreaseButton	= oUp
	MyDecreaseButton	= oDown
	MyGripButton		= oGrip
}
