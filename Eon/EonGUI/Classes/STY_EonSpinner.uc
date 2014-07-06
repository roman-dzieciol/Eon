/* =============================================================================
:: File Name	::	STY_EonSpinner.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class STY_EonSpinner extends Eon_Styles;


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	KeyName="EonSpinner"

	Images(0)=Texture'EonTX_Menu.FloatEdit.SpinnerBlurry'
	Images(1)=Texture'EonTX_Menu.FloatEdit.SpinnerWatched'
	Images(2)=Texture'EonTX_Menu.FloatEdit.SpinnerBlurry'
	Images(3)=Texture'EonTX_Menu.FloatEdit.SpinnerPressed'
	Images(4)=Texture'EonTX_Menu.FloatEdit.SpinnerBlurry'

	RStyles(0)=MSTY_Normal
	RStyles(1)=MSTY_Normal
	RStyles(2)=MSTY_Normal
	RStyles(3)=MSTY_Normal
	RStyles(4)=MSTY_Normal

	ImgColors(0)=(R=153,G=146,B=136,A=192)
	ImgColors(1)=(R=255,G=255,B=255,A=255)
	ImgColors(2)=(R=153,G=146,B=136,A=192)
	ImgColors(3)=(R=255,G=255,B=255,A=255)
	ImgColors(4)=(R=153,G=146,B=136,A=64)

	ImgStyle(0)=ISTY_Scaled
	ImgStyle(1)=ISTY_Scaled
	ImgStyle(2)=ISTY_Scaled
	ImgStyle(3)=ISTY_Scaled
	ImgStyle(4)=ISTY_Scaled
}
