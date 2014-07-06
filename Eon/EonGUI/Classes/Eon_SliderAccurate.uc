/* =============================================================================
:: File Name	::	Eon_SliderAccurate.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_SliderAccurate extends Eon_Slider;

function bool InternalCapturedMouseMove(float deltaX, float deltaY)
{
	Super.InternalCapturedMouseMove(deltaX, deltaY);
	OnChange(Self);
	return true;
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bIntSlider=false
}
