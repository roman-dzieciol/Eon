/* =============================================================================
:: File Name	::	Eon_TabServerNews.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_TabServerNews extends Eon_TabServerBase;

var() Eon_ScrollTextBox	NewsBox;
var bool				GotMOTD;
var MasterServerClient	MSC;
var String				MOTD;


delegate OnMOTDVerified();

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	NewsBox = Eon_ScrollTextBox(Controls[0]);

	MSC = PlayerOwner().Level.Spawn( class'MasterServerClient' );
	MSC.OnReceivedMOTDData	= MyReceivedMOTDData;
	MSC.OnQueryFinished		= MyQueryFinished;

	if( !GotMOTD )
	{
		MSC.StartQuery(CTM_GetMOTD);
	}
}

function OnCloseBrowser()
{
	if( MSC != None )
	{
		MSC.CancelPings();
		MSC.Destroy();
		MSC = None;
	}
}


function MyReceivedMOTDData( MasterServerClient.EMOTDResponse Command, string Data )
{
	switch( Command )
	{
	case MR_MOTD: 				GotMOTD = true;
								NewsBox.SetContent(Data, Chr(13));
								break;

	case MR_OptionalUpgrade:	//UpgradeButton.bVisible = true;
	 							break;

	case MR_MandatoryUpgrade:	//MustUpgrade = true;
								//UpgradeButton.bVisible = true;
								break;

	case MR_NewServer:			break;
	case MR_IniSetting:			break;
	case MR_Command:			break;
	}
}

function MyQueryFinished( MasterServerClient.EResponseInfo ResponseInfo, int Info )
{
	switch( ResponseInfo )
	{
	case RI_Success:				OnMOTDVerified();
									OnMOTDVerified = None;
									break;

	case RI_AuthenticationFailed:	break;

	case RI_ConnectionFailed:

									MSC.StartQuery(CTM_GetMOTD);		// try again
									break;

	case RI_ConnectionTimeout:

									break;
	}
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	Begin Object class=Eon_ScrollTextBox Name=oNewsBox
		TextAlign=TXTA_Left
		WinWidth=1.0
		WinHeight=1.0
		WinLeft=0.00
		WinTop=0.00
		CharDelay=0.002
		EOLDelay=0.5
		bNeverFocus=true
		bAcceptsInput=true
		bVisibleWhenEmpty=true
	End Object

	Controls(0)=oNewsBox

}
