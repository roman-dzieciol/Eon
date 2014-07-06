/* =============================================================================
:: File Name	::	Eon_AIManager.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_AIManager extends Info;


var() bool 				bSoaking;	// Debug
var() array<Eon_AI>		AICache;	// Cache
var() float				AITimer;	// Performance


// = AI LIFESPAN ===============================================================

function InitAI( Eon_AI A )
{
	A.bSoaking = bSoaking;
	A.SetTimer( AITimer, true );
	LogAI("InitAI" @ A);
}


// = ORDERS ====================================================================

function SetOrders( Controller C )
{
	local int i;
	for(i=0; i<AICache.Length; i++)
	{
		LogAI("SetOrders" @ AICache[i] @ C);
		AICache[i].Leader = C;
		AICache[i].GotoState('Follow', 'KeepMoving');
	}
}



// = CACHE =====================================================================

function int RegisterAI( Eon_AI A )
{
	AICache[AICache.Length] = A;
	return AICache.Length - 1;
}

function UnRegisterAI( int i )
{
	AICache.Remove(i,1);
}

#include ../_inc/debug/Log.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	AITimer=1
}
