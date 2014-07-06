/* =============================================================================
:: File Name	::	Eon_Position.uc
:: Design Notes	::	Should be located in free air above the base.
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class EonKP_KeyPosition extends EonKP_Keypoint;

var() edfindable EonKP_KeyPosition 		ParentPosition;

var(Debug) array<EonKB_KeyBuilding>		Buildings;
var(Debug) array<EonKO_KeyObjective>	Objectives;
var(Debug) array<EonKP_KeyPosition>		Positions;

var(Debug) bool							bSendSupplies;
var(Debug) int							Supplies;
var(Debug) int							SuppliesMax;
var(Debug) int							SuppliesOut;
var(Debug) int							SuppliesRegen;

var(Debug) float						SpawnRadius;
var(Debug) float						SpawnPriority;

var(Debug) EonKB_AidCenter				AidCenter;
var(Debug) EonKB_Armory					Armory;
var(Debug) EonKB_Barracks				Barracks;
var(Debug) EonKB_Corral					Corral;
var(Debug) EonKB_Storage				Storage;


// = REPLICATION ===============================================================

replication
{
	reliable if (Role == ROLE_Authority)
		Supplies;
}


// = LIFESPAN ==================================================================

simulated function BeginPlay()
{
	RegisterParent();
	RegisterGame();
	ResetSupplies();

	SetTimer(10, true);
	Timer();
}

simulated function Timer()
{
	if( bSendSupplies )	SendSupplies();
	else				RestartPlayers();

	bSendSupplies = !bSendSupplies;
}


// = SUPPLIES ==================================================================

function SendSupplies();

function ResetSupplies()
{
	default.Supplies	= Min(default.Supplies, default.SuppliesMax);
	Supplies			= Clamp(Supplies, default.Supplies, default.SuppliesMax);
	SuppliesMax			= default.SuppliesMax;
}

function UseSupplies( float Amount )
{
	Supplies -= Amount;
}

function bool SuppliesAvailable( float Amount )
{
	return Amount < Supplies;
}


// = SPAWNING ==================================================================

function RestartPlayers()
{
	//LogKP("Respawning Players");
}

function vector GetStartLocation( class<Actor> A )
{
	local vector	HitLocation, HitNormal, TraceEnd, TraceStart, Extent;
	local float		CHeight, CRadius;
	local int		i;

	if( A != None )
	{
		CHeight = A.default.CollisionHeight;
		CRadius = A.default.CollisionRadius;
	}
	else
		return CRand( Location, SpawnRadius );

	Extent = CRadius * vect(1,1,0);

	while( ++i < 10 )
	{
		TraceEnd	= TryStartLocation(A) + CHeight * vect(0,0,1);
		TraceStart	= TraceEnd			  + CHeight * vect(0,0,1) * 4 * i;
		if( Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true, Extent) == None )
			HitLocation = TraceEnd;

		if( VSize( HitLocation - TraceStart) >= CHeight)
			return HitLocation + CHeight * vect(0,0,1);

		LogError("Invalid Start Location" @ HitLocation @ i);
	}
	return Location;
}

function rotator GetStartRotation()
{
	local rotator	R;
	R = RRand(0,65535,0);
	return R;
}

delegate vector TryStartLocation( class<Actor> A )
{
	return CRand( Location, SpawnRadius );
}

function bool ValidPawnClass( class<Eon_Pawn> P )
{
	if( P == None )							return true;
	if( P.default.TeamIndex != Ownership )	return false;
	return true;
}

// = CACHE =====================================================================

simulated function RegisterParent()
{
	if( ParentPosition != None && ParentPosition != self )
	{
		ParentPosition.Register( self );
	}
}

simulated function RegisterGame()
{
	if( Level.NetMode != NM_Client )
	{
		if( EonGI_Base(Level.Game) != None )	EonGI_Base(Level.Game).Register( self );
		else									LogMapWarning("Eon_Game == None in" @ name);
	}
}

simulated function Register( EonKP_Keypoint KP )
{
	if( KP != None && KP != self )
	{
		Positions[Positions.Length] = EonKP_KeyPosition(KP);
	}
}

// = AUTOMATE ==================================================================

function Automate()
{
	if( ParentPosition != None )
	{
		Ownership = ParentPosition.Ownership;
		Texture = OwnershipTexture[Ownership];
	}
	else
	{
		Ownership = TEAM_Neutral;
		Texture = OwnershipTexture[Ownership];
	}
}

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	DrawScale=25
	SpawnRadius=256
}
