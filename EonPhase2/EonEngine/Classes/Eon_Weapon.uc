/* =============================================================================
:: File Name	::	Eon_Weapon.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_Weapon extends Weapon
	HideDropDown
	CacheExempt;


var() vector	FireLocation;
var() rotator	FireRotation;



replication
{
	reliable if( bNetOwner && Role < ROLE_Authority )
		StartFireCoords;
}



simulated event RenderOverlays( Canvas Canvas ){}
simulated function vector GetEffectStart()
{
	return Location;
}

simulated function PostBeginPlay()
{
	//LogClass("PostBeginPlay");
	Super.PostBeginPlay();
}

event PreBeginPlay()
{
	//LogClass("PreBeginPlay");
	Super.PreBeginPlay();
}

simulated function Destroyed()
{
	//LogClass("Destroyed");
	Super.Destroyed();
}

simulated function bool StartFire(int Mode)
{
	//LogClass("StartFire");
	return Super.StartFire(Mode);
}

simulated event ClientStartFire(int Mode)
{
	if( Pawn(Owner).Controller.IsInState('GameEnded') || Pawn(Owner).Controller.IsInState('RoundEnded') )
		return;

	//LogClass("ClientStartFire");

	if( Role < ROLE_Authority || Level.NetMode == NM_Standalone )
	{
		//LogClass("ClientStartFire StartFireCoords");
		Eon_WeaponAttachment(ThirdPersonActor).SetFireCoords(self, Owner);
	}

	if( Role < ROLE_Authority )
	{
		if( bDebugging )
			log(self$" client start fire ");

		if( StartFire(Mode) )
		{
			if( bDebugging )
				log(self$" call server start fire ");
			ServerStartFire(Mode);
		}
	}
	else
	{
		StartFire(Mode);
	}
}

simulated function Timer()
{
	local int Mode;
	local float OldDownDelay;

	OldDownDelay = DownDelay;
	DownDelay = 0;

	if( ClientState == WS_ReadyToFire )
	{
 		if( Role < ROLE_Authority || Level.NetMode == NM_Standalone )
		{
			//LogClass("Timer StartFireCoords");
			Eon_WeaponAttachment(ThirdPersonActor).SetFireCoords(self, Owner);
		}
	}
	else if (ClientState == WS_BringUp)
	{
		for( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )
	       FireMode[Mode].InitEffects();
		PlayIdle();
		ClientState = WS_ReadyToFire;
		SetTimer(1/NetUpdateFrequency,true);
	}
	else if (ClientState == WS_PutDown)
	{
		if ( OldDownDelay > 0 )
		{
			if ( HasAnim(PutDownAnim) )
				PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
			SetTimer(PutDownTime, false);
			return;
		}
		if ( Instigator.PendingWeapon == None )
		{
			PlayIdle();
			ClientState = WS_ReadyToFire;
		}
		else
		{
			ClientState = WS_Hidden;
			Instigator.ChangedWeapon();
			if ( Instigator.Weapon == self )
			{
				PlayIdle();
				ClientState = WS_ReadyToFire;
			}
			else
			{
				for( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )
					FireMode[Mode].DestroyEffects();
			}
		}
	}
}

function StartFireCoords( vector V, rotator R )
{
	FireLocation = V;
	FireRotation = R;
}

// = INC =======================================================================

simulated final function LogClass	( coerce string S ){ Log(S@"["$Name$"]", 'WN');}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	DrawType=DT_None
}
