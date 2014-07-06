/* =============================================================================
:: File Name	::	Eon_PageVideoNew.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.50 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageVideoNew extends Eon_PageImportant;

var		int 		Count;
var		string		OrigRes;

var() Eon_Button		AcceptButton;
var() Eon_Button		RestoreButton;
var() GUILabel			QuestionLabel;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	AcceptButton	= Eon_Button(Controls[1]);
	RestoreButton	= Eon_Button(Controls[2]);
	QuestionLabel	= GUILabel(Controls[3]);
}

event Timer()
{
	Count--;
	RestoreButton.Caption = "Restore"@"("$Count$")";

	if( Count <= 0 )
	{
		SetTimer(0);

		// Reset resolution here
		PlayerOwner().ConsoleCommand("setres"@OrigRes);
		Controller.CloseMenu(false);
	}
}

function Execute(string DesiredRes)
{
	local string res,bit,x,y;
	local int i;

	if( DesiredRes == "" )
		return;

	res	= Controller.GetCurrentRes();
	bit = PlayerOwner().ConsoleCommand("get ini:Engine.Engine.RenderDevice Use16bit");

	if( bit == "true" )	OrigRes=res$"x16";
	else				OrigRes=res$"x32";

	if( bool(PlayerOwner().ConsoleCommand("ISFULLSCREEN")) )
			OrigRes=OrigRes$"f";
	else	OrigRes=OrigRes$"w";

	PlayerOwner().ConsoleCommand("set ini:Engine.Engine.RenderDevice Use16bit"@(InStr(DesiredRes,"x16") != -1));
	PlayerOwner().ConsoleCommand("setres"@DesiredRes);

	i = Instr(DesiredRes,"x");
	x = left(DesiredRes,i);
	y = mid(DesiredRes,i+1);

	if( (int(x)<640) || (int(y)<480) )
	{
		PlayerOwner().ConsoleCommand("tempsetres 640x480");
		SetTimer(0,false);
		Controller.ReplaceMenu("EonInterface.Eon_PageDeferChangeRes");
		Controller.GameResolution = Left(DesiredRes,Len(DesiredRes) - 4);
	}
	else
		Controller.GameResolution = "";
}

function StartTimer()
{
	Count = 15;
	SetTimer(1.0,true);
}

function bool InternalOnClick(GUIComponent Sender)
{
	SetTimer(0);

	if( Sender == RestoreButton )
		PlayerOwner().ConsoleCommand("setres"@OrigRes);

	Controller.CloseMenu(false);
	return true;
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=GUIImage name=oBGImage
		WinWidth=1.0
		WinHeight=1.0
		WinTop=0
		WinLeft=0
		Image=Material'EonTX_Menu.Buttons.btn-d-none-50'
		ImageColor=(R=255,G=255,B=255,A=255);
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Stretched
		bAcceptsInput=false
		bNeverFocus=true
		bBoundToParent=true
		bScaleToParent=true
	End Object

	Begin Object Class=Eon_Button Name=oAccept
		WinWidth=0.2
		WinTop=0.4675
		WinLeft=0.52
		Caption="Accept"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_Button Name=oRestore
		WinWidth=0.2
		WinTop=0.4675
		WinLeft=0.76
		Caption="Restore (15)"
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_Label Name=oLabel
		WinWidth=0.44
		WinTop=0.4675
		WinLeft=0.04
		Caption="Do you accept these settings?"
		TextAlign=TXTA_Center
	End Object


	Controls(0)=oBGImage
	Controls(1)=oAccept
	Controls(2)=oRestore
	Controls(3)=oLabel

	WinWidth=1.0
	WinHeight=0.1
	WinTop=0.45
	WinLeft=0.0


	bRequire640x480=false
	bAllowedAsLast=false
	bDisconnectOnOpen=false

	OnActivate=StartTimer
}
