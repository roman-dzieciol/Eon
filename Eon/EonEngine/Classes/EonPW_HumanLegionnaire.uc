/* =============================================================================
:: File Name	::	EonPW_HumanLegionnaire.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonPW_HumanLegionnaire extends EonPW_Human;


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	// Engine.Actor
    Skins(0)=Shader'EonTS_HumanRifleman.Body'
    Skins(1)=Shader'EonTS_HumanRifleman.Body'
    Skins(2)=Shader'EonTS_HumanRifleman.Body'
    Skins(3)=Shader'EonTS_HumanRifleman.Body'
    Skins(4)=Shader'EonTS_HumanRifleman.Body'
    Skins(5)=Shader'EonTS_HumanRifleman.Body'
    Skins(6)=Shader'EonTS_HumanRifleman.Body'
    Skins(7)=Shader'EonTS_HumanRifleman.Body'
    Skins(8)=Texture'EonTX_HumanRifleman.Face'
    Skins(9)=Texture'EonTX_HumanRifleman.Mask'
    Skins(10)=Shader'EonTS_HumanRifleman.Body'
    Skins(11)=Shader'EonTS_HumanRifleman.Body'
    Skins(12)=Shader'EonTS_HumanRifleman.Body'
    Skins(13)=Shader'EonTS_HumanRifleman.Body'
    Skins(14)=Shader'EonTS_HumanRifleman.Body'
    Skins(15)=Shader'EonTS_HumanRifleman.Body'
    Skins(16)=Shader'EonTS_HumanRifleman.Body'
    Skins(17)=Shader'EonTS_HumanRifleman.Body'


	// EonEngine.Eon_Pawn
    CamSkins(0)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(1)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(2)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(3)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(4)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(5)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(6)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(7)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(8)=Shader'EonTS_Camera.Invisible'
    CamSkins(9)=Shader'EonTS_Camera.Invisible'
    CamSkins(10)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(11)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(12)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(13)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(14)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(15)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(16)=Shader'EonTS_HumanRifleman.Body'
    CamSkins(17)=Shader'EonTS_HumanRifleman.Body'

	MenuFOV=90
	MenuName="Rifleman"
	MenuOffset=(X=100,Y=40,Z=-42)

	SpawnCost=1
}
