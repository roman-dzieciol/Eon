/* =============================================================================
:: File Name	::	Eon_FontArray.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_FontArray extends Eon_FontBase;

var int	FontScreenWidth[7];

event Font GetFont(int XRes)
{
	local int i;

	for(i=0; i<7; i++)
	{
		if( default.FontScreenWidth[i] <= XRes )
			return LoadFontStatic(i);
	}

	return LoadFontStatic(6);
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

	FontScreenWidth(0)=1900
	FontScreenWidth(1)=1600
	FontScreenWidth(2)=1280
	FontScreenWidth(3)=1024
	FontScreenWidth(4)=800
	FontScreenWidth(5)=640
	FontScreenWidth(6)=600

}
