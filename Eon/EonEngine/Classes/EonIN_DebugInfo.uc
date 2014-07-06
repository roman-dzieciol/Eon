/* =============================================================================
:: File Name	::	EonIN_DebugInfo.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonIN_DebugInfo extends Eon_Interaction;

var() Actor			A;
var() Material		TXBackground;
var() float			X,Y,XL,YL;


event Initialized()
{
	Super.Initialized();
}

function CleanUp()
{
	Super.CleanUp();
	A = None;
}

function ChoseActor( Actor IActor )
{
	A = IActor;
}

function PostRender( Canvas C )
{

	if( A == None )							return;
	if( ViewportOwner.Actor == None )		return;

	C.Font = C.default.Font;
	C.Style = C.default.Style;

	X	= C.ClipX-128;
	Y	= 0;
	XL	= 128;
	YL	= C.ClipY;

	C.SetPos(X, Y);
	C.SetDrawColor(255, 255, 255, 255);
	C.DrawTileStretched(TXBackground, XL, YL);

	C.StrLen("HEIGHT", XL, YL);
	X += 4;
	Y += YL;

}



/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bVisible=true
	bActive=true

	TXBackground=Material'EonTS_GUI.Background.Dark'
}
