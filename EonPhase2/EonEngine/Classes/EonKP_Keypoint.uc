/* =============================================================================
:: File Name	::	Eon_Keypoint.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.30 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonKP_Keypoint extends Keypoint;

#include ../_inc/const/Teams.uc

var() Eon_Enum.ETeam			Ownership;
var() string					PositionName;
var() Texture					TXError;

var array<EonKP_Keypoint>		ChildKeypoints;
var array<Material>				OwnershipTexture;


// = LIFESPAN ==================================================================

function Automate();

simulated function Register( EonKP_Keypoint KP );


// = INC =======================================================================

#include ../_inc/debug/Log.uc
#include ../_inc/func/Rand.uc

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bStatic=false
	bStasis=false
	bNoDelete=True
	bAlwaysRelevant=true
	bReplicateMovement=false
	bOnlyDirtyReplication=true
	TXError=Texture'EonTX_Engine.Error32'
}
