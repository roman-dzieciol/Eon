/* =============================================================================
:: File Name	::	Eon_TabBuildBase.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabBuildBase extends Eon_TabBase;

//var() EonPC_Base			Player;
var() EonKB_KeyBuilding		Building;
var() Eon_ScrollTextBox		StatusBox;
var() string				StatusText;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
//	Player	= EonPC_Base(PlayerOwner());

	Super.InitComponent(MyController, MyOwner);
}

function NotifyOnClose()
{
//	Player		= None;
	Building	= None;
}

function SetBuilding( EonKB_KeyBuilding B )
{
	Building = B;
}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=Eon_ScrollTextBox Name=oStatusBox
		bVisibleWhenEmpty=true
		bNoTeletype=true
		StyleName="EonTextBoxStatus"
	End Object
	Controls(0)=oStatusBox

	WinWidth=0.46
	WinHeight=0.32
	WinTop=0.085
	WinLeft=0.52

}
