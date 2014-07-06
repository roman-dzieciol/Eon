/* =============================================================================
:: File Name	::	EonPW_BeastOfficer.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPW_BeastOfficer extends EonPW_Beast;


// = MOVEMENT ==================================================================

function bool DoJump( bool bUpdating )
{
	return false;
}


// = EYECAM ====================================================================

function rotator GetHeadCamRotation()
{
	local coords	C;
	C = GetBoneCoords(CamBone);
	return OrthoRotation(C.XAxis, -C.ZAxis, -C.YAxis);
}

function vector GetHeadCamLocation()
{
	local coords	C;
	C = GetBoneCoords(CamBone);
	//C.Origin += C.XAxis*CamOffset.X - C.ZAxis*CamOffset.Y - C.YAxis*CamOffset.Z;
	return C.Origin;
}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	// Engine.Actor
	Skins(0)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(1)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(2)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(3)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(4)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(5)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(6)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(7)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(8)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(9)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(10)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(11)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(12)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(13)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(14)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(15)=Material'EonTS_Avatar.BeastOfficer.Feathers'
	Skins(16)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(17)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(18)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(19)=Material'EonTS_Avatar.BeastOfficer.Body'
	Skins(20)=Material'EonTS_Weapon.Cannon.CannonShader'
	Skins(21)=Material'EonTS_Projectile.Cannon.Cannonball'
	Skins(22)=Material'EonTS_Projectile.Cannon.Cannonball'
	Skins(23)=Material'EonTS_Projectile.Cannon.Cannonball'
	Skins(24)=Material'EonTS_Projectile.Cannon.Cannonball'
	Skins(25)=Material'EonTS_Projectile.Cannon.Cannonball'
	Skins(26)=Material'EonTS_Projectile.Cannon.Cannonball'
	Skins(27)=Material'EonTS_Projectile.Cannon.Cannonball'
	Skins(28)=Material'EonTS_Projectile.Cannon.Cannonball'

	CollisionRadius=40
	CollisionHeight=80
	PrePivot=(X=0,Y=0,Z=-85)
	Mesh=SkeletalMesh'EonAN_BeastOfficer.EonPSK_BeastOfficer'


	// Engine.Pawn
	BaseEyeHeight=56
	EyeHeight=56

	AccelRate=512
	BrakingRate=1024
	WalkingPctDef=0.45
	CrouchedPct=0
	GroundSpeed=375


	// EonEngine.Eon_Pawn
	CamSkins(0)=Material'EonTS_Avatar.BeastOfficer.Body'
	CamSkins(1)=Material'EonTS_Avatar.BeastOfficer.Body'
	CamSkins(2)=Material'EonTS_Avatar.BeastOfficer.Body'
	CamSkins(3)=Material'EonTS_Avatar.BeastOfficer.Body'
	CamSkins(4)=Material'EonTS_Avatar.BeastOfficer.Body'
	CamSkins(5)=Material'EonTS_Avatar.Shared.Cam'
	CamSkins(6)=Material'EonTS_Avatar.BeastOfficer.Body'
	CamSkins(7)=Material'EonTS_Avatar.BeastOfficer.Body'
	CamSkins(8)=Material'EonTS_Avatar.BeastOfficer.Body'
	CamSkins(9)=Material'EonTS_Avatar.BeastOfficer.Body'
	CamSkins(10)=Material'EonTS_Avatar.Shared.Cam'
	CamSkins(11)=Material'EonTS_Avatar.Shared.Cam'
	CamSkins(12)=Material'EonTS_Avatar.Shared.Cam'
	CamSkins(13)=Material'EonTS_Avatar.Shared.Cam'
	CamSkins(14)=Material'EonTS_Avatar.Shared.Cam'
	CamSkins(15)=Material'EonTS_Avatar.BeastOfficer.Feathers'
	CamSkins(16)=Material'EonTS_Avatar.BeastOfficer.Body'
	CamSkins(17)=Material'EonTS_Avatar.BeastOfficer.Body'
	CamSkins(18)=Material'EonTS_Avatar.BeastOfficer.Body'
	CamSkins(19)=Material'EonTS_Avatar.BeastOfficer.Body'
	CamSkins(20)=Material'EonTS_Weapon.Cannon.CannonShader'
	CamSkins(21)=Material'EonTS_Projectile.Cannon.Cannonball'
	CamSkins(22)=Material'EonTS_Projectile.Cannon.Cannonball'
	CamSkins(23)=Material'EonTS_Projectile.Cannon.Cannonball'
	CamSkins(24)=Material'EonTS_Projectile.Cannon.Cannonball'
	CamSkins(25)=Material'EonTS_Projectile.Cannon.Cannonball'
	CamSkins(26)=Material'EonTS_Projectile.Cannon.Cannonball'
	CamSkins(27)=Material'EonTS_Projectile.Cannon.Cannonball'
	CamSkins(28)=Material'EonTS_Projectile.Cannon.Cannonball'

	MenuFOV=10
	MenuName="Officer"
	MenuOffset=(X=2000,Y=80,Z=-87.5)

	SpawnCost=5
	RagSkelName="BeastOfficer_High"

	CamMatrix=(XPlane=(X=1,Y=0,Z=0,W=0),YPlane=(X=0,Y=0,Z=-1,W=0),ZPlane=(X=0,Y=-1,Z=0,W=0),WPlane=(X=0,Y=0,Z=0,W=0))

	MoveControlClass=class'EonMC_BeastOfficer'
	AnimControlClass=class'EonAN_BeastOfficer'

	ANIM_Land="CrouchMid"
	ANIM_Run(0)="RunF"
	ANIM_Run(1)="MoveB"
	ANIM_Run(2)="RunFL"
	ANIM_Run(3)="RunFR"
	ANIM_AirD="JumpMid"
	ANIM_AirU="JumpMid"
	ANIM_JumpUTakeOff="JumpMid"
	ANIM_Crouching="CrouchMid"
}
