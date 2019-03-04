uses crt,mytimer,newint09,vgayey;
var
  on,off:byte;
  qualvol:array[0..8192]of byte;
  fader,fade,outcomevol:byte;
  beat,counter,pos:word;
  ch:char;
  newkey,lastkey:byte;

procedure tring;
begin
  fade:=63;
  on:=port[$61]or 2;
  off:=port[$61]and not(3);
  for pos:=0 to 15 do
  begin
	 qualvol[pos]:=round(32*sin(pi*pos/15));
	 yeyan(pos,qualvol[pos],15);
  end;
  for fader:=fade downto 1 do
  begin
	 for pos:=0 to 15 do
	 begin
		outcomevol:=fader*qualvol[pos]div fade;
		yeyan(pos,outcomevol,fader);
		port[$61]:=on;
		for beat:=0 to outcomevol do;
		port[$61]:=off;
		for beat:=outcomevol to 1024 do;
	 end;
  end;
end;

begin
  vgamode(1);
  gotomyint9;
  key:=0;
  repeat
	 if key=$1c then begin clear;tring;end;
  until key=1;
  goaway;
end.