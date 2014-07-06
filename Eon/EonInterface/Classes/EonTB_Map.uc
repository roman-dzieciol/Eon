/* =============================================================================
:: File Name	::	EonTB_Map.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonTB_Map extends EonTB_MidBase;


var() Texture			TXMap;
var() TexRotator		TXArrow;
var() Material			TXSelection[3];
var() MaterialSwitch	TXArrowSwitch;

var() float		MenuX, MenuY, MenuW, MenuH, MenuSX, MenuSY, MapRange;
var() float		IconScale, IconOffset, IconOffset64;

var() automated Eon_Button			MapInput;
var() automated Eon_Button			JoinHuman;
var() automated Eon_Button			JoinBeast;
var() automated Eon_Button			Spectate;
var() automated Eon_Label			Position;
var() automated Eon_Label			Supplies;

var() EonPC_Base		Player;
var() Eon_Pawn			Pawn;
var() Eon_HUD			HUD;
var() Eon_PRI			PRI;
var() rotator CamRot;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float	X,Y,W,H,M;
	local int	T;

	X = 0.01;
	Y = 0.01;
	W = 0.66;
	H = 0.88;
	SetupComponent( MapInput, W,H,X,Y,M,T );

	X = 0.68;
	Y = 0.01;
	W = 0.31;
	H = 0.06;
	SetupComponent( JoinHuman, W,H,X,Y,M,T );
	SetupComponent( JoinBeast, W,H,X,Y,M,T );
	SetupComponent( Spectate, W,H,X,Y,M,T );
	SetupComponent( Position, W,H,X,Y,M,T );
	SetupComponent( Supplies, W,H,X,Y,M,T );
	Super.InitComponent(MyController, MyOwner);



//	MapInput.bBoundToParent = false;
//	MapInput.bScaleToParent = false;


	TXMap	 = class'EonEngine.EonIN_Map'.default.TXMap;
	MapRange = class'EonEngine.EonIN_Map'.default.MapRange;

	Player	= EonPC_Base(PlayerOwner());
	Pawn	= Eon_Pawn(Player.Pawn);
	HUD		= Eon_HUD(Player.myHud);
	PRI		= Eon_PRI(Player.PlayerReplicationInfo);

	TXArrowSwitch = MaterialSwitch(TXArrow.Material);

 	if( Player.StartPosition != None )
		SelectPosition( Player.StartPosition );

	SetTimer(1, true);
}

event Timer()
{
	if( Player.StartPosition != None )
		UpdatePosition( Player.StartPosition );
}

function bool IPreDraw(Canvas C)
{
	Player	= EonPC_Base(PlayerOwner());
	Pawn	= Eon_Pawn(Player.Pawn);
	HUD		= Eon_HUD(Player.myHud);
	PRI		= Eon_PRI(Player.PlayerReplicationInfo);
	return false;
}

function bool IDraw(Canvas C)
{
	local vector PlayerLocation;
	local float X,Y;
	local int i, Team;

	HUD.HudScale=1.0;

	C.ColorModulate = C.Default.ColorModulate;
	C.SetDrawColor(255,255,255,255);

	MenuX = MapInput.Bounds[0];
	MenuY = MapInput.Bounds[1];
	MenuW = MapInput.Bounds[2]*WinWidth;
	MenuH = MapInput.Bounds[3]*WinHeight;

	MenuSX	= (MapInput.Bounds[2]-MenuX) / TXMap.USize;
	MenuSY	= (MapInput.Bounds[3]-MenuY) / TXMap.VSize;

	IconScale = C.ClipX / 1600;
	IconOffset = 16 * IconScale;
	IconOffset64 = IconOffset - 32 * IconScale;


	// 2D Map
	C.SetPos(MenuX, MenuY);
//	C.DrawTile(TXMap, MenuW, MenuH, 0, 0, TXMap.USize, TXMap.VSize);
	C.DrawTileScaled(TXMap, MenuSX, MenuSY);


	// Player Arrow
	C.GetCameraLocation(PlayerLocation,CamRot);
	if( PRI.Team != None )	Team = PRI.Team.TeamIndex;
	else					Team = TEAM_Neutral;

	TXArrowSwitch.Material	= TXArrowSwitch.Materials[Team];
	TXArrow.Rotation.Yaw	= -Player.Rotation.Yaw  - 16384;

	X = (MapRange+PlayerLocation.X) / (MapRange*2);
	Y = (MapRange+PlayerLocation.Y) / (MapRange*2);
	X = MenuX + MenuW*X - IconOffset;
	Y = MenuY + MenuH*Y - IconOffset;

	C.SetPos(X+IconOffset64, Y+IconOffset64);
	C.DrawTileScaled( TXArrow, IconScale, IconScale );

	// Positions
	for(i=0; i<HUD.KeyPositions.Length; i++)
	{
		X =  (MapRange+HUD.KeyPositions[i].Location.X) / (MapRange*2);
		Y =  (MapRange+HUD.KeyPositions[i].Location.Y) / (MapRange*2);
		X = MenuX + MenuW*X - IconOffset;
		Y = MenuY + MenuH*Y - IconOffset;

		if( HUD.KeyPositions[i] == Player.StartPosition )
		{
			C.Style = 3;
			C.SetPos(X+IconOffset64, Y+IconOffset64);
			C.DrawTileScaled(TXSelection[Player.StartPosition.Ownership], IconScale, IconScale);
			C.Style = 1;
			C.SetPos(X, Y);
			C.DrawTileScaled(HUD.KeyPositions[i].Texture, IconScale, IconScale);
		}
		else
		{
			C.SetPos(X, Y);
			C.DrawTileScaled(HUD.KeyPositions[i].Texture, IconScale, IconScale);
		}
	}

	// Menu
	if( Player.StartPosition != None )
	{
		X = Position.Bounds[0];
		Y = Position.Bounds[1] + (Position.Bounds[3]-Position.Bounds[1])*0.5 - IconOffset;
		C.SetPos(X, Y);
		C.DrawTileScaled( Player.StartPosition.Texture, IconScale, IconScale );
	}

//	C.Z = 0;
	return false;

}

function bool SpawnClick(GUIComponent Sender)
{
	local EonKP_KeyPosition	KPTarget, KPBase;
	local vector			V, T;
/*	local float x,y,w,h,px,py,mx,my;

	mx = Controller.MouseX;
	my = Controller.MouseY;


	x = MapInput.Bounds[0]*WinWidth;
	y = MapInput.Bounds[1]*WinHeight;
	w = MapInput.Bounds[2]*WinWidth;
	h = MapInput.Bounds[3]*WinHeight;

	px = mx / (x+w);
	py = my / (y+h);

	log( px @ py );

	return false;*/

	//200 350 500

	if( Pawn != None )		V = Pawn.Location;
	else					V = Player.Location;

	T = MapToWorld(Controller.MouseX, Controller.MouseY);
	KPTarget = HUD.LocatePosition(T);
	KPBase = HUD.LocatePosition(V);


	// if not selected and valid ownership, select this position
	if( KPTarget != None && KPTarget != Player.StartPosition
	&&( PRI.Team == None || PRI.Team.TeamIndex == KPTarget.Ownership ))
	{
		SelectPosition( KPTarget );
		return false;
	}

	// if selected and spectator, teleport
	if( KPTarget != None && KPTarget == Player.StartPosition && PRI.Team == None )
	{
		PRI.ServerTeleportTo(KPTarget);
	}

	return false;
}

function vector MapToWorld( float MouseX, float MouseY )
{
	local vector Result;

	Result.X = (((MouseX-MenuX) / MenuW)*MapRange*2)-MapRange;
	Result.Y = (((MouseY-MenuY) / MenuH)*MapRange*2)-MapRange;
	Result.Z = 0;

	//log( MouseX @ Result.X @ MouseY @ Result.Y,'MapToWorld');
	return Result;
}

function SelectPosition( EonKP_Keyposition KP )
{
	if( Player.StartPosition != KP )
		Player.StartPosition = KP;

//	SpawnMode.List.Clear();
//	KP.SpawnModesList(SpawnMode.List);

	Position.Caption = KP.PositionName;
	UpdatePosition( KP );
}

function UpdatePosition( EonKP_KeyPosition KP )
{
	if( EonKP_PositionPrimary(KP) != None )
			Supplies.Caption = "Supplies: Infinite";
	else	Supplies.Caption = "Supplies: " @ KP.Supplies;
}

function NotifyOnClose()
{
	Player	= None;
	Pawn	= None;
	HUD		= None;
	PRI		= None;
}

function bool IClick(GUIComponent Sender)
{
	switch( Sender )
	{
	case JoinHuman:		Player.ChangeTeam(TEAM_Human);		Controller.CloseMenu();	break;
	case JoinBeast:		Player.ChangeTeam(TEAM_Beast);		Controller.CloseMenu();	break;
	case Spectate:		Player.ChangeTeam(TEAM_Neutral);	Controller.CloseMenu();	break;
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

#include ../Eon/_inc/func/MakeType.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=Eon_Button Name=oMapInput
		StyleName=""
		OnClick=SpawnClick
	End Object

	Begin Object Class=Eon_Label Name=oPosition
		TextAlign=TXTA_Center
		Hint="Name"
	End Object

	Begin Object Class=Eon_Label Name=oSupplies
		TextAlign=TXTA_Left
		Hint="Supplies"
	End Object

	Begin Object Class=Eon_Button Name=oJoinHuman
		Caption="Join Human"
		OnClick=IClick
	End Object

	Begin Object Class=Eon_Button Name=oJoinBeast
		Caption="Join Beast"
		OnClick=IClick
	End Object

	Begin Object Class=Eon_Button Name=oSpectate
		Caption="Spectate"
		OnClick=IClick
	End Object

	MapInput	= oMapInput
	Position	= oPosition
	Supplies	= oSupplies
	JoinHuman	= oJoinHuman
	JoinBeast	= oJoinBeast
	Spectate	= oSpectate

	MapRange=32768

	TXSelection(0)=Material'EonTX_GUI.Map.SelectHuman'
	TXSelection(1)=Material'EonTX_GUI.Map.SelectBeast'
	TXSelection(2)=Material'EonTX_GUI.Map.SelectNeutral'
	TXArrow=TexRotator'EonTS_GUI.Map.Arrow'
	TXMap=Texture'Engine.DefaultTexture'


	OnDraw=IDraw
	OnPreDraw=IPreDraw

}
