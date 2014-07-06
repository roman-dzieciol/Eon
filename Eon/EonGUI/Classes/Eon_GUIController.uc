/* =============================================================================
:: File Name	::	Eon_GUIController.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_GUIController extends GUIController config(EonGUI);

var() config array<string>		Styles;	//


event InitializeController()
{
	local int i;
	local class<GUIStyles> NewStyleClass;

	// Register default styles
	for(i=0; i<Styles.Length; i++)
	{
		NewStyleClass = class<GUIStyles>(DynamicLoadObject(Styles[i],class'class'));
		if( NewStyleClass != None)
			if( !RegisterStyle(NewStyleClass) )
				LogGUI("Could not create requested style"@Styles[i]);
	}

	// Init Fonts
	for(i=0; i<FontStack.length; i++)
		FontStack[i].Controller = self;

	class'CacheManager'.static.InitCache();
}

function PurgeObjectReferences()
{
	local class<GUIStyles> OriginalStyle;
	local int i;

	// Remove any temporary (i.e. mod-defined) styles
	for ( i = 0; i < Styles.Length; i++ )
	{
		if ( StyleStack[i] == None )
		{
			OriginalStyle = class<GUIStyles>(DynamicLoadObject(Styles[i],class'Class'));
			if ( !RegisterStyle(OriginalStyle) )
			{
				log("Could not restore default style "$i$" ("$Styles[i]$")");
				continue;
			}
		}

		if ( StyleStack[i].bTemporary )
		{
			OriginalStyle = class<GUIStyles>(DynamicLoadObject(Styles[i],class'Class'));
			if ( !RegisterStyle(OriginalStyle) )
			{
				log("Could not restore default style "$i$" ("$Styles[i]$")");
				StyleStack[i] = None;
			}
		}
	}

	if (StyleStack.Length > Styles.Length)
		StyleStack.Remove(Styles.Length, StyleStack.Length - Styles.Length);

	if (FontStack.Length > FONT_NUM)
		FontStack.Remove(FONT_NUM, FontStack.Length - FONT_NUM);

	if (MouseCursors.Length > CURSOR_NUM)
		MouseCursors.Remove(CURSOR_NUM, MouseCursors.Length - CURSOR_NUM);

	PurgeComponentClasses();
}


function PurgeComponentClasses()
{
	if( RegisteredClasses.Length > 0 )
		RegisteredClasses.Remove(0, RegisteredClasses.Length);

	Super.PurgeComponentClasses();
}

function bool RegisterStyle(class<GUIStyles> StyleClass, optional bool bTemporary)
{
	//LogGUI("Registering" @ StyleClass);
	return Super.RegisterStyle( StyleClass,  bTemporary);
}


// = INC =======================================================================

simulated function LogGUI( coerce string S )	{ Log(S@"["$Name$"]", 'GUI');}

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object Class=Eon_FontDefault Name=oFontDefault
	End Object

	Begin Object Class=Eon_FontMorpheus Name=oFontMorpheus
	End Object

	Begin Object Class=Eon_FontMorpheusHeader Name=oFontMorpheusHeader
	End Object

	Begin Object Class=Eon_FontMorpheusSmaller Name=oFontMorpheusSmaller
	End Object

	FontStack(9)=oFontDefault
	FontStack(10)=oFontMorpheus
	FontStack(11)=oFontMorpheusHeader
	FontStack(12)=oFontMorpheusSmaller
	FONT_NUM=13


	 MouseCursors(0)=Texture'2K4Menus.Cursors.Pointer'
	 MouseCursors(1)=Texture'2K4Menus.Cursors.ResizeAll'
	 MouseCursors(2)=Texture'2K4Menus.Cursors.ResizeSWNE'
	 MouseCursors(3)=Texture'2K4Menus.Cursors.Resize'
	 MouseCursors(4)=Texture'2K4Menus.Cursors.ResizeNWSE'
	 MouseCursors(5)=Texture'2K4Menus.Cursors.ResizeHorz'
	 MouseCursors(6)=Texture'2K4Menus.Cursors.Pointer'
	 ImageList(0)=Texture'2K4Menus.Controls.checkBoxBall_b'
	 ImageList(1)=Texture'2K4Menus.NewControls.ComboListDropdown'
	 ImageList(2)=Texture'2K4Menus.NewControls.LeftMark'
	 ImageList(3)=Texture'2K4Menus.NewControls.RightMark'
	 ImageList(4)=Texture'2K4Menus.Controls.Plus_b'
	 ImageList(5)=Texture'2K4Menus.Controls.Minus_b'
	 ImageList(6)=Texture'2K4Menus.NewControls.UpMark'
	 ImageList(7)=Texture'2K4Menus.NewControls.DownMark'

	bModAuthor=False

	Begin Object Class=Eon_ToolTip Name=Template
	End Object
}
