uses crt,vgaliza;
var
  x,y,a,b:word;
  ch:char;
  p,p2:pointer;
  myseg,myofs:word;
begin
  vgamode(3);
  getmem(p,65535);
  getmem(p2,65535);
  aload('pictures\ship.liz',p^);
  uncompress(p^,p2^);
  gseg2:=seg(p2^);
  gofs2:=ofs(p2^);
  for x:=0 to 319 do
  for y:=0 to 199 do
  yeyan(x,y,yeyun2(x,y));
  aload('pictures\ship.liz',p^);
  uncompress(p^,p2^);
  gseg2:=seg(p2^);
  gofs2:=ofs(p2^);
  for x:=0 to 319 do
  for y:=0 to 199 do
  begin
    yeyan(x,y+200,yeyun2(x,y));
    yeyan(x,y+400,yeyun2(x,y));
  end;
  readkey;
  repeat
    retr;
    setdofs(sydofs);
{    retr;
    setdofs(sydofs+16000);}
    sydofs:=sydofs+80;
  until keypressed;
end.