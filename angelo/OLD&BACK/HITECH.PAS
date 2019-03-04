uses vgaliz,crt;
var
  squareroot:array[0..16383]of word;
  x,y,z,a,b,c:word;
  w:byte;
function qr(n:word):byte;
begin
  qr:=squareroot[n shr 2];
end;
procedure init;
begin
  directvideo:=false;
  for x:=0 to 16383 do
  begin
    squareroot[x]:=trunc(sqrt(x));
    gotoxy(1,1);writeln(x);
  end;
end;
begin
  vgamode(1);
{  init;}
  aload('sr.all',ptr(seg(squareroot),ofs(squareroot))^);
  for x:=0 to 319 do
  for y:=0 to 199 do
  begin
    z:=qr(x*y-x*x+y*y)+qr(x*y+x*x-y*y);
    yeyan(x,y,z);
  end;
  readln;
  aload('art.all',ptr($a000,0)^);
{  for x:=0 to 63 do
  begin
    retr;
    mix(0,255,x,63,0,63-x,0,63);
  end;              }
  readln;
end.