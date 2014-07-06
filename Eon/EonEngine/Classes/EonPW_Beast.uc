/* =============================================================================
:: File Name	::	EonPW_Beast.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPW_Beast extends Eon_Pawn;



/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	// Engine.Pawn
	AirSpeed=440
	WaterSpeed=440
	GroundSpeed=440
	AccelRate=512
	JumpZ=768

	// EonEngine.Eon_Pawn
	MoveControlClass=class'EonMC_Beast'
	AnimControlClass=class'EonAN_Beast'

	TeamIndex=1
}
