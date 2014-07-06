
/* =============================================================================
:: File Name	::	Eon_Console.uc
:: Description	::	none
:: =============================================================================
:: Revision history:
:: 00.10.10 - Roman Dzieciol, Created
:: =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
class Eon_Console extends ExtendedConsole;

var() Material	TConsole;
var() Material	TConsoleBack;

state ConsoleVisible
{
	function PostRender( canvas Canvas )
	{

		local float fw,fh;
		local float yclip,y;
		local int idx;

		Canvas.Font = class'HudBase'.static.GetConsoleFont(Canvas);
		yclip = canvas.ClipY*0.5;
		Canvas.StrLen("X",fw,fh);

		Canvas.SetPos(0,0);
		Canvas.SetDrawColor(255,255,255,200);
		Canvas.Style=4;
		Canvas.DrawTileStretched(TConsoleBack,Canvas.ClipX,yClip);
		Canvas.Style=1;

		Canvas.SetPos(0,yclip-1);
		Canvas.SetDrawColor(255,255,255,255);
		Canvas.DrawTile(TConsole,Canvas.ClipX,2,0,0,64,2);

		Canvas.SetDrawColor(255,255,255,255);

		Canvas.SetPos(0,yclip-5-fh);
		Canvas.DrawText("(>"@TypedStr$"_");

		idx = SBHead - SBPos;
		y = yClip-y-5-(fh*2);

		if (ScrollBack.Length==0)
			return;

		Canvas.SetDrawColor(255,255,255,255);
		while (y>fh && idx>=0)
		{
			Canvas.SetPos(0,y);
			Canvas.DrawText(Scrollback[idx],false);
			idx--;
			y-=fh;
		}
	}
}

exec function SpeechMenuToggle()
{
}

//

/* =============================================================================
:: Copyright © 2004 Corona Leonis Entertainment, Inc.	 All Rights Reserved.
============================================================================= */
DefaultProperties
{
	TConsole=Material'EonTS_GUI.Background.Dark'
	TConsoleBack=Material'ConsoleBack'
}
