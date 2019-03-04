uses vgaliza3,crt;
var x,y:word;
    c0,c1,c2:byte;
    c:array[0..2,0..255]of byte;
begin
  vgamode(3);
  for x:=0 to 319 do
  for y:=0 to 199 do
  begin
    yeyan(x,y,x*y+x-y+x*x-y*y+x*y*3);
    yeyan(x,y+200,x*y+x+y+x*x+y*y+trunc(x*y*3*sin(x*pi*2/199)/cos(x*pi*2/319)));
  end;
  for x:=0 to 255 do
    for y:=0 to 2 do c[y,x]:=(x shr 2)*y;
  repeat
    retr;
    c0:=c[0,0];
    c1:=c[1,0];
    c2:=c[2,0];
    for x:=0 to 254 do
    begin
      c[0,x]:=c[0,x+1];
      c[1,x]:=c[1,x+1];
      c[2,x]:=c[2,x+1];
      myup(x,c[0,x],c[1,x],c[2,x]);
    end;
    c[0,255]:=c0;
    c[1,255]:=c1;
    c[2,255]:=c2;
    myup(x,c[0,255],c[1,255],c[2,255]);
  until keypressed;
  readkey;
end.