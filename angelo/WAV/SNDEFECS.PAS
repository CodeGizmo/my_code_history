{$N+,E+}
program sndefecs;
uses crt,vgayey;
var
  ch:char;
  pats:array[0..100]of byte;
  on,off: byte;

procedure z(freq,vol:word);
var
  b,d:word;
begin
  if freq>vol then
  for b:=0 to 2 do
  begin
    port[$61]:=on;
    for d:=0 to vol do;
    port[$61]:=off;
    for d:=0 to freq-vol do;
  end;
end;

procedure tring(freq:word);
var v:word;

begin

  for v:=100 downto 0 do
  begin
    z(freq,pats[v]);      { 100 PATTERNS    }
  end;
end;

var
  ff,vol,freq:word;
  as,xx:word;

begin
  on:=port[$61]or 3;
  off:=port[$61]and not(3);
  for ff:=1 to 99 do
  pats[100-ff]:=pats[101-ff]+ff;
  vgamode(1);
  for ff:=0 to 100 do
  begin
    pats[ff]:=trunc(100*abs(cos(ff*pi/100)));
    yeyan(ff,pats[ff],15);
  end;
  vol:=0;
  freq:=100;
  ch:=#0;
  repeat
    if keypressed then
    begin
      ch:=readkey;
      if ch='a' then z(freq,vol);
      if ch='s' then tring(freq);
      if ch='d' then inc(vol,4);
      if ch='f' then dec(vol,4);
      if ch='e' then inc(freq,20);
      if ch='r' then dec(freq,20);
      if ch='q' then begin vol:=320;xx:=4 end;
      if vol>60000 then vol:=0;
      if freq>60000 then freq:=0;
      bar(vol,0,319,5,0);
      bar(0,0,vol,5,5);
      bar(freq,100,319,105,0);
      bar(0,100,freq,105,6);
    end;
    z(freq,vol);
  until ch=#27;
end.