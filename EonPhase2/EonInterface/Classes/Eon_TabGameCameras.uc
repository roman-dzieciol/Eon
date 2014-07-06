/* =============================================================================
:: File Name	::	Eon_TabGameCameras.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabGameCameras extends Eon_TabGameBase;


var() Eon_ListBox			AnimationList;
var() Eon_MenuEditBox		TweenTime;
var() Eon_MenuEditBox		CamRotBone;
var() Eon_MenuEditBox		CamLocBone;
var() bool					bInitialized;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	AnimationList	= Eon_ListBox(Controls[0]);
	TweenTime		= Eon_MenuEditBox(Controls[1]);
	CamRotBone		= Eon_MenuEditBox(Controls[2]);
	CamLocBone		= Eon_MenuEditBox(Controls[3]);

	TweenTime.FloatOnly(true);

	InitLists();
}

function InitLists()
{
	local EonPC_Base		P;
	local EonGI_Base		G;
	local Eon_CameraMan		C;
	local int				i;

	P = EonPC_Base(PlayerOwner());	if( P == None )	return;
	G = EonGI_Base(P.Level.Game);		if( G == None )	return;
	C = G.Cameras[0];					if( C == None )	return;

	AnimationList.List.Clear();
	for(i=0; i<C.Animations.Length; i++)
	{
		AnimationList.List.Add( string(C.Animations[i]) );
	}
	P.SetViewTarget(C);

	CamLocBone.SetText( string(C.CamLocBone) );
	CamRotBone.SetText( string(C.CamRotBone) );

	bInitialized = true;
}

singular function InternalOnChange(GUIComponent Sender)
{
	local EonPC_Base		P;
	local EonGI_Base		G;
	local Eon_CameraMan		C;

	if( !bInitialized )									return;
	P = EonPC_Base(PlayerOwner());		if( P == None )	return;
	G = EonGI_Base(P.Level.Game);		if( G == None )	return;
	C = G.Cameras[0];					if( C == None )	return;

	switch( Sender )
	{
		case CamRotBone:
			C.SetPropertyText("CamRotBone", CamRotBone.GetText());
			if( string(C.CamRotBone) ~= CamRotBone.GetText())
			{
				CamRotBone.SetText( string(C.CamRotBone) );
				CamRotBone.MyEditBox.bAllSelected = false;
			}
			//C.SaveConfig();
		break;

		case CamLocBone:
			C.SetPropertyText("CamLocBone", CamLocBone.GetText());
			if( string(C.CamLocBone) ~= CamLocBone.GetText())
			{
				CamLocBone.SetText( string(C.CamLocBone) );
				CamLocBone.MyEditBox.bAllSelected = false;
			}
			//C.SaveConfig();
		break;

		case AnimationList:
			P.SetViewTarget(C);
			C.PlayAnim(C.Animations[AnimationList.List.Index],,float(TweenTime.GetText()));
		break;
	}
	return;
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{


	Begin Object Class=Eon_ListBox Name=oAnimationList
		WinWidth=0.45
		WinHeight=0.7
		WinLeft=0.0
		WinTop=0.3
		bVisibleWhenEmpty=true
		Hint="Select animation"
		StyleName="EonListBoxDebug"
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuEditBox Name=oTweenTime
		WinWidth=0.45
		WinHeight=0.06
		WinLeft=0.0
		WinTop=0.0
		Caption="Tween Time"
		CaptionWidth=0.5
		StyleName="EonEditBoxDebug"
	End Object

	Begin Object class=Eon_MenuEditBox Name=oCamRotBone
		WinWidth=0.45
		WinHeight=0.06
		WinLeft=0.0
		WinTop=0.12
		Caption="CamRot Bone"
		CaptionWidth=0.5
		StyleName="EonEditBoxDebug"
		OnChange=InternalOnChange
	End Object

	Begin Object class=Eon_MenuEditBox Name=oCamLocBone
		WinWidth=0.45
		WinHeight=0.06
		WinLeft=0.0
		WinTop=0.18
		Caption="CamLoc Bone"
		CaptionWidth=0.5
		StyleName="EonEditBoxDebug"
		OnChange=InternalOnChange
	End Object

	Controls(0)=oAnimationList
	Controls(1)=oTweenTime
	Controls(2)=oCamRotBone
	Controls(3)=oCamLocBone
}
