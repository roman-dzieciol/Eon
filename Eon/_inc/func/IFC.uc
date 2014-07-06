static final operator(1) string ? ( bool B, string S )		{ if(B)			 return S;	else return "IFC"; }	// ACHTUNG HACK ALERT
static final operator(0) string : ( string A, string B )	{ if(A != "IFC") return A;	else return B;}

