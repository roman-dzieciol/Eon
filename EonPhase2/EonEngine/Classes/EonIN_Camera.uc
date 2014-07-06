/* =============================================================================
:: File Name	::	EonIN_Camera.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonIN_Camera extends Eon_Interaction;

enum ECamFOV
{
	CF_Linear,
	CF_WidePinch,
	CF_WideFull
};


var() Eon_CamMesh				CamMesh;
var() class<Eon_CamMesh>		CamMeshClass;


delegate OnPreRender( Canvas C );

event Initialized()
{
	Super.Initialized();
	CamMesh = PlayerOwner.Spawn( CamMeshClass );
}

function CleanUp()
{
	Super.CleanUp();
	CamMeshClass = None;
	CamMesh.Destroy();
	CamMesh = None;
}

function SetCamFOV( ECamFOV E )
{
	switch( E )
	{
		case CF_Linear:
			OnPreRender = PreRenderDisable;
			CamMesh.AdjustLoc = vect(0,0,0);
		break;

		case CF_WidePinch:
			bVisible = True;
			OnPreRender = CamMesh.PreRenderWidePinch;
			CamMesh.SetCamMesh( CamMesh.CamMeshWidePinch );
		break;

		case CF_WideFull:
			bVisible = True;
			OnPreRender = CamMesh.PreRenderWideFull;
			CamMesh.SetCamMesh(CamMesh. CamMeshWideFull );
		break;
	}
}

function PreRender( Canvas C )
{
	OnPreRender(C);
}

final function PreRenderDisable( Canvas C )
{
	bVisible = False;
	C.bRenderLevel = True;
}

exec function CamFOV( string S )
{
	if		( S ~= "wide" )				SetCamFOV( CF_WidePinch );
	else								SetCamFOV( CF_Linear );
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	bVisible = false
	CamMeshClass = class'EonEngine.Eon_CamMesh'

}
