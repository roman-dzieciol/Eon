/* =============================================================================
:: File Name	::	Eon_CamMesh.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_CamMesh extends Actor;

#include ../_inc/const/RenderStyle.uc

var() vector			Offset;

var() ScriptedTexture	CamLeft;
var() ScriptedTexture	CamRight;

var() rotator			CamLeftRot;
var() rotator			CamRightRot;

var() rotator			CamLeftDir;
var() rotator			CamRightDir;

var() vector			CamLoc;

var() Material					TBlack;
var() Material					TMask;
var() float						TMaskX;
var() float						TMaskY;

var() StaticMesh				CamMeshWidePinch;
var() StaticMesh				CamMeshWideFull;
var() float						ClipXLast;
var() float						ClipYLast;

var() vector					AdjustLoc;


event RenderTexture( ScriptedTexture Tex )
{
	if( Tex == CamLeft)	Tex.DrawPortal(0, 0, Tex.USize, Tex.VSize, self, CamLoc, CamLeftRot, 90);
	else				Tex.DrawPortal(0, 0, Tex.USize, Tex.VSize, self, CamLoc, CamRightRot, 90);
}

function SetCamMesh( StaticMesh M )
{
	SetStaticMesh( M );

	TMaskX = TMask.MaterialUSize();
	TMaskY = TMask.MaterialVSize();

	CamLeft = ScriptedTexture(Skins[0]);
	CamRight = ScriptedTexture(Skins[1]);

	CamLeft.Client = Self;
	CamRight.Client = Self;
}

function SetResolution( float X, float Y )
{
	CamLeft.SetSize(X,Y);
	CamRight.SetSize(X,Y);
}

function RenderMesh( vector CamPos, rotator CamRot)
{
	local vector MeshLoc,LX,LY,LZ,GX,GY,GZ;
	local rotator MeshRot;

	GetAxes(CamRot,GX,GY,GZ);
	AdjustLoc = 127*GX;
	MeshLoc = CamPos + (127*GX);
	MeshRot = OrthoRotation(-GX,-GY,GZ);		// look at me!

	GetAxes(CamLeftDir,GX,GY,GZ);
	LX = GX >> CamRot;
	LY = GY >> CamRot;
	LZ = GZ >> CamRot;
	CamLeftRot = OrthoRotation(LX,LY,LZ);

	GetAxes(CamRightDir,GX,GY,GZ);
	LX = GX >> CamRot;
	LY = GY >> CamRot;
	LZ = GZ >> CamRot;
	CamRightRot = OrthoRotation(LX,LY,LZ);

	SetLocation( MeshLoc );
	SetRotation( MeshRot );
	CamLoc = MeshLoc;

	CamLeft.Revision++;
	CamRight.Revision++;
}

final function AdjustCameraLocation( out vector CamPos )
{
	//log("AdjustCameraLocation"@Level.TimeSeconds);
	CamPos -= AdjustLoc;
}

final function PreRenderWidePinch( Canvas C )
{
	local vector	CamPos;
	local rotator	CamRot;

	if( ClipXLast != C.ClipX && ClipYLast != C.ClipY )
	{
		ClipXLast = C.ClipX;
		ClipYLast = C.ClipY;
		if( ClipYLast >= 1024 || ClipXLast >= 1024 )	SetResolution(1024, 1024);
		else											SetResolution(512, 512);
	}

	C.bRenderLevel = False;
	C.SetDrawColor(255,255,255,255);
	C.SetPos(0,0);
	C.DrawTileStretched( TBlack, C.ClipX, C.ClipY );

	C.GetCameraLocation(CamPos, CamRot);
	RenderMesh(CamPos, CamRot);
	C.DrawActor(self, false, true, 90);

	C.SetPos(0,0);
	C.Style = CSTY_Alpha;
	C.DrawTile( TMask, C.ClipX, C.ClipY, 0, 0, TMaskX, TMaskY );
}

final function PreRenderWideFull( Canvas C )
{
	local vector	CamPos;
	local rotator	CamRot;

	if( ClipXLast != C.ClipX && ClipYLast != C.ClipY )
	{
		ClipXLast = C.ClipX;
		ClipYLast = C.ClipY;
		if( ClipYLast >= 1024 || ClipXLast >= 1024 )	SetResolution(1024, 1024);
		else											SetResolution(512, 512);
	}

	C.bRenderLevel = False;
	C.SetDrawColor(255,255,255,255);
	C.GetCameraLocation(CamPos, CamRot);
	RenderMesh(CamPos, CamRot);
	C.DrawActor(self, false, true, 90);
}


#include ../_inc/func/String.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Offset=(X=127,Y=0,Z=0)

	RemoteRole=ROLE_None
	bUnlit=true
	bOnlyOwnerSee=true

	DrawType=DT_StaticMesh
	Skins(0)=Material'EonTX_Camera.CamLeft'
	Skins(1)=Material'EonTX_Camera.CamRight'

	CamLeftDir	= (Pitch=0,Yaw=-8192,Roll=0)
	CamRightDir	= (Pitch=0,Yaw=8192,Roll=0)

	bLightingVisibility=false
	DrawScale=1

	bAlwaysTick=false
	bStasis=False
	bBlockZeroExtentTraces=false
	bBlockNonZeroExtentTraces=false
	CollisionRadius=0
	CollisionHeight=0
	bIgnoreOutOfWorld=true


	TBlack	= Material'Engine.BlackTexture'
	TMask	= Material'EonTX_Camera.CamSqrtMask'

	CamMeshWidePinch	= StaticMesh'EonSM_Camera.CamSqrt'
	CamMeshWideFull		= StaticMesh'EonSM_Camera.CamSqrtLin'
}
