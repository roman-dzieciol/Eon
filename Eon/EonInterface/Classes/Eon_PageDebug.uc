/* =============================================================================
:: File Name	::	Eon_PageDebug.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageDebug extends Eon_PageMidGame;


function CreateTabs()
{
	GUIImage(Controls[0]).Image = None;
	GUIImage(Controls[1]).Image = None;
	GUIImage(Controls[2]).Image = None;
	TabControl.AddTab("Cameras","EonInterface.Eon_TabGameCameras",,"Cameras",false);
}


/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	OnClose=InternalOnClose
	OnDeActivate=InternalOnDeActivate
	OnActivate=InternalOnActivate
	OnKeyEvent=InternalOnKeyEvent
	OnReOpen=InternalOnReOpen
}
