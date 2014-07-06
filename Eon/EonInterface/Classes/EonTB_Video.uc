/* =============================================================================
:: File Name	::	EonTB_Video.uc
:: Description	::	Keep it simple, stupid
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonTB_Video extends EonTB_MenuBase;

// TODO: rewrite the resolution mess

struct DisplayMode
{
	var int		Width;
	var int		Height;
};

var() array<GUIListElem>	TextureDetailLevels;

var() array<GUIListElem>	Resolutions;
var() array<GUIListElem>	BitDepthText;

var() array<GUIListElem>	WorldDetailLevels;
var() array<GUIListElem>	PhysicsDetailLevels;
var() array<GUIListElem>	DecalDetailLevels;
var() array<GUIListElem>	ShadowDetailLevels;
var() array<GUIListElem>	RagdollDetailLevels;
var() array<GUIListElem>	MeshLODDetailLevels;

var() automated Eon_MenuComboBox	TexturesDetailWorld;
var() automated Eon_MenuComboBox	TexturesDetailPlayer;

var() automated Eon_MenuComboBox	TextureDetailWorld;
var() automated Eon_MenuComboBox	TextureDetailPlayerSkin;
var() automated Eon_MenuComboBox	TextureDetailWeaponSkin;
var() automated Eon_MenuComboBox	TextureDetailTerrain;
var() automated Eon_MenuComboBox	TextureDetailLightmap;
var() automated Eon_MenuComboBox	TextureDetailRenderMap;

var() automated Eon_MenuComboBox	RendResolution;
var() automated Eon_MenuComboBox	RendColorDepth;
var() automated Eon_MenuCheckBox	RendFullScreen;
var() automated Eon_MenuSlider		RendGamma;
var() automated Eon_MenuSlider		RendBrightness;
var() automated Eon_MenuSlider		RendContrast;

var() automated Eon_Section			SRenderer;
var() automated Eon_Section			SDetails;
var() automated Eon_Section			STexturesWorld;
var() automated Eon_Section			STexturesPlayer;

var() automated Eon_MenuComboBox	DetailWorld;
var() automated Eon_MenuComboBox	DetailPhysics;
var() automated Eon_MenuComboBox	DetailDecalStay;
var() automated Eon_MenuComboBox	DetailShadow;
var() automated Eon_MenuComboBox	DetailRagdoll;
var() automated Eon_MenuComboBox	DetailMeshLOD;

var() automated Eon_MenuCheckBox	DetailDecals;
var() automated Eon_MenuCheckBox	DetailCoronas;
var() automated Eon_MenuCheckBox	DetailDetailTextures;
var() automated Eon_MenuCheckBox	DetailProjectors;
var() automated Eon_MenuCheckBox	DetailDecoLayers;
var() automated Eon_MenuCheckBox	DetailDynamicLights;
var() automated Eon_MenuCheckBox	DetailTrilinear;
var() automated Eon_MenuCheckBox	DetailWeather;

var() automated Eon_MenuSlider		DetailFog;
var() automated Eon_MenuSlider		DetailBlur;


var() string	PageVideoApply;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local float	X,Y,W,H,M;
	local int	T,i;



//	TexturesDetailWorld.bTabStop = False;
//	TexturesDetailPlayer.bTabStop = False;

	X = 0.01;
	Y = 0.01;
	W = 0.48;
	H = 0.05;
	M = 0.01;

	SetupComponent( SRenderer, W, 0.35, X, Y, M, T );
	SRenderer.SetupComponent( RendResolution, T );
	SRenderer.SetupComponent( RendColorDepth, T );
	SRenderer.SetupComponent( RendFullScreen, T );
	SRenderer.SetupComponent( RendBrightness, T );
	SRenderer.SetupComponent( RendContrast, T );
	SRenderer.SetupComponent( RendGamma, T );

	SetupComponent( STexturesWorld, W, 0.2, X, Y, M, T );
	STexturesWorld.SetupComponent( TexturesDetailPlayer, T );
	STexturesWorld.SetupComponent( TextureDetailPlayerSkin, T );
	STexturesWorld.SetupComponent( TextureDetailWeaponSkin, T );

	SetupComponent( STexturesPlayer, W, 0.3, X, Y, M, T );
	STexturesPlayer.SetupComponent( TexturesDetailWorld, T );
	STexturesPlayer.SetupComponent( TextureDetailWorld, T );
	STexturesPlayer.SetupComponent( TextureDetailTerrain, T );
	STexturesPlayer.SetupComponent( TextureDetailLightmap, T );
	STexturesPlayer.SetupComponent( TextureDetailRenderMap, T );

	X = 0.51;
	Y = 0.01;
	W = 0.48;
	H = 0.05;

	SetupComponent( SDetails, W, 0.8725, X, Y, M, T );
	SDetails.SetupComponent( DetailWorld, T );
	SDetails.SetupComponent( DetailPhysics, T );
	SDetails.SetupComponent( DetailShadow, T );
	SDetails.SetupComponent( DetailRagdoll, T );
	SDetails.SetupComponent( DetailMeshLOD, T );
	SDetails.SetupComponent( DetailDecalStay, T );
	SDetails.SetupComponent( DetailDecals, T );
	SDetails.SetupComponent( DetailCoronas, T );
	SDetails.SetupComponent( DetailDetailTextures, T );
	SDetails.SetupComponent( DetailProjectors, T );
	SDetails.SetupComponent( DetailDecoLayers, T );
	SDetails.SetupComponent( DetailWeather, T );
	SDetails.SetupComponent( DetailDynamicLights, T );
	SDetails.SetupComponent( DetailTrilinear, T );
	SDetails.SetupComponent( DetailFog, T );
	SDetails.SetupComponent( DetailBlur, T );


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

	TexturesDetailWorld.SetContents( TextureDetailLevels );
	TexturesDetailPlayer.SetContents( TextureDetailLevels );
	TextureDetailWorld.SetContents( TextureDetailLevels );
	TextureDetailPlayerSkin.SetContents( TextureDetailLevels );
	TextureDetailWeaponSkin.SetContents( TextureDetailLevels );
	TextureDetailTerrain.SetContents( TextureDetailLevels );
	TextureDetailLightmap.SetContents( TextureDetailLevels );
	TextureDetailRenderMap.SetContents( TextureDetailLevels );

	DetailWorld.SetContents( WorldDetailLevels );
	DetailPhysics.SetContents( PhysicsDetailLevels );
	DetailDecalStay.SetContents( DecalDetailLevels );
	DetailShadow.SetContents( ShadowDetailLevels );
	DetailRagdoll.SetContents( RagdollDetailLevels );
	DetailMeshLOD.SetContents( MeshLODDetailLevels );

	RendResolution.SetContents( Resolutions );
	RendColorDepth.SetContents( BitDepthText );
}

function ShowPanel(bool bShow)
{
	Super.ShowPanel(bShow);
	if( bShow )
		CheckSliders();
}

function CheckSupportedResolutions()
{
	local int				HighestRes, B, i;
	local string			CurrentSelection;
	local PlayerController	P;

	P = PlayerOwner();
	B = int( GetBitDepth() );

	CurrentSelection = RendResolution.GetText();
	RendResolution.Clear();

	// Don't let user create non-fullscreen window bigger than highest
	// supported resolution, or MacOS X client crashes. --ryan.
	if( !RendFullScreen.IsChecked() )
	{
		for(i=0; i<Resolutions.Length; i++)
			if( bool(P.ConsoleCommand(Resolutions[i].ExtraStrData $ B)) )
				HighestRes = i;

		for(i=0; i<=HighestRes; i++)
			RendResolution.AddItem( Resolutions[i].Item );

	}
	else  // Set dropdown for fullscreen modes...
	{
		for(i=0; i<Resolutions.Length; i++)
			if( bool(P.ConsoleCommand(Resolutions[i].ExtraStrData $ B)) )
				RendResolution.AddItem( Resolutions[i].Item );
	}

	RendResolution.SetText( CurrentSelection );
	CheckSliders();
}



function CheckSliders()
{
	// SDLDrv can adjust gamma ramps in a Window, WinDrv can't...  --ryan.
	if( IsFullScreen() || !PlatformIsWindows() )
	{
		EnableComponent(RendGamma);
		EnableComponent(RendContrast);
		EnableComponent(RendBrightness);
	}
	else
	{
		DisableComponent(RendGamma);
		DisableComponent(RendContrast);
		DisableComponent(RendBrightness);
	}

	// TODO: Implement
	DisableComponent(TexturesDetailWorld);
	DisableComponent(TexturesDetailPlayer);

}

final function string GetResolution()
{
	if( Controller.GameResolution != "" )	return Controller.GameResolution;
	else									return Controller.GetCurrentRes();
}

final function string GetBitDepth( optional bool bText )
{
	local int i;
	i = int(!bool(PlayerOwner().ConsoleCommand("get ini:Engine.Engine.RenderDevice Use16bit")));
	return Eval(bText, BitDepthText[i].Item, BitDepthText[i].ExtraStrData);
}

final function bool IsFullScreen()
{
	return bool(PlayerOwner().ConsoleCommand("ISFULLSCREEN"));
}

function ApplyChanges(GUIComponent Sender)
{
	local string DesiredRes;

	DesiredRes = RendResolution.GetText() $"x"$ RendColorDepth.GetExtra();
	DesiredRes = DesiredRes $ Eval(RendFullScreen.IsChecked(), "f", "w");

	Controller.OpenMenu(PageVideoApply, DesiredRes);
	CheckSliders();
}

function ILoadINI(GUIComponent Sender, string S)
{
	local PlayerController	P;
	local int				i;

	P = PlayerOwner();
//	if( GUIMenuOption(Sender) != None )
//		Log("ILoadINI" @ GUIMenuOption(Sender).Caption @ s, 'GUI');

	switch( Sender )
	{
		case TextureDetailWorld:
		case TextureDetailPlayerSkin:
		case TextureDetailWeaponSkin:
		case TextureDetailTerrain:
		case TextureDetailLightmap:
		case TextureDetailRendermap:	Eon_MenuComboBox(Sender).SetExtra(S);				break;

		case RendResolution:			RendResolution.SetText( GetResolution() );			break;
		case RendColorDepth:			RendColorDepth.SetText( GetBitDepth(true) );		break;
		case RendFullScreen:			RendFullScreen.Checked( IsFullScreen() );			break;
		case RendGamma:					RendGamma.SetComponentValue( float(S), true );		break;
		case RendContrast:				RendContrast.SetComponentValue( float(S), true );	break;
		case RendBrightness:			RendBrightness.SetComponentValue( float(S), true );	break;

		case DetailBlur:				DetailBlur.SetValue( class'Eon_Pawn'.default.MotionBlur );			break;
		case DetailDynamicLights:		DetailDynamicLights.Checked( !bool(S) );									break;
		case DetailPhysics: 			DetailPhysics.SetIndexText( P.Level.default.PhysicsDetailLevel );			break;
		case DetailDecalStay: 			DetailDecalStay.SetIndexText( Clamp(P.Level.default.DecalStayScale,0,2) );	break;
		case DetailShadow: 				DetailShadow.SetIndexText( class'Eon_Pawn'.default.ShadowType );			break;
		case DetailRagdoll: 			DetailRagdoll.SetIndexText( class'Eon_Pawn'.default.RagdollDetail );		break;
		case DetailMeshLOD: 			DetailMeshLOD.SetIndexText( class'LevelInfo'.default.MeshLODDetailLevel );	break;
		case DetailFog:					DetailFog.SetComponentValue( float(S), true );								break;

		case DetailDecals:				DetailDecals.SetComponentValue( bool(S), true );			break;
		case DetailCoronas:				DetailCoronas.SetComponentValue( bool(S), true );			break;
		case DetailDetailTextures:		DetailDetailTextures.SetComponentValue( bool(S), true );	break;
		case DetailProjectors:			DetailProjectors.SetComponentValue( bool(S), true );		break;
		case DetailDecoLayers:			DetailDecoLayers.SetComponentValue( bool(S), true );		break;
		case DetailWeather:				DetailWeather.SetComponentValue( bool(S), true );			break;
		case DetailTrilinear:			DetailTrilinear.SetComponentValue( bool(S), true );			break;

		case DetailWorld:
			if( bool(P.ConsoleCommand("get ini:Engine.Engine.RenderDevice HighDetailActors")) )			i = 1;
			if( bool(P.ConsoleCommand("get ini:Engine.Engine.RenderDevice SuperHighDetailActors")) )	i = 2;
			DetailWorld.SetIndexText( i );
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
		case TextureDetailWorld:
		case TextureDetailPlayerSkin:
		case TextureDetailWeaponSkin:
		case TextureDetailTerrain:
		case TextureDetailLightmap:
		case TextureDetailRendermap:
			P.ConsoleCommand("set" @ Sender.INIOption @ Eon_MenuComboBox(Sender).GetExtra() );
			P.ConsoleCommand("flush");
		break;

		case RendResolution:			ApplyChanges(Sender);		break;
		case RendColorDepth:			ApplyChanges(Sender);		break;
		case RendFullScreen:			ApplyChanges(Sender);		break;
		case RendGamma:					P.ConsoleCommand("GAMMA" @ RendGamma.GetValue());							break;
		case RendBrightness:			P.ConsoleCommand("BRIGHTNESS" @ RendBrightness.GetValue());				break;
		case RendContrast:				P.ConsoleCommand("CONTRAST" @ RendContrast.GetValue());					break;

		case DetailDynamicLights:		P.ConsoleCommand("set" @ Sender.INIOption @ !DetailDynamicLights.IsChecked());	break;

		case DetailWorld:
			i = DetailWorld.GetIndex();
			P.ConsoleCommand("set ini:Engine.Engine.RenderDevice HighDetailActors" @ (i>0));
			P.ConsoleCommand("set ini:Engine.Engine.RenderDevice SuperHighDetailActors" @ (i>1));
			P.Level.DetailChange( EDetailMode(i) );
		break;

		case DetailBlur:
			P.ConsoleCommand("MOTIONBLUR" @ DetailBlur.GetValue());
			class'Eon_Pawn'.default.MotionBlur = DetailBlur.GetValue();
			class'Eon_Pawn'.static.StaticSaveConfig();
		break;

		case DetailPhysics:
			P.Level.default.PhysicsDetailLevel = EPhysicsDetailLevel(DetailPhysics.GetIndex());
			P.Level.PhysicsDetailLevel = P.Level.default.PhysicsDetailLevel;
			P.Level.SaveConfig();
		break;

		case DetailShadow:
			class'Eon_Pawn'.default.ShadowType = EShadowDetail(DetailShadow.GetIndex());
			class'Eon_Pawn'.static.StaticSaveConfig();
		break;

		case DetailDecalStay:
			P.Level.default.DecalStayScale = DetailDecalStay.GetIndex();
			P.Level.DecalStayScale = P.Level.default.DecalStayScale;
			P.Level.SaveConfig();
		break;

		case DetailWeather:
		case DetailTrilinear:
		case DetailDecals:
		case DetailCoronas:
		case DetailDetailTextures:
		case DetailProjectors:
		case DetailDecoLayers:
			P.ConsoleCommand("set" @ Sender.INIOption @ Eon_MenuCheckBox(Sender).IsChecked() );
		break;

		case DetailRagdoll:
			class'Eon_Pawn'.default.RagdollDetail = ERagdollDetail(DetailRagdoll.GetIndex());
			class'Eon_Pawn'.static.StaticSaveConfig();
		break;						break;

		case DetailFog:
			P.ConsoleCommand("set" @ Sender.INIOption @ DetailFog.GetValue() );
		break;
	}
}


/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	// Sections ----------------------------------------------------------------

	Begin Object Class=Eon_Section Name=oSRenderer
	End Object

	Begin Object Class=Eon_Section Name=oSDetails
	End Object

	Begin Object Class=Eon_Section Name=oSTexturesWorld
	End Object

	Begin Object Class=Eon_Section Name=oSTexturesPlayer
	End Object

	SRenderer			= oSRenderer
	SDetails			= oSDetails
	STexturesPlayer		= oSTexturesPlayer
	STexturesWorld		= oSTexturesWorld


	// Section Renderer --------------------------------------------------------

	Begin Object class=Eon_MenuComboBox Name=oRendResolution
		INIDefault="640x480"
		Hint="Select the video resolution at which you wish to play."
		Caption="Resolution"
	End Object

	Begin Object class=Eon_MenuComboBox Name=oRendColorDepth
		INIDefault="false"
		Hint="Select the maximum number of colors to display at one time."
		Caption="Color Depth"
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oRendFullScreen
		Caption="Full Screen"
		INIDefault="True"
		Hint="Check this box to run the game full screen."
	End Object

	Begin Object class=Eon_MenuSlider Name=oRendGamma
		MinValue=0.5
		MaxValue=2.5
		INIDefault="1.0"
		INIOption="ini:Engine.Engine.ViewportManager Gamma"
		Hint="Use the slider to adjust the Gamma to suit your monitor."
		Caption="Gamma"
	End Object

	Begin Object class=Eon_MenuSlider Name=oRendBrightness
		MinValue=0
		MaxValue=1
		INIDefault="0.5"
		INIOption="ini:Engine.Engine.ViewportManager Brightness"
		Hint="Use the slider to adjust the Brightness to suit your monitor."
		Caption="Brightness"
	End Object

	Begin Object class=Eon_MenuSlider Name=oRendContrast
		MinValue=0
		MaxValue=1
		INIDefault="0.5"
		INIOption="ini:Engine.Engine.ViewportManager Contrast"
		Hint="Use the slider to adjust the Contrast to suit your monitor."
		Caption="Contrast"
	End Object

	RendResolution		= oRendResolution
	RendColorDepth		= oRendColorDepth
	RendFullScreen		= oRendFullScreen
	RendGamma			= oRendGamma
	RendBrightness		= oRendBrightness
	RendContrast		= oRendContrast


	// Section Textures Player -------------------------------------------------


	Begin Object class=Eon_MenuComboBox Name=oTexturesDetailPlayer
		Caption="Player Textures"
		Hint="Player Textures"
	End Object

	Begin Object class=Eon_MenuComboBox Name=oTextureDetailPlayerSkin
		INIOption="ini:Engine.Engine.ViewportManager TextureDetailPlayerSkin"
		Hint="Player Texture Detail"
		Caption="Player"
	End Object

	Begin Object class=Eon_MenuComboBox Name=oTextureDetailWeaponSkin
		INIOption="ini:Engine.Engine.ViewportManager TextureDetailWeaponSkin"
		Hint="Weapon Texture Detail"
		Caption="Weapon"
	End Object

	TexturesDetailPlayer		= oTexturesDetailPlayer
	TextureDetailPlayerSkin		= oTextureDetailPlayerSkin
	TextureDetailWeaponSkin		= oTextureDetailWeaponSkin


	// Section Textures World --------------------------------------------------

	Begin Object class=Eon_MenuComboBox Name=oTexturesDetailWorld
		Caption="World Textures"
		Hint="World Textures"
	End Object

	Begin Object class=Eon_MenuComboBox Name=oTextureDetailWorld
		INIOption="ini:Engine.Engine.ViewportManager TextureDetailWorld"
		Hint="World Texture Detail"
		Caption="World"
	End Object

	Begin Object class=Eon_MenuComboBox Name=oTextureDetailTerrain
		INIOption="ini:Engine.Engine.ViewportManager TextureDetailTerrain"
		Hint="Terrain Texture Detail"
		Caption="Terrain"
	End Object

	Begin Object class=Eon_MenuComboBox Name=oTextureDetailLightmap
		INIOption="ini:Engine.Engine.ViewportManager TextureDetailLightmap"
		Hint="Lightmap Texture Detail"
		Caption="Lightmap"
	End Object

	Begin Object class=Eon_MenuComboBox Name=oTextureDetailRendermap
		INIOption="ini:Engine.Engine.ViewportManager TextureDetailRendermap"
		Hint="Rendermap Texture Detail"
		Caption="Rendermap"
	End Object

	TexturesDetailWorld			= oTexturesDetailWorld
	TextureDetailWorld			= oTextureDetailWorld
	TextureDetailTerrain		= oTextureDetailTerrain
	TextureDetailLightmap		= oTextureDetailLightmap
	TextureDetailRendermap		= oTextureDetailRendermap


	// Section Details ---------------------------------------------------------

	Begin Object class=Eon_MenuComboBox Name=oDetailWorld
		Hint="Changes the level of detail used for optional geometry and effects."
		Caption="World Detail"
	End Object

	Begin Object class=Eon_MenuSlider Name=oDetailBlur
		MinValue=0
		MaxValue=1
		Hint="Use the slider to adjust the Motion Blur."
		Caption="Motion Blur"
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailDynamicLights
		Caption="Dynamic Lighting"
		Hint="Enables dynamic lights."
		INIDefault="True"
		INIOption="ini:Engine.Engine.ViewportManager NoDynamicLights"
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailTrilinear
		Caption="Trilinear Filtering"
		Hint="Enable Trilinear filtering, recommended for high-performance PCs."
		INIDefault="False"
		INIOption="ini:Engine.Engine.RenderDevice UseTrilinear"
	End Object

	Begin Object class=Eon_MenuComboBox Name=oDetailShadow
		Caption="Shadow Type"
		Hint="Shadow Type."
	End Object

	Begin Object class=Eon_MenuComboBox Name=oDetailPhysics
		Caption="Physics Detail"
		Hint="Changes the physics simulation level of detail."
		INIDefault="High"
	End Object

	Begin Object class=Eon_MenuComboBox Name=oDetailMeshLOD
		Caption="Dynamic Mesh LOD"
		Hint="Dynamic Mesh LOD"
		INIDefault="Medium"
	End Object

	Begin Object class=Eon_MenuComboBox Name=oDetailDecalStay
		Caption="Decal Stay"
		Hint="Changes how long weapon scarring effects stay around."
		INIDefault="Normal"
	End Object

	Begin Object class=Eon_MenuComboBox Name=oDetailRagdoll
		Caption="Ragdoll Detail"
		Hint="Changes the ragdoll complexity."
		INIDefault="High"
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailDecals
		Caption="Decals"
		Hint="Enables weapon scarring effects."
		INIOption="ini:Engine.Engine.ViewportManager Decals"
		INIDefault="True"
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailCoronas
		Caption="Coronas"
		Hint="Enables coronas."
		INIDefault="True"
		INIOption="ini:Engine.Engine.ViewportManager Coronas"
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailDetailTextures
		Caption="Detail Textures"
		Hint="Enables detail textures."
		INIDefault="True"
		INIOption="ini:Engine.Engine.RenderDevice DetailTextures"
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailProjectors
		Caption="Projectors"
		Hint="Enables Projectors."
		INIDefault="True"
		INIOption="ini:Engine.Engine.ViewportManager Projectors"
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailDecoLayers
		Caption="Foliage"
		Hint="Enables grass and other decorative foliage."
		INIDefault="True"
		INIOption="ini:Engine.Engine.ViewportManager DecoLayers"
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailWeather
		Caption="Weather"
		Hint="Weather effects."
		INIDefault="True"
		INIOption="ini:Engine.Engine.ViewportManager WeatherEffects"
	End Object

	Begin Object class=Eon_MenuSlider Name=oDetailFog
		MinValue=0
		MaxValue=1
		INIDefault="0.5"
		INIOption="ini:Engine.Engine.ViewportManager DrawDistanceLOD"
		Hint="Fog"
		Caption="Fog"
	End Object

	DetailWorld				= oDetailWorld
	DetailPhysics			= oDetailPhysics
	DetailDecalStay			= oDetailDecalStay
	DetailShadow			= oDetailShadow
	DetailDecals			= oDetailDecals
	DetailMeshLOD			= oDetailMeshLOD
	DetailCoronas			= oDetailCoronas
	DetailDetailTextures	= oDetailDetailTextures
	DetailProjectors		= oDetailProjectors
	DetailDecoLayers		= oDetailDecoLayers
	DetailRagdoll			= oDetailRagdoll
	DetailFog				= oDetailFog
	DetailWeather			= oDetailWeather
	DetailTrilinear			= oDetailTrilinear
	DetailBlur				= oDetailBlur
	DetailDynamicLights		= oDetailDynamicLights

	// -------------------------------------------------------------------------

	Resolutions(0)=(Item="320x240",ExtraStrData="SupportedResolution WIDTH=320 HEIGHT=240 BITDEPTH=")
	Resolutions(1)=(Item="512x384",ExtraStrData="SupportedResolution WIDTH=512 HEIGHT=384 BITDEPTH=")
	Resolutions(2)=(Item="640x480",ExtraStrData="SupportedResolution WIDTH=640 HEIGHT=480 BITDEPTH=")
	Resolutions(3)=(Item="800x500",ExtraStrData="SupportedResolution WIDTH=800 HEIGHT=500 BITDEPTH=")
	Resolutions(4)=(Item="800x600",ExtraStrData="SupportedResolution WIDTH=800 HEIGHT=600 BITDEPTH=")
	Resolutions(5)=(Item="1024x640",ExtraStrData="SupportedResolution WIDTH=1024 HEIGHT=640 BITDEPTH=")
	Resolutions(6)=(Item="1024x768",ExtraStrData="SupportedResolution WIDTH=1027 HEIGHT=768 BITDEPTH=")
	Resolutions(7)=(Item="1152x864",ExtraStrData="SupportedResolution WIDTH=1152 HEIGHT=864 BITDEPTH=")
	Resolutions(8)=(Item="1280x800",ExtraStrData="SupportedResolution WIDTH=1280 HEIGHT=800 BITDEPTH=")
	Resolutions(9)=(Item="1280x960",ExtraStrData="SupportedResolution WIDTH=1280 HEIGHT=960 BITDEPTH=")
	Resolutions(10)=(Item="1280x1024",ExtraStrData="SupportedResolution WIDTH=1280 HEIGHT=1024 BITDEPTH=")
	Resolutions(11)=(Item="1600x1200",ExtraStrData="SupportedResolution WIDTH=1600 HEIGHT=1200 BITDEPTH=")
	Resolutions(12)=(Item="1680x1050",ExtraStrData="SupportedResolution WIDTH=1680 HEIGHT=1050 BITDEPTH=")
	Resolutions(13)=(Item="1920x1200",ExtraStrData="SupportedResolution WIDTH=1920 HEIGHT=1200 BITDEPTH=")

	BitDepthText(0)=(Item="16-bit color",ExtraStrData="16")
	BitDepthText(1)=(Item="32-bit color",ExtraStrData="32")

	TextureDetailLevels(0)=(Item="Lowest",ExtraStrData="UltraLow")
	TextureDetailLevels(1)=(Item="Very Low",ExtraStrData="VeryLow")
	TextureDetailLevels(2)=(Item="Low",ExtraStrData="Low")
	TextureDetailLevels(3)=(Item="Lower",ExtraStrData="Lower")
	TextureDetailLevels(4)=(Item="Normal",ExtraStrData="Normal")
	TextureDetailLevels(5)=(Item="Higher",ExtraStrData="Higher")
	TextureDetailLevels(6)=(Item="High",ExtraStrData="High")
	TextureDetailLevels(7)=(Item="Very High",ExtraStrData="VeryHigh")
	TextureDetailLevels(8)=(Item="Highest",ExtraStrData="UltraHigh")

	WorldDetailLevels(0)=(Item="Normal")
	WorldDetailLevels(1)=(Item="High")
	WorldDetailLevels(2)=(Item="Super High")

	PhysicsDetailLevels(0)=(Item="High")
	PhysicsDetailLevels(1)=(Item="Normal")
	PhysicsDetailLevels(2)=(Item="Low")

	DecalDetailLevels(1)=(Item="Normal")
	DecalDetailLevels(2)=(Item="High")
	DecalDetailLevels(0)=(Item="Low")

	RagdollDetailLevels(0)=(Item="High")
	RagdollDetailLevels(1)=(Item="Normal")
	RagdollDetailLevels(2)=(Item="Low")

	ShadowDetailLevels(0)=(Item="None")
	ShadowDetailLevels(1)=(Item="Blob")
	ShadowDetailLevels(2)=(Item="Static")
	ShadowDetailLevels(3)=(Item="Sun Based")

	MeshLODDetailLevels(0)=(Item="Low")
	MeshLODDetailLevels(1)=(Item="Medium")
	MeshLODDetailLevels(2)=(Item="High")
	MeshLODDetailLevels(3)=(Item="Ultra")

	PageVideoApply="EonInterface.EonPG_VideoApply"
}
