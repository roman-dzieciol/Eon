/* =============================================================================
:: File Name	::	Test.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Test extends Commandlet;

event int Main( string Parms )
{
	local Vector V,X;
	local rotator R;
	local float F;
	local float D;

	F = int(-32768 + FRand()*65536);
	D = (F/16384)*90;

	R.Yaw = F;

	V = VRand();
	V.X = int(V.X*100);
	V.Y = int(V.Y*100);
	V.Z = int(V.Z*100);

	X = V >> R;

	log( "V=" $V );
	log( "X=" $X );
	log( "F=" $F$ " D=" $D);
	return 0;
}

// = INC =======================================================================

#include ../_inc/func/string.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

}
