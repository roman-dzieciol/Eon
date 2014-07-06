/* =============================================================================
:: File Name	::	Eon_TeamInfo.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TeamInfo extends TeamInfo;

var() Eon_TeamAI		AI;

var() array< class<Eon_Pawn> >	PlayerClasses;

function bool AddToTeam( Controller Other )
{
	local Controller		P;
	local bool				bSuccess;
	local Eon_PRI			PRI;
	local EonPC_Base		PC;


	// make sure loadout works for this team
	if( Other == None )
	{
		log("Added none to team!!!");
		return false;
	}

	if( MessagingSpectator(Other) != None )
		return false;

	PRI = Eon_PRI(Other.PlayerReplicationInfo);

	Size++;
	PRI.Team = self;

	bSuccess = false;
	if( Other.IsA('PlayerController') )	PRI.TeamID = 0;
	else								PRI.TeamID = 1;

	while( !bSuccess )
	{
		bSuccess = true;
		for ( P=Level.ControllerList; P!=None; P=P.nextController )
			if ( P.bIsPlayer && (P != Other)
				&& (P.PlayerReplicationInfo.Team == PRI.Team)
				&& (P.PlayerReplicationInfo.TeamId == PRI.TeamId) )
				bSuccess = false;
		if ( !bSuccess )
			PRI.TeamID = PRI.TeamID + 1;
	}

	PC = EonPC_Base(Other);
	if( PC != None )
	{
		// reset player classes
		PC.PlayerClassesReset( TeamIndex );
		PC.PlayerClassesResetClient( TeamIndex );

		// reset selected position
		if( PC.StartPosition != None &&	PC.StartPosition.Ownership != TeamIndex )
			PC.StartPosition = None;
	}

	return true;
}

function RemoveFromTeam(Controller Other)
{
	Size--;
}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	TeamName="Eon"
	ColorNames(0)="Human"
	ColorNames(1)="Beast"
	ColorNames(2)="Neutral"
	ColorNames(3)="Error"

	PlayerClasses(0)=None
}
