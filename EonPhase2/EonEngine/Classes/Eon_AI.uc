/* =============================================================================
:: File Name	::	Eon_AI.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_AI extends AIController;

var() EonGI_Base		EonGame;
var() Eon_Pawn			EonPawn;
var() Eon_AIManager		AIManager;
var() int				CacheID;

var() Controller		Leader;

// = LIFESPAN ==================================================================

event PostBeginPlay()
{
	Super.PostBeginPlay();


	EonGame		= EonGI_Base(Level.Game);		Assert( EonGame != None );
	AIManager	= EonGame.AIManager;			Assert( AIManager != None );
	CacheID		= AIManager.RegisterAI(self);

}

function Possess(Pawn aPawn)
{
	aPawn.PossessedBy(self);
	Pawn = aPawn;
	if ( PlayerReplicationInfo != None )
		PlayerReplicationInfo.bIsFemale = Pawn.bIsFemale;
	// preserve Pawn's rotation initially for placed Pawns
	FocalPoint = Pawn.Location + 512*vector(Pawn.Rotation);

	EonPawn		= Eon_Pawn(Pawn);				Assert( EonPawn != None );
	EonGame.ChangeTeam(self, EonPawn.TeamIndex, false);
	AIManager.InitAI(self);

	Restart();
}

event Destroyed()
{
	AIManager.UnRegisterAI( CacheID );
	Super.Destroyed();
}

event Timer()
{
	//GotoState('Follow', 'KeepMoving');
}

event Tick( float DT )
{
}

// == FOLLOW ===================================================================

state Follow
{
	event Timer()
	{
	}

KeepMoving:

	LogAI("KeepMoving");
	if( Leader != None && Leader.Pawn != None )
		MoveTo( Leader.Pawn.Location );

	//if ( !Pawn.ReachedDestination( Leader.Pawn ) )
			Goto('KeepMoving');
}


#include ../_inc/debug/log.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bIsPlayer=true
	bStasis=false
	PlayerReplicationInfoClass=Class'EonEngine.Eon_PRI'
}
