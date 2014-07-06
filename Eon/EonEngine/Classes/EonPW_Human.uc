/* =============================================================================
:: File Name	::	EonPW_Human.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPW_Human extends Eon_Pawn;


function rotator GetHeadCamRotation()
{
	local coords	C;
	C = GetBoneCoords(CamBone);
	return OrthoRotation(-C.YAxis, -C.ZAxis, C.XAxis);
}

function vector GetHeadCamLocation()
{
	local coords	C;
	C = GetBoneCoords(CamBone);
	C.Origin += -C.YAxis*CamOffset.X - C.ZAxis*CamOffset.Y + C.XAxis*CamOffset.Z;
	return C.Origin;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	// Engine.Actor
	CollisionRadius=24
	CollisionHeight=40
	PrePivot=(X=0,Y=0,Z=-40)
	Mesh=SkeletalMesh'EonAN_HumanRifleman.EonPSK_HumanRifleman'

	// Engine.Pawn
	BaseEyeHeight=28
	EyeHeight=28


	AccelRate		= 1024
	BrakingRate		= 2048
	WalkingPctDef	= 0.5
	GroundSpeed		= 325

	// EonEngine.Eon_Pawn
	CamBone="Bip01 Head"
	CamMatrix=(XPlane=(X=0,Y=-1,Z=0,W=0),YPlane=(X=0,Y=0,Z=-1,W=0),ZPlane=(X=1,Y=0,Z=0,W=0),WPlane=(X=0,Y=0,Z=0,W=0))
	CamOffset=(X=8,Y=0,Z=0)
	AimOffset=(X=8,Y=2.775,Z=3.15)

	MoveControlClass=class'EonMC_HumanSoldier'
	AnimControlClass=class'EonAN_HumanSoldier'

	RagSkelName="HumanRifleman_High"

	TeamIndex=0
	SpawnCost=1

	ANIM_AirD		= "Idle"
	ANIM_AirU		= "Idle"
	ANIM_Idle		= "Idle"
	ANIM_Land		= "Crouching"
	ANIM_Crouching	= "Crouching"
	ANIM_FireCrouch	= "CrouchShoot"
	ANIM_Fire		= "Shoot"
	ANIM_Aiming		= "Shoot"
	ANIM_Reload		= "Reload"

	BoneGun	= Gun

	DefaultInventory(0)="EonWeapons.EonWN_HumanRifle"
}
