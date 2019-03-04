uses crt,vgaliza3,charmani;
var
  ch:char;
  a,b,c,d,d1,d2:word;
  p:pointer;
begin
  vgamode(3);
  newchar(8,8,0);
  newchar(8,8,1);
  charload('mychar0.chr',0);
  charload('mychar1.chr',1);
  for a:=0 to 255 do
  begin
    curchar:=0;
    font[curchar].tc:=a;
    putchar2(a);
    curchar:=1;
    font[curchar].tc:=a;
    putchar2(a);
  end;
  readkey;
end.