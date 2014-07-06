/* =============================================================================
:: File Name	::	EonKO_KeyObjective.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonKO_KeyObjective extends EonKP_Keypoint;

var() edfindable EonKP_KeyPosition	KeyPosition;


simulated function BeginPlay()
{
	RegisterSelf();
}

simulated function RegisterSelf()
{
	if( KeyPosition != None )
	{
		KeyPosition.Objectives[KeyPosition.Objectives.Length] = self;
	}
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

}
