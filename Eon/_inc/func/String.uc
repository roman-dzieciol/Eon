
static final operator(2) string @	( coerce string A, float F )	{ return A @ FSTR(F); }
static final operator(2) string $	( coerce string A, float F )	{ return A $ FSTR(F); }
static final operator(2) string @	( float F , coerce string B )	{ return FSTR(F) @ B; }
static final operator(2) string $	( float F , coerce string B )	{ return FSTR(F) $ B; }
static final operator(2) string $	( float F , float G )			{ return FSTR(F) $ FSTR(G); }
static final operator(2) string @	( float F , float G )			{ return FSTR(F) @ FSTR(G); }

static final operator(2) string $	( coerce string A, rotator R )	{ return A $ R.Pitch$", "$R.Yaw$", "$R.Roll; }
static final operator(2) string @	( coerce string A, rotator R )	{ return A @ R.Pitch$", "$R.Yaw$", "$R.Roll; }
static final operator(2) string $	( rotator R, coerce string B )	{ return R.Pitch$", "$R.Yaw$", "$R.Roll $ B; }
static final operator(2) string @	( rotator R, coerce string B )	{ return R.Pitch$", "$R.Yaw$", "$R.Roll @ B; }
static final operator(2) string @	( rotator R, rotator P )		{ return R.Pitch$", "$R.Yaw$", "$R.Roll @ P.Pitch$", "$P.Yaw$", "$P.Roll; }
static final operator(2) string $	( rotator R, rotator P )		{ return R.Pitch$", "$R.Yaw$", "$R.Roll $ P.Pitch$", "$P.Yaw$", "$P.Roll; }

static final operator(2) string @	( coerce string A, vector V )	{ return A @ V.X$", "$V.Y$", "$V.Z; }
static final operator(2) string $	( coerce string A, vector V )	{ return A $ V.X$", "$V.Y$", "$V.Z; }
static final operator(2) string @	( vector V, coerce string B )	{ return V.X$", "$V.Y$", "$V.Z @ B; }
static final operator(2) string $	( vector V, coerce string B )	{ return V.X$", "$V.Y$", "$V.Z $ B; }
static final operator(2) string $	( vector V, vector W )			{ return V.X$", "$V.Y$", "$V.Z $ W.X$", "$W.Y$", "$W.Z; }
static final operator(2) string @	( vector V, vector W )			{ return V.X$", "$V.Y$", "$V.Z @ W.X$", "$W.Y$", "$W.Z; }

static final operator(255) string %	( coerce string A, coerce string B )	{ return A $ "[" $ B $ "]"; }


static final function string FSTR(float Value, optional int Precision)
{
	local string	IntString, FloatString;
	local float		FloatPart;
	local int		IntPart;

	if( Precision == 0 )	Precision = 6;
	else					Precision = Max(Precision, 1);

	if( Value < 0 )
	{
		IntString = "-";
		Value *= -1;
	}

	IntPart = int(Value);
	FloatPart = Value - IntPart;
	IntString = IntString $ string(IntPart);
	FloatString = string(int(FloatPart * 10 ** Precision));

	while( Len(FloatString) < Precision )
		FloatString = "0" $ FloatString;

//	while (Len(IntString) < Precision)
//		IntString = "0" $ IntString;

	return IntString$"."$FloatString;
}


static function string VSTR(vector V){ return V.X$", "$V.Y$", "$V.Z; }
static function string RSTR(rotator R){ return R.Pitch$", "$R.Yaw$", "$R.Roll; }
static function string QSTR(quat Q){ return Q.X$", "$Q.Y$", "$Q.Z$", "$Q.W; }


static final function CDASTR( coerce array<class> C )
{
	local int i;
	for(i=0; i<C.Length; i++)
		Log(i@C[i],'Log');
}
