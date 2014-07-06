/* =============================================================================
:: File Name	::	Eon_TabVideo.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabVideo extends Eon_TabMenuBase;

struct DisplayMode
{
	var int	Width, Height;
};

var() DisplayMode	DisplayModes[14];
var() string		BitDepthText[2];

var() Eon_MenuComboBox		ResolutionCombo;
var() Eon_MenuComboBox		ColorDepthCombo;
var() Eon_MenuCheckBox		FullScreenBox;
var() Eon_MenuSlider		GammaSlider;
var() Eon_MenuSlider		BrightnessSlider;
var() Eon_MenuSlider		ContrastSlider;
var() Eon_MenuSlider		BlurSlider;
var() Eon_Button			ApplyButton;
var() Eon_MenuCheckBox		DynamicLighting;
var() Eon_MenuCheckBox		Trilinear;



function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

/*	ResolutionCombo		= Eon_MenuComboBox(Controls[0]);
	ColorDepthCombo		= Eon_MenuComboBox(Controls[1]);
	FullScreenBox		= Eon_MenuCheckBox(Controls[2]);

	GammaSlider			= Eon_MenuSlider(Controls[3]);
	BrightnessSlider	= Eon_MenuSlider(Controls[4]);
	ContrastSlider		= Eon_MenuSlider(Controls[5]);
	BlurSlider			= Eon_MenuSlider(Controls[6]);

	ApplyButton			= Eon_Button(Controls[7]);

	DynamicLighting		= Eon_MenuCheckBox(Controls[8]);
	Trilinear			= Eon_MenuCheckBox(Controls[9]);*/

	ColorDepthCombo.AddItem(BitDepthText[0]);
	ColorDepthCombo.AddItem(BitDepthText[1]);
	ColorDepthCombo.ReadOnly(true);

	CheckSupportedResolutions();
}

function Refresh()
{
	InternalOnLoadINI(ResolutionCombo,"");
	InternalOnLoadINI(ColorDepthCombo,"");
	InternalOnLoadINI(FullScreenBox,"");
}

function CheckSupportedResolutions()
{
	local int		HighestRes, Index, BitDepth;
	local string	CurrentSelection;

	CurrentSelection = ResolutionCombo.GetText();

	if( ResolutionCombo.ItemCount() > 0 )
		ResolutionCombo.RemoveItem( 0, ResolutionCombo.ItemCount() );

	if( ColorDepthCombo.GetText() == BitDepthText[0] )		BitDepth = 16;
	else													BitDepth = 32;

	// Don't let user create non-fullscreen window bigger than highest
	// supported resolution, or MacOS X client crashes. --ryan.
	if( !FullScreenBox.IsChecked() )
	{
		HighestRes = 0;
		for( Index = 0; Index < ArrayCount(DisplayModes); Index++ )
		{
			if( PlayerOwner().ConsoleCommand(
					"SupportedResolution"$
					" WIDTH="$DisplayModes[Index].Width$
					" HEIGHT="$DisplayModes[Index].Height$
					" BITDEPTH="$BitDepth) == "1")
			{
				HighestRes = Index;   // biggest resolution hardware supports.
			}
		}

		for( Index = 0; Index <= HighestRes; Index++ )
		{
			ResolutionCombo.AddItem( DisplayModes[Index].Width$"x"$DisplayModes[Index].Height );
		}
	}

	else  // Set dropdown for fullscreen modes...
	{
		for( Index = 0; Index < ArrayCount(DisplayModes); Index++)
		{
			if( PlayerOwner().ConsoleCommand(
				"SupportedResolution"$
				" WIDTH="$DisplayModes[Index].Width$
				" HEIGHT="$DisplayModes[Index].Height$
				" BITDEPTH="$BitDepth) == "1")
			{
				ResolutionCombo.AddItem( DisplayModes[Index].Width$"x"$DisplayModes[Index].Height );
			}
		}
	}

	ResolutionCombo.SetText( CurrentSelection );
}

function bool ApplyChanges(GUIComponent Sender)
{
	local string DesiredRes;

	DesiredRes = ResolutionCombo.GetText();

	if( ColorDepthCombo.GetText() == BitDepthText[0] )	DesiredRes=DesiredRes$"x16";
	else												DesiredRes=DesiredRes$"x32";

	if( FullScreenBox.IsChecked() )						DesiredRes=DesiredRes$"f";
	else												DesiredRes=DesiredRes$"w";

	ApplyButton.bVisible = false;

	if( Controller.OpenMenu("EonInterface.Eon_PageVideoNew") )
		Eon_PageVideoNew(Controller.TopPage()).Execute( DesiredRes );

	return true;
}

function InternalOnLoadINI(GUIComponent Sender, string s)
{

	switch( Sender )
	{
		case ResolutionCombo:
			if( Controller.GameResolution != "" )
					ResolutionCombo.SetText(Controller.GameResolution);
			else	ResolutionCombo.SetText(Controller.GetCurrentRes());
		break;

		case ColorDepthCombo:
			if( PlayerOwner().ConsoleCommand("get ini:Engine.Engine.RenderDevice Use16bit") ~= "true" )
					ColorDepthCombo.SetText(BitDepthText[0]);
			else	ColorDepthCombo.SetText(BitDepthText[1]);
			CheckSupportedResolutions();
		break;

		case FullScreenBox:
			FullScreenBox.Checked(bool(Sender.PlayerOwner().ConsoleCommand("ISFULLSCREEN")));
			CheckSupportedResolutions();
		break;

		case BlurSlider:
			BlurSlider.SetValue(class'ECFG_MotionBlur'.default.MotionBlur);
		break;

		case DynamicLighting:
			DynamicLighting.Checked(!bool(s));
		break;
	}
}

function string InternalOnSaveINI(GUIComponent Sender);

function InternalOnChange(GUIComponent Sender)
{
	if( !Controller.bCurMenuInitialized )
		return;

	switch( Sender )
	{
		case ResolutionCombo:
			ApplyButton.bVisible = true;
		break;

		case ColorDepthCombo:
			ApplyButton.bVisible = true;
			CheckSupportedResolutions();
		break;

		case FullScreenBox:
			ApplyButton.bVisible = true;
			CheckSupportedResolutions();
		break;

		case GammaSlider:
			PlayerOwner().ConsoleCommand("GAMMA"@GammaSlider.GetValue());
		break;

		case BrightnessSlider:
			PlayerOwner().ConsoleCommand("BRIGHTNESS"@BrightnessSlider.GetValue());
		break;

		case ContrastSlider:
			PlayerOwner().ConsoleCommand("CONTRAST"@ContrastSlider.GetValue());
		break;

		case BlurSlider:
			PlayerOwner().ConsoleCommand("MOTIONBLUR"@BlurSlider.GetValue());
		break;

		case DynamicLighting:
			PlayerOwner().ConsoleCommand("set"@Sender.INIOption @ !DynamicLighting.IsChecked());
		break;

		case Trilinear:
			PlayerOwner().ConsoleCommand("set"@Sender.INIOption @ Trilinear.IsChecked());
		break;
	}
}


/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object class=Eon_MenuComboBox Name=oResolutionCombo
		WinWidth=0.45
		WinHeight=0.065000
		WinTop=0.1
		WinLeft=0.0
		INIOption="@INTERNAL"
		INIDefault="640x480"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
		Hint="Select the video resolution at which you wish to play."
		Caption="Resolution"
		bReadOnly=true
		TabOrder=0
	End Object

	Begin Object class=Eon_MenuComboBox Name=oColorDepthCombo
		WinWidth=0.45
		WinHeight=0.065
		WinLeft=0.0
		WinTop=0.225
		INIOption="@Internal"
		INIDefault="false"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
		Hint="Select the maximum number of colors to display at one time."
		Caption="Color Depth"
		TabOrder=1
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oFullScreenBox
		WinWidth=0.35
		WinHeight=0.065
		WinLeft=0.55
		WinTop=0.1
		Caption="Full Screen"
		INIOption="@Internal"
		INIDefault="True"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
		Hint="Check this box to run the game full screen."
		bSquare=true
		CaptionWidth=0.5
		TabOrder=2
	End Object

	Begin Object class=Eon_MenuSlider Name=oGammaSlider
		Caption="Gamma"
		WinWidth=0.45
		WinLeft=0.0
		WinTop=0.625
		MinValue=0.5
		MaxValue=2.5
		INIOption="ini:Engine.Engine.ViewportManager Gamma"
		INIDefault="0.8"
		OnChange=InternalOnChange
		Hint="Use the slider to adjust the Gamma to suit your monitor."
		TabOrder=3
	End Object

	Begin Object class=Eon_MenuSlider Name=oBrightnessSlider
		Caption="Brightness"
		WinWidth=0.45
		WinLeft=0.0
		WinTop=0.75
		MinValue=0
		MaxValue=1
		INIOption="ini:Engine.Engine.ViewportManager Brightness"
		INIDefault="0.8"
		OnChange=InternalOnChange
		Hint="Use the slider to adjust the Brightness to suit your monitor."
		TabOrder=4
	End Object

	Begin Object class=Eon_MenuSlider Name=oContrastSlider
		Caption="Contrast"
		WinWidth=0.45
		WinLeft=0.0
		WinTop=0.875
		MinValue=0
		MaxValue=1
		INIOption="ini:Engine.Engine.ViewportManager Contrast"
		INIDEfault="0.8"
		OnChange=InternalOnChange
		Hint="Use the slider to adjust the Contrast to suit your monitor."
		TabOrder=5
	End Object

	Begin Object class=Eon_MenuSlider Name=oBlurSlider
		WinWidth=0.45
		WinLeft=0.55
		WinTop=0.625
		MinValue=0
		MaxValue=1
		INIOption="@INTERNAL"
		OnLoadINI=InternalOnLoadINI
		OnChange=InternalOnChange
		Hint="Use the slider to adjust the Motion Blur."
		Caption="Motion Blur"
		TabOrder=6
	End Object

	Begin Object class=Eon_Button Name=oApplyButton
		WinWidth=0.35
		WinHeight=0.065000
		WinLeft=0.55
		WinTop=0.225
		Caption="Apply Changes"
		Hint="Apply all changes to your video settings."
		bVisible=false
		OnClick=ApplyChanges
		OnChange=InternalOnChange
		TabOrder=7
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailDynamicLighting
		WinWidth=0.35
		WinLeft=0.55
		WinTop=0.75
		Caption="Dynamic Lighting"
		Hint="Enables dynamic lights."
		INIOption="ini:Engine.Engine.ViewportManager NoDynamicLights"
		INIDefault="True"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
		TabOrder=8
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailTrilinear
		WinWidth=0.35
		WinLeft=0.55
		WinTop=0.875
		Caption="Trilinear Filtering"
		Hint="Enable trilinear filtering, recommended for high-performance PCs."
		INIOption="ini:Engine.Engine.RenderDevice UseTrilinear"
		INIDefault="False"
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
		TabOrder=9
	End Object
/*
	Controls(0)=oResolutionCombo
	Controls(1)=oColorDepthCombo
	Controls(2)=oFullScreenBox
	Controls(3)=oGammaSlider
	Controls(4)=oBrightnessSlider
	Controls(5)=oContrastSlider
	Controls(6)=oBlurSlider
	Controls(7)=oApplyButton
	Controls(8)=oDetailDynamicLighting
	Controls(9)=oDetailTrilinear
	*/

	ResolutionCombo=oResolutionCombo
	ColorDepthCombo=oColorDepthCombo
	FullScreenBox=oFullScreenBox
	GammaSlider=oGammaSlider
	BrightnessSlider=oBrightnessSlider
	ContrastSlider=oContrastSlider
	BlurSlider=oBlurSlider
	ApplyButton=oApplyButton
	DynamicLighting=oDetailDynamicLighting
	Trilinear=oDetailTrilinear


	DisplayModes(0)=(Width=320,Height=240)
	DisplayModes(1)=(Width=512,Height=384)
	DisplayModes(2)=(Width=640,Height=480)
	DisplayModes(3)=(Width=800,Height=500)
	DisplayModes(4)=(Width=800,Height=600)
	DisplayModes(5)=(Width=1024,Height=640)
	DisplayModes(6)=(Width=1024,Height=768)
	DisplayModes(7)=(Width=1152,Height=864)
	DisplayModes(8)=(Width=1280,Height=800)
	DisplayModes(9)=(Width=1280,Height=960)
	DisplayModes(10)=(Width=1280,Height=1024)
	DisplayModes(11)=(Width=1600,Height=1200)
	DisplayModes(12)=(Width=1680,Height=1050)
	DisplayModes(13)=(Width=1920,Height=1200)


	BitDepthText(0)="16-bit color"
	BitDepthText(1)="32-bit color"


	PanelCaption="Video"
}
