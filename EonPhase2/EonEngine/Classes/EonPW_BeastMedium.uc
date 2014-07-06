/* =============================================================================
:: File Name	::	EonPW_BeastMedium.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPW_BeastMedium extends EonPW_Beast;

function rotator GetHeadCamRotation()
{
	local coords	C;
	C = GetBoneCoords(CamBone);
	return OrthoRotation(C.XAxis, C.ZAxis, -C.YAxis);
}

function vector GetHeadCamLocation()
{
	local coords	C;
	C = GetBoneCoords(CamBone);
	//C.Origin += C.XAxis*CamOffset.X + C.ZAxis*CamOffset.Y - C.YAxis*CamOffset.Z;
	return C.Origin;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	// Engine.Actor
	Skins(0)=Material'EonTS_Avatar.BeastShrike.Feathers'
	Skins(1)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(2)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(3)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(4)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(5)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(6)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(7)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(8)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(9)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(10)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(11)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(12)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(13)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(14)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(15)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(16)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(17)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(18)=Material'EonTS_Avatar.BeastShrike.Body'
	Skins(19)=Material'EonTS_Avatar.BeastShrike.Body'

	CollisionRadius=24
	CollisionHeight=36
	PrePivot=(X=0,Y=0,Z=-36)
	Mesh=SkeletalMesh'EonAN_BeastShrike.EonPSK_BeastShrike'


	// Engine.Pawn
	BaseEyeHeight=16
	EyeHeight=16

	HeadBone="Bip01 Head"
	SpineBone2="Bip01 Neck"
	SpineBone1="Bip01 Spine1"
	RootBone="Bip01"


	// EonEngine.Eon_Pawn
	CamSkins(0)=Material'EonTS_Avatar.BeastShrike.Feathers'
	CamSkins(1)=Material'EonTS_Avatar.BeastShrike.Body'
	CamSkins(2)=Material'EonTS_Avatar.BeastShrike.Body'
	CamSkins(3)=Material'EonTS_Avatar.BeastShrike.Body'
	CamSkins(4)=Material'EonTS_Avatar.BeastShrike.Body'
	CamSkins(5)=Material'EonTS_Avatar.Shared.Cam'
	CamSkins(6)=Material'EonTS_Avatar.BeastShrike.Body'
	CamSkins(7)=Material'EonTS_Avatar.BeastShrike.Body'
	CamSkins(8)=Material'EonTS_Avatar.BeastShrike.Body'
	CamSkins(9)=Material'EonTS_Avatar.Shared.Cam'
	CamSkins(10)=Material'EonTS_Avatar.Shared.Cam'
	CamSkins(11)=Material'EonTS_Avatar.Shared.Cam'
	CamSkins(12)=Material'EonTS_Avatar.Shared.Cam'
	CamSkins(13)=Material'EonTS_Avatar.Shared.Cam'
	CamSkins(14)=Material'EonTS_Avatar.BeastShrike.Body'
	CamSkins(15)=Material'EonTS_Avatar.BeastShrike.Body'
	CamSkins(16)=Material'EonTS_Avatar.BeastShrike.Body'
	CamSkins(17)=Material'EonTS_Avatar.BeastShrike.Body'
	CamSkins(18)=Material'EonTS_Avatar.BeastShrike.Body'
	CamSkins(19)=Material'EonTS_Avatar.BeastShrike.Body'

	MenuFOV=50
	MenuName="Medium"
	MenuOffset=(X=250,Y=50,Z=-50)

	SpawnCost=1
	RagSkelName="BeastShrike_High"

	CamMatrix=(XPlane=(X=1,Y=0,Z=0,W=0),YPlane=(X=0,Y=0,Z=1,W=0),ZPlane=(X=0,Y=-1,Z=0,W=0),WPlane=(X=0,Y=0,Z=0,W=0))

	MoveControlClass=class'EonMC_BeastShrike'
	AnimControlClass=class'EonAN_BeastShrike'

	bCanMantle=true
	MantleHandL=(X=39.871700,Y=-16.291219,Z=+59.543762)
	MantleHandR=(X=39.871749,Y=+16.291219,Z=+59.543762)
	MantleFootL=(X=35.262535,Y=-12.703601,Z=-15.484350)
	MantleFootR=(X=35.252914,Y=+12.726344,Z=-15.476976)
}
