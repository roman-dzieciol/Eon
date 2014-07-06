/* =============================================================================
:: File Name	::	Eon_TabGameAvatar.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabGameAvatar extends Eon_TabGameBase;

var Eon_MenuAvatar			Avatar;
var class<Eon_MenuAvatar>	AvatarClass;
var class<Eon_Pawn>			AvatarPawnClass;
var bool					bRenderAvatar;

var() Material				TXPanel;

var() string				Contents, CNeutral;

var() EonPC_Base			Player;
var() Eon_PRI				PRI;
var() byte					Team, OldTeam;

var() array< class<Eon_Pawn> >	Classes;

var() Eon_ScrollTextBox		TextBox;
var() Eon_Label				ClassLabel;
var() Eon_ListBox			ClassList;
var() Eon_Button			MoveUp;
var() Eon_Button			MoveDown;


var bool bInitialized;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float X,Y,W,H,LY;

	TextBox		= Eon_ScrollTextBox(Controls[0]);
	ClassLabel	= Eon_Label(Controls[1]);
	ClassList	= Eon_ListBox(Controls[2]);

	X = 0.0;
	Y = 0.0;
	W = 0.425;
	H = ClassLabel.default.WinHeight;
	LY = Y;

	ClassLabel.WinWidth		= W;
	ClassLabel.WinHeight	= H;
	ClassLabel.WinLeft		= X;
	ClassLabel.WinTop		= LY;	LY += H;

	H = 0.25;

	ClassList.WinWidth		= W;
	ClassList.WinHeight		= H;
	ClassList.WinLeft		= X;
	ClassList.WinTop		= LY;	LY += H + 0.065;

/*	H = MoveUp.default.WinHeight;

	MoveUp.WinWidth			= W/2;
	MoveUp.WinHeight		= H;
	MoveUp.WinLeft			= X;
	MoveUp.WinTop			= LY;

	MoveDown.WinWidth		= W/2;
	MoveDown.WinHeight		= H;
	MoveDown.WinLeft		= X+W/2;
	MoveDown.WinTop			= LY;	LY += H;*/

	H = 1 - LY;

	TextBox.WinWidth		= W;
	TextBox.WinHeight		= H;
	TextBox.WinLeft			= X;
	TextBox.WinTop			= LY;	LY += H;

	Super.InitComponent(MyController, MyOwner);

	// Get references
	Player	= EonPC_Base(PlayerOwner());
	PRI		= Eon_PRI(Player.PlayerReplicationInfo);
	Team	= PRI.GetTeamIndex();

	log(Player);
	log(PRI);
	log(Team);

	Avatar = PlayerOwner().Spawn( AvatarClass );
	bRenderAvatar = false;

	TextBox.SetContent(Contents);
	SetupFor(Team);

	bInitialized = true;
}

function bool IDraw(Canvas C)
{
	local vector CamPos;
	local rotator CamRot;

	// Avatar Background
	C.SetDrawColor(120,105,85,255);
	C.SetPos( C.ClipX*WinWidth*0.45 + C.ClipX*WinLeft, 0 + C.ClipY*WinTop);
	C.DrawTileStretched(TXPanel, C.ClipX*0.55*WinWidth, C.ClipY*WinHeight);

	// Avatar Model
	if( bRenderAvatar )
	{
		C.SetDrawColor(255,255,255,255);
		C.GetCameraLocation(CamPos, CamRot);
		Avatar.SetAvatarLocation(CamPos, CamRot);
		C.DrawActor(Avatar, false, true, Avatar.FOV);
	}

	return false;
}

function NotifyOnClose()
{
	bInitialized = false;
	AvatarClass	= None;
	if( Avatar != None)
	{
		Avatar.Destroy();
		Avatar = None;
	}

	Player		= None;

	Classes.Remove(0,Classes.Length);
}


function bool IPreDraw(Canvas C)
{

	return false;
}



function SetupFor( int NewTeam )
{
	local int		i;

	bInitialized = false;
	LogMenu("SetupFor" @ NewTeam @ Classes.Length);

	// Get references
	Classes	= Player.PlayerClassesGet();

	// Player Combo fill
	ClassList.List.Clear();
	if( Classes.Length == 0 )		ClassList.List.Add( "Ghost" );
	for(i=0; i<Classes.Length; i++)	ClassList.List.Add( Classes[i].default.MenuName );

	bInitialized = true;

	if( Player.PlayerClass > Classes.Length )
		Player.PlayerClass = 0;

	ClassList.List.SetIndex( Player.PlayerClass );
}

/*
function SetupFor( int NewTeam )
{
	local int		i;
	local string	S;

	bInitialized = false;

	// Get references
	Classes	= PRI.GetPlayerClassesFor( NewTeam );

	LogMenu("SetupFor" @ NewTeam @ PRI.PlayerClassIndex @ Classes.Length);

	// Team Combo set
	TeamCombo.SetIndex( NewTeam );

	// Player Combo fill
	PlayerCombo.Clear();
	for(i=0; i<Classes.Length; i++)
	{
		if( Classes[i] != None )	S = Classes[i].default.MenuName;
		else						S = "Ghost";
		PlayerCombo.AddItem( S );
	}

	bInitialized = true;

	// Player Combo set
	PlayerCombo.SetIndex( 0 );
}*/


function IChange(GUIComponent Sender)
{
	if( !bInitialized )
		return;

	switch( Sender )
	{
		case ClassList:
			LogMenu("IChange ClassList");
			Player.PlayerClassSet( ClassList.List.Index );
			Player.PlayerClassSetServer( ClassList.List.Index );
			if( Classes.Length != 0 )
			{
				bRenderAvatar = Classes[ ClassList.List.Index ] != None;
				if( bRenderAvatar )
					Avatar.SetPawnClass( Classes[ ClassList.List.Index ] );
			}
		break;
	}

	return;
}

function bool IClick(GUIComponent Sender)
{
	if( !bInitialized )
		return false;

	switch( Sender )
	{
/*		case MoveUp:	i = ClassList.List.Index;
						if( Swap(i, i-1, Classes) )
						{
							log("MoveUp");
							//Player.ServerSetPlayerClassPriority( Classes[i], i-1 );
							Player.SetPlayerClassPriority( Classes[i], i+1 );
							ClassList.MoveUp();
						}
						return true;

		case MoveDown:	i = ClassList.List.Index;
						if( Swap(i, i+1, Classes) )
						{
							log("MoveDown");
							//Player.ServerSetPlayerClassPriority( Classes[i], i+1 );
							Player.SetPlayerClassPriority( Classes[i], i-1 );
							ClassList.MoveDown();
						}
						return true;*/
	}
	return false;
}

function bool Swap( int A, int B, out array<class> ClassArray )
{
	local class temp;

	if( A < 0 || A >= ClassArray.Length
	||	B < 0 || B >= ClassArray.Length )
		return false;

	temp = ClassArray[A];
	ClassArray[A] = ClassArray[B];
	ClassArray[B] = temp;
	return true;
}

/*

		case Play:		PRI.SetPlayerClass( PlayerCombo.GetIndex() );
						PRI.ServerChangeTeam( TeamCombo.GetIndex() );	break;
*/

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=Eon_ScrollTextBox Name=oTextBox
		bVisibleWhenEmpty=true
		bNoTeletype=true
	End Object

	Begin Object class=Eon_Label Name=oClassLabel
		Caption="Preferred  Player  Class:"
		TextAlign=TXTA_Center
	End Object

	Begin Object class=Eon_ListBox Name=oClassList
		OnChange=IChange
	End Object

	Begin Object class=Eon_Button Name=oMoveUp
		Caption="Move Up"
		OnClick=IClick
	End Object

	Begin Object class=Eon_Button Name=oMoveDown
		Caption="Move Down"
		OnClick=IClick
	End Object

	Controls(0)=oTextBox
	Controls(1)=oClassLabel
	Controls(2)=oClassList


	AvatarClass=class'EonInterface.Eon_MenuAvatar'
	AvatarPawnClass=class'EonEngine.EonPW_BeastOfficer'
	TXPanel=Material'EonTX_Menu.Buttons.btn-d-none-75'

	OnPreDraw=IPreDraw
	OnDraw=IDraw


	Contents="Eliminate all enemies."
	CNeutral="You are currently in spectator mode.||To select a player class click the [MAP] button above and join one of the teams."
}
