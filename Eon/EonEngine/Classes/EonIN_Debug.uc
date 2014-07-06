/* =============================================================================
:: File Name	::	EonIN_Debug.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonIN_Debug extends Eon_Interaction;


const EDINFO_None				= 0;
const EDINFO_SE_WorldLocation	= 1;
const EDINFO_S_WorldLocation	= 2;
const EDINFO_E_WorldLocation	= 3;
const EDINFO_SE_VSize			= 4;
const EDINFO_S_VSize			= 5;
const EDINFO_E_VSize			= 6;
const EDINFO_SE_Rotator			= 7;
const EDINFO_S_Rotator			= 8;
const EDINFO_E_Rotator			= 9;


struct DrawLineContainer
{
	var vector Start;
	var vector End;
	var color C;
	var byte DrawInfo;
	var bool bStaying;
};

var() array<DrawLineContainer>	DLC;
var() IntBox					DMargin, VMargin;


event Initialized()
{
	Super.Initialized();
}

function PostRender( canvas Canvas )
{
	if( DLC.Length == 0 )					return;
	if( ViewportOwner.Actor == None )		return;

	Canvas.Font = Canvas.default.Font;
	Canvas.Style = 5;

	while( DLC.Length > 0 )
	{
		switch( DLC[0].DrawInfo )
		{
			case EDINFO_SE_WorldLocation:
				DrawVectorBox(Canvas, DLC[0].Start, DLC[0].Start, "S", DLC[0].C);
				DrawVectorBox(Canvas, DLC[0].End, DLC[0].End, "E", DLC[0].C);
			break;

			case EDINFO_S_WorldLocation:
				DrawVectorBox(Canvas, DLC[0].Start, DLC[0].Start, "S", DLC[0].C);
			break;

			case EDINFO_E_WorldLocation:
				DrawVectorBox(Canvas, DLC[0].End, DLC[0].End, "E", DLC[0].C);
			break;

			case EDINFO_SE_VSize:
				DrawVectorBox(Canvas, DLC[0].Start, VSize(DLC[0].End - DLC[0].Start), "S", DLC[0].C);
				DrawVectorBox(Canvas, DLC[0].End, VSize(DLC[0].End - DLC[0].Start), "E", DLC[0].C);
			break;

			case EDINFO_S_VSize:
				DrawVectorBox(Canvas, DLC[0].Start, VSize(DLC[0].End - DLC[0].Start), "S", DLC[0].C);
			break;

			case EDINFO_E_VSize:
				DrawVectorBox(Canvas, DLC[0].End, VSize(DLC[0].End - DLC[0].Start), "E", DLC[0].C);
			break;

			case EDINFO_SE_Rotator:
				DrawVectorBox(Canvas, DLC[0].Start, RS(rotator(DLC[0].End - DLC[0].Start)), "S", DLC[0].C);
				DrawVectorBox(Canvas, DLC[0].End, RS(rotator(DLC[0].End - DLC[0].Start)), "E", DLC[0].C);
			break;

			case EDINFO_S_Rotator:
				DrawVectorBox(Canvas, DLC[0].Start, RS(rotator(DLC[0].End - DLC[0].Start)), "S", DLC[0].C);
			break;

			case EDINFO_E_Rotator:
				DrawVectorBox(Canvas, DLC[0].End, RS(rotator(DLC[0].End - DLC[0].Start)), "E", DLC[0].C);
			break;

			default:
			break;
		}

		DLC.Remove(0, 1);
	}

}

final function string RS(rotator R)
{
	return R.Pitch$", "$R.Yaw$", "$R.Roll;
}

final function DrawVectorBox(Canvas Canvas, vector V, coerce string Info, coerce string Desc, color C)
{
	local vector ScreenLocation;
	local float XV, YV, XD, YD;

	ScreenLocation = WorldToScreen(V);

	// dont draw locations behind us
	if( ScreenLocation.Z > 1 )
		return;

	// pixel perfect
	ScreenLocation.X = Ceil(ScreenLocation.X);
	ScreenLocation.Y = Ceil(ScreenLocation.Y);

	// get text dimensions
	Canvas.StrLen(Desc, XD, YD);
	Canvas.StrLen(Info, XV, YV);

	// pixel perfect
	XD = Ceil(XD);	YD = Ceil(YD);	XV = Ceil(XV);	YV = Ceil(YV);

	//! hardcoded margins for readability improvement

	// draw color box
	Canvas.SetPos(ScreenLocation.X, ScreenLocation.Y);
	Canvas.SetDrawColor(C.R, C.G, C.B, C.A);
	Canvas.DrawTileStretched(Texture'UCGeneric.SolidColours.White', XD+3, YD+1);

	// draw description text
	Canvas.SetPos(ScreenLocation.X+2,ScreenLocation.Y);
	Canvas.SetDrawColor(0, 0, 0, 255);
	Canvas.DrawText(Desc, false);

	// draw black box
	Canvas.SetPos(ScreenLocation.X+XD+3,ScreenLocation.Y);
	Canvas.SetDrawColor(255, 255, 255, C.A);
	Canvas.DrawTileStretched(Texture'UCGeneric.SolidColours.Black', XV+3, YV+1);

	// draw info text
	Canvas.SetPos(ScreenLocation.X+XD+3+2, ScreenLocation.Y);
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.DrawText(Info, false);

}

final function RegisterDrawLine( vector Start, vector End, color C, optional byte DrawInfo, optional bool bStaying )
{
	local DrawLineContainer D;

	if( !bVisible )
		return;

	D.Start		= Start;
	D.End		= End;
	D.C			= C;
	D.DrawInfo	= DrawInfo;
	D.bStaying	= bStaying;

	DLC[DLC.Length] = D;
}

exec function DBGL()
{
	bVisible = !bVisible;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bVisible=true
	bActive=true
	DMargin=(X1=0,Y1=1,X2=1,Y2=1)
	VMargin=(X1=0,Y1=1,X2=1,Y2=1)
}
