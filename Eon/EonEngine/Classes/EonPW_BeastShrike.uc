/* =============================================================================
:: File Name	::	EonPW_BeastShrike.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPW_BeastShrike extends EonPW_Beast;

var() config float		ChanceIdleGrab;


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

// = ANIM ======================================================================

final function NOTIFY_Grab4Idle()
{
	if( FRand() < ChanceIdleGrab )	ANIM_GrabIdle = 'Grab4Idle';
	else							ANIM_GrabIdle = 'Grab4Idle2';
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	// Engine.Actor
    Skins(0)=FinalBlend'EonTS_BeastShrike.Feathers'
    Skins(1)=Shader'EonTS_BeastShrike.Body'
    Skins(2)=Shader'EonTS_BeastShrike.Body'
    Skins(3)=Shader'EonTS_BeastShrike.Body'
    Skins(4)=Shader'EonTS_BeastShrike.Body'
    Skins(5)=Shader'EonTS_BeastShrike.Body'
    Skins(6)=Shader'EonTS_BeastShrike.Body'
    Skins(7)=Shader'EonTS_BeastShrike.Body'
    Skins(8)=Shader'EonTS_BeastShrike.Body'
    Skins(9)=Shader'EonTS_BeastShrike.Body'
    Skins(10)=Shader'EonTS_BeastShrike.Body'
    Skins(11)=Shader'EonTS_BeastShrike.Body'
    Skins(12)=Shader'EonTS_BeastShrike.Body'
    Skins(13)=Shader'EonTS_BeastShrike.Body'
    Skins(14)=Shader'EonTS_BeastShrike.Body'
    Skins(15)=Shader'EonTS_BeastShrike.Body'
    Skins(16)=Shader'EonTS_BeastShrike.Body'
    Skins(17)=Shader'EonTS_BeastShrike.Body'
    Skins(18)=Shader'EonTS_BeastShrike.Body'
    Skins(19)=Shader'EonTS_BeastShrike.Body'

	CollisionRadius=24
	CollisionHeight=36
	PrePivot=(X=0,Y=0,Z=-42)
	Mesh=SkeletalMesh'EonAN_BeastShrike.EonPSK_BeastShrike'


	// Engine.Pawn
	BaseEyeHeight=16
	EyeHeight=16

	CrouchHeight=24
	CrouchRadius=24

	HeadBone="Bip01 Head"
	SpineBone2="Bip01 Neck"
	SpineBone1="Bip01 Spine1"
	RootBone="Bip01"

	AccelRate=1024
	BrakingRate=2048
	WalkingPctDef=0.33


	// EonEngine.Eon_Pawn
    CamSkins(0)=Shader'EonTS_Camera.Invisible'
    CamSkins(1)=Shader'EonTS_BeastShrike.Body'
    CamSkins(2)=Shader'EonTS_BeastShrike.Body'
    CamSkins(3)=Shader'EonTS_BeastShrike.Body'
    CamSkins(4)=Shader'EonTS_BeastShrike.Body'
    CamSkins(5)=Shader'EonTS_Camera.Invisible'
    CamSkins(6)=Shader'EonTS_BeastShrike.Body'
    CamSkins(7)=Shader'EonTS_BeastShrike.Body'
    CamSkins(8)=Shader'EonTS_BeastShrike.Body'
    CamSkins(9)=Shader'EonTS_Camera.Invisible'
    CamSkins(10)=Shader'EonTS_Camera.Invisible'
    CamSkins(11)=Shader'EonTS_Camera.Invisible'
    CamSkins(12)=Shader'EonTS_Camera.Invisible'
    CamSkins(13)=Shader'EonTS_Camera.Invisible'
    CamSkins(14)=Shader'EonTS_BeastShrike.Body'
    CamSkins(15)=Shader'EonTS_BeastShrike.Body'
    CamSkins(16)=Shader'EonTS_BeastShrike.Body'
    CamSkins(17)=Shader'EonTS_BeastShrike.Body'
    CamSkins(18)=Shader'EonTS_BeastShrike.Body'
    CamSkins(19)=Shader'EonTS_BeastShrike.Body'

	MenuFOV=50
	MenuName="Shrike"
	MenuOffset=(X=250,Y=50,Z=-50)

	SpawnCost=1
	RagSkelName="BeastShrike_High"
	CamMatrix=(XPlane=(X=1,Y=0,Z=0,W=0),YPlane=(X=0,Y=0,Z=1,W=0),ZPlane=(X=0,Y=-1,Z=0,W=0),WPlane=(X=0,Y=0,Z=0,W=0))

	MoveControlClass=class'EonMC_BeastShrike'
	AnimControlClass=class'EonAN_BeastShrike'

	bCanMantle=true
	MantleHandL=(X=42,Y=-18,Z=+51)
	MantleHandR=(X=42,Y=+18,Z=+51)
	MantleFootL=(X=42,Y=-12,Z=-15)
	MantleFootR=(X=42,Y=+12,Z=-15)

	ChanceIdleGrab=0.9

	ANIM_Land="JumpULand2"
	ANIM_Walk(0)="WalkF"
	ANIM_Walk(1)="Idle"
	ANIM_Walk(2)="Idle"
	ANIM_Walk(3)="Idle"
	ANIM_Run(0)="RunF"
	ANIM_Run(1)="Idle"
	ANIM_Run(2)="RunFL"
	ANIM_Run(3)="RunFR"
}
