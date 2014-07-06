/* =============================================================================
:: File Name	::	Eon_TabAudio.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabAudio extends Eon_TabMenuBase;


var() string	AudioModes[4];

var() Eon_MenuSlider		MusicSlider;
var() Eon_MenuSlider		AmbientSlider;
var() Eon_MenuSlider		SoundSlider;
var() Eon_MenuSlider		ChannelsSlider;
var() Eon_MenuSlider		DopplerFactorSlider;
var() Eon_MenuSlider		RolloffSlider;
var() Eon_MenuComboBox		AudioMode;
var() Eon_MenuCheckBox		ReverseStereo;
var() Eon_MenuCheckBox		LowDetail;
var() Eon_MenuCheckBox		DisablePitch;
var() Eon_MenuCheckBox		UsePrecache;

var() Sound SoundSliderSound;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local int i;
	Super.InitComponent(MyController, MyOwner);

	MusicSlider			= Eon_MenuSlider(Controls[0]);
	AmbientSlider		= Eon_MenuSlider(Controls[1]);
	SoundSlider			= Eon_MenuSlider(Controls[2]);
	ChannelsSlider		= Eon_MenuSlider(Controls[3]);
	AudioMode			= Eon_MenuComboBox(Controls[4]);
	ReverseStereo		= Eon_MenuCheckBox(Controls[5]);
	LowDetail			= Eon_MenuCheckBox(Controls[6]);
	DisablePitch		= Eon_MenuCheckBox(Controls[7]);
	UsePrecache			= Eon_MenuCheckBox(Controls[8]);
	DopplerFactorSlider	= Eon_MenuSlider(Controls[9]);
	RolloffSlider		= Eon_MenuSlider(Controls[10]);

	for( i = 0; i < ArrayCount(AudioModes); i++ )
		AudioMode.AddItem(AudioModes[i]);
}

function InternalOnLoadINI(GUIComponent Sender, string s)
{
	local bool b1, b2, b3;

	switch( Sender )
	{
		case AudioMode:
		    B1 = bool( PlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice UseEAX" ) );
		    B2 = bool( PlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice CompatibilityMode" ) );
		    B3 = bool( PlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice Use3DSound" ) );

		    if( B2 )		AudioMode.SetText(AudioModes[3]);
		    else if( B1 )	AudioMode.SetText(AudioModes[2]);
			else if( B3 )	AudioMode.SetText(AudioModes[1]);
			else			AudioMode.SetText(AudioModes[0]);
		break;

		case ReverseStereo:
			ReverseStereo.Checked(bool(s));
		break;

		case LowDetail:
		    B1 = PlayerOwner().Level.bLowSoundDetail;
			B2 = bool( PlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice LowQualitySound" ) );

			// Make sure both are the same - LevelInfo.bLowSoundDetail take priority
			if( B1 != B2 )
			{
				PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice LowQualitySound"@B1);
				PlayerOwner().ConsoleCommand("SOUND_REBOOT");

				// Restart music.
				if( PlayerOwner().Level.Song != "" && PlayerOwner().Level.Song != "None" )
					PlayerOwner().ClientSetMusic( PlayerOwner().Level.Song, MTRAN_Instant );
			}

			LowDetail.Checked(B1);
		break;
	}
}

function string InternalOnSaveINI(GUIComponent Sender);

function InternalOnChange(GUIComponent Sender)
{
	local string t;
	local bool b1;

	if( !Controller.bCurMenuInitialized )
		return;

	switch( Sender )
	{
		case MusicSlider:
			PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$MusicSlider.GetValue());
		break;

		case AmbientSlider:
			PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice AmbientVolume "$AmbientSlider.GetValue());
		break;

		case SoundSlider:
			PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume "$SoundSlider.GetValue());
			PlayerOwner().ConsoleCommand("stopsounds");
			PlayerOwner().PlaySound( SoundSliderSound );
		break;

		case ChannelsSlider:
			PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice Channels "$ChannelsSlider.GetValue());
		break;

		case DopplerFactorSlider:
			PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice DopplerFactor "$DopplerFactorSlider.GetValue());
		break;

		case RolloffSlider:
			PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice Rolloff "$RolloffSlider.GetValue());
			PlayerOwner().ConsoleCommand("ROLLOFF"@RolloffSlider.GetValue());
		break;

		case AudioMode:
			t = AudioMode.GetText();

			if( t == AudioModes[3] )
			{
	            PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice UseEAX false" );
	            PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice Use3DSound false" );
	            PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice CompatibilityMode true" );
			}
			else if( t == AudioModes[0] )
			{
	            PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice UseEAX false" );
	            PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice Use3DSound false" );
	            PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice CompatibilityMode false" );
			}
			else if( t == AudioModes[1] )
			{
	            PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice UseEAX false" );
	            PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice Use3DSound true" );
	            PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice CompatibilityMode false" );
				Controller.OpenMenu("EonInterface.Eon_PagePerfWarning");
			}
			else if( t == AudioModes[2] )
			{
	            PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice UseEAX true" );
	            PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice Use3DSound true" );
	            PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice CompatibilityMode false" );
				Controller.OpenMenu("EonInterface.Eon_PagePerfWarning");
			}
			RestartSoundSystem();
		break;

		case LowDetail:
			b1 = LowDetail.IsChecked();
			PlayerOwner().Level.bLowSoundDetail = b1;
	        PlayerOwner().Level.SaveConfig();
			PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice LowQualitySound "$B1);
			RestartSoundSystem();
		break;

		case DisablePitch:
		case UsePrecache:
			PlayerOwner().ConsoleCommand("set" @ Sender.INIOption @ Eon_MenuCheckBox(Sender).IsChecked());
			RestartSoundSystem();
		break;
	}
}

function RestartSoundSystem()
{
	PlayerOwner().ConsoleCommand("SOUND_REBOOT");

	// Restart music.
	if( PlayerOwner().Level.Song != "" && PlayerOwner().Level.Song != "None" )
		PlayerOwner().ClientSetMusic( PlayerOwner().Level.Song, MTRAN_Instant );
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

	Begin Object class=Eon_MenuCheckBox Name=oReverseStereo
		WinWidth=0.35
		WinHeight=0.065
		WinLeft=0.0
		WinTop=0.3
		Caption="Reverse Stereo"
		INIOption="ini:Engine.Engine.AudioDevice ReverseStereo"
		INIDefault="False"
		Hint="Reverses the left and right audio channels."
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oLowDetail
		WinWidth=0.35
		WinHeight=0.065
		WinLeft=0.0
		WinTop=0.425
		Caption="Low Sound Detail"
		INIOption="@Internal"
		INIDefault="False"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		Hint="Lowers quality of sound."
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDisablePitch
		WinWidth=0.35
		WinHeight=0.065
		WinLeft=0.55
		WinTop=0.3
		Caption="Disable Pitch"
		INIOption="ini:Engine.Engine.AudioDevice DisablePitch"
		INIDefault="False"
		Hint="Disable Pitch Adjustments."
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oUsePrecache
		WinWidth=0.35
		WinHeight=0.065
		WinLeft=0.55
		WinTop=0.425
		Caption="Use Precache"
		INIOption="ini:Engine.Engine.AudioDevice UsePrecache"
		INIDefault="True"
		Hint="Precache sounds."
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuComboBox Name=oAudioMode
		WinWidth=0.90
		WinHeight=0.065
		WinLeft=0.0
		WinTop=0.1
		Caption="Audio Mode"
		INIOption="@Internal"
		INIDefault="Software 3D Audio"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		Hint="Changes the audio system mode."
		CaptionWidth=0.34
		bReadOnly=true
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuSlider Name=oMusicSlider
		Caption="Music Volume"
		WinWidth=0.45
		WinHeight=0.06
		WinLeft=0.0
		WinTop=0.625
		MinValue=0.0
		MaxValue=1.0
		INIOption="ini:Engine.Engine.AudioDevice MusicVolume"
		INIDefault="0.5"
		Hint="Changes the volume of the background music."
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuSlider Name=oAmbientSlider
		Caption="Ambient Volume"
		WinWidth=0.45
		WinHeight=0.06
		WinLeft=0.0
		WinTop=0.75
		MinValue=0.0
		MaxValue=1.0
		INIOption="ini:Engine.Engine.AudioDevice AmbientVolume"
		INIDefault="0.3"
		Hint="Changes the volume of the ambient sounds."
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuSlider Name=oSoundSlider
		Caption="Effects Volume"
		WinWidth=0.45
		WinHeight=0.06
		WinLeft=0.0
		WinTop=0.875
		MinValue=0.0
		MaxValue=1.0
		INIOption="ini:Engine.Engine.AudioDevice SoundVolume"
		INIDefault="0.75"
		Hint="Changes the volume of all in game sound effects."
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuSlider Name=oChannelsSlider
		Caption="Sound Channels"
		WinWidth=0.45
		WinHeight=0.06
		WinLeft=0.55
		WinTop=0.625
		MinValue=8
		MaxValue=64
		bIntSlider=true
		INIOption="ini:Engine.Engine.AudioDevice Channels"
		INIDefault="32"
		Hint="Changes the number of sound channels  -  Default 32"
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuSlider Name=oDopplerFactorSlider
		Caption="Doppler Factor"
		WinWidth=0.45
		WinHeight=0.06
		WinLeft=0.55
		WinTop=0.75
		MinValue=0
		MaxValue=2.0
		INIOption="ini:Engine.Engine.AudioDevice DopplerFactor"
		INIDefault="1"
		Hint="How much Doppler Effect is applied  -  Default 1.0"
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuSlider Name=oRolloffSlider
		Caption="Rolloff Factor"
		WinWidth=0.45
		WinHeight=0.06
		WinLeft=0.55
		WinTop=0.875
		MinValue=0
		MaxValue=1.5
		INIOption="ini:Engine.Engine.AudioDevice Rolloff"
		INIDefault="0.5"
		Hint="How much the Distance affects Volume of the Sound Sources -  Default 0.5"
		OnChange=InternalOnChange
	End Object

	Controls(0)=oMusicSlider
	Controls(1)=oAmbientSlider
	Controls(2)=oSoundSlider
	Controls(3)=oChannelsSlider
	Controls(4)=oAudioMode
	Controls(5)=oReverseStereo
	Controls(6)=oLowDetail
	Controls(7)=oDisablePitch
	Controls(8)=oUsePrecache
	Controls(9)=oDopplerFactorSlider
	Controls(10)=oRolloffSlider

	AudioModes[0]="Software 3D Audio"
	AudioModes[1]="Hardware 3D Audio"
	AudioModes[2]="Hardware 3D Audio + EAX"
	AudioModes[3]="Safe Mode"

	//SoundSliderSound=sound'EonSD_RifmanRifle.Wavs.RifmanRifleFire2'
}
