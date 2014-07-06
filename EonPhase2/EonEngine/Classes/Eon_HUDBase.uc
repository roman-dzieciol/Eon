/* =============================================================================
:: File Name	::	Eon_HUDBase.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_HUDBase extends HudBase;




var() Material					TBackground;

// Level Action
var() Font						LevelActionFont;
var() color						LevelActionFontColor;
var() float						LevelActionPositionX;
var() float						LevelActionPositionY;

var() localized string			LevelActionSaving;
var() localized string			LevelActionConnecting;
var() localized string			LevelActionPrecaching;

// Build info
var() string					BuildInfoFontName;
var() font						BuildInfoFont;
var() string					BuildInfoText;


var() bool						bReceivedPositions;
var() array<EonKP_KeyPosition>	KeyPositions;

var() Eon_PRI					OwnerPRI;

// debug


struct DrawLineContainer
{
	var vector Start;
	var vector End;
	var color C;
	var int DrawInfo;
	var bool bStaying;
};
var() array<DrawLineContainer>	DLC;
var() EonIN_Debug				EonDebug;
var() EonIN_Monitor				EonMonitor;
var() EonIN_DebugInfo			EonDebugInfo;



// =============================================================================

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	LevelActionFont		= DynamicLoadFont( LevelActionFontName );
	BuildInfoFont		= DynamicLoadFont( BuildInfoFontName );
	ProgressFontFont	= DynamicLoadFont( ProgressFontName );

	LogHUD("Initialized");
}

simulated event PostRender( canvas Canvas )
{
	BuildMOTD();
	LinkActors();

	Canvas.ColorModulate = Canvas.Default.ColorModulate;

	if( !bHideHud )
	{
		if( bShowLocalStats )
		{
			// Display Local Stats and maybe Messages
			if( LocalStatsScreen == None )
				GetLocalStatsScreen();

			if( LocalStatsScreen != None )
			{
				LocalStatsScreen.DrawScoreboard(Canvas);
				DisplayMessages(Canvas);
			}
		}
		else if( bShowScoreBoard )
		{
			// Display Scoreboard and maybe Messages
			if( ScoreBoard != None )
			{
				ScoreBoard.DrawScoreboard(Canvas);
				DisplayMessages(Canvas);
			}
		}
		else
		{
			Canvas.ColorModulate.X = 1;
			Canvas.ColorModulate.Y = 1;
			Canvas.ColorModulate.Z = 1;
			Canvas.ColorModulate.W = HudOpacity/255;

			// Display HUD
			if( PlayerOwner == None
			||  PawnOwner == None
			||  PawnOwnerPRI == None
			|| (PlayerOwner.IsSpectating() && PlayerOwner.bBehindView) )
				DrawSpectatingHud(Canvas);
			else if( !PawnOwner.bHideRegularHUD )
				DrawHud(Canvas);

			Canvas.ColorModulate = Canvas.Default.ColorModulate;

			// Display Progress Messages or Level Action
			if( Level.LevelAction == LEVACT_None && Level.Pauser == None && PlayerOwner != None)
			{
				if( PlayerOwner.ProgressTimeOut > Level.TimeSeconds )
					DisplayProgressMessages(Canvas);
				else if( MOTDState == 1 )
					MOTDState = 2;
			}
			else
				DrawLevelAction( Canvas );

			// Display Bad Connection Alert
			if( bShowBadConnectionAlert )
				DisplayBadConnectionAlert(Canvas);

			// Display Messages
			DisplayMessages(Canvas);
		}
	}
	else if( bShowDebugInfo )
		DrawDebugInfo(Canvas);

	if( PlayerConsole != None && PlayerConsole.bTyping )
		DrawTypingPrompt(Canvas, PlayerConsole.TypedStr);
}


simulated function DrawHud (Canvas C)
{
	if( FontsPrecached < 2 )
		PrecacheFonts(C);

	UpdateHud();

	if( bShowTargeting )
		DrawTargeting(C);

	PassStyle = STY_Alpha;
	DrawHudPassA(C);
	PassStyle = STY_Additive;
	DrawHudPassB(C);
	PassStyle = STY_Alpha;
	DrawHudPassC(C);
	PassStyle = STY_None;
	DrawHudPassD(C);

	DisplayLocalMessages(C);
	DrawWeaponName(C);
}


simulated event WorldSpaceOverlays()
{
	Super.WorldSpaceOverlays();

	while( DLC.Length > 0 )
	{
		if( DLC[0].bStaying )	DrawStayingDebugLine(DLC[0].Start, DLC[0].End, DLC[0].C.R, DLC[0].C.G, DLC[0].C.B);
		else				Draw3DLine(DLC[0].Start, DLC[0].End, DLC[0].C);
		DLC.Remove(0, 1);
	}
}

// =============================================================================

simulated function DrawDebugInfo(Canvas Canvas)
{
	local float XPos, YPos;

	Canvas.Style = ERenderStyle.STY_Alpha;
	Canvas.Font = GetConsoleFont(Canvas);
	Canvas.SetPos(0,0);

	Canvas.SetDrawColor(255,255,255,128);
	Canvas.DrawTileStretched(TBackground,Canvas.ClipX,Canvas.ClipY);

	Canvas.DrawColor = ConsoleColor;
	PlayerOwner.ViewTarget.DisplayDebug(Canvas, XPos, YPos);
}

function bool DrawLevelAction( Canvas C )
{
	local String LevelActionText;
	local Plane OldModulate;

	switch( Level.LevelAction )
	{
		case LEVACT_None:		LevelActionText = LevelActionPaused;		break;
		case LEVACT_Loading:	LevelActionText = LevelActionLoading;		break;
		case LEVACT_Saving:		LevelActionText = LevelActionSaving;		break;
		case LEVACT_Connecting:	LevelActionText = LevelActionConnecting;	break;
		case LEVACT_Precaching:	LevelActionText = LevelActionPrecaching;	break;
		default:				return false;
	}

	OldModulate = C.ColorModulate;
	C.Font = LevelActionFont;
	C.Style = ERenderStyle.STY_Alpha;
	C.DrawColor = LevelActionFontColor;
	C.ColorModulate = C.default.ColorModulate;
	C.DrawScreenText( LevelActionText, LevelActionPositionX, LevelActionPositionY, DP_MiddleMiddle );
	C.ColorModulate = OldModulate;
	return true;
}

simulated function DrawTypingPrompt( Canvas C, String Text, optional int Pos )
{
	local float XPos, YPos;
	local float XL, YL;

	C.Font = GetConsoleFont(C);
	C.Style = ERenderStyle.STY_Normal;
	C.TextSize ("A", XL, YL);

	XPos = (ConsoleMessagePosX * HudCanvasScale * C.SizeX) + (((1.0 - HudCanvasScale) * 0.5) * C.SizeX);
	YPos = (ConsoleMessagePosY * HudCanvasScale * C.SizeY) + (((1.0 - HudCanvasScale) * 0.5) * C.SizeY) - YL;

	C.SetPos (0, YPos-3);
	C.SetDrawColor(255,255,255,255);
	C.DrawTileStretched(TBackground,C.ClipX,YL+3);

	C.SetPos (XPos, YPos);
	C.DrawColor = ConsoleColor;
	C.DrawTextClipped("(>"@Left(Text, Pos)$chr(4)$Eval(Pos < Len(Text), Mid(Text, Pos), "_"), true);
}




// =============================================================================

simulated function Font DynamicLoadFont( string S )
{
	local Font F;

	F = Font(DynamicLoadObject(S, class'Font'));
	if( F == None )
	{
		Log("Warning: "$Self$" Couldn't dynamically load font "$S);
		F = Font'DefaultFont';
	}

	return F;
}

function ActorRenderOverlay( Canvas C, Actor A, bool bClearZBuffer )
{
	if( bClearZBuffer )
		C.DrawActor(None, false, true);
	A.RenderOverlays( C );
}

// =============================================================================

exec function ShowDebug()
{
	bShowDebugInfo = !bShowDebugInfo;
	if( bShowDebugInfo )
		bHideHud = true;
}

// = LIFESPAN ==================================================================



simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if( PlayerOwner != None && EonDebug == None && EonMonitor == None )
	{
		EonDebug = EonIN_Debug(PlayerOwner.Player.InteractionMaster.AddInteraction("EonEngine.EonIN_Debug",PlayerOwner.Player));
		EonMonitor = EonIN_Monitor(PlayerOwner.Player.InteractionMaster.AddInteraction("EonEngine.EonIN_Monitor",PlayerOwner.Player));
		//EonDebugInfo = EonIN_DebugInfo(PlayerOwner.Player.InteractionMaster.AddInteraction("EonEngine.EonIN_DebugInfo",PlayerOwner.Player));
	}

	if( OwnerPRI == None && PawnOwnerPRI != None )
		OwnerPRI = Eon_PRI(PawnOwnerPRI);

	if( !bReceivedPositions && OwnerPRI != None )
	{
		ClearPositions();
		RequestPositions();

	}
}

simulated function LinkActors()
{
	PlayerOwner = PlayerController (Owner);

	if( PlayerOwner == None )
	{
		PlayerConsole	= None;
		PawnOwner		= None;
		PawnOwnerPRI	= None;
		return;
	}

	if( PlayerOwner.Player != None )	PlayerConsole = PlayerOwner.Player.Console;
	else								PlayerConsole = None;

	if( PlayerOwner.ViewTarget != None
	&&	Pawn(PlayerOwner.ViewTarget) != None
	&&	Pawn(PlayerOwner.ViewTarget).Health > 0 )
		PawnOwner = Pawn(PlayerOwner.ViewTarget);
	else if( PlayerOwner.Pawn != None )
		PawnOwner = PlayerOwner.Pawn;
	else
		PawnOwner = None;

	if( PawnOwner != None && PawnOwner.PlayerReplicationInfo != None )
			PawnOwnerPRI = PawnOwner.PlayerReplicationInfo;
	else	PawnOwnerPRI = PlayerOwner.PlayerReplicationInfo;

}

// = POSITIONS =================================================================

simulated function ClearPositions()
{
	KeyPositions.Remove(0,KeyPositions.Length);
	bReceivedPositions = false;
}

simulated function RequestPositions()
{
	if( OwnerPRI != None )
	{
		OwnerPRI.OnReceivePosition = ReceivePosition;
		OwnerPRI.ServerSendPositions();
		bReceivedPositions = true;
	}
}

simulated function ReceivePosition( EonKP_KeyPosition KP )
{
	Log("ReceivePosition" @ KP @ name, 'HUD');
	AddPosition( KP );
}

simulated function AddPosition( EonKP_KeyPosition KP )
{
	KeyPositions[KeyPositions.Length] = KP;
}

simulated function RemovePositions( EonKP_KeyPosition KP )
{
	local int i;

	for(i=KeyPositions.Length-1; i>=0; i--)
	{
		if( KeyPositions[i] == KP )
		{
			KeyPositions.Remove(i,1);
			continue;
		}
	}
}

simulated function ResetPositions()
{
	log("ResetPositions" @ name, 'HUD');
	ClearPositions();
	RequestPositions();
}


simulated function EonKP_KeyPosition LocatePosition( vector Position )
{
	local float				Distance, LowestDistance;
	local vector			DistanceVector;
	local EonKP_KeyPosition	BestPosition;
	local int 				i;

	LowestDistance = 4096.0;

	for(i=0; i<KeyPositions.Length; i++)
	{
		DistanceVector = KeyPositions[i].Location - Position;
		DistanceVector.Z = 0;
		Distance = VSize(DistanceVector);
		if( Distance < LowestDistance )
		{
			BestPosition = KeyPositions[i];
			LowestDistance = Distance;
		}
		//log( distance @ DistanceVector @ KeyPositions[i].Location @ Position @ BestPosition,'LocatePosition');
	}

	return BestPosition;
}

// = DEBUG =====================================================================

final function HUD_DrawLine( vector Start, vector End, color C, optional int DrawInfo, optional bool bStaying )
{
	local DrawLineContainer D;

	if( !EonDebug.bVisible )
		return;

	D.Start		= Start;
	D.End		= End;
	D.C			= C;
	D.DrawInfo	= DrawInfo;
	D.bStaying	= bStaying;

	DLC[DLC.Length] = D;
	EonDebug.RegisterDrawLine(Start, End, C, DrawInfo, bStaying);
}

final function HUD_Monitor( string Desc, string Value, color C, optional float DrawMode )
{
	EonMonitor.RegisterDrawInfo( Desc, Value, C, DrawMode );
}

final function HUD_DebugInfo( Actor A )
{
	EonDebugInfo.ChoseActor( A );
}


// = INC =======================================================================

#include ../_inc/debug/Log.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	// HUD
	ConsoleMessagePosX=0.005
	ConsoleMessagePosY=0.825
	ConsoleColor=(R=255,G=144,B=0,A=255)

	FontArrayNames(0)="UT2003Fonts.FontEurostile37"
	FontArrayNames(1)="UT2003Fonts.FontEurostile29"
	FontArrayNames(2)="UT2003Fonts.FontEurostile24"
	FontArrayNames(3)="UT2003Fonts.FontEurostile21"
	FontArrayNames(4)="UT2003Fonts.jFontMedium800x600"	//17
	FontArrayNames(5)="UT2003Fonts.jFontMedium"			//14
	FontArrayNames(6)="UT2003Fonts.FontEurostile12"
	FontArrayNames(7)="UT2003Fonts.jFontSmallText800x600" //9
	FontArrayNames(8)="UT2003Fonts.FontSmallText"		//6

	FontScreenWidthMedium(0)=2048
	FontScreenWidthMedium(1)=1600
	FontScreenWidthMedium(2)=1280
	FontScreenWidthMedium(3)=1024
	FontScreenWidthMedium(4)=800
	FontScreenWidthMedium(5)=640
	FontScreenWidthMedium(6)=512
	FontScreenWidthMedium(7)=400
	FontScreenWidthMedium(8)=320

	FontScreenWidthSmall(0)=4096
	FontScreenWidthSmall(1)=3200
	FontScreenWidthSmall(2)=2560
	FontScreenWidthSmall(3)=2048
	FontScreenWidthSmall(4)=1600
	FontScreenWidthSmall(5)=1280
	FontScreenWidthSmall(6)=1024
	FontScreenWidthSmall(7)=800
	FontScreenWidthSmall(8)=640

	BuildInfoFontName="Engine.DefaultFont"

	NowViewing="Now viewing"
	InitialViewingString="Press Fire to View a different player"

	LevelActionFontName="UT2003Fonts.FontMedium"
	LevelActionFontColor=(R=255,G=255,B=255,A=255)
	LevelActionPositionX=0.5
	LevelActionPositionY=0.25
	LevelActionPaused="PAUSED"
	LevelActionLoading="LOADING..."
	LevelActionSaving="SAVING..."
	LevelActionConnecting="CONNECTING..."
	LevelActionPrecaching="PRECACHING..."

	TBackground=Material'EonTS_GUI.Background.Dark'
}
