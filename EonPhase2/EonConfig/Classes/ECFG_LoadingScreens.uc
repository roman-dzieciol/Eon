/* =============================================================================
:: File Name	::	ECFG_LoadingScreens.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.05.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class ECFG_LoadingScreens extends EonConfig_Base;

var() config array<string>	LoadingScreen;


static function Texture GetRandomScreen()
{
	local int i;
	i = Rand( default.LoadingScreen.Length );
	return Texture( DynamicLoadObject( default.LoadingScreen[i], class'Texture') );
}


/* =============================================================================
:: Copyright © 2003 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	LoadingScreen(0)=EonTX_Backgrounds.Nature.bg-000
	LoadingScreen(1)=EonTX_Backgrounds.Nature.bg-001
	LoadingScreen(2)=EonTX_Backgrounds.Nature.bg-004
	LoadingScreen(3)=EonTX_Backgrounds.Nature.bg-006
}
