/* =============================================================================
:: File Name	::	Eon_PageBuilding.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageBuilding extends Eon_PageBase;


var() GUIImage			BG;
var() Eon_TabControl	TabControl;
var() Eon_Button		Exit;

var() Eon_TabBuildBase	TabBuild;
var() Eon_TabBuildHelp	TabHelp;

var() string	TabHelpName;

var() EonPC_Base			Player;
var() EonIN_Use				EonUse;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float X,Y,W,H,LY;

	BG			= GUIImage(Controls[0]);
	TabControl	= Eon_TabControl(Controls[1]);
	Exit		= Eon_Button(Controls[2]);


	X = WinLeft;
	Y = WinTop;
	W = WinWidth;
	H = WinHeight;
	LY = Y;

	BG.WinWidth		= W;
	BG.WinHeight	= H;
	BG.WinLeft		= X;
	BG.WinTop		= LY;

	X = WinLeft		+ 0.01;
	Y = WinTop		+ 0.01;
	W = WinWidth	- 0.02;
	H = WinHeight	- 0.095;
	LY = Y;

	TabControl.WinWidth		= W;
	TabControl.WinHeight	= TabControl.TabHeight;
	TabControl.WinLeft		= X;
	TabControl.WinTop		= LY;	LY += H + 0.01;

	Exit.WinWidth		= W;
	Exit.WinLeft		= X;
	Exit.WinTop			= LY;

	Super.InitComponent(MyController, MyOwner);
}

event HandleParameters(string Param1, string Param2)
{
	TabBuild = Eon_TabBuildBase(TabControl.AddTab(Param2,	Param1,,		Param2,	true));
	TabHelp	 = Eon_TabBuildHelp(TabControl.AddTab("Help",	TabHelpName,,	"Help",	false));

	TabHelp.LoadHelp( Param2 );
}

function bool IKeyEvent(out byte Key, out byte State, float delta)
{
	return false;
}

function IClose(optional Bool bCanceled)
{
	if( PlayerOwner() != None && PlayerOwner().Level.Pauser != None )
		PlayerOwner().SetPause(false);

	Player		= None;

	EonUse.bVisible		= true;
//	EonUse.OnPostRender = None;
	EonUse				= None;

	TabControl.NotifyOnClose();
	Super.OnClose(bCanceled);
}

function bool IPreDraw(Canvas C)
{
	Player	= EonPC_Base(PlayerOwner());

	if( Player.EonUse != None && TabBuild != None )
	{
		EonUse = Player.EonUse;
		EonUse.bVisible = false;
		TabBuild.SetBuilding( EonKB_KeyBuilding( EonUse.Selected ) );
		OnPreDraw = IWatchDist;
	}

	return false;
}


function bool IWatchDist(Canvas C)
{
	local vector	V;
	local rotator	R;

	C.GetCameraLocation(V,R);
	if( VSize(EonUse.Selected.Location - V) > EonUse.DistMax*4 )
		Controller.CloseMenu();

	return false;
}

function IDeActivate()
{
	bVisible = false;
}

function IActivate()
{
	bVisible = true;
}

function LevelChanged()
{
	Super.LevelChanged();
	Controller.CloseMenu(true);
}

function bool IClick(GUIComponent Sender)
{
	switch( Sender )
	{
		case Exit:	Controller.CloseMenu(true);		break;
	}
	return true;
}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object class=GUIImage Name=oBG
		Image=Material'EonTS_GUI.Background.Dark'
		ImageColor=(R=255,G=255,B=255,A=255);
		ImageRenderStyle=MSTY_Modulated
		ImageStyle=ISTY_Stretched
	End Object

	Begin Object Class=Eon_TabControl Name=oTabControl
		TabHeight=0.065
		bAcceptsInput=true
		bDockPanels=false
	End Object

	Begin Object Class=Eon_Button Name=oExit
		Caption="Exit"
		OnClick=IClick
	End Object

	Controls(0)=oBG
	Controls(1)=oTabControl
	Controls(2)=oExit

	OnClose=IClose
	OnDeActivate=IDeActivate
	OnActivate=IActivate
	OnKeyEvent=IKeyEvent
	OnPreDraw=IPreDraw

	WinWidth=0.48
	WinHeight=0.48
	WinTop=0.01
	WinLeft=0.51

	bRequire640x480=false
	bAllowedAsLast=true
	bDisconnectOnOpen=false
	bPersistent=false


	TabHelpName="EonInterface.Eon_TabBuildHelp"
}
