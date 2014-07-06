/* =============================================================================
:: File Name	::	Eon_CheatManager.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_CheatManager extends CheatManager;

exec function FC( optional bool B )			{	FreeCamera(B);	}
exec function LC()							{	LockCamera();	}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

}
