/* =============================================================================
:: File Name	::	Eon_CameraMan.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_CameraMan extends Actor
	config(EonCameraMan)
	placeable;

var() config name				CamRotBone;
var() config name				CamLocBone;
var() config array<Name>		Animations;
var() config MeshAnimation		CameraAnim;
var() config SkeletalMesh		CameraMesh;


simulated event BeginPlay()
{
	if( Level.NetMode != NM_Client )
	{
		if( EonGI_Base(Level.Game) != None )	EonGI_Base(Level.Game).RegisterCameraMan( self );
		else									LogMapWarning("Eon_Game == None in" @ name);
	}

	LinkMesh(CameraMesh);
	LinkSkelAnim(CameraAnim);
	BoneRefresh();
	//SaveConfig();
}

#include ../_inc/debug/Log.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	DrawScale=0.5
	DrawType=DT_Mesh
	CameraMesh=SkeletalMesh'EonAN_CameraMan.EonPSK_CameraMan'
	CameraAnim=MeshAnimation'EonAN_CameraMan.EonPSA_CameraMan'
	Mesh=SkeletalMesh'EonAN_CameraMan.EonPSK_CameraMan'

	Animations(0)=PointA
	Animations(1)=PointAtoB
	Animations(2)=PointAtoC
	Animations(3)=PointAtoD
	Animations(4)=PointB
	Animations(5)=PointBtoA
	Animations(6)=PointC
	Animations(7)=PointCtoA
	Animations(8)=PointD

	CamLocBone=Cambone
	CamRotBone=CameraManBone
}
