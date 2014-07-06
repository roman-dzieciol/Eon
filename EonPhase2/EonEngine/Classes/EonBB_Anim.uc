/* =============================================================================
:: File Name	::	EonBB_Anim.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.11.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonBB_Anim extends BrushBuilder config(EonEditor) ;

var() config name AnimName;
var() config float AnimFrame;

var() config array<name>	BoneNames;

event bool Build()
{
	local Actor A;
	local bool bResult;

	foreach AllObjects(class'Actor', A)
	{
		if( A.bSelected && !A.bDeleteMe )
		{
			bResult = True;
			Process(A);
		}
	}

	SaveConfig();
	if( !bResult )
		return BadParameters("Select Actor first!");
}

function Process( Actor A )
{
	local int		i;
	local vector	V,O;

	A.PlayAnim(AnimName, 1,0,0);
	if( AnimFrame != -1 )
		A.SetAnimFrame(AnimFrame);

	Log("Actor Location" @ A.Location,'Anim');

	for(i=0; i<BoneNames.Length; i++)
	{
		V = A.GetBoneCoords(BoneNames[i]).Origin;
		O = A.Location-V;
		Log("Bone" @i@ "Location" @V@ "Offset" @O,'Anim');
	}
}

// = INC =======================================================================

#include ../_inc/func/string.uc


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

	ToolTip="Anim"
}
