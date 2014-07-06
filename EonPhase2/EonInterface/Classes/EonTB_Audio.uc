/* =============================================================================
:: File Name	::	EonTB_Audio.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonTB_Audio extends EonTB_MenuBase;


var() array<GUIListElem>			AudioModes;

var() automated Eon_Section			SSound;
var() automated Eon_MenuSlider		MusicSlider;
var() automated Eon_MenuSlider		SoundSlider;
var() automated Eon_MenuComboBox	AudioMode;
var() automated Eon_MenuCheckBox	ReverseStereo;
var() automated Eon_MenuCheckBox	LowDetail;
var() automated Eon_MenuCheckBox	SystemDriver;
var() automated Eon_MenuCheckBox	MessageBeep;

var() sound 						SNDEffects;
var() bool							bIsWin32;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float	X,Y,W,H,M;
	local int	T,i;

	X = 0.01;
	Y = 0.01;
	W = 0.98;
	H = 0.05;
	M = 0.01;

	SetupComponent( SSound, W, 0.5, X, Y, M, T );
	SSound.SetupComponent( MusicSlider, T );
	SSound.SetupComponent( SoundSlider, T );
	SSound.SetupComponent( AudioMode, T );
	SSound.SetupComponent( ReverseStereo, T );
	SSound.SetupComponent( LowDetail, T );
	SSound.SetupComponent( SystemDriver, T );
	SSound.SetupComponent( MessageBeep, T );

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

	AudioMode.SetContents( AudioModes );
	bIsWin32 = PlatformIsWindows() && !PlatformIs64Bit();
}

function ILoadINI(GUIComponent Sender, string S)
{
	local PlayerController	P;
	local bool				bLow;
	local int				i;

	P = PlayerOwner();

	switch( Sender )
	{
		case MusicSlider:				MusicSlider.SetComponentValue( float(S), true );		break;
		case SoundSlider:				SoundSlider.SetComponentValue( float(S), true );		break;
		case ReverseStereo:				ReverseStereo.SetComponentValue( bool(S), true );		break;
		case SystemDriver:				SystemDriver.SetComponentValue( bool(S), true );		break;
		case MessageBeep:				MessageBeep.SetComponentValue( class'HUD'.default.bMessageBeep, true );			break;

		case LowDetail:
			bLow = P.Level.bLowSoundDetail;
			if( bLow != bool(S) )
			{
				P.ConsoleCommand("set" @ Sender.INIOption @ bLow);
				RestartSound(P);
			}
			LowDetail.SetComponentValue( bLow, true );
		break;

		case AudioMode:
			if( bIsWin32 )
			{
				if(!bool(P.ConsoleCommand("get ini:Engine.Engine.AudioDevice CompatibilityMode")) )	i=1;
				if( bool(P.ConsoleCommand("get ini:Engine.Engine.AudioDevice Use3DSound")) )		i=2;
				if( bool(P.ConsoleCommand("get ini:Engine.Engine.AudioDevice UseEAX")) )			i=3;
			}
			AudioMode.SetIndexText(i);
		break;
	}
}

function IChange(GUIComponent Sender)
{
	local PlayerController	P;
	local int				i;

	if( !Controller.bCurMenuInitialized )
		return;

	P = PlayerOwner();

	switch( Sender )
	{
		case MusicSlider:
			P.ConsoleCommand("set" @ MusicSlider.INIOption @ MusicSlider.GetValue() );
			P.ConsoleCommand("SetMusicVolume" @ MusicSlider.GetValue() );
			if( P.Level.Song != "" && P.Level.Song != "None" )
					P.ClientSetMusic( P.Level.Song, MTRAN_Instant );
		break;

		case SoundSlider:
			P.ConsoleCommand("set" @ SoundSlider.INIOption @ SoundSlider.GetValue() );
			P.ConsoleCommand("StopSounds");
			P.PlaySound( SNDEffects );
		break;

		case AudioMode:
			if( bIsWin32 )
			{
				i = AudioMode.GetIndex();
		        P.ConsoleCommand("set ini:Engine.Engine.AudioDevice CompatibilityMode" @ (i<1));
		        P.ConsoleCommand("set ini:Engine.Engine.AudioDevice Use3DSound" @ (i>1));
		        P.ConsoleCommand("set ini:Engine.Engine.AudioDevice UseEAX" @ (i>2));
				RestartSound(P);
			}
		break;

		case ReverseStereo:
			P.ConsoleCommand("set" @ ReverseStereo.INIOption @ ReverseStereo.IsChecked() );
		break;

		case SystemDriver:
			P.ConsoleCommand("set" @ SystemDriver.INIOption @ SystemDriver.IsChecked() );
			P.ConsoleCommand("SOUND_REBOOT");
		break;

		case LowDetail:
			P.ConsoleCommand("set" @ LowDetail.INIOption @ LowDetail.IsChecked() );
			P.Level.bLowSoundDetail = LowDetail.IsChecked();
			P.Level.StaticSaveConfig();
			RestartSound(P);
		break;

		case MessageBeep:
			if( P.MyHud != None )
			{
				P.myHUD.bMessageBeep = MessageBeep.IsChecked();
				P.myHUD.SaveConfig();
			}
			else
			{
				class'HUD'.default.bMessageBeep = MessageBeep.IsChecked();
				class'HUD'.static.StaticSaveConfig();
			}
		break;
	}
}

final function RestartSound( PlayerController P )
{
	P.ConsoleCommand("SOUND_REBOOT");						// Restart driver
	if( P.Level.Song != "" && P.Level.Song != "None" )		// Restart music
		P.ClientSetMusic( P.Level.Song, MTRAN_Instant );
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

	// Sound -------------------------------------------------------------------

	Begin Object Class=Eon_Section Name=oSSound
		NumColumns=2
	End Object

	Begin Object class=Eon_MenuComboBox Name=oAudioMode
		Caption="Audio Mode"
		INIDefault="Software 3D Audio"
		Hint="Changes the audio system mode."
	End Object

	Begin Object class=Eon_MenuSlider Name=oMusicSlider
		Caption="Music Volume"
		MinValue=0.0
		MaxValue=1.0
		INIOption="ini:Engine.Engine.AudioDevice MusicVolume"
		INIDefault="0.5"
		Hint="Changes the volume of the background music."
	End Object

	Begin Object class=Eon_MenuSlider Name=oSoundSlider
		Caption="Effects Volume"
		MinValue=0.0
		MaxValue=1.0
		INIOption="ini:Engine.Engine.AudioDevice SoundVolume"
		INIDefault="0.75"
		Hint="Changes the volume of all in game sound effects."
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oLowDetail
		Caption="Low Sound Detail"
		INIOption="ini:Engine.Engine.AudioDevice LowQualitySound"
		INIDefault="False"
		Hint="Lowers quality of sound."
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oReverseStereo
		Caption="Reverse Stereo"
		INIOption="ini:Engine.Engine.AudioDevice ReverseStereo"
		INIDefault="False"
		Hint="Reverses the left and right audio channels."
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oSystemDriver
		Caption="System Driver"
		INIOption="ini:Engine.Engine.AudioDevice UseDefaultDriver"
		INIDefault="False"
		Hint="Use system installed OpenAL driver"
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oMessageBeep
		Caption="Message Beep"
		INIDefault="False"
		Hint="Enables a beep when receiving a text message from other players."
	End Object


	SSound				= oSSound
	MusicSlider			= oMusicSlider
	SoundSlider			= oSoundSlider
	AudioMode			= oAudioMode
	LowDetail			= oLowDetail
	ReverseStereo		= oReverseStereo
	SystemDriver		= oSystemDriver
	MessageBeep			= oMessageBeep

	AudioModes(0)=(Item="Safe Mode")
	AudioModes(1)=(Item="3D Audio")
	AudioModes(2)=(Item="H/W 3D Audio")
	AudioModes(3)=(Item="H/W 3D Audio + EAX")
}
