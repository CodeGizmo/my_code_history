uses crt,mytimer,newint09,vgaliz;
var
  on,off:byte;
  qualvol:array[0..8192]of byte;
  qualpit:array[0..8192]of byte;
  fader,fade,outcomevol:byte;
  beat,counter,pos:word;
  ch:char;
  newkey,lastkey:byte;
var last:integer;
procedure tring;
var myp:integer;
begin
  myp:=0;
  last:=360;
  fade:=13;
  on:=port[$61]or 2;
  off:=port[$61]and not(3);
  for pos:=0 to last do
  begin
	 qualvol[pos]:=trunc(32*sin(pos*pi/360));
         qualpit[pos]:=trunc(32*sin(pos*pi/360));
	 yeyan(pos,qualvol[pos],15);
  end;
  for fader:=fade downto 1 do
  begin
	 for pos:=0 to last do
	 begin

            myp:=qualpit[pos];
            myp:=pos;
		outcomevol:=fader*qualvol[pos]div fade;
		yeyan(pos,outcomevol,fader);
		port[$61]:=on;
		for beat:=0 to outcomevol do;
		port[$61]:=off;
		for beat:=outcomevol to 48+myp do;
	 end;
  end;
end;

begin
  vgamode(1);
  gotomyint9;
  key:=0;
  repeat
	 clear;tring;
  until key=1;
  goaway;
end.