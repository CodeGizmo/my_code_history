uses crt,vgaliza3;
function V(x,y,z,m:longint):word;
var
  h:extended;
  vi:extended;
begin
  h:=sqrt(x*x+y *y+z*z);
  vi:=z*200*200{z*z}*m/(h*h*h);
  V:=round(vi);
end;
var x,y,z:word;
    vr,
    vr1,
    vr2,vr3,vr4:word;
    rrr:byte;
begin
  vgamode(3);
  for x:=0 to 63 do
    myup(x,x,x,x);
  for x:=64 to 255 do
    myup(x,63,63,63);
  rrr:=0;
  for y:=0 to 399 do
    for x:=0 to 319 do
    begin
      vr1:=V(x+random(rrr),y+random(rrr),300,63);
      vr4:=V(319+16-x-random(rrr),399+16-y-random(rrr),150,63);
{      vr3:=V(x,399-y,150,63);
      vr4:=V(319-x,399-y,100,106);}
      yeyan(x,y,{round(vr1*abs(sin(sqrt(x*x+y*y)/8)))}vr1+vr4);
    end;
  y:=0;
  repeat
    for x:=0 to 63 do
      myup(x+y,x,x,x);
    for x:=64 to 255 do
      myup(x+y,63,63,63);
    inc(y);
    retr;
  until keypressed;
  readkey;
end.
