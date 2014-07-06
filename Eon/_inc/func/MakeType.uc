function vector		MVect	(float X, float Y, float Z)				{	local vector V; V.X=X; V.Y=Y; V.Z=Z; return V;	}
function color		MCol	(byte R, byte G, byte B, byte A)		{	local color C; C.R=R; C.G=G; C.B=B; C.A=A; return C;	}
function rotator	MRot	(float Pitch, float Yaw, float Roll)	{	local rotator R; R.Pitch=Pitch; R.Yaw=Yaw; R.Roll=Roll; return R;	}
