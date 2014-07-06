/* =============================================================================
:: File Name	::	Eon_Error.uc
:: Description	::	Deprecated
:: =============================================================================
:: Revision history:
:: 00.10.00 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_Error extends Object
	abstract;


struct sConfigError
{
	var() string	Section;
	var() string	Property;
	var() string	Value;
};


var() sConfigError	ConfigErrors[1000];
var() string		MapErrors[1000];

var() array<int>	PendingErrors;


static function AddError( int i )
{
	default.PendingErrors[default.PendingErrors.Length] = i;
}

static function int GetError()
{
	local int i;
	if( default.PendingErrors.Length > 0 )
	{
		i = default.PendingErrors[0];
		default.PendingErrors.Remove(0,1);
	}
	else
	{
		i = -1;
	}
	return i;
}

static function string GetErrorText( int ErrorCode, optional string CRLF )
{
	local string S;
	local int i;

	S =	"Error #" $ErrorCode@ "Detected!"$CRLF$CRLF;
	i = int(Right(string(ErrorCode),3));

	switch( int(Mid(string(ErrorCode),0,1)) )
	{
		case 1:		return "Configuration"	@ S @	GetErrorTextConfig(i, CRLF);
		case 2:		return "Map"			@ S @	default.MapErrors[i];
	}
}

static function string GetErrorTextConfig( int i, optional string CRLF )
{
	local string S;

	if( default.ConfigErrors[i].Section != "" )
	{
		S = "In ";
		switch( int(Left(string(i), 0)) )
		{
			case 0:		S = S $	"main config file";		break;
			case 1:		S = S $	"user config file";		break;
			default:	S = S $	"config file";			break;
		}
		S = S $	", section [" $ default.ConfigErrors[i].Section $ "]";
		S = S $	", property " $ default.ConfigErrors[i].Property;
		S = S $	", expected: " $ CRLF $ default.ConfigErrors[i].Value;
	}
	else
		S = "Unknown Configuration Error";

	return S;
}
/*
static function LogError( int i )
{
	Log(, 'Error');
}*/

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	ConfigErrors(001)=(Section="Engine.Engine",Property="GUIController",Value="EonGUI.GUIController")
	MapErrors(001)="A KeyPosition has no ParentPosition assigned, see the log file for details."
	MapErrors(002)="A SpawnPoint has no KeyPosition assigned, see the log file for details."
	MapErrors(003)="A PrimaryPosition has no Ownership set, see the log file for details."
}
