uses crt,vgaliza3;
var
  a                     :real;
  x,y,z,r,
  yp,zp,yl,zl,
  d1,d2,d3,d4:integer;
  aa,bb:byte;
  red,grn,blu:array[0..255]of byte;
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
{        a:=mysqrt(r*r-sqr(z+zp+zl)-sqr(y+yp+yl))*63/r;}
(*        yeyan(xx+y,yy+z,trunc({arctan(mysqrt(1-sqr(a)/(a+0.000000001)))/pi}a));*)
        yeyan(xx+y,yy+z,(trunc(mysqrt(r*r-sqr(z+zp+zl)-sqr(y+yp+yl))*63/r))+1);
    end;
end;
begin
  vgamode(1);
  for d1:=1 to 64 do
  begin
    myup(d1     ,64-d1  ,d1-1   ,48-(d1 div 2));
    myup(64+d1  ,d1-1   ,64     ,16-(d1 div 4));
    myup(128+d1 ,64-d1  ,64-d1  ,0);
    myup(128+64+d1,d1-1 ,0   ,(d1*48 div 64));
  end;
  sphereit(0,0,-50,-50,25,0,49);
  sphereit(100,100,-25,-25,-12,5,25);
(*  repeat
  for d4:=-12 to -6 do
    sphereit(0,0,-12,-12,trunc(d4*cos(pi*d4/12)),0{trunc(d4*sin(pi*(d4/12)))},12);
  for d4:=6 to 12 do
    sphereit(0,0,-12,-12,trunc(d4*cos(pi*d4/12)),0{trunc(d4*sin(pi*(d4/12)))},12);
  until keypressed;
  readkey;*)
  for aa:=0 to 255 do mygetdac(aa,red[aa],grn[aa],blu[aa]);
  while not keypressed do
  begin
    inc(bb);
    for aa:=32 to 255 do
    begin
      if aa and 63=63 then retr;
      myup(aa,red[aa+bb],grn[aa+bb],blu[aa+bb]);
    end;
    retr;
  end;
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