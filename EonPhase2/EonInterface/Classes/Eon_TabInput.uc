/* =============================================================================
:: File Name	::	Eon_TabInput.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabInput extends Eon_TabMenuBase;

var() Eon_MenuCheckBox		AutoAim;
var() Eon_MenuCheckBox		AutoSlope;
var() Eon_MenuCheckBox		InvertMouse;
var() Eon_MenuCheckBox		MouseSmoothing;
var() Eon_MenuCheckBox		UseJoystick;
var() Eon_MenuSlider		MouseSensitivity;
var() Eon_MenuSlider		MenuSensitivity;
var() Eon_MenuSlider		MouseSmoothStr;
var() Eon_MenuSlider		MouseAccel;
var() Eon_MenuCheckBox		MouseLag;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local int i;
	Super.InitComponent(MyController, MyOwner);

	for(i=0; i<Controls.Length; i++)
		Controls[i].OnChange = InternalOnChange;

	AutoAim				= Eon_MenuCheckBox(Controls[0]);
	AutoSlope			= Eon_MenuCheckBox(Controls[1]);
	InvertMouse			= Eon_MenuCheckBox(Controls[2]);
	MouseSmoothing		= Eon_MenuCheckBox(Controls[3]);
	UseJoystick			= Eon_MenuCheckBox(Controls[4]);
	MouseSensitivity	= Eon_MenuSlider(Controls[5]);
	MenuSensitivity		= Eon_MenuSlider(Controls[6]);
	MouseSmoothStr		= Eon_MenuSlider(Controls[7]);
	MouseAccel			= Eon_MenuSlider(Controls[8]);
	MouseLag			= Eon_MenuCheckBox(Controls[9]);

	AutoAim.Checked( PlayerOwner().Level.Game.AutoAim == 1 );
	AutoSlope.Checked( PlayerOwner().bSnapToLevel );
	InvertMouse.Checked( class'PlayerInput'.default.bInvertMouse );
	MouseSmoothing.Checked( class'PlayerInput'.default.MouseSmoothingMode > 0 );
	UseJoystick.Checked( bool(PlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager UseJoystick")) );
 	MouseSensitivity.SetValue( class'PlayerInput'.default.MouseSensitivity );
	MenuSensitivity.SetValue( Controller.MenuMouseSens );
	MouseSmoothStr.SetValue( class'PlayerInput'.Default.MouseSmoothingStrength );
	MouseAccel.SetValue( class'PlayerInput'.Default.MouseAccelThreshold );
	MouseLag.Checked( bool(PlayerOwner().ConsoleCommand("get ini:Engine.Engine.RenderDevice ReduceMouseLag")) );
}

function InternalOnChange(GUIComponent Sender)
{
	if( !Controller.bCurMenuInitialized )
		return;

	switch( Sender )
	{
		case AutoAim:
			PlayerOwner().Level.Game.AutoAim = float(AutoAim.IsChecked());
			PlayerOwner().Level.Game.SaveConfig();
		break;

		case MouseLag:
			PlayerOwner().ConsoleCommand("set ini:Engine.Engine.RenderDevice ReduceMouseLag "$MouseLag.IsChecked());
		break;

		case AutoSlope:
			PlayerOwner().bSnapToLevel = AutoSlope.IsChecked();
			PlayerOwner().SaveConfig();
		break;

		case InvertMouse:
			PlayerOwner().ConsoleCommand("set PlayerInput bInvertMouse "$InvertMouse.IsChecked());
			class'PlayerInput'.default.bInvertMouse = InvertMouse.IsChecked();
			class'PlayerInput'.static.StaticSaveConfig();
		break;

		case MouseSmoothing:
			class'PlayerInput'.default.MouseSmoothingMode = float( MouseSmoothing.IsChecked() );
		break;

		case UseJoystick:
			PlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager UseJoystick"@UseJoystick.IsChecked());
		break;

		case MouseSensitivity:
			class'PlayerInput'.default.MouseSensitivity = MouseSensitivity.GetValue();
			PlayerOwner().ConsoleCommand("set PlayerInput MouseSensitivity "$MouseSensitivity.GetValue());
			class'PlayerInput'.static.StaticSaveConfig();
		break;

		case MenuSensitivity:
			Controller.MenuMouseSens = MenuSensitivity.GetValue();
			Controller.SaveConfig();
		break;

		case MouseSmoothStr:
			class'PlayerInput'.default.MouseSmoothingStrength = MouseSmoothStr.GetValue();
			PlayerOwner().ConsoleCommand("set PlayerInput MouseSmoothingStrength "$MouseSmoothStr.GetValue());
			class'PlayerInput'.static.StaticSaveConfig();
		break;

		case MouseAccel:
			class'PlayerInput'.default.MouseAccelThreshold = MouseAccel.GetValue();
			PlayerOwner().ConsoleCommand("set PlayerInput MouseAccelThreshold "$MouseAccel.GetValue());
			class'PlayerInput'.static.StaticSaveConfig();
		break;
	}
}



/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object class=Eon_MenuSlider Name=oMouseSensitivity
		WinWidth=1.0
		WinLeft=0.0
		WinTop=0.1
		MinValue=1.0
		MaxValue=25.0
		CaptionWidth=0.35
		Caption="Mouse Sensitivity (In Game)"
		Hint="Adjust mouse sensitivity"
	End Object

	Begin Object class=Eon_MenuSlider Name=oMenuSensitivity
		WinWidth=1.0
		WinLeft=0.0
		WinTop=0.225
		MinValue=1.0
		MaxValue=6.0
		CaptionWidth=0.35
		Caption="Mouse Sensitivity (Menus)"
		Hint="Adjust mouse speed within the menus"
	End Object

	Begin Object class=Eon_MenuSlider Name=oMouseSmoothStr
		WinWidth=1.0
		WinLeft=0.0
		WinTop=0.35
		MinValue=0.0
		MaxValue=1.0
		CaptionWidth=0.35
		Caption="Mouse Smoothing Strength"
		Hint="Adjust the amount of smoothing that is applyed to mouse movements"
	End Object

	Begin Object class=Eon_MenuSlider Name=oMouseAccel
		WinWidth=1.0
		WinLeft=0.0
		WinTop=0.475
		MinValue=0.0
		MaxValue=100.0
		CaptionWidth=0.35
		Caption="Mouse Accel. Threshold"
		Hint="Adjust to determine the amount of movement needed before acceleration is applied"
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oAutoAim
		WinLeft=0.0
		WinTop=0.7
		Caption="Auto Aim"
		Hint="Enabling this option will activate computer-assisted aiming in single player games."
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oAutoSlope
		WinLeft=0.0
		WinTop=0.8
		Caption="Auto Slope"
		Hint="When enabled, your view will automatically pitch up/down when on a slope."
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oInvertMouse
		WinLeft=0.0
		WinTop=0.9
		Caption="Invert Mouse"
		Hint="When enabled, the Y axis of your mouse will be inverted."
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oMouseSmoothing
		WinLeft=0.55
		WinTop=0.7
		Caption="Mouse Smoothing"
		Hint="Enable this option to automatically smooth out movements in your mouse."
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oUseJoystick
		WinLeft=0.55
		WinTop=0.8
		Caption="Enable Joystick"
		Hint="Enable this option to enable joystick support."
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oMouseLag
		WinLeft=0.55
		WinTop=0.9
		Caption="Reduce Mouse Lag"
		Hint="Enable this option will reduce the amount of lag in your mouse."
	End Object


	Controls(0)=oAutoAim
	Controls(1)=oAutoSlope
	Controls(2)=oInvertMouse
	Controls(3)=oMouseSmoothing
	Controls(4)=oUseJoystick
	Controls(5)=oMouseSensitivity
	Controls(6)=oMenuSensitivity
	Controls(7)=oMouseSmoothStr
	Controls(8)=oMouseAccel
	Controls(9)=oMouseLag
}
