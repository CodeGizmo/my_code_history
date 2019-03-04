uses vgaliz,crt;
var
  x,y,z:word;
  p:pointer;
  ppseg:word;

var a,b,c:integer;
function sr(w:word):byte;
begin
  b:=1;
  a:=1;
  for c:=0 to 10 do
  begin
    b:=(a+b)div 2;
    a:=w div b;
  end;
  sr:=b;
end;

var ea,eb:real;
function esr(w:word):real;
begin
  eb:=1;
  ea:=1;
  for c:=0 to 10 do
  begin
    eb:=(ea+eb)/2;
    ea:=w/eb;
  end;
  esr:=b;
end;

var b1:byte;
function sqrt256(w:word):byte;
begin
  b1:=w shr 8;
  if w>255 then
    sqrt256:=((w+(b1 shl 8))div mem[ppseg:b1])shr 1
    else sqrt256:=mem[ppseg:w+256];
end;

{function sqrt256(w:word):byte;
begin
  sqrt256:=trunc(sqrt(w));
end;}

var red,green,blue:byte;
    rd,gr,bl:byte;
    rdi,gri,bli:shortint;
    cc:byte;
procedure movedac;
begin
  for c:=0 to 254 do
  begin
    mygetdac(c+1,red,green,blue);
    myup(c,red,green,blue);
  end;
  myup(255,rd,gr,bl);
  rd:=rd+rdi;    gr:=gr+gri;    bl:=bl+bli;
  inc(cc);
  if cc>63 then
  begin
    rdi:=random(2); if rd>0 then rdi:=-rdi;
    gri:=random(2); if gr>0 then gri:=-gri;
    bli:=random(2); if bl>0 then bli:=-bli;
    cc:=0;
  end;
end;

begin
  cc:=0;rd:=0;bl:=0;gr:=0;rdi:=1;gri:=1;bli:=1;
  vgamode(1);
  getmem(p,512);
  aload('sqrt256.all',p^);
  ppseg:=seg(p^);

  for x:=0 to 319 do
  for y:=0 to 199 do
    yeyan(x,y,(sqrt256(x*x-y*y+x*y+x+y)+sqrt256(y*y-x*x))shr 1);
  repeat
    movedac;
    retr;
  until keypressed;
  b1:=ord(readkey);

  for x:=0 to 319 do
  for y:=0 to 199 do
    yeyan(x,y,(sqrt256(x*x-y*y+x*y+x+y)+sqrt256(y*y-x*x)+sqrt256(65535-x*y))shr 1);

  repeat
    movedac;
    retr;
  until keypressed;
  b1:=ord(readkey);


  for x:=0 to 319 do
  for y:=0 to 199 do
    yeyan(x,y,sqrt256(65536-x*x-y*y));

  repeat
    movedac;
    retr;
  until keypressed;
  b1:=ord(readkey);

  for x:=0 to 319 do
  for y:=0 to 199 do
    yeyan(x,y,x*x+y*y);

  repeat
    movedac;
    retr;
  until keypressed;
  b1:=ord(readkey);

  for x:=0 to 319 do
  for y:=0 to 199 do
    yeyan(x,y,x*y);

  repeat
    movedac;
    retr;
  until keypressed;
  b1:=ord(readkey);

  for x:=0 to 319 do
  for y:=0 to 199 do
    yeyan(x,y,sqrt256(x*y-x*x+y*y)+sqrt256(x*y+x*x-y*y));


  repeat
    movedac;
    retr;
  until keypressed;
  b1:=ord(readkey);

  for x:=0 to 319 do
  for y:=0 to 199 do
    yeyan(x,y,sqrt256(x*y+x*y*x+y*x*y+x*x*x+y*y*y+x*x+y*y));

  repeat
    movedac;
    retr;
  until keypressed;
  b1:=ord(readkey);

  for x:=0 to 319 do
  for y:=0 to 199 do
    yeyan(x,y,sqrt256(x*y+x*y*x+y*x*y));

  repeat
    movedac;
    retr;
  until keypressed;
  b1:=ord(readkey);

  for x:=0 to 319 do
  for y:=0 to 199 do
    yeyan(x,y,sqrt256(x*y)+sqrt256(x*y+x*y*x-y*x*y-x+y+x*x-y*y));

  repeat
    movedac;
    retr;
  until keypressed;
  b1:=ord(readkey);


  freemem(p,512);
end.