/* =============================================================================
:: File Name	::	Eon_LoadingVignette.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.00 - Switch, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_LoadingVignette extends UT2LoadingPageBase;

var() Texture	Background;

var() Texture	Logo;
var() float		LogoPosX, LogoPosY;
var() float		LogoScaleX, LogoScaleY;

var() String	LoadingFontName;
var() Font		LoadingFont;
var() float		LoadingPosX, LoadingPosY, MapPosY;
var() Color		LoadingColor;
var() String	LoadingString;


// = LIFESPAN ==================================================================

simulated event Init()
{
	Super.PreBeginPlay();
	Background	= class'ECFG_LoadingScreens'.static.GetRandomScreen();
	LoadingFont	= Font(DynamicLoadObject( LoadingFontName, class'Font'));
}


// = DRAW ======================================================================

simulated function ScreenText(Canvas C, String Text, float posX, float posY, float ScaleX,float ScaleY)
{
	C.Style = ERenderStyle.STY_Alpha;
	C.Font = LoadingFont;
	C.DrawColor = LoadingColor;
	C.FontScaleX = ScaleX;
	C.FontScaleY = ScaleY;
	C.DrawScreenText( Text, posX, posY, DP_MiddleMiddle );
}

simulated event DrawVignette( Canvas C, float Progress )
{
	local float ResScaleX, ResScaleY;
	local float PosX, PosY, DX, DY;

	C.Reset();

	C.SetPos( 0, 0 );
	C.Style = ERenderStyle.STY_Alpha;
	C.DrawColor = C.MakeColor( 255, 255, 255 );
	C.DrawTile( Background, C.SizeX, C.SizeY, 0, 0, Background.USize, Background.VSize );

	ResScaleX	= C.SizeX / 640.0;
	ResScaleY	= C.SizeY / 480.0;
	DX			= Logo.USize * ResScaleX * LogoScaleX;
	DY			= Logo.VSize * ResScaleY * LogoScaleY;
	PosX		= (LogoPosX * C.SizeX) - (DX * 0.5);
	PosY		= (LogoPosY * C.SizeY) - (DY * 0.5);
	ResScaleX	*= 0.5;
	ResScaleY	*= 0.5;

	C.SetPos( PosX, PosY );
	C.Style = ERenderStyle.STY_Alpha;
	C.DrawTile( Logo, DX, DY, 0, 0, Logo.USize, Logo.VSize );
	ScreenText( C, LoadingString, LoadingPosX, LoadingPosY, ResScaleX, ResScaleY );

	if( MapName ~= "ut2-intro.ut2" )
		return;

	ScreenText( C, MapName, LoadingPosX, MapPosY, ResScaleX, ResScaleY );
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Logo=Texture'InterfaceContent.Logos.Logo'
	LogoScaleX=0.5
	LogoScaleY=0.5
	LogoPosX=0.49
	LogoPosY=0.25

	LoadingFontName="UT2003Fonts.FontLarge"
	LoadingString=". . . E O N . . ."
	LoadingPosX=0.5
	LoadingPosY=0.65
	LoadingColor=(R=255,G=255,B=255,A=255)

	MapPosY=0.725
}
