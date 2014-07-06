/* =============================================================================
:: File Name	::	Eon_TabMenuPlay.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabMenuPlay extends Eon_TabMenuBase;


var() Eon_MenuComboBox		GameCombo;
var() Eon_ListBox			MapsList;
var() bool					bInitialized;
var() string				PlayURL;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	GameCombo	= Eon_MenuComboBox(Controls[0]);
	MapsList	= Eon_ListBox(Controls[1]);

	InitLists();
}

function InitLists()
{
	GameCombo.AddItem( "Eon Practice",, 		"EonEngine.EonGI_Base" );
	GameCombo.AddItem( "CameraMan CrashTest",,	"EonEngine.Eon_GameCinematic" );
	GameCombo.SetIndex(0);
	GameCombo.bReadOnly = true;

	ReadMapList("EON-");
	bInitialized = true;
}

singular function InternalOnChange(GUIComponent Sender)
{
	if( !bInitialized )									return;

	switch( Sender )
	{
		case GameCombo:
			PlayURL = MapsList.List.Get() $ "?Game=" $ GameCombo.GetExtra();
		break;

		case MapsList:
			PlayURL = MapsList.List.Get() $ "?Game=" $ GameCombo.GetExtra();
		break;
	}
	return;
}

function ReadMapList( string MapPreFix )
{
	MapsList.List.Clear();
	Controller.GetMapList(MapPrefix,MapsList.List);
	MapsList.List.SortList();
	MapsList.List.SetIndex(0);
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object class=Eon_MenuComboBox Name=oGameCombo
		WinWidth=0.45
		WinHeight=0.065
		WinLeft=0.0
		WinTop=0.0
		OnChange=InternalOnChange
		Hint="Game Type"
		Caption="Game Type"
		CaptionWidth=0.3
	End Object

	Begin Object Class=Eon_ListBox Name=oMapsList
		WinWidth=0.45
		WinHeight=0.7
		WinLeft=0.0
		WinTop=0.3
		bVisibleWhenEmpty=true
		Hint="oMapList"
		OnChange=InternalOnChange
	End Object

	Controls(0)=oGameCombo
	Controls(1)=oMapsList
}
