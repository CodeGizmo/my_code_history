uses vgaliz,crt,dos;
var
  x,y,a,b:integer;
  p:pointer;
  s:string;
  mys,myo:integer;
begin
  getmem(p,65535);
  vgamode(1);
  aload('e:\tp\bin\turbo.ico',p^);
  myo:=ofs(p^);
  mys:=seg(p^);
{  for c:=0 to 255 do myup(c,random(64),random(64),random(64));}
  for b:=0 to 199 do
  for a:=0 to  15 do
  yeyan(a,b,mem[mys:myo+a+b*16]);
  readln;
end.