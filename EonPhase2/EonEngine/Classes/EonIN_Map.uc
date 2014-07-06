/* =============================================================================
:: File Name	::	EonIN_Map.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonIN_Map extends Eon_Interaction;



var() float						IconScaleX, IconScaleY, IconOffset, IconX, IconY;

var() float						MapRange,
								MapRangeInv,
								MapRangeMax,
								MapRangeDouble,
								MapRangeDoubleInv;

var() float						MapScale,
								MapScaleMax,
								MapScaleInv,
								MapScaleDouble,
								MapScaleDoubleInv,
								MapScaleInvOne;

var() float						MapZoom,
								MapZoomMax,
								MapZoomInv,
								MapZoomRev,
								MapZoomDouble,
								MapZoomDoubleInv,
								MapZoomInvOne;

var() Texture					TXMap;
var() TexRotator				TXArrow;
var() MaterialSwitch			TXArrowSwitch;
var() float						MapScaleX, MapScaleY, MapPosX, MapPosY, MapSizeX, MapSizeY, MapSizeU, MapSizeV;
var() float						MenuX, MenuY, MenuW, MenuH;
var() float PosX, PosY, PX, PY, LX, LY, PLX, PLY;

var() array<EonKP_KeyPosition>	KeyPositions;
var() vector PlayerLocation;
var() rotator CamRot;


function CleanUp()
{
	Super.CleanUp();
	TXMap			= None;
	TXArrow			= None;
	TXArrowSwitch	= None;
	KeyPositions.Remove(0,KeyPositions.Length);
}

// = LIFESPAN ==================================================================

event Initialized()
{
	Super.Initialized();
	TXMap = default.TXMap;
	TXArrowSwitch = MaterialSwitch(TXArrow.Material);

	MapRange = default.MapRange;
	SetMapScale( default.MapScale );
	SetMapZoom( default.MapZoom );
	SetMapRange( default.MapRange );
}

// = MAP =======================================================================

function PreRender( Canvas C )
{
//	C.GetCameraLocation(PlayerLocation, CamRot);
	KeyPositions = Eon_HUD(PlayerOwner.myHUD).KeyPositions;
}

function PostRender( Canvas C )
{
	local int i, Team;

	C.ColorModulate = C.Default.ColorModulate;
	C.SetDrawColor(255,255,255,255);

	MapSizeU = TXMap.USize;
	MapSizeV = TXMap.VSize;

	MenuW = C.ClipX * MapScale;
	MenuH = C.ClipY * MapScale;
	MenuX = C.ClipX - MenuW;
	MenuY = 0;

	IconX		= MenuX - IconOffset;
	IconY		= MenuY - IconOffset;
	IconScaleX	= 0.5;
	IconScaleY	= 0.5;

	MapScaleX	= MenuW;
	MapScaleY	= MenuH;


	if( true )
	{
		PLX = (MapRange + PlayerLocation.X) * MapRangeDoubleInv;
		PLY = (MapRange + PlayerLocation.Y) * MapRangeDoubleInv;

		PX = MenuX - 32 + MapScaleX * 0.5;
		PY = MenuY - 32 + MapScaleY * 0.5;

		MapPosX		= 0;
		MapPosY		= 0;
		MapPosX		+= MapSizeU * PLX;
		MapPosY		+= MapSizeV * PLY;
		MapPosX		-= MapSizeU * MapZoom * 0.5;
		MapPosY		-= MapSizeV * MapZoom * 0.5;

		MapSizeX	= MapSizeV * MapZoom;
		MapSizeY	= MapSizeU * MapZoom;
	}
	else
	{
		PLX = (MapRange + PlayerLocation.X) * MapRangeDoubleInv;
		PLY = (MapRange + PlayerLocation.Y) * MapRangeDoubleInv;

		PX = MenuX - 32 + MapScaleX * PLX;
		PY = MenuY - 32 + MapScaleY * PLY;

		MapPosX		= 0;
		MapPosY		= 0;
		MapPosX		+= MapSizeU * 0.5 * MapZoomInvOne;
		MapPosY		+= MapSizeV * 0.5 * MapZoomInvOne;

		MapSizeX	= MapSizeU;
		MapSizeY	= MapSizeV;
		MapSizeX	-= MapSizeU * MapZoomInvOne;
		MapSizeY	-= MapSizeV * MapZoomInvOne;
	}

	// 2D Map
	C.SetPos(MenuX, MenuY);
	C.DrawTile( TXMap, MapScaleX, MapScaleY, MapPosX, MapPosY, MapSizeX, MapSizeY );

	// Player Arrow
	if( PRI.Team != None )	Team = PRI.Team.TeamIndex;
	else					Team = TEAM_Neutral;

	TXArrowSwitch.Material	= TXArrowSwitch.Materials[Team];
	TXArrow.Rotation.Yaw	= -PlayerOwner.Rotation.Yaw  - 16384;

	C.SetPos(PX, PY);
	C.DrawTileScaled( TXArrow, 0.5, 0.5 );

	// Draw positions
	for(i=0; i<KeyPositions.Length; i++)
	{
		PosX =  (MapRange + KeyPositions[i].Location.X) * MapRangeDoubleInv;
		PosY =  (MapRange + KeyPositions[i].Location.Y) * MapRangeDoubleInv;

		LX = MenuX;
		LY = MenuY;
		LX -= MenuW * PLX * MapZoomInv;
		LY -= MenuH * PLY * MapZoomInv;
		LX += MenuW  * 0.5;
		LY += MenuH  * 0.5;
		LX += MenuW * PosX * MapZoomInv;
		LY += MenuH * PosY * MapZoomInv;

		if(	LX > MenuX - IconOffset
		&&	LX < MenuX + MenuW + IconOffset
		&&	LY > MenuY - IconOffset
		&&	LY < MenuY + MenuH + IconOffset)
		{
			LX -= IconOffset;
			LY -= IconOffset;
			C.SetPos( LX, LY );
			C.DrawTileClipped( KeyPositions[i].Texture, 16, 16, 0, 0, 32, 32 );
		}
	}

	return;
}


exec function SetMapScale( float f )
{
	MapScale			= FClamp(f, 0.1, 1);
	MapScaleInv			= 1 / MapScale;
	MapScaleInvOne		= 1 - MapScale;
	MapScaleDouble		= 2 * MapScale;
	MapScaleDoubleInv	= 1 / MapScaleDouble;

}

exec function SetMapRange( float f )
{
	MapRange			= FClamp(f, 8192, MapRangeMax);
	MapRangeInv			= 1 / MapRange;
	MapRangeDouble		= 2 * MapRange;
	MapRangeDoubleInv	= 1 / MapRangeDouble;
}


exec function SetMapZoom( float f )
{
	MapZoom				= FClamp(f, 0.1, 1);
	MapZoomInv			= 1 / MapZoom;
	MapZoomRev			= 1 - MapZoom;
	MapZoomInvOne		= 1 - MapZoom;
	MapZoomDouble		= 2 * MapZoom;
	MapZoomDoubleInv	= 1 / MapZoomDouble;
}


/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{

	MapRangeMax=65536
	MapRange=32768
	MapScale=0.25
	MapZoom=0.3

	TXMap=Texture'Engine.DefaultTexture'
	TXArrow=TexRotator'EonTS_GUI.Map.Arrow'

	IconOffset=8

}
