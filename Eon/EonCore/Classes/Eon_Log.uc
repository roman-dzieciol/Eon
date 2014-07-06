/* =============================================================================
:: File Name	::	Eon_Log.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_Log extends Object;

var() int TabSize;
var() int ColumnPos;

var() name NAME_NONE;
var() name LogName;


static final function vLog( coerce string S, coerce string V, optional bool bQuote, optional coerce name N )
{
	local int i, L;
	local string T;

	if( N == default.NAME_NONE )
		N = default.LogName;

	L = default.ColumnPos - Len(N) - Len(S);
	for(i=L-int(L%default.TabSize); i>0; i-=default.TabSize)
		T = T$Chr(9);

	if( bQuote )	Log(S$T$Chr(34)$V$Chr(34),N);
	else			Log(S$T$V,N);
}

static final function LogKSimParams( Actor.KSimParams K, String Comment )
{
	Log(Comment, 'KSimParams');
	Log("-------------------------------------------------------------------------------", 'KSimParams');
	vLog("GammaPerSec", FSTR(K.GammaPerSec), false, 'KSimParams');
	vLog("Epsilon", FSTR(K.Epsilon), false, 'KSimParams');
	vLog("PenetrationOffset", FSTR(K.PenetrationOffset), false, 'KSimParams');
	vLog("PenetrationScale", FSTR(K.PenetrationScale), false, 'KSimParams');
	vLog("ContactSoftness", FSTR(K.ContactSoftness), false, 'KSimParams');
	vLog("MaxPenetration", FSTR(K.MaxPenetration), false, 'KSimParams');
	vLog("MaxTimestep", FSTR(K.MaxTimestep), false, 'KSimParams');
	//vLog("MaxKarmaSpeed", FSTR(K.MaxKarmaSpeed), false, 'KSimParams');
	//vLog("MaxRagdollSpeed", FSTR(K.MaxRagdollSpeed), false, 'KSimParams');
	Log("-------------------------------------------------------------------------------", 'KSimParams');
}

#include ../Eon/_inc/func/String.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	TabSize=4
	ColumnPos=41
	LogName=Eon
}
