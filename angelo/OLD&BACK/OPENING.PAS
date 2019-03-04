uses vgayey,crt;
var
  p1,p2:pointer;
  a:word;
begin
  vgamode(1);
  getmem(p1,64000);
  getmem(p2,64000);
  aload('bugbunny.liz',p1^);
  explode(p1^,p2^);
  gseg:=seg(p2^);
  a:=0;
  repeat
    retr;
    retr;
    movebar(0,0,319,199,a,0);
    inc(a);
    if a>319 then a:=0;
  until keypressed;
  readln;
end.