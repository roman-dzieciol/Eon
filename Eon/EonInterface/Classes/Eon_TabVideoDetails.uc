/* =============================================================================
:: File Name	::	Eon_TabVideoDetails.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.40 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabVideoDetails extends Eon_TabMenuBase;

#include ../Eon/_inc/const/RagdollDetail.uc
#include ../Eon/_inc/const/ShadowType.uc

// localized names for the menu
var() string				TextureDetailLevels[9];
var() string				ActorDetailLevels[3];
var() string				PhysicsDetailLevels[3];
var() string				DecalStayDetailLevels[3];
var() string				ShadowDetailLevels[4];
var() string				RagdollDetailLevels[3];

// real names used in the config
var() string				TextureDetailNames[9];
var() string				DecalStayDetailNames[9];

var() Eon_MenuComboBox		TextureDetailWorld;
var() Eon_MenuComboBox		TextureDetailPlayerSkin;
var() Eon_MenuComboBox		TextureDetailWeaponSkin;
var() Eon_MenuComboBox		TextureDetailTerrain;
var() Eon_MenuComboBox		TextureDetailLightmap;
var() Eon_MenuComboBox		TextureDetailInterface;

var() Eon_MenuComboBox		DetailActor;
var() Eon_MenuComboBox		DetailPhysics;
var() Eon_MenuComboBox		DetailDecalStay;
var() Eon_MenuComboBox		DetailShadow;
var() Eon_MenuComboBox		DetailRagdoll;

var() Eon_MenuCheckBox		DetailDecals;
var() Eon_MenuCheckBox		DetailCoronas;
var() Eon_MenuCheckBox		DetailDetailTextures;
var() Eon_MenuCheckBox		DetailProjectors;
var() Eon_MenuCheckBox		DetailDecoLayers;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local int i;
	Super.InitComponent(MyController, MyOwner);

	TextureDetailWorld		= Eon_MenuComboBox(Controls[0]);
	TextureDetailPlayerSkin	= Eon_MenuComboBox(Controls[1]);
	TextureDetailWeaponSkin	= Eon_MenuComboBox(Controls[2]);
	TextureDetailTerrain	= Eon_MenuComboBox(Controls[3]);
	TextureDetailLightmap	= Eon_MenuComboBox(Controls[4]);
	TextureDetailInterface	= Eon_MenuComboBox(Controls[5]);

	DetailActor				= Eon_MenuComboBox(Controls[6]);
	DetailPhysics			= Eon_MenuComboBox(Controls[7]);
	DetailDecalStay			= Eon_MenuComboBox(Controls[8]);
	DetailShadow			= Eon_MenuComboBox(Controls[9]);

	DetailDecals			= Eon_MenuCheckBox(Controls[10]);
	DetailCoronas			= Eon_MenuCheckBox(Controls[11]);
	DetailDetailTextures	= Eon_MenuCheckBox(Controls[12]);
	DetailProjectors		= Eon_MenuCheckBox(Controls[13]);
	DetailDecoLayers		= Eon_MenuCheckBox(Controls[14]);

	DetailRagdoll			= Eon_MenuComboBox(Controls[15]);

	for( i=0; i<ArrayCount(TextureDetailLevels); i++ )
	{
		TextureDetailWorld.AddItem(TextureDetailLevels[i]);
		TextureDetailPlayerSkin.AddItem(TextureDetailLevels[i]);
		TextureDetailWeaponSkin.AddItem(TextureDetailLevels[i]);
		TextureDetailTerrain.AddItem(TextureDetailLevels[i]);
		TextureDetailLightmap.AddItem(TextureDetailLevels[i]);
		TextureDetailInterface.AddItem(TextureDetailLevels[i]);
	}

	DetailActor.AddItem(ActorDetailLevels[0]);
	DetailActor.AddItem(ActorDetailLevels[1]);
	DetailActor.AddItem(ActorDetailLevels[2]);

	DetailPhysics.AddItem(PhysicsDetailLevels[0]);
	DetailPhysics.AddItem(PhysicsDetailLevels[1]);
	DetailPhysics.AddItem(PhysicsDetailLevels[2]);

	DetailDecalStay.AddItem(DecalStayDetailLevels[0]);
	DetailDecalStay.AddItem(DecalStayDetailLevels[1]);
	DetailDecalStay.AddItem(DecalStayDetailLevels[2]);

	DetailShadow.AddItem(ShadowDetailLevels[0]);
	DetailShadow.AddItem(ShadowDetailLevels[1]);
	DetailShadow.AddItem(ShadowDetailLevels[2]);
	DetailShadow.AddItem(ShadowDetailLevels[3]);

	DetailRagdoll.AddItem(RagdollDetailLevels[0]);
	DetailRagdoll.AddItem(RagdollDetailLevels[1]);
	DetailRagdoll.AddItem(RagdollDetailLevels[2]);
}


function InternalOnLoadINI(GUIComponent Sender, string s)
{
	local bool a, b;

	switch( Sender )
	{
		case TextureDetailWorld:
		case TextureDetailPlayerSkin:
		case TextureDetailWeaponSkin:
		case TextureDetailTerrain:
		case TextureDetailLightmap:
		case TextureDetailInterface:
			Eon_MenuComboBox(Sender).SetText( TextureDetailLevels[ GetTextureDetailIndex(s) ] );
		break;

		case DetailActor:
			a = bool(PlayerOwner().ConsoleCommand("get ini:Engine.Engine.RenderDevice HighDetailActors"));
			b = bool(PlayerOwner().ConsoleCommand("get ini:Engine.Engine.RenderDevice SuperHighDetailActors"));
			if( b )			DetailActor.SetText( ActorDetailLevels[0] );
			else if( a )	DetailActor.SetText( ActorDetailLevels[1] );
			else			DetailActor.SetText( ActorDetailLevels[2] );
		break;

		case DetailPhysics:
			switch( PlayerOwner().Level.default.PhysicsDetailLevel )
			{
				case PDL_High:		DetailPhysics.SetText( PhysicsDetailLevels[0] );	break;
				case PDL_Medium:	DetailPhysics.SetText( PhysicsDetailLevels[1] );	break;
				case PDL_Low:		DetailPhysics.SetText( PhysicsDetailLevels[2] );	break;
			}
		break;

		case DetailDecalStay:
			switch( PlayerOwner().Level.default.DecalStayScale )
			{
				case 2:		DetailDecalStay.SetText( DecalStayDetailLevels[0] );	break;
				case 1:		DetailDecalStay.SetText( DecalStayDetailLevels[1] );	break;
				case 0:		DetailDecalStay.SetText( DecalStayDetailLevels[2] );	break;
			}
		break;

		case DetailShadow:
			switch( class'Eon_Pawn'.default.ShadowType )
			{
				case ST_None:		DetailShadow.SetText( ShadowDetailLevels[0] );	break;
				case ST_Blob:		DetailShadow.SetText( ShadowDetailLevels[1] );	break;
				case ST_Static:		DetailShadow.SetText( ShadowDetailLevels[2] );	break;
				case ST_SunBased:	DetailShadow.SetText( ShadowDetailLevels[3] );	break;
			}
		break;

		case DetailRagdoll:
			switch( class'Eon_Pawn'.default.RagdollDetail )
			{
				case RDL_High:		DetailRagdoll.SetText( RagdollDetailLevels[0] );	break;
				case RDL_Medium:	DetailRagdoll.SetText( RagdollDetailLevels[1] );	break;
				case RDL_Low:		DetailRagdoll.SetText( RagdollDetailLevels[2] );	break;
			}
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
		case TextureDetailWorld:
		case TextureDetailPlayerSkin:
		case TextureDetailWeaponSkin:
		case TextureDetailTerrain:
		case TextureDetailLightmap:
		case TextureDetailInterface:
			PlayerOwner().ConsoleCommand("set" @ Sender.INIOption @ TextureDetailNames[ Eon_MenuComboBox(Sender).GetIndex() ]);
			PlayerOwner().ConsoleCommand("flush");
		break;

		case DetailActor:
			switch( DetailActor.GetIndex() )
			{
				case 0:
					PlayerOwner().ConsoleCommand("set ini:Engine.Engine.RenderDevice HighDetailActors True");
					PlayerOwner().ConsoleCommand("set ini:Engine.Engine.RenderDevice SuperHighDetailActors True");
					PlayerOwner().Level.DetailChange(DM_SuperHigh);
				break;

				case 1:
					PlayerOwner().ConsoleCommand("set ini:Engine.Engine.RenderDevice HighDetailActors True");
					PlayerOwner().ConsoleCommand("set ini:Engine.Engine.RenderDevice SuperHighDetailActors False");
					PlayerOwner().Level.DetailChange(DM_High);
				break;

				case 2:
					PlayerOwner().ConsoleCommand("set ini:Engine.Engine.RenderDevice HighDetailActors False");
					PlayerOwner().ConsoleCommand("set ini:Engine.Engine.RenderDevice SuperHighDetailActors False");
					PlayerOwner().Level.DetailChange(DM_Low);
				break;
			}
		break;

		case DetailPhysics:
			switch( DetailPhysics.GetIndex() )
			{
				case 0:	PlayerOwner().Level.default.PhysicsDetailLevel = PDL_High;		break;
				case 1:	PlayerOwner().Level.default.PhysicsDetailLevel = PDL_Medium;	break;
				case 2:	PlayerOwner().Level.default.PhysicsDetailLevel = PDL_Low;		break;
			}
			PlayerOwner().Level.PhysicsDetailLevel = PlayerOwner().Level.default.PhysicsDetailLevel;
			PlayerOwner().Level.SaveConfig();
		break;

		case DetailShadow:
			switch( DetailShadow.GetIndex() )
			{
				case 0:	class'Eon_Pawn'.default.ShadowType = ST_None;		break;
				case 1:	class'Eon_Pawn'.default.ShadowType = ST_Blob;		break;
				case 2:	class'Eon_Pawn'.default.ShadowType = ST_Static;		break;
				case 3:	class'Eon_Pawn'.default.ShadowType = ST_SunBased;	break;
			}
			class'Eon_Pawn'.static.StaticSaveConfig();
		break;

		case DetailDecalStay:
			switch( DetailDecalStay.GetIndex() )
			{
				case 0:	PlayerOwner().Level.default.DecalStayScale = 2;		break;
				case 1:	PlayerOwner().Level.default.DecalStayScale = 1;		break;
				case 2:	PlayerOwner().Level.default.DecalStayScale = 0;		break;
			}
			PlayerOwner().Level.DecalStayScale = PlayerOwner().Level.default.DecalStayScale;
			PlayerOwner().Level.SaveConfig();
		break;

		case DetailDecals:
		case DetailCoronas:
		case DetailDetailTextures:
		case DetailProjectors:
		case DetailDecoLayers:
			PlayerOwner().ConsoleCommand("set" @ Sender.INIOption @ Eon_MenuCheckBox(Sender).IsChecked());
		break;

		case DetailRagdoll:
			switch( DetailRagdoll.GetIndex() )
			{
				case 0:	class'Eon_Pawn'.default.RagdollDetail = RDL_High;		break;
				case 1:	class'Eon_Pawn'.default.RagdollDetail = RDL_Medium;	break;
				case 2:	class'Eon_Pawn'.default.RagdollDetail = RDL_Low;		break;
			}
			class'Eon_Pawn'.static.StaticSaveConfig();
		break;
	}
}

function byte GetTextureDetailIndex( string S )
{
	switch( S )
	{
		case "UltraHigh":	return 0;
		case "VeryHigh":	return 1;
		case "High":		return 2;
		case "Higher":		return 3;
		case "Normal":		return 4;
		case "Lower":		return 5;
		case "Low":			return 6;
		case "VeryLow":		return 7;
		case "UltraLow":	return 8;
		default:			return 9;
	}
}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object class=Eon_MenuComboBox Name=oTextureDetailWorld
		WinLeft=0.0
		WinTop=0.1
		CaptionWidth=0.54
		Caption="World Textures"
		Hint="World Texture Detail"
		INIOption="ini:Engine.Engine.ViewportManager TextureDetailWorld"
		INIDefault="Normal"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuComboBox Name=oTextureDetailPlayerSkin
		WinLeft=0.0
		WinTop=0.2
		CaptionWidth=0.54
		Caption="Player Textures"
		Hint="Player Texture Detail"
		INIOption="ini:Engine.Engine.ViewportManager TextureDetailPlayerSkin"
		INIDefault="Normal"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuComboBox Name=oTextureDetailWeaponSkin
		WinLeft=0.0
		WinTop=0.3
		CaptionWidth=0.54
		Caption="Weapon Textures"
		Hint="Weapon Texture Detail"
		INIOption="ini:Engine.Engine.ViewportManager TextureDetailWeaponSkin"
		INIDefault="Normal"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuComboBox Name=oTextureDetailTerrain
		WinLeft=0.55
		WinTop=0.1
		CaptionWidth=0.54
		Caption="Terrain Textures"
		Hint="Terrain Texture Detail"
		INIOption="ini:Engine.Engine.ViewportManager TextureDetailTerrain"
		INIDefault="Normal"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuComboBox Name=oTextureDetailLightmap
		WinLeft=0.55
		WinTop=0.2
		CaptionWidth=0.54
		Caption="Lightmap Textures"
		Hint="Lightmap Texture Detail"
		INIOption="ini:Engine.Engine.ViewportManager TextureDetailLightmap"
		INIDefault="Normal"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuComboBox Name=oTextureDetailInterface
		WinLeft=0.55
		WinTop=0.3
		CaptionWidth=0.54
		Caption="Interface Textures"
		Hint="Interface Texture Detail"
		INIOption="ini:Engine.Engine.ViewportManager TextureDetailInterface"
		INIDefault="Normal"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuComboBox Name=oDetailShadow
		WinLeft=0.55
		WinTop=0.5
		CaptionWidth=0.54
		Caption="Shadow Type"
		Hint="Shadow Type."
		INIOption="@Internal"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuComboBox Name=oDetailActor
		WinLeft=0.55
		WinTop=0.6
		CaptionWidth=0.54
		Caption="Actor Detail"
		Hint="Changes the level of detail used for optional geometry and effects."
		INIOption="@Internal"
		INIDefault="High"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuComboBox Name=oDetailPhysics
		WinLeft=0.55
		WinTop=0.7
		CaptionWidth=0.54
		Caption="Physics Detail"
		Hint="Changes the physics simulation level of detail."
		INIOption="@Internal"
		INIDefault="High"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuComboBox Name=oDetailDecalStay
		WinLeft=0.55
		WinTop=0.8
		CaptionWidth=0.54
		Caption="Decal Stay"
		Hint="Changes how long weapon scarring effects stay around."
		INIOption="@Internal"
		INIDefault="Normal"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuComboBox Name=oDetailRagdoll
		WinLeft=0.55
		WinTop=0.9
		CaptionWidth=0.54
		Caption="Ragdoll Detail"
		Hint="Changes the ragdoll complexity."
		INIOption="@Internal"
		INIDefault="High"
		OnLoadINI=InternalOnLoadINI
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailDecals
		WinLeft=0.0
		WinTop=0.5
		Caption="Decals"
		Hint="Enables weapon scarring effects."
		INIOption="ini:Engine.Engine.ViewportManager Decals"
		INIDefault="True"
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailCoronas
		WinLeft=0.0
		WinTop=0.6
		Caption="Coronas"
		Hint="Enables coronas."
		INIOption="ini:Engine.Engine.ViewportManager Coronas"
		INIDefault="True"
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailDetailTextures
		WinLeft=0.0
		WinTop=0.7
		Caption="Detail Textures"
		Hint="Enables detail textures."
		INIOption="ini:Engine.Engine.RenderDevice DetailTextures"
		INIDefault="True"
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailProjectors
		WinLeft=0.0
		WinTop=0.8
		Caption="Projectors"
		Hint="Enables Projectors."
		INIOption="ini:Engine.Engine.ViewportManager Projectors"
		INIDefault="True"
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuCheckBox Name=oDetailDecoLayers
		WinLeft=0.0
		WinTop=0.9
		Caption="Foliage"
		Hint="Enables grass and other decorative foliage."
		INIOption="ini:Engine.Engine.ViewportManager DecoLayers"
		INIDefault="True"
		OnSaveINI=InternalOnSaveINI
		OnChange=InternalOnChange
	End Object

	Controls(0)=oTextureDetailWorld
	Controls(1)=oTextureDetailPlayerSkin
	Controls(2)=oTextureDetailWeaponSkin
	Controls(3)=oTextureDetailTerrain
	Controls(4)=oTextureDetailLightmap
	Controls(5)=oTextureDetailInterface
	Controls(6)=oDetailActor
	Controls(7)=oDetailPhysics
	Controls(8)=oDetailDecalStay
	Controls(9)=oDetailShadow
	Controls(10)=oDetailDecals
	Controls(11)=oDetailCoronas
	Controls(12)=oDetailDetailTextures
	Controls(13)=oDetailProjectors
	Controls(14)=oDetailDecoLayers
	Controls(15)=oDetailRagdoll

	TextureDetailLevels(0)="UltraHigh"
	TextureDetailLevels(1)="VeryHigh"
	TextureDetailLevels(2)="High"
	TextureDetailLevels(3)="Higher"
	TextureDetailLevels(4)="Normal"
	TextureDetailLevels(5)="Lower"
	TextureDetailLevels(6)="Low"
	TextureDetailLevels(7)="VeryLow"
	TextureDetailLevels(8)="UltraLow"

	ActorDetailLevels(0)="Super High"
	ActorDetailLevels(1)="High"
	ActorDetailLevels(2)="Normal"

	PhysicsDetailLevels(0)="High"
	PhysicsDetailLevels(1)="Normal"
	PhysicsDetailLevels(2)="Low"

	DecalStayDetailLevels(0)="High"
	DecalStayDetailLevels(1)="Normal"
	DecalStayDetailLevels(2)="Low"

	ShadowDetailLevels(0)="None"
	ShadowDetailLevels(1)="Blob"
	ShadowDetailLevels(2)="Static"
	ShadowDetailLevels(3)="Sun Based"

	RagdollDetailLevels(0)="High"
	RagdollDetailLevels(1)="Medium"
	RagdollDetailLevels(2)="Low"

	TextureDetailNames(0)="UltraHigh"
	TextureDetailNames(1)="VeryHigh"
	TextureDetailNames(2)="High"
	TextureDetailNames(3)="Higher"
	TextureDetailNames(4)="Normal"
	TextureDetailNames(5)="Lower"
	TextureDetailNames(6)="Low"
	TextureDetailNames(7)="VeryLow"
	TextureDetailNames(8)="UltraLow"

	DecalStayDetailNames(0)="High"
	DecalStayDetailNames(1)="Normal"
	DecalStayDetailNames(2)="Low"
}
