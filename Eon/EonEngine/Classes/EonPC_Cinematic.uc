/* =============================================================================
:: File Name	::	Eon_PlayerCinematic.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPC_Cinematic extends EonPC_Base;

var() name	CamBone;

function string FindMenu()
{
	return MainMenu;
}

exec function Fire( optional float F )
{
	GotoMenu(FindMenu());
}

exec function AltFire( optional float F )
{
	GotoMenu(FindMenu());
}

exec function ShowMenu()
{
	GotoMenu(FindMenu());
}

exec function GotoMenu(string MenuName)
{
	ClientOpenMenu(MenuName);
	ConsoleCommand( "DISCONNECT" );
}

function ServerViewNextPlayer()
{
}

auto state PlayerWaiting
{
ignores SeePlayer, HearNoise, NotifyBump, TakeDamage, PhysicsVolumeChange, NextWeapon, PrevWeapon, SwitchToBestWeapon;

	exec function Jump( optional float F ){}
	exec function Suicide()	{}
	function ServerRestartPlayer(){}

	exec function Fire( optional float F )
	{
		GotoMenu(FindMenu());
	}

	exec function AltFire( optional float F )
	{
		GotoMenu(FindMenu());
	}
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	//MainMenu="EonInterface.Eon_PageDebug"
	CamBone=Cambone
}
