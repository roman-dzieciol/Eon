/* =============================================================================
:: File Name	::	EonIN_Cmd.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonIN_Cmd extends Eon_Interaction;

var() Font		FontCmd;
var() Material	BGMaterial;
var() Texture	TXAim;


function PostRender( Canvas C )
{
//	DrawCoords( C );
//	SimpleTracer( C );
//	DrawTypingPrompt( C );

	OnPostRender( C );
}

delegate OnPostRender( Canvas C )
{
//	LogIN("OnPostRender");
}


function DrawCoords( Canvas C )
{
	local float		X, Y, XL, YL;
	local string	S;

	C.ColorModulate = C.Default.ColorModulate;
	C.SetDrawColor(255,255,255,255);

	X = GUIController(ViewportOwner.GUIController).MouseX;
	Y = GUIController(ViewportOwner.GUIController).MouseY;
	S = X @ Y;

	C.StrLen(S, XL, YL);

	C.SetPos (X+32, Y);
	C.DrawTextClipped(S, false);
}

function SimpleTracer( canvas C )
{
	local actor		Other;
	local rotator	CamRot;
	local vector	CamLoc, HitLocation, HitNormal, StartTrace, EndTrace, ScreenLocation;
	local float		IconScale, TraceDist;

	//Perform a trace to find any colliding actors
//	C.GetCameraLocation(CamLoc, CamRot);
	StartTrace = CamLoc;
	EndTrace = StartTrace + vector(CamRot) * 10000.0;
	Other = PlayerOwner.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
	if( Other == None )
		HitLocation = EndTrace;

//	PlayerOwner.ClientMessage("Hit:"@Other);

	//Convert 3d location to 2d for display on the Canvas
	ScreenLocation = WorldToScreen(HitLocation);

	if( ScreenLocation.Z < 0 )
		return;

	TraceDist = (10000 - VSize(HitLocation - StartTrace)) / 10000;
	IconScale = FClamp(TraceDist, 0.25, 1);

	C.SetPos(ScreenLocation.X-IconScale*16, ScreenLocation.Y-IconScale*16);
	C.Style = 1;
	C.SetDrawColor(255,255,255);
	C.DrawIcon(TXAim, IconScale);
}

simulated function DrawTypingPrompt (Canvas C)
{
	local float X, Y;
	local float XL, YL;
	local string S;

	S = "Commander Mode";

	C.Font = FontCmd;
	//C.Style = ERenderStyle.STY_Normal;

	C.ColorModulate = C.Default.ColorModulate;
	C.SetDrawColor(255,255,255,255);

	C.StrLen(S, XL, YL);

	X = (C.ClipX - XL)*0.5;
	Y = (C.ClipY - YL)*0.5;

	C.SetPos (0, 0);
	C.SetDrawColor(255,255,255,255);
	C.DrawTileStretched(BGMaterial,C.ClipX,YL+16);

	C.SetPos (X, 8);
	//C.DrawColor = ConsoleColor;
	C.DrawTextClipped(S, false);
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	FontCmd=Font'UT2003Fonts.jFontMono800x600'
	BGMaterial=Material'EonTS_GUI.Background.Dark'
	TXAim=Texture'EonTX_Engine.Error32'
}
