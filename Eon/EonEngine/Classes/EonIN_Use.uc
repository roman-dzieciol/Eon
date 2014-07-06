/* =============================================================================
:: File Name	::	EonIN_Use.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonIN_Use extends Eon_Interaction;

var() Texture		TXAim;
var() Actor			Selected;
var() float			Alpha;
var() string		SelectedName;
var() float			DistMax;

var() vector		Dir;

var() Eon_Pawn			Pawn;
var() EInputKey			KeyPressed;
var() EInputKey			KeyValid;

var() GUIStyles			STYButton;
var() GUIStyles			STYBackground;
var() GUI.eFontScale	FSButton;
var() GUI.eFontScale	FSBackground;


event Initialized()
{
	Super.Initialized();
	STYButton		= GUIController(ViewportOwner.GUIController).GetStyle("EonBuildingHelp", FSButton);
	STYBackground	= GUIController(ViewportOwner.GUIController).GetStyle("EonBackground", FSBackground);
}

function CleanUp()
{
	Super.CleanUp();
	Selected		= None;
	Pawn			= None;
}

function PostRender( Canvas C )
{
	DrawTrace( C );
}

function DrawTrace( canvas C )
{
	local actor		Other;
	local rotator	CamRot;
	local vector	CamLoc, HitLocation, HitNormal, StartTrace, EndTrace;
	local float		X, Y, XL, YL;

	//Perform a trace to find any colliding actors
	C.GetCameraLocation(CamLoc, CamRot);
	StartTrace = CamLoc;
	EndTrace = StartTrace + vector(CamRot) * DistMax;
	Other = PlayerOwner.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
	if( Other == None )
		HitLocation = EndTrace;

	Selected = Other;

	if( EonKB_KeyBuilding(Selected) != None )
	{
		SelectedName = EonKB_KeyBuilding(Selected).BuildingName @ "- Press <USE> to access.";
	}

	if( Alpha > 0 )
	{
		X = C.ClipX * 0.51;
		Y = C.ClipY * 0.01;
		XL = C.ClipX * 0.48;
		YL = C.ClipY * 0.085;

		C.Style = CSTY_Normal;
		C.SetDrawColor(255,255,255,255);
		C.ColorModulate.W = Alpha;

		STYBackground.Draw(C,MSAT_Blurry,X,Y,XL,YL);

		X = C.ClipX * 0.52;
		Y = C.ClipY * 0.02;
		XL = C.ClipX * 0.46;
		YL = C.ClipY * 0.065;

//		STYButton.Draw(C,MSAT_Blurry,X,Y,XL,YL);
		STYButton.DrawText(C,MSAT_Blurry,X+16,Y,XL,YL,TXTA_Center,SelectedName, FSButton);
	}
}

function Tick(float DT)
{
	local float	MantlePoints;

	if( KeyValid != IK_None && Pawn != None && Pawn.bCanMantle )
	{
		MantlePoints = Pawn.MantleTry(Pawn.Rotation, Pawn.Location);
		if( MantlePoints > 1 )
			Pawn.MantleBegin();
	}

	if( EonKB_KeyBuilding(Selected) != None )
	{
		Alpha += 1*DT*4;
		Alpha = FClamp(Alpha,0,1);
	}
	else
	{
		Alpha -= 1*DT*4;
		Alpha = FClamp(Alpha,0,1);
	}
}

function bool KeyEvent(EInputKey Key, EInputAction Action, FLOAT Delta )
{
	ConsoleCommand("NEARCLIP 0.1");

	switch( Action )
	{
		case IST_Press:
			KeyPressed = Key;
		break;

		case IST_Release:
			if( KeyValid == Key )
			{
				KeyValid = IK_None;
				OnKeyRelease();
			}
		break;
	}
	return false;
}

delegate OnKeyPress( Eon_Pawn P )
{
	Pawn = P;
	KeyValid = KeyPressed;
}

delegate OnKeyRelease()
{
	if( Pawn != None )
		Pawn.MantleEnd();
}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bVisible=True
	bRequiresTick=True

	TXAim=Texture'EonTX_Engine.Error32'
	DistMax=192
}
