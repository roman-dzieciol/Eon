/* =============================================================================
:: File Name	::	Eon_TabBuildCorral.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabBuildCorral extends Eon_TabBuildBase;


var() EonKB_Corral			TheBuilding;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float X,Y,W,H,LY;

	StatusBox	= Eon_ScrollTextBox(Controls[0]);

	X = 0.0;
	Y = 0.0;
	W = 1.0;
	H = 1.0;
	LY = Y;

	StatusBox.WinWidth		= W;
	StatusBox.WinHeight		= H;
	StatusBox.WinLeft		= X;
	StatusBox.WinTop		= LY;	LY += H;

	Super.InitComponent(MyController, MyOwner);
}

function bool IPreDraw(Canvas C)
{
	StatusText = TheBuilding.BuildingName @ "Status:";
	StatusText = StatusText $ "||*MOO!*";

	StatusBox.SetContent(StatusText);
	return false;
}

function NotifyOnClose()
{
	Super.NotifyOnClose();
	TheBuilding = None;
}

function SetBuilding( EonKB_KeyBuilding B )
{
	Super.SetBuilding(B);
	TheBuilding = EonKB_Corral(B);
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

	OnPreDraw=IPreDraw

}
