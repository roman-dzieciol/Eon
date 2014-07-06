/* =============================================================================
:: File Name	::	EonIN_Monitor.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonIN_Monitor extends Eon_Interaction;



const DMODE_None				= 0.00f;
const DMODE_Normal				= 1.00f;

struct DrawInfoContainer
{
	var string Desc;
	var string Value;
	var color C;
	var float DrawMode;
	var bool bFreeze;
	var bool bDisable;
};

var() array<DrawInfoContainer> DIC;

var() float XPos, YPos;
var() Font		IntFont;
var() string	IntFontName;
var() bool		bUpdateSize;
var() floatbox	DescMargin, ValueMargin;	// left, top, right, bottom
var() floatbox	DescText, ValueText;		// X1,Y1 = offset, X2,Y2 = size
var() floatbox	DescBox, ValueBox;			// X1,Y1 = offset, X2,Y2 = size
var() floatbox 	Border, BorderBox;
var() color 	BorderColor;


function PostRender( canvas Canvas )
{
	local float XP, YP;

	if( DIC.Length == 0 )					return;
	if( ViewportOwner.Actor == None )		return;

	Canvas.Font = Canvas.default.Font;
	Canvas.Style = 5;

	XP = XPos;
	YP = YPos;




	while( DIC.Length > 0 )
	{
		switch( DIC[0].DrawMode )
		{
			case DMODE_Normal:
				DrawMonitorBox(Canvas, XP, YP, DIC[0].Desc, DIC[0].Value, DIC[0].C);
			break;

			default:
			break;
		}

		DIC.Remove(0, 1);
	}
}

function DrawMonitorBox(canvas Canvas, out float XL, out float YL, coerce string Desc, coerce string Value, color C)
{
	Canvas.SetPos(XL+DescBox.X1, YL+DescBox.Y1);
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.DrawTileStretched(Texture'UCGeneric.SolidColours.White', DescBox.X2, DescBox.Y2);

	Canvas.SetPos(XL+ValueBox.X1, YL+ValueBox.Y1);
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.DrawTileStretched(Texture'UCGeneric.SolidColours.Black', ValueBox.X2, ValueBox.Y2);

	// draw border box
//	Canvas.SetDrawColor(BorderColor.R, BorderColor.G, BorderColor.B, BorderColor.A);
//	Canvas.DrawColor = BorderColor;
//	Canvas.SetPos(XL+BorderBox.X1, YL+BorderBox.Y1);
//	Canvas.DrawTileStretched(Texture'UCGeneric.SolidColours.White', BorderBox.X2, BorderBox.Y2);

	// draw description box
	Canvas.SetPos(XL+DescBox.X1, YL+DescBox.Y1);
	Canvas.SetDrawColor(C.R, C.G, C.B, C.A);
	Canvas.DrawTileStretched(Texture'UCGeneric.SolidColours.White', DescBox.X2, DescBox.Y2);

	// draw description text
	Canvas.SetPos(XL+DescText.X1, YL+DescText.Y1);
	Canvas.SetDrawColor(0, 0, 0, 255);
	Canvas.DrawText(Desc, false);

	// draw value box
	Canvas.SetPos(XL+ValueBox.X1, YL+ValueBox.Y1);
	Canvas.SetDrawColor(255, 255, 255, C.A);
	Canvas.DrawTileStretched(Texture'UCGeneric.SolidColours.Black', ValueBox.X2, ValueBox.Y2);

	// draw value text
	Canvas.SetPos(XL+ValueText.X1, YL+ValueText.Y1);
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.DrawText(Value, false);



	// draw border box
	Canvas.DrawColor = BorderColor;

	// border-top desc
	Canvas.SetPos(XL+Border.X1, YL);
	Canvas.DrawTileStretched(Texture'UCGeneric.SolidColours.White', DescBox.X2, 1);

	// border-top value
	Canvas.SetPos(XL+Border.X1+DescBox.X2, YL);
	Canvas.DrawTileStretched(Texture'UCGeneric.SolidColours.White', ValueBox.X2, 1);

	// border-left
	Canvas.SetPos(XL, YL);
	Canvas.DrawTileStretched(Texture'UCGeneric.SolidColours.White', 1, BorderBox.Y2);

	// border-right
//	Canvas.SetPos(XL+Border.X1+DescBox.X2+ValueBox.X2, YL);
//	Canvas.DrawTileStretched(Texture'UCGeneric.SolidColours.White', 1, BorderBox.Y2);

//	Canvas.SetDrawColor(C.R, C.G, C.B, C.A);

	// border-bottom desc
	Canvas.SetPos(XL+Border.X1, YL+Border.Y1+DescBox.Y2);
	Canvas.DrawTileStretched(Texture'UCGeneric.SolidColours.White', DescBox.X2, 1);

	Canvas.SetDrawColor(C.R*0.5, C.G*0.5, C.B*0.5, C.A);

	// border-bottom value
	Canvas.SetPos(XL+Border.X1+DescBox.X2, YL+Border.Y1+DescBox.Y2);
	Canvas.DrawTileStretched(Texture'UCGeneric.SolidColours.White', ValueBox.X2, 1);


	YL += BorderBox.Y2;

}

function PreRender( canvas Canvas )
{
	Super.PreRender(Canvas);

	if( !bUpdateSize )
		return;

	Canvas.Font = Canvas.default.Font;
	Canvas.Style = 5;

	Canvas.StrLen("XXXXXXXXXXXXXXXX", DescText.X2, DescText.Y2);
	Canvas.StrLen("XXXXXX.XX, XXXXXXX.XX, XXXXXXX.XX", ValueText.X2, ValueText.Y2);

	Border.X1 = 1;	// border-left
	Border.Y1 = 1;	// border-top
	Border.X2 = 0;	// border-right
	Border.Y2 = 1;	// border-bottom

	DescMargin.X1 = 2;	// margin-left
	DescMargin.Y1 = 0;	// margin-top
	DescMargin.X2 = 1;	// margin-right
	DescMargin.Y2 = 1;	// margin-bottom

	ValueMargin.X1 = 2;	// margin-left
	ValueMargin.Y1 = 0;	// margin-top
	ValueMargin.X2 = 1;	// margin-right
	ValueMargin.Y2 = 1;	// margin-bottom


	DescText.X1 = Border.X1 + DescMargin.X1;	// X-Offset
	DescText.Y1 = Border.Y1;					// Y-Offset
	DescText.X2 = Ceil(DescText.X2);			// X-Length
	DescText.Y2 = Ceil(DescText.Y2);			// Y-Length

	ValueText.X1 = Border.X1 + DescMargin.X1 + DescText.X2 + DescMargin.X2 + ValueMargin.X1;
	ValueText.Y1 = Border.Y1;
	ValueText.X2 = Ceil(ValueText.X2);
	ValueText.Y2 = Ceil(ValueText.Y2);

	DescBox.X1 = Border.X1;
	DescBox.Y1 = Border.Y1;
	DescBox.X2 = DescMargin.X1 + DescText.X2 + DescMargin.X2;
	DescBox.Y2 = DescText.Y2 + DescMargin.Y2;

/*
	DescBox.X1 = 0;
	DescBox.Y1 = 0;
	DescBox.X2 = Border.X1 + DescBox.X2 + ValueBox.X2 + Border.X2;
	DescBox.Y2 = Border.Y1 + DescBox.Y2 + Border.Y2;
*/

	ValueBox.X1 = Border.X1 + DescBox.X2;
	ValueBox.Y1 = Border.Y1;
	ValueBox.X2 = ValueMargin.X1 + ValueText.X2 + ValueMargin.X2;
	ValueBox.Y2 = ValueText.Y2 + ValueMargin.Y2;

	BorderBox.X1 = 0;
	BorderBox.Y1 = 0;
	BorderBox.X2 = Border.X1 + DescBox.X2 + ValueBox.X2 + Border.X2;
	BorderBox.Y2 = Border.Y1 + DescBox.Y2 + Border.Y2;

	XPos = Canvas.ClipX - BorderBox.X2;
	YPos = 192;


	bUpdateSize = false;
}

function RegisterDrawInfo( string Desc, string Value, color C, optional float DrawMode )
{
	local DrawInfoContainer D;

	if( !bVisible )
		return;

	D.Desc		= Desc;
	D.Value		= Value;
	D.C			= C;
	D.DrawMode	= DMODE_Normal;
//	D.DrawMode	= DrawMode;

	DIC[DIC.Length] = D;
}

exec function DBGM()
{
	bVisible = !bVisible;
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bVisible=false
	bActive=true
	bUpdateSize=true
	BorderColor=(R=0,B=0,G=0,A=255)
}
