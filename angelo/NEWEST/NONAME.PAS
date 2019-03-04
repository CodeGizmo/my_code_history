uses crt,vgaliza3,rolfazil;
var
  p1,p2,p:pointer;
  a,b,c,d:word;
begin
  vgamode(1);
  getmem(p1,65535);
  getmem(p2,65535);
{  getmem(p,65535);}
  aload('pictures\newbunny.liz',p1^);
  uncompress(p1^,ptr($a000,0)^);
  slidec(ptr($a000,0)^,p1^,64000,2);
  aload('pictures\myicons2.liz',p2^);
  uncompress(p2^,ptr($a000,0)^);
  slidec(ptr($a000,0)^,p2^,64000,2);
  repeat
    slideu(p1^,ptr($a000,0)^);
    slideu(p2^,ptr($a000,0)^);
  until keypressed and(readkey=#27);
end.