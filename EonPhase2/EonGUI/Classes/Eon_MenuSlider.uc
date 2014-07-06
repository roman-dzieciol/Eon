/* =============================================================================
:: File Name	::	Eon_MenuSlider.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_MenuSlider extends moSlider;

var() float 		DMinValue, DMaxValue;
var() float			DValue;

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	ComponentClassName="EonGUI.Eon_Slider"
	bStandardized=False
	WinHeight=0.05

	LabelStyleName			= "EonLabel"
	SliderCaptionStyleName	= "EonLabel"
	SliderBarStyleName		= "EonSliderBar"
	SliderStyleName			= "EonSliderKnob"
}
