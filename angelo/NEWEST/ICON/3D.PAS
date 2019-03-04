uses crt,vgaliza3;
var
  x,y,z,r,
  yp,zp,yl,zl,
  d1,d2,d3,d4:integer;
function mysqrt(i:real):real;
begin
  if i<0 then mysqrt:=-sqrt(-i) else mysqrt:=sqrt(i);
end;

procedure sphereit(xx,yy,xpp,ypp,xll,yll,r:integer);
begin
  yp:=xpp;
  zp:=ypp;
  yl:=xll;
  zl:=yll;
  for y:=0 to r*2 do
    for z:=0 to r*2 do
    begin
      if (sqr(y+yp)+sqr(z+zp))<=sqr(r) then
{        yeyan(xx+y,yy+z,(trunc(mysqrt(r*r-sqr(z+zp)-sqr(y+yp))+mysqrt(sqr(r)-sqr(z+zl)-sqr(y+yl))*63/r)));}
        yeyan(xx+y,yy+z,(trunc(mysqrt(r*r-sqr(z+zp+zl)-sqr(y+yp+yl))*63/r)));
    end;
end;
begin
  vgamode(1);
  for d1:=0 to 63 do
  begin
    myup(d1,d1,d1,0);
    myup(64+d1,63-d1,63-d1,0);
  end;
{  sphereit(0,0,-50,-50,25,0,49);
  sphereit(100,100,-25,-25,-12,5,25);}
  repeat
  for d4:=0 to 12 do
    sphereit(0,0,-12,-12,trunc(d4*cos(pi*d4/12)),trunc(d4*sin(pi*(d4/12))),12);
  until keypressed;
  readkey;
end.





  r:=49;
  yp:=-50;
  zp:=-50;
  yl:=25;
  zl:=0;
  for y:=0 to 99 do
    for z:=0 to 99 do
    begin
      if (sqr(y+yp)+sqr(z+zp))<=sqr(r) then
        yeyan(y,z,(trunc(mysqrt(r*r-sqr(z+zp)-sqr(y+yp))+mysqrt(sqr(z+zl)+sqr(y+yl)-sqr(zl)-sqr(yl))*63/r)));
    end;
  readkey;
end.