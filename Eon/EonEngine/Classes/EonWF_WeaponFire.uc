/* =============================================================================
:: File Name	::	EonWF_WeaponFire.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonWF_WeaponFire extends WeaponFire;

event ModeDoFire()
{
	//LogClass("ModeDoFire");
	Super.ModeDoFire();
}

function Update(float dt)
{
	//LogClass("Update" @ dt );
}

function StartFiring()
{
	//LogClass("StartFiring" );
}

function StopFiring()
{
	//LogClass("StopFiring" );
}

simulated function bool AllowFire()
{
	if( !Super.AllowFire() )
		return false;

	if( Eon_Pawn(Instigator).AimingState != 1 )
		return false;

	return true;
}


// = INC =======================================================================

simulated final function		LogClass( coerce string S ){ Log(S@"["$Name$"]", 'WF');}
simulated final function bool	LogResult( bool B, string S ){ LogClass(S);	return B;}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

}
