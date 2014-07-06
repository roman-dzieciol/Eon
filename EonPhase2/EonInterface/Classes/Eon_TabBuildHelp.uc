/* =============================================================================
:: File Name	::	Eon_TabBuildHelp.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabBuildHelp extends Eon_TabBuildBase;

var() Eon_ScrollTextBox		TextBox;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float X,Y,W,H,LY;

	TextBox		= Eon_ScrollTextBox(Controls[0]);

	X = 0.0;
	Y = 0.0;
	W = 1.0;
	H = 1.0;
	LY = Y;

	TextBox.WinWidth	= W;
	TextBox.WinHeight	= H;
	TextBox.WinLeft		= X;
	TextBox.WinTop		= LY;	LY += H;

	Super.InitComponent(MyController, MyOwner);
}

function LoadHelp( string HelpName )
{
	local string S;
	S = Localize(HelpName, "Help", "EonBuildings");
	TextBox.SetContent( S );
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=Eon_ScrollTextBox Name=oTextBox
		bVisibleWhenEmpty=true
		bNoTeletype=true
	End Object

	Controls(0)=oTextBox
}
