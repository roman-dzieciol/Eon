/* =============================================================================
:: File Name	::	Eon_PageCommand.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageCommand extends Eon_PageBase;

var() GUIImage				Test;

var() EonPC_Base			Player;
var() Eon_Pawn				Pawn;
var() Eon_HUD				HUD;
var() Eon_PRI				PRI;
var() EonIN_Cmd				EonCmd;

var() int	FirstKey;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float X,Y,W,H,LY;

	Test	= GUIImage(Controls[0]);

	X = 0.0;
	Y = 0.0;
	W = 0.1;
	H = 0.1;
	LY = Y;

	Test.WinWidth		= W;
	Test.WinHeight		= H;
	Test.WinLeft		= X;
	Test.WinTop			= LY;	LY += H;

	Super.InitComponent(MyController, MyOwner);
}

function IOnClose(optional Bool bCanceled)
{
	Player		= None;
	Pawn		= None;
	HUD			= None;
	PRI			= None;

	EonCmd.bVisible		= false;
	EonCmd.OnPostRender = None;
	EonCmd				= None;

	OnPreDraw	= IPreDrawInit;
	FirstKey	= default.FirstKey;

	LogMenu("close");

	Super.OnClose(bCanceled);
}

function bool IKeyEvent(out byte Key, out byte State, float delta)
{
	if		( FirstKey == default.FirstKey )	FirstKey = Key;
	else if	( FirstKey == Key )					Player.ClientCloseMenu(true);
	return true;
}


function bool IPreDrawInit(Canvas C)
{
	Player	= EonPC_Base(PlayerOwner());
	Pawn	= Eon_Pawn(Player.Pawn);
	HUD		= Eon_HUD(Player.myHud);
	PRI		= Eon_PRI(Player.PlayerReplicationInfo);

	if( Player.EonCmd != None )
	{
		EonCmd = Player.EonCmd;
		EonCmd.bVisible = true;
		EonCmd.OnPostRender = IPostRender;
		OnPreDraw = IPreDraw;
	}

	return false;
}

function bool IPreDraw(Canvas C)
{
	Player	= EonPC_Base(PlayerOwner());
	Pawn	= Eon_Pawn(Player.Pawn);
	HUD		= Eon_HUD(Player.myHud);
	PRI		= Eon_PRI(Player.PlayerReplicationInfo);

	return false;
}

function IPostRender(Canvas C)
{
//	log(Test.WinLeft@Test.WinTop);
	Test.WinLeft		= Controller.MouseX;
	Test.WinTop			= Controller.MouseY;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object class=GUIImage Name=oTest
		Image=Material'EonTS_GUI.Background.Dark'
		ImageColor=(R=255,G=255,B=255,A=255);
		ImageRenderStyle=MSTY_Modulated
		ImageStyle=ISTY_Stretched
	End Object

	Controls(0)=oTest

	OnClose=IOnClose
	OnPreDraw=IPreDrawInit
	OnKeyEvent=IKeyEvent

	bRequire640x480=false
	bAllowedAsLast=true
	bDisconnectOnOpen=false
	bPersistent=true

	FirstKey=-1
}
