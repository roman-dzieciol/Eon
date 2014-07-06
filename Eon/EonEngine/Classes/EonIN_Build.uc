/* =============================================================================
:: File Name	::	EonIN_Build.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonIN_Build extends Eon_Interaction;

var() string BuildText;

function PostRender( Canvas C )
{
	local float X, Y;
	local float XL, YL;

	C.Font = C.default.Font;
	C.ColorModulate = C.Default.ColorModulate;
	C.SetDrawColor(255,255,255,160);

	C.StrLen(BuildText, XL, YL);
	X = (C.ClipX - XL)*0.5;
	Y = 3;

	C.SetPos(X, Y);
	C.DrawTextClipped(BuildText);
}
/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bVisible=False
	BuildText="EON 00.11.01 ALPHA - WORK IN PROGRESS - (C) 2003-2004 CORONA LEONIS"
}
