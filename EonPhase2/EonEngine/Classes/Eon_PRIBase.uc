/* =============================================================================
:: File Name	::	Eon_PRIBase.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PRIBase extends PlayerReplicationInfo;

#include ../_inc/const/Teams.uc

var() Eon_SquadAI				Squad;


replication
{
	reliable if (Role < ROLE_Authority)
		ServerSendPositions,
		ServerTeleportTo
		;

	reliable if (Role == ROLE_Authority)
		ClientReceivePosition
		;

	reliable if (Role == ROLE_Authority)
		Squad;
}

// = SPAWNING ==================================================================

function bool ServerTeleportTo( EonKP_KeyPosition KP )
{
	local vector		NewStart;
	local EonPC_Base	P;

	LogRI("ServerTeleportTo" @ KP);

	if( Team != None && Team.TeamIndex != KP.Ownership )
		return false;

	P = EonPC_Base(Owner);
	NewStart = KP.GetStartLocation( P.PawnClass );


	if( P.SetLocation(NewStart) )
	{
		if( P.Pawn != None )
		{
			P.Pawn.SetLocation( NewStart );
			P.Pawn.PlayTeleportEffect(false, false);
		}
		P.ClientSetRotation( KP.GetStartRotation() );
		P.ClientCloseMenu(true);
		return true;
	}

	return false;
}

// = PLAYER CLASS ==============================================================
/*
simulated function ServerSetPlayerClass( byte B )
{
	LogRI("ServerSetPlayerClass" @ B);
	PlayerClassIndex = B;
}

simulated function SetPlayerClass( byte B )
{
	LogRI("SetPlayerClass" @ B);
	PlayerClassIndex = B;
	ServerSetPlayerClass( B );
}

simulated function SetPlayerClassPriority( array< class<Eon_Pawn> > A )
{
	LogRI("SetPlayerClassPriority" @ A.Length);
	PlayerClassPriority = A;
	ServerSetPlayerClassPriority( A );
}

simulated function ServerSetPlayerClassPriority( array< class<Eon_Pawn> > A )
{
	LogRI("ServerSetPlayerClassPriority" @ A.Length);
	PlayerClassPriority = A;
}

simulated function array< class<Eon_Pawn> > GetPlayerClasses( optional bool bDefault )
{
	if( Team != None )
	{
		if( bDefault )	return Eon_TeamInfo(Team).default.PlayerClasses;
		else			return Eon_TeamInfo(Team).PlayerClasses;
	}
	else
		return class'Eon_TeamNeutral'.default.PlayerClasses;
}

simulated function array< class<Eon_Pawn> > GetPlayerClassesFor( int TeamNum )
{
	switch( TeamNum )
	{
	case 0:		return class'Eon_TeamHuman'.default.PlayerClasses;
	case 1:		return class'Eon_TeamBeast'.default.PlayerClasses;
	default:	return class'Eon_TeamNeutral'.default.PlayerClasses;
	}
}*/

// = TEAM ======================================================================

simulated function byte GetTeamIndex()
{
	if( Team != None )	return Team.TeamIndex;
	else				return TEAM_Neutral;
}

/*function class<Eon_Pawn> GetPawnClass()
{
	if( PlayerClassPriority.Length > 0 )	return PlayerClassPriority[0];
	else									return None;
}*/

// = POSITION ==================================================================


delegate OnReceivePosition( EonKP_KeyPosition KP );

function ServerSendPositions()
{
	local int i;
	local EonGI_Base EonGame;

	LogRI("ServerSendPositions");

	EonGame = EonGI_Base(Level.Game);

	if( Team == None )
	{
		for(i=0; i<EonGame.PositionAll.Length; i++)
			ClientReceivePosition( EonGame.PositionAll[i] );
	}
	else
	{
		if( Team.TeamIndex == TEAM_Human)
		{
			for(i=0; i<EonGame.PositionHuman.Length; i++)
				ClientReceivePosition( EonGame.PositionHuman[i] );
		}
		else if( Team.TeamIndex == TEAM_Beast)
		{
			for(i=0; i<EonGame.PositionBeast.Length; i++)
				ClientReceivePosition( EonGame.PositionBeast[i] );
		}
	}

	EonPC_Base(Owner).bReadyToStart = (Level.NetMode == NM_Standalone );
	EonPC_Base(Owner).ShowLoginMenu();
}

simulated function ClientReceivePosition( EonKP_KeyPosition KP )
{
	LogRI("ClientReceivePosition" @ KP);
	OnReceivePosition( KP );
}

// = INC =======================================================================

#include ../_inc/debug/Log.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

}
