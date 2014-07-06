/* =============================================================================
:: File Name	::	EonWF_Trace.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonWF_Trace extends EonWF_WeaponFire;

var() class<DamageType>	DamageType;
var() int				DamageMin;
var() int				DamageMax;
var() float				TraceRange;
var() float				Momentum;


function float MaxRange()
{
	if( Instigator.Region.Zone.bDistanceFog )
			return FClamp(Instigator.Region.Zone.DistanceFogEnd, 8000, default.TraceRange);
	else	return default.TraceRange;
}

function DoFireEffect()
{
	local vector	StartTrace;
	local rotator	Aim;

	//LogClass("DoFireEffect");
	Instigator.MakeNoise(1.0);

	StartTrace	= Eon_Weapon(Weapon).FireLocation + Instigator.Location;
	Aim			= Eon_Weapon(Weapon).FireRotation + Instigator.Rotation;

	DoTrace(StartTrace, Aim);
}

function DoTrace( vector Start, rotator Dir )
{
	local vector	X, End, HitLocation, HitNormal;
	local Actor		Other;
	local int		Damage;

	TraceRange = MaxRange();
	X = Vector(Dir);
	End = Start + TraceRange * X;

	Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);
	if( Other != None && Other != Instigator )
	{
		Damage = DamageMin + FRand()*(DamageMax-DamageMin);
		WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other, HitLocation, HitNormal);
		if( !Other.bWorldGeometry )
		{
			Other.TakeDamage(Damage, Instigator, HitLocation, Momentum*X, DamageType);
		}
	}
	else
	{
		HitLocation = End;
		WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
	}

	//LogClass("DoTrace" @ Other @ VSize(HitLocation - Start) @ HitNormal);
}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Momentum	= 10000
	TraceRange	= 8192
	bInstantHit	= true

}

