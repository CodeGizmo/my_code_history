uses crt,vgaliza3,charmani;
var
  ch:char;
  a,b,c,d,d1,d2:word;
  p:pointer;
begin
  randomize;
  vgamode(3);
  newchar(charw,charh,0);
  for a:=0 to 255 do
  begin
    defcharget(a,mychar[a]^);
    charxy((a mod 16)*charw,(a div 16)*charh);
    font[curchar].tc:=a;
    font[curchar].tb:=a+64;
    putchar2(a);
  end;
  readkey;
end.