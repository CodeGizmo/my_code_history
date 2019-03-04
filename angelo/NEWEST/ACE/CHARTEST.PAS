uses crt,vgaliza3,chmani2;
var
  p:pointer;
  a:word;
begin
  vgamode(3);
  charload('mychar2.chr',0);
  charxy(0,0);
  for a:=0 to 2550 do
  begin
    charxy((a*6)mod 320,((a*6)div 320)*8);
    font[curchar].tc:=a;
    putcharb(a);
  end;
  readkey;
end.