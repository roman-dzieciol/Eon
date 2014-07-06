/* =============================================================================
:: File Name	::	EonWF_TraceRifle.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonWF_TraceRifle extends EonWF_Trace;


var() bool		bStartLoaded;
var() int		ClipAmmo;
var() int		ClipSize;
var() float		ClipReload;


// = INIT ======================================================================

event PreBeginPlay()
{
	Super.PreBeginPlay();

	if( bStartLoaded )
	{
		ClipInsert();
	}
}


// = WEAPON FIRE ===============================================================

event ModeDoFire()
{
	Super.ModeDoFire();

	ClipAmmo--;
	if( ClipAmmo == 0 )
		GotoState('Reloading');
}

simulated function bool AllowFire()
{
	if( !Super.AllowFire() )
		return false;

	if( ClipAmmo == 0 )
	{
		GotoState('Reloading');
		return false;
	}
	return true;
}


// = ABSTRACT RIFLE ============================================================

function ClipEject()
{
	//LogClass("ClipEject");
	Weapon.PlayOwnedSound(ReloadSound);
	Instigator.PlayFiring(1.0,'Reload');
}

function ClipInsert()
{
	//LogClass("ClipInsert");
	ClipAmmo = ClipSize;
}


// = RELOADING =================================================================

state Reloading
{
	simulated function BeginState()
	{
		LogClass("Reloading");
		ClipEject();
		NextFireTime = Level.TimeSeconds + ClipReload;
		SetTimer(ClipReload, false);
	}

	simulated function Timer()
	{
		ClipInsert();
		GotoState('');
	}

	simulated function bool AllowFire()
	{
		return false;
	}
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	ClipReload		= 2
	ClipSize		= 5
	bStartLoaded	= true
}
