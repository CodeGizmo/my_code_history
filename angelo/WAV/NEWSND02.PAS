uses newint09,vgaliza3;
var
  on,off:byte;
  qualvol:array[0..8192]of word;
  fader,fade,outcomevol:word;
  beat,pos:word;
  ch:char;

procedure trig;
begin
  for pos:=0 to 8191 do
  begin
    outcomevol:=qualvol[pos];
    port[$61]:=on;
    for beat:=0 to outcomevol do;
    port[$61]:=off;
    for beat:=outcomevol to 1024 do;
  end;
end;{trig}

begin
  on:=port[$61]or 2;
  off:=port[$61]and not(3);
  vgamode(1);
  gotomyint9;
  key:=0;
  for fade:=16 to 1 do
  begin
    for fader:=0 to 511 do
    begin
      qualvol[(fade-1)*512+fader]:=(fade-1)*512+fader;
    end;
  end;
  repeat
    if myreadkey=$1c then begin clear;trig;end;
  until key=1;
  goaway;
end.