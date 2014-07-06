/* =============================================================================
:: File Name	::	Eon_Pawn.uc
:: Description	::	Handles Animations & Visual FX
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_Pawn extends Eon_PawnBase;

simulated function AnimControlCreate( class<Eon_AnimControl> C )
{
	//LogPawn("AnimControlCreate" @ C @ AnimControl);
	if( AnimControl == None || AnimControl.Outer != self || AnimControl.class != C )
		AnimControl = new(self) C;

	AnimControl.Setup();
}


// = REPLICATION ===============================================================

/*replication
{
	reliable if( bNetDirty && (Role==ROLE_Authority) )
		PlayDying;
}*/
/*
simulated event ModifyVelocity(float DeltaTime, vector OldVelocity)
{
	local vector	Dir, HitLocation,HitNormal,TraceEnd,TraceStart,VA,VB,VC,VD;
	local vector	VCamBone, OffsetA, OffsetB, OffsetC,OffsetD,X,Y,Z;
	local float		F,FDot, FSpeed;
	local actor		A;
	local rotator	R;

	if( Level.NetMode == NM_DedicatedServer )	return;

	X = Velocity;
	FSpeed = VSize(X)*DeltaTime;

	R				= rotation;
	Dir				= vector(R);
	VCamBone		= GetBoneCoords(CamBone).Origin;
	TraceStart		= Location;
	TraceEnd		= VCamBone + Dir;

	HUD_DrawLine(TraceStart, TraceEnd, 0,192,0,255,1);

	A = Trace( HitLocation, HitNormal, TraceEnd, TraceStart, false );
	if( A != None )
	{
		OffsetA	= HitLocation - TraceEnd;
		F		= VSize(OffsetA);
		OffsetB	= HitNormal * F;
		OffsetC	= HitLocation - VCamBone + Dir;
		OffsetD	= Velocity;

		HUD_DrawLine(Location, Location+Normal(OffsetA)*64, 255,255,0,255,1);
		HUD_DrawLine(Location, Location+Normal(OffsetB)*64, 255,128,0,255,1);
		HUD_DrawLine(Location, Location+Normal(OffsetC)*64, 255,0,0,255,1);

		Acceleration = OffsetB/DeltaTime;
		//Velocity = OffsetB/DeltaTime;
		if( Physics == PHYS_Walking )
		{
			Velocity.X = 0;
			Velocity.Y = 0;
			Log("PHYS_Walking");
		}
		else if( Physics == PHYS_Falling )
		{
			Log("PHYS_Falling");
			Velocity.X *= 0.75*(1-DeltaTime);
			Velocity.Y *= 0.75*(1-DeltaTime);
			if( Velocity.Z > 0 )
				Velocity.Z -= 10*DeltaTime;
		}

		//Log( Level.TimeSeconds @ Location @ ColLocation @ Velocity @ Acceleration );
		//Move( OffsetB );
		//SetLocation( Location + OffsetB );
		//Log( Level.TimeSeconds @ Location  @ ColLocation @ Velocity @ Acceleration );
	}
		ClientMessage( Velocity @ Acceleration );
}*/


// = JUMPING ===================================================================

event Landed(vector HitNormal)
{
	//LogPawn("Landed" @ HitNormal);
	TakeFallingDamage();
	bJustLanded = true;
}

function bool JumpDeferred()
{
	return false;
}


function bool DoJump( bool bUpdating )
{
	//LogPawn("DoJump" @ bUpdating);

	if( !bIsCrouched && !bWantsToCrouch && Physics == PHYS_Walking )
	{
		if( Role == ROLE_Authority )
		{
			if( Level.Game != None )
				MakeNoise(0.1 * Level.Game.GameDifficulty);
		}

		if( bIsWalking )	Velocity.Z = Default.JumpZ;
		else				Velocity.Z = JumpZ;

		SetPhysics(PHYS_Falling);
		return true;
	}

	return false;
}

// = PAWN LIFESPAN =============================================================

simulated event Tick(float DeltaTime)
{
	if( Level.NetMode == NM_DedicatedServer )	return;

	OnTick(DeltaTime);
	AnimControl.Update(DeltaTime);
}



// = DAMAGE ====================================================================

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	TearOffMomentum = momentum;
	Super.TakeDamage( Damage, instigatedBy, hitlocation, momentum, damageType);
}


// = DYING =====================================================================

function KilledBy( pawn EventInstigator )
{
	local Controller	Killer;
	local vector		HitLocation;

	LogPawn("KilledBy" @ EventInstigator);

	if( EventInstigator != None )
		Killer = EventInstigator.Controller;

	Health = 0;
	HitLocation = Location;
	TearOffMomentum = 50*Velocity + 25*VRand();

	Died( Killer, class'Suicided', HitLocation );
}

simulated event PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local KarmaParamsSkel	KSkelParams;
	local float	BoneDist;
	local name	Bone;

	LogPawn("PlayDying");

	bReplicateMovement = false;
	AmbientSound = None;
	bCanTeleport = false;
	bPlayedDeath = true;
	bTearOff = true;
	KSetBlockKarma(true);

	// these are replicated to other clients
	HitDamageType = DamageType;
	TakeHitLocation = HitLoc;

	GotoState('Dying');

	if( Level.NetMode != NM_DedicatedServer )
	{
		StopAnimating(true);

		KSkelParams							= KarmaParamsSkel(KParams);
		KSkelParams.KSkeleton				= RagSkelName;
		KSkelParams.KVelDropBelowThreshold	= RagMinSpeed;

		// initial angular and linear velocity
		KSkelParams.KStartLinVel.X = 0.75 * Velocity.X;
		KSkelParams.KStartLinVel.Y = 0.75 * Velocity.Y;
		KSkelParams.KStartLinVel.Z = 0.75 * Velocity.Z;

		// I guesss KarmaParamsSkel.KShotBone was deferred until cancelled
		if( class<Suicided>(DamageType) == None )
				Bone = GetClosestBone( HitLoc, Normal(TearOffMomentum), BoneDist );
		else	Bone = 'Bip01 Spine1';
		KRegisterImpulse(TearOffMomentum, HitLoc, Bone );

		KSetBlockKarma(true);
		SetPhysics(PHYS_KarmaRagdoll);
		return;
	}

	// non-ragdoll death fallback
	Velocity += TearOffMomentum/50;
	BaseEyeHeight = Default.BaseEyeHeight;
	SetPhysics(PHYS_Falling);
}

simulated function KRegisterImpulse(vector Impulse, vector Position, name Bone)
{
	local sKImpulse K;

	K.Impulse	= Impulse;
	K.Position	= Position;
	K.Bone		= Bone;
	KImpulses[KImpulses.Length]	= K;
	//LogPawn("KRegisterImpulse" @ level.timeseconds @ K.Impulse @ K.Position @ K.Bone);
}

// == DYING ====================================================================

state Dying
{
ignores Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, Landed;

	function LieStill(){}
	function LandThump(){}
	event AnimEnd(int Channel){}
	event Landed(vector HitNormal){}

	simulated function BeginState()
	{
		if( bTearOff && Level.NetMode == NM_DedicatedServer )
			LifeSpan = 1.0;

		SetPhysics(PHYS_Falling);
		SetCollision(false,false,false);
		SetCollisionSize(0,0);
		AmbientSound = None;

		RagAvgSpeed = VSize(Velocity);
		RagLifeSpan = Level.TimeSeconds+30;

		if( Controller != None )
		{
			if( Controller.bIsPlayer )
			{
				Controller.PawnDied(self);
			}
			else
				Controller.Destroy();
		}
	}

	singular event BaseChange()
	{
		//LogPawn("BaseChange()" @ Base);
		if( Base == None )
		{
			SetPhysics(PHYS_Falling);
		}
		else if( Pawn(Base) != None )
		{
			ChunkUp( Rotation, 1.0 );
		}
	}

	simulated function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
	{
		local float BoneDist;
		//LogPawn("TakeDamage");

		if( bRagFrozen )
		{
			//LogPawn("HIT FROZEN. M:"$Momentum);
			bRagFrozen = False;
			KRegisterImpulse(Momentum, Hitlocation, GetClosestBone( Hitlocation, Normal(Momentum), BoneDist ) );
			SetPhysics(PHYS_KarmaRagDoll);
			RagAvgSpeed = VSize(Velocity);
		}
		else if( bPlayedDeath && Physics == PHYS_KarmaRagDoll )
		{
			//LogPawn("HIT RAGDOLL. M:"$Momentum);
			KAddImpulse(Momentum, Hitlocation, GetClosestBone( Hitlocation, Normal(Momentum), BoneDist ) );
		}

		Damage *= DamageType.Default.GibModifier;
		Health -=Damage;

		if( Health < -3000 )
		{
			ChunkUp( Rotation, DamageType.default.GibPerterbation );
		}
	}

	simulated function Timer()
	{
		/*if( Level.TimeSeconds > RagLifeSpan && !PlayerCanSeeMe() )
		{
			LogPawn("Ragdoll expired:" @ self);
			Destroy();
		}*/

		RagAvgSpeed = (RagAvgSpeed + VSize(Velocity)) * 0.5;
		if( RagAvgSpeed < RagMinSpeed && !bRagFrozen )
		{
			if( Level.TimeSeconds > RagRestTime )
			{
				SetPhysics(PHYS_None);
				bCollideWorld = true;
				bRagFrozen = True;
				SetTimer(0.0, false);
				Disable('Tick');
			}
		}
	}

	simulated event KVelDropBelow()
	{
		//LogPawn("KVelDropBelow" @ Level.TimeSeconds);
		RagRestTime = default.RagRestTime + Level.TimeSeconds;
		SetTimer(0.25, true);
	}

	simulated event KImpact( Actor A, vector ILocation, vector IVelocity, vector INormal )
	{
		if( Level.TimeSeconds > RagImpactTime + RagImpactInterval )
		{
			PlaySound( RagImpactSound, SLOT_Pain, RagImpactVolume);
			RagImpactTime = Level.TimeSeconds;
		}
	}

	simulated event Tick(float DeltaTime)
	{
		if( Level.NetMode == NM_DedicatedServer ) return;

		OnTick(DeltaTime);

		if( !bPlayedDeath )
			PlayDying(HitDamageType, TakeHitLocation);

		while( KImpulses.Length > 0 )
		{
			//LogPawn("Tick KImpulses" @ Level.TimeSeconds);
			KAddImpulse( KImpulses[0].Impulse, KImpulses[0].Position, KImpulses[0].Bone );
			KImpulses.Remove(0,1);
		}
	}

Begin:
	Sleep(0.15);
	PlayDyingSound();
}


// = ANIM ======================================================================

simulated event AnimEnd(int Channel)
{
	AnimControl.NotifyAnimEnd(Channel);
}

simulated function Setup()
{
	LinkMesh(default.Mesh);
	AssignInitialPose();
}

simulated function AssignInitialPose()
{
	TweenAnim('RunF',0.0);
	AnimBlendParams( 1,		1, 0, 0,, false );
//	AnimBlendParams(1, 1.0, 0.2, 0.2, 'Bip01 Spine1');
	BoneRefresh();
}

simulated function PlayFiring(optional float Rate, optional name FiringMode)
{
	AnimControl.PlayFiring( Rate, FiringMode );
}



// = DEBUG =====================================================================

simulated function DisplayDebug(Canvas C, out float YL, out float Y)
{
	DisplayDebugActor(C,YL,Y);
	DisplayDebugPawn(C,YL,Y);
}



// = INC =======================================================================

#include ../_inc/debug/DebugActor.uc
#include ../_inc/debug/DebugPawn.uc

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	RagSkelName="Bot2"
	RagMinSpeed=24
	RagRestTime=5
	RagImpactVolume=3
	RagImpactInterval=0.5
	RagImpactSound=Sound'EonSP_BeastShrike.PImpactGround'

	bJumpReady=true
}
