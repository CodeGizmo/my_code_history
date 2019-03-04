program sndefecs;
uses crt,vgayey,mytimer;
var
  ch:char;
  pats:array[0..100]of byte;
  on,off: byte;

procedure az(freq:word;vol:byte);
var
  b,d,v:word;
begin
  v:=trunc(vol*freq/255);
  for b:=0 to trunc((65536+vol*0.1)/(freq+10)) do
  begin
    port[$61]:=on;
    for d:=0 to v do;
    port[$61]:=off;
    for d:=0 to freq-v do;
  end;
end;

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

  for v:=1 to 100 do
  begin
    az(freq,pats[v]);      { 100 PATTERNS    }
  end;
end;

var 
  ff,vol,freq:word;
  as,xx:word;

var
  ons:boolean;
  vol2:byte;
begin
  ons:=false;
  on:=port[$61]or 3;
  off:=port[$61]and not(3);
  vol2:=0;
  freq:=100;
  repeat
    if keypressed then
    begin
      ch:=readkey;
      if ch='d' then inc(vol2,1);
      if ch='f' then dec(vol2,1);
      if ch='e' then inc(freq,20);
      if ch='r' then dec(freq,20);
      if ch='s' then ons:=not(ons);
      gotoxy(1,1);writeln(freq:6,vol2:6);
    end;
    if ons then z(freq,vol2);
  until ch=#27;
end.