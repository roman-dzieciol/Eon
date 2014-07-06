/* =============================================================================
:: File Name	::	Eon_Interaction.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_Interaction extends Interaction;

#include ../Eon/_inc/const/Teams.uc
#include ../Eon/_inc/const/RenderStyle.uc

var() Material		TBackground;
var() EonPC_Base	PlayerOwner;
var() Eon_PRI		PRI;


event Initialized()
{
	//LogIN("Initializing");
	PlayerOwner = EonPC_Base(ViewportOwner.Actor);
	PRI			= Eon_PRI(PlayerOwner.PlayerReplicationInfo);
}

function CleanUp()
{
	PlayerOwner	= None;
	PRI			= None;
}

event NotifyLevelChange()
{
	Master.RemoveInteraction(self);
	CleanUp();
}

// = INC =======================================================================

#include ../Eon/_inc/debug/Log.uc
#include ../Eon/_inc/func/String.uc

function LogIN		( coerce string S ){ Log(S@"["$Name$"]", 'IN');}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bVisible=false
	bActive=true
	TBackground=Material'EonTS_GUI.Background.Dark'
}
