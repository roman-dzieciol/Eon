/* =============================================================================
:: File Name	::	Eon_TabBuildBarracks.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabBuildBarracks extends Eon_TabBuildBase;

var() EonKB_Barracks		TheBuilding;

var() Eon_ComboBox			ClassCombo;
var() Eon_Button			Spawn;

var() EonPC_Base			Player;
var() Eon_Pawn				Pawn;
var() Eon_HUD				HUD;
var() Eon_PRI				PRI;
var() byte					Team;

var() array< class<Eon_Pawn> >	Classes;



function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float X,Y,W,H,LY;

	StatusBox	= Eon_ScrollTextBox(Controls[0]);
	ClassCombo	= Eon_ComboBox(Controls[1]);
	Spawn		= Eon_Button(Controls[2]);

	X = 0.0;
	Y = 0.0;
	W = 1.0;
	H = 0.06 / WinHeight;
	LY = Y;

	Spawn.WinWidth			= W/2;
	Spawn.WinHeight			= H;
	Spawn.WinLeft			= X;
	Spawn.WinTop			= LY;

	ClassCombo.WinWidth		= W/2;
	ClassCombo.WinHeight	= H;
	ClassCombo.WinLeft		= X+W/2;
	ClassCombo.WinTop		= LY;	LY += H;

	StatusBox.WinWidth		= W;
	StatusBox.WinHeight		= 1 - LY;
	StatusBox.WinLeft		= X;
	StatusBox.WinTop		= LY;	LY += H;

	Super.InitComponent(MyController, MyOwner);

	// Get references
	Player	= EonPC_Base(PlayerOwner());
	Pawn	= Eon_Pawn(Player.Pawn);
	HUD		= Eon_HUD(Player.myHud);
	PRI		= Eon_PRI(Player.PlayerReplicationInfo);
	Team	= PRI.GetTeamIndex();

	if( !Pawn.bCommander )
	{
		Spawn.MenuStateChange( MSAT_Disabled );
		ClassCombo.MenuStateChange( MSAT_Disabled );
	}
}

function bool IPreDraw(Canvas C)
{
	// Get references
	Player	= EonPC_Base(PlayerOwner());
	Pawn	= Eon_Pawn(Player.Pawn);
	HUD		= Eon_HUD(Player.myHud);
	PRI		= Eon_PRI(Player.PlayerReplicationInfo);
	Team	= PRI.GetTeamIndex();

	StatusText = TheBuilding.BuildingName @ "Status:";

	StatusBox.SetContent(StatusText);
	return false;
}


function NotifyOnClose()
{
	Super.NotifyOnClose();
	TheBuilding = None;

	Player		= None;
	Pawn		= None;
	HUD			= None;
	PRI			= None;

	Classes.Remove(0,Classes.Length);
}

function SetBuilding( EonKB_KeyBuilding B )
{
	Super.SetBuilding(B);
	TheBuilding = EonKB_Barracks(B);
}


function bool IClick(GUIComponent Sender)
{
	switch( Sender )
	{
		//case Spawn:		TheBuilding.AddAI( Player, ClassCombo.GetIndex() );	break;
	}
	return false;
}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object class=Eon_ComboBox Name=oClassCombo
		bReadOnly=true
	End Object

	Begin Object Class=Eon_Button Name=oSpawm
		Caption="Spawn AI Player:"
		OnClick=IClick
	End Object

	Controls(1)=oClassCombo
	Controls(2)=oSpawm

	OnPreDraw=IPreDraw

}
