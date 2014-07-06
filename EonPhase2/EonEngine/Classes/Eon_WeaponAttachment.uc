/* =============================================================================
:: File Name	::	Eon_WeaponAttachment.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_WeaponAttachment extends WeaponAttachment;

var() class<xEmitter>	MuzzleFlashClass;
var() xEmitter			MuzzleFlash;
var() name				MuzzleBone;

var() class<Actor>		HitEffectClass;


replication
{
	reliable if( Role == ROLE_Authority )
		UpdateHitClient;
}


simulated function Destroyed()
{
	if( MuzzleFlash != None )
		MuzzleFlash.Destroy();

	Super.Destroyed();
}

simulated function MakeMuzzleFlash()
{
	if( MuzzleFlash == None )
	{
		MuzzleFlash = Spawn( MuzzleFlashClass );
		AttachToBone( MuzzleFlash, MuzzleBone );
	}

	MuzzleFlash.mStartParticles++;
}

simulated event ThirdPersonEffects()
{
	//Log("ThirdPersonEffects" @ FiringMode @ FlashCount, 'Attachment');

	if( FlashCount != 0 && Level.NetMode != NM_DedicatedServer )
	{
		MakeMuzzleFlash();

		if( Instigator != None )
		{
			if( FiringMode == 1 )	Instigator.PlayFiring(1.0,'1');
			else					Instigator.PlayFiring(1.0,'0');
		}
	}


}

function UpdateHit(Actor HitActor, vector HitLocation, vector HitNormal)
{
	UpdateHitClient( HitActor, HitLocation, HitNormal );
}

simulated function UpdateHitClient(Actor HitActor, vector HitLocation, vector HitNormal);


simulated function SetFireCoords( Eon_Weapon W, Actor A )
{
	local coords	C;
	local vector	V;
	local rotator	R;

	C = GetBoneCoords(MuzzleBone);
	V = C.Origin - A.Location;
	R = OrthoRotation(C.XAxis,C.YAxis,C.ZAxis) - A.Rotation;
	W.StartFireCoords(V,R);

	//DrawStayingDebugLine(HitStart,HitStart + vector(HitRotation)*512,255,0,0);
}

// = INC =======================================================================

simulated final function LogClass	( coerce string S ){ Log(S@"["$Name$"]", 'WA');}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
}
