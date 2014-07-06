/* =============================================================================
:: File Name	::	Eon_TabControl.uc
:: Description	::	none
:: =============================================================================
:: CHANGES		::	TabButton class no longer hardcoded
::				:: 	TabPages receive OnClose notification
:: =============================================================================
:: Revision history:
:: 00.05.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabControl extends GUITabControl;

var() class<GUITabButton>	TabButtonClass;

function GUITabPanel AddTab(string InCaption, string PanelClass, optional GUITabPanel ExistingPanel, optional string InHint, optional bool bForceActive)
{
	local class<GUITabPanel>	NewPanelClass;
	local GUITabButton			NewTabButton;
	local GUITabPanel			NewTabPanel;
	local int					i;

	log("AddTab" @ InCaption @ PanelClass @ ExistingPanel @ InHint @ bForceActive, 'GUI');

	// Make sure this doesn't exist first
	for(i=0; i<TabStack.Length; i++)
	{
		if( TabStack[i].Caption ~= InCaption )
		{
			log("A tab with the caption" @ InCaption @ "already exists.");
			return none;
		}
	}

	if( ExistingPanel == None )
		NewPanelClass = class<GUITabPanel>(Controller.AddComponentClass(PanelClass));

	if( ExistingPanel != None || NewPanelClass != None )
	{
		if( ExistingPanel != None )			NewTabPanel = GUITabPanel(AppendComponent(ExistingPanel,True));
		else if( NewPanelClass != None )			NewTabPanel = GUITabPanel(AddComponent(PanelClass,True));

		if( NewTabPanel == None )
		{
			log("Could not create panel for"@NewPanelClass);
			return None;
		}

		if( NewTabPanel.MyButton != None )
			NewTabButton = NewTabPanel.MyButton;
		else
		{
			NewTabButton = new TabButtonClass;
			if( NewTabButton == None )
			{
				log("Could not create tab for"@NewPanelClass);
				return None;
			}

			NewTabButton.InitComponent(Controller, Self);
			NewTabButton.Opened(Self);
			NewTabPanel.MyButton = NewTabButton;
			if( !bDrawTabAbove )
			{
				NewTabPanel.MyButton.bBoundToParent = False;
				//NewTabPanel.MyButton.Style = Controller.GetStyle("FlippedTabButton",NewTabPanel.FontScale);
			}
		}

		NewTabPanel.MyButton.Hint           = Eval(InHint != "", InHint, NewTabPanel.Hint);
		NewTabPanel.MyButton.Caption        = Eval(InCaption != "", InCaption, NewTabPanel.PanelCaption);
		NewTabPanel.MyButton.OnClick        = InternalTabClick;
		NewTabPanel.MyButton.MyPanel        = NewTabPanel;
		NewTabPanel.MyButton.FocusInstead   = self;
		NewTabPanel.MyButton.bNeverFocus    = true;

		NewTabPanel.InitPanel();

		// Add the tab to controls
		TabStack[TabStack.Length] = NewTabPanel.MyButton;
		if( (TabStack.Length == 1 && bVisible) || bForceActive )
				ActivateTab(NewTabPanel.MyButton,true);
		else	NewTabPanel.Hide();

		return NewTabPanel;

	}

	return none;
}

function GUITabPanel InsertTab(int Pos, string Caption, string PanelClass, optional GUITabPanel ExistingPanel, optional string InHint, optional bool bForceActive)
{
	local class<GUITabPanel> NewPanelClass;
	local GUITabPanel NewTabPanel;
	local GUITabButton NewTabButton;

	if( ExistingPanel == None )
		NewPanelClass = class<GUITabPanel>(Controller.AddComponentClass(PanelClass));

	if( ExistingPanel != None || NewPanelClass != None )
	{
		if( ExistingPanel != None )
			NewTabPanel = GUITabPanel(AppendComponent(ExistingPanel,True));
		else if (NewPanelClass != None)
			NewTabPanel = GUITabPanel(AddComponent(PanelClass,True));

		if( NewTabPanel == None )
		{
			log("Could not create panel for"@NewPanelClass);
			return None;
		}

		if( NewTabPanel.MyButton != None )
			NewTabButton = NewTabPanel.MyButton;

		else
		{
			NewTabButton = new TabButtonClass;
			if (NewTabButton==None)
			{
				log("Could not create tab for"@NewPanelClass);
				return None;
			}

			NewTabButton.InitComponent(Controller, Self);
			NewTabButton.Opened(Self);
			NewTabPanel.MyButton = NewTabButton;
		}


		NewTabPanel.MyButton.Caption = Caption;
		NewTabPanel.MyButton.Hint = InHint;
		NewTabPanel.MyButton.OnClick = InternalTabClick;
		NewTabPanel.MyButton.MyPanel = NewTabPanel;
		NewTabPanel.MyButton.FocusInstead = self;
		NewTabPanel.MyButton.bNeverFocus = true;
		NewTabPanel.InitPanel();

		TabStack.Insert(Pos, 1);
		TabStack[Pos] = NewTabPanel.MyButton;
		if( TabStack.Length==1 || bForceActive )
			ActivateTab(NewTabPanel.MyButton,true);

		else NewTabPanel.Hide();

		return NewTabPanel;
	}

	return None;
}

function NotifyOnClose();
/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	TabButtonClass=class'EonGUI.Eon_TabButton'
	TabHeight=0.065
	bDrawTabAbove=true
	bDockPanels=true
}
