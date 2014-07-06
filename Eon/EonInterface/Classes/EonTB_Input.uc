/* =============================================================================
:: File Name	::	EonTB_Input.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonTB_Input extends EonTB_MenuBase;


var() automated	Eon_Section			SOptions;
var() automated	Eon_Button			ControlBindButton;
var() automated	Eon_MenuCheckBox	InvertMouse;
var() automated	Eon_MenuCheckBox	MouseSmoothing;
var() automated	Eon_MenuCheckBox	UseJoystick;
var() automated	Eon_MenuCheckBox	MouseLag;

var() automated	Eon_Section			SForce;
var() automated	Eon_MenuCheckBox	WeaponEffects;
var() automated	Eon_MenuCheckBox	PickupEffects;
var() automated	Eon_MenuCheckBox	DamageEffects;
var() automated	Eon_MenuCheckBox	GUIEffects;

var() automated	Eon_Section			SFine;
var() automated	Eon_MenuFloatEdit	MouseSensitivity;
var() automated	Eon_MenuFloatEdit	MenuSensitivity;
var() automated	Eon_MenuFloatEdit	MouseAccel;
var() automated	Eon_MenuFloatEdit	MouseSmoothStr;
var() automated	Eon_MenuFloatEdit	DodgeTime;

var() bool							bIsWin32;
var() string						PageControls;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float	X,Y,W,H,M;
	local int	T,i;

	M = 0.01;

	X = 0.01;
	Y = 0.01;
	W = 0.31;
	H = 0.74;

	SetupComponent( SOptions, W, H, X, Y, M, T );
	SOptions.SetupComponent( ControlBindButton, T );
	SOptions.SetupComponent( InvertMouse, T );
	SOptions.SetupComponent( MouseSmoothing, T );
	SOptions.SetupComponent( UseJoystick, T );
	SOptions.SetupComponent( MouseLag, T );

	X = 0.32;
	Y = 0.01;
	W = 0.67;
	H = 0.74;

	SetupComponent( SFine, W, H, X, Y, M, T );
	SFine.SetupComponent( MouseSensitivity, T );
	SFine.SetupComponent( MenuSensitivity, T );
	SFine.SetupComponent( MouseAccel, T );
	SFine.SetupComponent( MouseSmoothStr, T );
	SFine.SetupComponent( DodgeTime, T );

	X = 0.01;
	Y = 0.75;
	W = 0.98;
	H = 0.15;

	SetupComponent( SForce, W, H, X, Y, M, T );
	SForce.SetupComponent( WeaponEffects, T );
	SForce.SetupComponent( PickupEffects, T );
	SForce.SetupComponent( DamageEffects, T );
	SForce.SetupComponent( GUIEffects, T );

	Super.InitComponent(MyController, MyOwner);

	for(i=0; i<Controls.Length; i++)
	{
		if( GUIMenuOption(Controls[i]) != None )
		{
			Controls[i].OnChange	= IChange;
			Controls[i].OnLoadINI	= ILoadINI;
			if( Controls[i].INIOption == "" )
				Controls[i].INIOption = "@INTERNAL";
		}
	}

	bIsWin32 = PlatformIsWindows() && !PlatformIs64Bit();

	// Disable force feedback options on non-win32 platforms...  --ryan.
	if( !bIsWin32 )
	{
		DisableComponent(WeaponEffects);
		DisableComponent(PickupEffects);
		DisableComponent(DamageEffects);
		DisableComponent(GUIEffects);
	}
}

function ILoadINI(GUIComponent Sender, string S)
{
	local PlayerController	P;

	P = PlayerOwner();

	switch( Sender )
	{
		case MouseLag:					MouseLag.SetComponentValue( bool(S), true );													break;
		case InvertMouse:				InvertMouse.SetComponentValue( class'PlayerInput'.default.bInvertMouse, true );					break;
		case MouseSmoothing:			MouseSmoothing.SetComponentValue((class'PlayerInput'.default.MouseSmoothingMode > 0), true );	break;
		case UseJoystick:				UseJoystick.SetComponentValue( bool(S), true );													break;

		case WeaponEffects:				WeaponEffects.SetComponentValue( P.bEnableWeaponForceFeedback, true );		break;
		case PickupEffects:				PickupEffects.SetComponentValue( P.bEnablePickupForceFeedback, true );		break;
		case DamageEffects:				DamageEffects.SetComponentValue( P.bEnableDamageForceFeedback, true );		break;
		case GUIEffects:				GUIEffects.SetComponentValue( P.bEnableGUIForceFeedback, true );			break;

		case MouseSensitivity:			MouseSensitivity.SetComponentValue( class'PlayerInput'.default.MouseSensitivity, true );			break;
		case MenuSensitivity:			MenuSensitivity.SetComponentValue( Controller.MenuMouseSens, true );							break;
		case MouseAccel:				MouseAccel.SetComponentValue( class'PlayerInput'.Default.MouseAccelThreshold, true );		break;
		case MouseSmoothStr:			MouseSmoothStr.SetComponentValue( class'PlayerInput'.Default.MouseSmoothingStrength, true );	break;
		case DodgeTime:					DodgeTime.SetComponentValue( class'PlayerInput'.Default.DoubleClickTime, true );			break;

	}
}

function IChange(GUIComponent Sender)
{
	local PlayerController	P;

	if( !Controller.bCurMenuInitialized )
		return;

	P = PlayerOwner();

	switch( Sender )
	{
		case MouseLag:					P.ConsoleCommand("set" @ MouseLag.INIOption @ MouseLag.IsChecked() );	break;
		case UseJoystick:				P.ConsoleCommand("set" @ UseJoystick.INIOption @ UseJoystick.IsChecked() );	break;

		case InvertMouse:
			P.InvertMouse( string(InvertMouse.IsChecked()) );
			P.SaveConfig();
			class'PlayerInput'.default.bInvertMouse = InvertMouse.IsChecked();
			class'PlayerInput'.Static.StaticSaveConfig();
		break;

		case MouseSmoothing:
			P.SetMouseSmoothing( int(MouseSmoothing.IsChecked()) );
			P.SaveConfig();
			class'PlayerInput'.default.MouseSmoothingMode = byte(MouseSmoothing.IsChecked());
			class'PlayerInput'.Static.StaticSaveConfig();
		break;

		case MenuSensitivity:
			Controller.MenuMouseSens = FMax(0, MenuSensitivity.GetValue());
			Controller.SaveConfig();
		break;

		case MouseSensitivity:
			P.SetSensitivity( FMax(0, MouseSensitivity.GetValue()) );
			P.SaveConfig();
		break;

		case MouseAccel:
			P.SetMouseAccel( FMax(0, MouseAccel.GetValue()) );
			P.SaveConfig();
		break;

		case MouseSmoothStr:
			P.ConsoleCommand("SetSmoothingStrength" @ MouseSmoothStr.GetValue());
			P.SaveConfig();
		break;


		case WeaponEffects:				P.bEnableWeaponForceFeedback	= WeaponEffects.IsChecked();	break;
		case PickupEffects:				P.bEnablePickupForceFeedback	= PickupEffects.IsChecked();	break;
		case DamageEffects:				P.bEnableDamageForceFeedback	= DamageEffects.IsChecked();	break;
		case GUIEffects:				P.bEnableGUIForceFeedback		= GUIEffects.IsChecked();		break;
	}

	P.bForceFeedbackSupported = P.ForceFeedbackSupported( WeaponEffects.IsChecked() || PickupEffects.IsChecked() || DamageEffects.IsChecked() || GUIEffects.IsChecked());
}

function bool IClick(GUIComponent Sender)
{
	switch( Sender )
	{
		case ControlBindButton:		Controller.OpenMenu(PageControls);	break;
	}

	return true;
}



/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

	// Options -----------------------------------------------------------------

	 Begin Object Class=Eon_Section Name=oSOptions
	 End Object

	 Begin Object Class=Eon_Button Name=oControlBindButton
		 Caption="Configure Controls"
		 Hint="Configure controls and keybinds"
		 OnClick=IClick
	 End Object

	 Begin Object Class=Eon_MenuCheckBox Name=oInvertMouse
		 Caption="Invert Mouse"
		 Hint="When enabled, the Y axis of your mouse will be inverted."
	 End Object

	 Begin Object Class=Eon_MenuCheckBox Name=oMouseSmoothing
		 Caption="Mouse Smoothing"
		 Hint="Enable this option to automatically smooth out movements in your mouse."
	 End Object

	 Begin Object Class=Eon_MenuCheckBox Name=oUseJoystick
		 Caption="Enable Joystick"
		 Hint="Enable this option to enable joystick support."
		 INIOption="ini:Engine.Engine.ViewportManager UseJoystick"
	 End Object

	 Begin Object Class=Eon_MenuCheckBox Name=oMouseLag
		 Caption="Reduce Mouse Lag"
		 Hint="Enable this option will reduce the amount of lag in your mouse."
		 INIOption="ini:Engine.Engine.RenderDevice ReduceMouseLag"
	 End Object

	SOptions			= oSOptions
	ControlBindButton	= oControlBindButton
	InvertMouse			= oInvertMouse
	MouseSmoothing		= oMouseSmoothing
	UseJoystick			= oUseJoystick
	MouseLag			= oMouseLag




	// Force Feedback ----------------------------------------------------------

	 Begin Object Class=Eon_Section Name=oSForce
	 	NumColumns=2
	 End Object

	 Begin Object Class=Eon_MenuCheckBox Name=oWeaponEffects
		 Caption="Weapon Effects"
		 Hint="Turn this option On/Off to feel the weapons you fire."
	 End Object

	 Begin Object Class=Eon_MenuCheckBox Name=oPickupEffects
		 Caption="Pickup Effects"
		 Hint="Turn this option On/Off to feel the items you pick up."
	 End Object

	 Begin Object Class=Eon_MenuCheckBox Name=oDamageEffects
		 Caption="Damage Effects"
		 Hint="Turn this option On/Off to feel the damage you take."
	 End Object

	 Begin Object Class=Eon_MenuCheckBox Name=oGUIEffects
		 Caption="Vehicle Effects"
		 Hint="Turn this option On/Off to feel the vehicle effects."
	 End Object

	SForce				= oSForce
	WeaponEffects		= oWeaponEffects
	PickupEffects		= oPickupEffects
	DamageEffects		= oDamageEffects
	GUIEffects			= oGUIEffects



	// Fine Tuning -------------------------------------------------------------

	 Begin Object Class=Eon_Section Name=oSFine
	 End Object

	 Begin Object Class=Eon_MenuFloatEdit Name=oMouseSensitivity
		 MinValue=0.250000
		 MaxValue=25.000000
		 Step=0.250000
		 Caption="Mouse Sensitivity (Game)"
		 Hint="Adjust mouse sensitivity"
	 End Object

	 Begin Object Class=Eon_MenuFloatEdit Name=oMenuSensitivity
		 MinValue=1.000000
		 MaxValue=6.000000
		 Step=0.250000
		 Caption="Mouse Sensitivity (Menus)"
		 Hint="Adjust mouse speed within the menus"
	 End Object

	 Begin Object Class=Eon_MenuFloatEdit Name=oMouseAccel
		 MinValue=0.000000
		 MaxValue=100.000000
		 Step=5.000000
		 Caption="Mouse Accel. Threshold"
		 Hint="Adjust to determine the amount of movement needed before acceleration is applied"
	 End Object

	 Begin Object Class=Eon_MenuFloatEdit Name=oMouseSmoothStr
		 MinValue=0.000000
		 MaxValue=1.000000
		 Step=0.050000
		 Caption="Mouse Smoothing Strength"
		 Hint="Adjust the amount of smoothing that is applied to mouse movements"
	 End Object

	 Begin Object Class=Eon_MenuFloatEdit Name=oDodgeTime
		 MinValue=0.000000
		 MaxValue=1.000000
		 Step=0.050000
		 Caption="Dodge Double-Click Time"
		 Hint="Determines how fast you have to double click to dodge"
	 End Object


	SFine				= oSFine
	MouseSensitivity	= oMouseSensitivity
	MenuSensitivity		= oMenuSensitivity
	MouseAccel			= oMouseAccel
	MouseSmoothStr		= oMouseSmoothStr
	DodgeTime			= oDodgeTime

	PageControls="EonInterface.EonPG_ControlBinder"
}
