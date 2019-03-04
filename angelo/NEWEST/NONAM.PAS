uses crt,vgaliza3,rolfazil,dos;
var
  p1,p2,p:pointer;
  a,b,c,d:word;
  h1,m1,s1,hs1,
  h2,m2,s2,hs2:word;
  t,rate:real;
  count:word;
begin
  vgamode(1);
  getmem(p1,65535);
  getmem(p2,65535);
{  getmem(p,65535);}
  aload('pictures\newbunny.liz',p1^);
  uncompress(p1^,ptr($a000,0)^);
  slidewc(ptr($a000,0)^,p1^,64000,13);
  aload('pictures\myicons2.liz',p2^);
  uncompress(p2^,ptr($a000,0)^);
  slidewc(ptr($a000,0)^,p2^,64000,13);
  gettime(h1,m1,s1,hs1);
  count:=0;
  repeat
    inc(count);
    slidewu(p1^,ptr($a000,0)^);
    slidewu(p2^,ptr($a000,0)^);
  until keypressed and(readkey=#27);
  delay(1);
  gettime(h2,m2,s2,hs2);
  vgamode(mtext);
  clear;
  t:=(hs2-hs1+s2*100-s1*100)/100;
  writeln('Elapsed time=',t:5:2,' count=',count:6,' rate=',count*2/t:6:2);
  readkey;
end.