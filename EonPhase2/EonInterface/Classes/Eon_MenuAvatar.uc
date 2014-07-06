/* =============================================================================
:: File Name	::	Eon_MenuAvatar.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_MenuAvatar extends Actor;

// FIXME :: offset calculation should work with all fov values

var() vector	Offset;
var() float		FOV;


function SetPawnClass( class<Eon_Pawn> P )
{
	LinkMesh( P.default.Mesh );

	if( P.default.Skins.Length > 0 )	Skins = P.default.Skins;
	else								Skins.Remove(0,Skins.Length);

	Offset	= P.default.MenuOffset;
	FOV		= P.default.MenuFOV;
}

function SetAvatarLocation( vector CamPos, rotator CamRot )
{
	local vector X,Y,Z, N;
	local rotator R;

	GetAxes(CamRot, X, Y, Z);

	N = CamPos + (Offset.X * X) + (Offset.Y * Y) + (Offset.Z * Z);
	SetLocation(N);

	R = OrthoRotation(-X,-Y,Z); // look
	SetRotation( R );
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	RemoteRole=ROLE_None
	bUnlit=false
	bAlwaysTick=true
	DrawType=DT_Mesh
	bOnlyOwnerSee=true
	LODBias=10000
	AmbientGlow=32
	bLightingVisibility=false



	DrawScale=1

//	RotationRate=(Pitch=0,Yaw=8192,Roll=0)
//	bFixedRotationDir=true
//	Physics=PHYS_None

	bBlockZeroExtentTraces=false
	bBlockNonZeroExtentTraces=false
}
