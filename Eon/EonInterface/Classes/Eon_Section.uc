/* =============================================================================
:: File Name	::	Eon_Section.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_Section extends GUISectionBackground;

function bool SetupComponent( GUIComponent Component, out int T )
{
	if( Component == None )
		return false;

	if( Component.bTabStop )
		Component.TabOrder = T++;

	return ManageComponent(Component);
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	CaptionStyleName="EonLabel"
	bRemapStack=True
	HeaderTop=Material'EonTS_Colors.Invisible'
	HeaderBar=Material'EonTS_Colors.Invisible'
	HeaderBase=Material'EonTS_Colors.Invisible'
	ColPadding=0.050000
	LeftPadding=0.0
	RightPadding=0.0
	ImageOffset(0)=16.000000
	ImageOffset(1)=16.000000
	ImageOffset(2)=16.000000
	ImageOffset(3)=16.000000
	NumColumns=1
	FontScale=FNS_Small
	RenderWeight=0.010000
	bAltCaption=True
	ImageRenderStyle=MSTY_Normal
	ImageColor=(R=64,G=64,B=64,A=255)
	Image=Material'EonTX_Menu.Buttons.btn-d-none-25'
	ImageStyle=ISTY_Stretched
}
