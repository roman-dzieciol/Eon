/* =============================================================================
:: File Name	::	EonPW_BeastOfficer.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPW_BeastShepherd extends EonPW_Beast;


// = LIFESPAN ==================================================================

static function bool ValidSpawnPoint( EonKP_KeyPoint K )
{
	return	(	default.TeamIndex == K.Ownership
			&&	EonKP_PositionTertiary(K) == None );
}

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
    Skins(0)=Shader'EonTS_BeastShepherd.Body'
    Skins(1)=Shader'EonTS_BeastShepherd.Body'
    Skins(2)=Shader'EonTS_BeastShepherd.Body'
    Skins(3)=Shader'EonTS_BeastShepherd.Body'
    Skins(4)=Shader'EonTS_BeastShepherd.Body'
    Skins(5)=Shader'EonTS_BeastShepherd.Body'
    Skins(6)=Shader'EonTS_BeastShepherd.Body'
    Skins(7)=Shader'EonTS_BeastShepherd.Body'
    Skins(8)=Shader'EonTS_BeastShepherd.Body'
    Skins(9)=Shader'EonTS_BeastShepherd.Body'
    Skins(10)=Shader'EonTS_BeastShepherd.Body'
    Skins(11)=Shader'EonTS_BeastShepherd.Body'
    Skins(12)=Shader'EonTS_BeastShepherd.Body'
    Skins(13)=Shader'EonTS_BeastShepherd.Body'
    Skins(14)=Shader'EonTS_BeastShepherd.Body'
    Skins(15)=FinalBlend'EonTS_BeastShepherd.Feathers'
    Skins(16)=Shader'EonTS_BeastShepherd.Body'
    Skins(17)=Shader'EonTS_BeastShepherd.Body'
    Skins(18)=Shader'EonTS_BeastShepherd.Body'
    Skins(19)=Shader'EonTS_BeastShepherd.Body'
    Skins(20)=Shader'EonTS_Weapon.Cannon.CannonShader'
    Skins(21)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    Skins(22)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    Skins(23)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    Skins(24)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    Skins(25)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    Skins(26)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    Skins(27)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    Skins(28)=Shader'EonTS_Weapon.Cannon.CannonBalls'

	CollisionRadius=40
	CollisionHeight=80
	PrePivot=(X=0,Y=0,Z=-85)
	Mesh=SkeletalMesh'EonAN_BeastShepherd.EonPSK_BeastShepherd'


	// Engine.Pawn
	BaseEyeHeight=56
	EyeHeight=56

	AccelRate=512
	BrakingRate=1024
	WalkingPctDef=0.45
	CrouchedPct=0
	GroundSpeed=375


	// EonEngine.Eon_Pawn
    CamSkins(0)=Shader'EonTS_BeastShepherd.Body'
    CamSkins(1)=Shader'EonTS_BeastShepherd.Body'
    CamSkins(2)=Shader'EonTS_BeastShepherd.Body'
    CamSkins(3)=Shader'EonTS_BeastShepherd.Body'
    CamSkins(4)=Shader'EonTS_BeastShepherd.Body'
    CamSkins(5)=Shader'EonTS_Camera.Invisible'
    CamSkins(6)=Shader'EonTS_BeastShepherd.Body'
    CamSkins(7)=Shader'EonTS_BeastShepherd.Body'
    CamSkins(8)=Shader'EonTS_BeastShepherd.Body'
    CamSkins(9)=Shader'EonTS_BeastShepherd.Body'
	CamSkins(10)=Shader'EonTS_Camera.Invisible'
    CamSkins(11)=Shader'EonTS_Camera.Invisible'
    CamSkins(12)=Shader'EonTS_Camera.Invisible'
    CamSkins(13)=Shader'EonTS_Camera.Invisible'
    CamSkins(14)=Shader'EonTS_Camera.Invisible'
    CamSkins(15)=FinalBlend'EonTS_BeastShepherd.Feathers'
    CamSkins(16)=Shader'EonTS_BeastShepherd.Body'
    CamSkins(17)=Shader'EonTS_BeastShepherd.Body'
    CamSkins(18)=Shader'EonTS_BeastShepherd.Body'
    CamSkins(19)=Shader'EonTS_BeastShepherd.Body'
    CamSkins(20)=Shader'EonTS_Weapon.Cannon.CannonShader'
    CamSkins(21)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    CamSkins(22)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    CamSkins(23)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    CamSkins(24)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    CamSkins(25)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    CamSkins(26)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    CamSkins(27)=Shader'EonTS_Weapon.Cannon.CannonBalls'
    CamSkins(28)=Shader'EonTS_Weapon.Cannon.CannonBalls'

	MenuFOV=10
	MenuName="Officer"
	MenuOffset=(X=2000,Y=80,Z=-87.5)

	SpawnCost=5
	RagSkelName="BeastOfficer_High"

	CamMatrix=(XPlane=(X=1,Y=0,Z=0,W=0),YPlane=(X=0,Y=0,Z=-1,W=0),ZPlane=(X=0,Y=-1,Z=0,W=0),WPlane=(X=0,Y=0,Z=0,W=0))

	MoveControlClass=class'EonMC_BeastShepherd'
	AnimControlClass=class'EonAN_BeastShepherd'

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
