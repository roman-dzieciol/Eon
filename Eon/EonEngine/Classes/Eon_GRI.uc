/* =============================================================================
:: File Name	::	Eon_GRI.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_GRI extends GameReplicationInfo;

var() array<EonKP_KeyPosition>	KeyPositions;

replication
{
	reliable if (Role < ROLE_Authority)
		ServerSendPositions;

	reliable if (Role == ROLE_Authority)
		ClientReceivePosition;
}



simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	LogRI("PostBeginPlay");
	if( Level.NetMode != NM_Client )
	{
		KeyPositions = EonGI_Base(Level.Game).PositionAll;
	}
}


// = POSITIONS =================================================================

function ServerSendPositions()
{
	local int i;

	LogRI("ServerSendPositions");
	for(i=0; i<KeyPositions.Length; i++)
		ClientReceivePosition( KeyPositions[i] );
}

simulated function AddKP( EonKP_KeyPosition KP )
{
	LogRI("AddKP" @ KP);
	KeyPositions[KeyPositions.Length] = KP;
}

simulated function ClientReceivePosition( EonKP_KeyPosition KP )
{
	LogRI("ClientReceivePosition" @ KP);
	KeyPositions[KeyPositions.Length] = KP;
	OnReceivePosition( KP );
}

delegate OnReceivePosition( EonKP_KeyPosition KP );


// = INC =======================================================================

#include ../Eon/_inc/debug/log.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	ServerName="Eon 2004 Server"
	ShortName="Eon Server"
}
