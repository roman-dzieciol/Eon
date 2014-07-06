/* =============================================================================
:: File Name	::	EonHD_Logo.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonHD_Logo extends HUD;

var() Material	TXLogo;
var() Material	TXBlack;

event PostBeginPlay()
{
	//LogHUD("PostBeginPlay");
	SetTimer(30,false);
}

event Timer()
{
	local EonPC_Base P;
	LogHUD("Timer");
	P = EonPC_Base(Level.GetLocalPlayerController());
	P.ClientOpenMenu(P.MainMenu);
}

event PostRender( Canvas C )
{
	C.Reset();
	C.SetDrawColor(255,255,255);

	// Draw black background
	C.SetPos(0,0);
	C.DrawTileStretched( TXBlack, C.ClipX, C.ClipY );

	// Draw Logo
	C.SetPos((C.ClipX-C.ClipY)/2,0);
	C.DrawTile( TXLogo, C.ClipY, C.ClipY, 0, 0, TXLogo.MaterialUSize(), TXLogo.MaterialVSize() );
}

// = INC =======================================================================

#include ../_inc/debug/Log.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	TXLogo=Material'EonTX_Intro.Eon'
	TXBlack=Material'EonTX_Colors.Black'
}
