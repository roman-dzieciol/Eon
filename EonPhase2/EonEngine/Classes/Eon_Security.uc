/* =============================================================================
:: File Name	::	Eon_Security.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_Security extends Security;

event ServerCallback(int SecType, string Data)	// Should be Subclassed
{
	Super.ServerCallback(SecType,Data);
}

auto state StartUp
{
	function Timer()
	{
		// Police the client by checking key packages for modifications

//		ClientPerform(0,"core","");							// Check the QuickMD5
//		ClientPerform(1,"engine.actor.setinitialstate","");	// Check a CodeMD5
//		ClientPerform(2,"core.u","");						// Do a full MD5
//		ClientPerform(3,"","");								// Get Package List
	}

Begin:
	SetTimer(FRand()+1,false);
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

}
