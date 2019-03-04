uses crt,vgaliza;
var
  x,y,a,b:word;
  ch:char;
  p,p2:pointer;
  myseg,myofs:word;
  counter:word;
begin
  vgamode(3);
  getmem(p,65535);
  getmem(p2,65535);
  aload('pictures\ship.liz',p^);
  uncompress(p^,ptr($a000,0)^);
  gmis:=1;
  getthis(0,0,319,199,p^);
  gmis:=3;
  putthis(0,0,p^,0);
  ch:=readkey;
  syaofs:=0;
  counter:=0;
  repeat
    syaofs:=syaofs+80;
    retr;
    setdofs(syaofs);
    inc(counter);
  until keypressed;
  vgamode(mtext);
  writeln('counter is ',counter);
  readln;
end.