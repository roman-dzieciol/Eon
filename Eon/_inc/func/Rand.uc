function vector CRand( vector Origin, float Radius )
{
	local vector v;
	local float f;

	f = 2*FRand()*pi;
	v = Origin;
	v.x += Radius*sin(f);
	v.y += Radius*cos(f);
	return v;
}

function rotator RRand( float PitchRange, float YawRange, float RollRange )
{
	local rotator	R;
	R.Pitch	= FRand() * PitchRange	- 0.5 * PitchRange;
	R.Yaw	= FRand() * YawRange	- 0.5 * YawRange;
	R.Roll	= FRand() * RollRange	- 0.5 * RollRange;
	return R;
}
