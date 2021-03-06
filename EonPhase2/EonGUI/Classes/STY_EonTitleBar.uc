/* =============================================================================
:: File Name	::	STY_EonTitleBar.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright � 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class STY_EonTitleBar extends Eon_Styles;

/*
	FontColors(0)=(R=143,G=137,B=128,A=160)
	FontColors(1)=(R=143,G=137,B=128,A=160)
	FontColors(2)=(R=143,G=137,B=128,A=160)
	FontColors(3)=(R=143,G=137,B=128,A=160)
	FontColors(4)=(R=143,G=137,B=128,A=160)
*/

/* =============================================================================
:: Copyright � 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	KeyName="EonTitleBar"

	Images(0)=Material'EonTX_Menu.Buttons.btn-d-std-50'
	Images(1)=Material'EonTX_Menu.Buttons.btn-d-over-50'
	Images(2)=Material'EonTX_Menu.Buttons.btn-d-std-50'
	Images(3)=Material'EonTX_Menu.Buttons.btn-d-over-50'
	Images(4)=Material'EonTX_Menu.Buttons.btn-d-std-50'

	RStyles(0)=MSTY_Normal
	RStyles(1)=MSTY_Normal
	RStyles(2)=MSTY_Normal
	RStyles(3)=MSTY_Normal
	RStyles(4)=MSTY_Normal

	ImgStyle(0)=ISTY_Stretched
	ImgStyle(1)=ISTY_Stretched
	ImgStyle(2)=ISTY_Stretched
	ImgStyle(3)=ISTY_Stretched
	ImgStyle(4)=ISTY_Stretched

	FontColors(0)=(R=153,G=146,B=136,A=160)
	FontColors(1)=(R=153,G=146,B=136,A=160)
	FontColors(2)=(R=153,G=146,B=136,A=160)
	FontColors(3)=(R=153,G=146,B=136,A=160)
	FontColors(4)=(R=153,G=146,B=136,A=160)
}
