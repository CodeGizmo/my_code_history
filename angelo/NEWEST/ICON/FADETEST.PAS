uses crt,vgaliza3;
var
  p:pointer;
  red,grn,blu:array[0..255]of byte;
  a,b,c,d:byte;
begin
  getmem(p,65530);
  vgamode(1);
  aload('..\pictures\newbunny.liz',p^);
  uncompress(p^,ptr($a000,0)^);
  for a:=0 to 255 do mygetdac(a,red[a],grn[a],blu[a]);
  repeat
    for b:=63 downto 0 do
    begin
      retr;
      for a:=0 to 255 do
        myup(a,red[a]+(63-red[a])*b div 63,
               grn[a]+(63-grn[a])*b div 63,
               blu[a]+(63-blu[a])*b div 63);
      b:=b-1;
    end;
    delay(1500);
    for b:=0 to 63 do
    begin
      retr;
      for a:=0 to 255 do
        myup(a,red[a]+(63-red[a])*b div 63,
               grn[a]+(63-grn[a])*b div 63,
               blu[a]+(63-blu[a])*b div 63);
      b:=b+7;
    end;
  until keypressed;

{  repeat
    for b:=63 downto 0 do
    begin
      retr;
      for a:=0 to 255 do
        myup(a,red[a]*b div 63,grn[a]*b div 63,blu[a]*b div 63);
      b:=b-3;
    end;
    for b:=0 to 63 do
    begin
      retr;
      for a:=0 to 255 do
        myup(a,red[a]*b div 63,grn[a]*b div 63,blu[a]*b div 63);
      b:=b;
    end;
  until keypressed;}
  readkey;
end.