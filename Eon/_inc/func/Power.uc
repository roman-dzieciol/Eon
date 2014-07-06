
static final function int NextPowerOfTwo2( coerce int in )
{
	in -= 1;
	in = in | (in >> 16);
	in = in | (in >> 8);
	in = in | (in >> 4);
	in = in | (in >> 2);
	in = in | (in >> 1);
	return in + 1;
}

final static function int NextPowerOfTwo( coerce int i )
{
	return 1 << int(loge(i-1) / loge(2)+1);
}

final static function int PrevPowerOfTwo( coerce int i )
{
	return 1 << int(loge(i) / loge(2));
}
