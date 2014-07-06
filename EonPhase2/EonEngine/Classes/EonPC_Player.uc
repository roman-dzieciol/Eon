/* =============================================================================
:: File Name	::	Eon_Player.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPC_Player extends EonPC_Base;

simulated function InitGUI()
{
	Super.InitGUI();
	AddEonInteraction("EonEngine.EonIN_Build");

	EonUse		= EonIN_Use( AddEonInteraction("EonEngine.EonIN_Use") );
	EonMap		= EonIN_Map( AddEonInteraction("EonEngine.EonIN_Map") );
	EonCmd		= EonIN_Cmd( AddEonInteraction("EonEngine.EonIN_Cmd") );
	EonCam		= EonIN_Camera( AddEonInteraction("EonEngine.EonIN_Camera") );
	//ShowLoginMenu();
}

function CalcFirstPersonView( out vector CameraLocation, out rotator CameraRotation )
{
	if( EonCam != None )
	{
		CameraLocation = CameraLocation + Pawn.EyePosition();
		EonCam.CamMesh.AdjustCameraLocation(CameraLocation);
	}
	else
		Super.CalcFirstPersonView(CameraLocation,CameraRotation);
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

}
