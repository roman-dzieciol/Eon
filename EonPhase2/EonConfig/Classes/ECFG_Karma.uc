/* =============================================================================
:: File Name	::	ECFG_Karma.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.30 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class ECFG_Karma extends EonConfig_Base;

#include ../_inc/const/RagdollDetail.uc

var() config byte RagdollDetail;

/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	RagdollDetail=RDL_Medium
}
