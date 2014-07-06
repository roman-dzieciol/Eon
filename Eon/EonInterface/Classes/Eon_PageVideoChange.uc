/* =============================================================================
:: File Name	::	Eon_PageVideoChange.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_PageVideoChange extends Eon_PageImportant;

var		int 		Count;
var		string		OrigRes;

var string	RestoreTextPre, RestoreTextPost, RestoreTextSingular;

var() Eon_Button		AcceptButton;
var() Eon_Button		BackButton;
var() GUILabel			QuestionLabel;
var() GUILabel			TimerLabel;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	AcceptButton	= Eon_Button(Controls[1]);
	BackButton		= Eon_Button(Controls[2]);
	QuestionLabel	= GUILabel(Controls[3]);
	TimerLabel		= GUILabel(Controls[4]);
}

event Timer()
{
	Count--;
	if( Count > 1 )	TimerLabel.Caption = RestoreTextPre$Count$RestoreTextPost;
	else			TimerLabel.Caption = RestoreTextSingular;

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
	Count=15;
	SetTimer(1.0,true);
}

function bool InternalOnClick(GUIComponent Sender)
{
	SetTimer(0);

	if( Sender == BackButton)
		PlayerOwner().ConsoleCommand("setres"@OrigRes);

	QuestionLabel.Caption="Do you accept these settings?";
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

	Begin Object Class=Eon_Button Name=oAcceptButton
		Caption="Keep Settings"
		WinWidth=0.2
		WinHeight=0.065000
		WinLeft=0.125
		WinTop=0.65
		bBoundToParent=true
		OnClick=InternalOnClick
	End Object

	Begin Object Class=Eon_Button Name=oBackButton
		Caption="Restore Settings"
		WinWidth=0.2
		WinHeight=0.065000
		WinLeft=0.65
		WinTop=0.65
		bBoundToParent=true
		OnClick=InternalOnClick
	End Object

	Begin Object class=GUILabel Name=oQuestionLabel
		Caption="Do you accept these settings?"
		TextALign=TXTA_Center
		WinWidth=1
		WinLeft=0
		WinTop=0.4
		WinHeight=0.065000
		StyleName="EonLabelQuestion"
	End Object

	Begin Object class=GUILabel Name=oTimerLabel
		Caption="(Original settings will be restored in 15 seconds)"
		TextALign=TXTA_Center
		WinWidth=1
		WinLeft=0
		WinTop=0.46
		WinHeight=0.065000
		StyleName="EonLabelQuestion"
	End Object

	Controls(0)=oBGImage
	Controls(1)=oAcceptButton
	Controls(2)=oBackButton
	Controls(3)=oQuestionLabel
	Controls(4)=oTimerLabel

	WinLeft=0.0175781
	WinWidth=0.96484375
	WinTop=0.375
	WinHeight=0.25
	OnActivate=StartTimer

	RestoreTextPre="(Original settings will be restored in "
	RestoreTextPost=" seconds)"
	RestoreTextSingular="(Original settings will be restored in 1 second)"
}
