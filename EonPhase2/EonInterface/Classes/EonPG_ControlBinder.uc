/* =============================================================================
:: File Name	::	EonPG_ControlBinder.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPG_ControlBinder extends KeyBindMenu config(EonGUI);

var() config array<KeyBinding>	CfgBindings;

function LoadCommands()
{
	local int i;
	SaveConfig();

	Super.LoadCommands();

	// Update the MultiColumnList's sortdata array to reflect the indexes of our Bindings array
	for(i=0; i<Bindings.Length; i++)
		li_Binds.AddedItem();
}

function ClearBindings()
{
	Super.ClearBindings();
	Bindings = CfgBindings;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	 Headings(0)="Action"
	 PageCaption="Configure Keys"
}
