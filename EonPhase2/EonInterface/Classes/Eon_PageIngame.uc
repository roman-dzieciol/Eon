/* =============================================================================
:: File Name	::	Eon_PageIngame.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageIngame extends Eon_PageBase;

var bool			bIgnoreEsc;

function LevelChanged()
{
	Super.LevelChanged();
	Controller.CloseMenu(true);
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
	if( bIgnoreEsc && Key == 0x1B )
	{
		bIgnoreEsc = false;
		return true;
	}
}

function InternalOnClose(optional Bool bCanceled)
{
	if( PlayerOwner() != None && PlayerOwner().Level.Pauser != None )
		PlayerOwner().SetPause(false);

	Super.OnClose(bCanceled);
}

function InternalOnDeActivate()
{
	bVisible = false;
}

function InternalOnActivate()
{
	bVisible = true;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{


	OnClose=InternalOnClose
	OnDeActivate=InternalOnDeActivate
	OnActivate=InternalOnActivate
	OnKeyEvent=InternalOnKeyEvent

	bIgnoreEsc=true
	bRequire640x480=false
	bAllowedAsLast=true
	bDisconnectOnOpen=false
}
