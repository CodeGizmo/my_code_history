program sndefecs;
uses crt,vgayey,newint09;
var
  ch:char;
  pats:array[0..10,0..100]of byte;
  on,off:byte;

procedure z(freq,vol:word);
var
  b,d:word;
begin
  if freq>=vol then
  for b:=0 to 1 do
  begin
    port[$61]:=on;
    for d:=0 to vol do;
    port[$61]:=off;
    for d:=0 to freq-vol do;
  end;
end;

procedure tring(freq:word);
var v1,v2:word;

begin
  for v1:=1 to 10 do
  for v2:=1 to 100 do
  begin
    z(random(freq)+100,pats[v1,v2]);      { 100 PATTERNS    }
  end;
end;

var
  x,y:byte;
begin
  on:=port[$61]or 3;
  off:=port[$61]and not(3);
  vgamode(1);
  for y:=1 to 10 do
  for x:=1 to 100 do
  begin
    pats[11-y,x]:={random(256);
    round(sqrt(sqr(50)-sqr(x-50))*y/10);}
    round(256*sin(pi*x/50){/(cos(pi*x/50))+1)});
    yeyan(x,100+pats[11-y,x],15);
  end;
  readln;
  ch:=#0;
  repeat
    if keypressed then
    begin
      ch:=readkey;
    end;
    tring(64);
    pats[random(10)+1,random(100)+1]:=random(256);
  until ch=#27;
end.