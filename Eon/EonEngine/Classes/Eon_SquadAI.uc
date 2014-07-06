/* =============================================================================
:: File Name	::	Eon_SquadAI.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_SquadAI extends ReplicationInfo;

var() Eon_SquadAI			NextSquad;

var() Controller			SquadLeader;
var() array<Controller>		SquadMembers;

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

}
