uses vgayey,crt;
var
  ch:char;
  xp:array[0..100]of word;
  yp:array[0..100]of word;
  zp:array[0..100]of word;
  nxp:array[0..100]of word;
  nyp:array[0..100]of word;
  nzp:array[0..100]of word;
  a:word;
  degreeofvision:real;
  td:word;

procedure giveshape;
begin
  xp[1]:=0;xp[2]:=0;  xp[3]:=2;xp[4]:=2;
  yp[1]:=0;yp[2]:=2;  yp[3]:=2;yp[4]:=0;
  zp[1]:=0;zp[2]:=0;  zp[3]:=0;zp[4]:=0;
  xp[5]:=0;xp[6]:=0;  xp[7]:=2;xp[8]:=2;
  yp[5]:=0;yp[6]:=2;  yp[7]:=2;yp[8]:=0;
  zp[5]:=2;zp[6]:=2;  zp[7]:=2;zp[8]:=2;
end;

procedure makeshape(c:byte);
begin
  line(nxp[1],nyp[1],nxp[2],nyp[2],c);
  line(nxp[3],nyp[3],nxp[2],nyp[2],c);
  line(nxp[3],nyp[3],nxp[4],nyp[4],c);
  line(nxp[1],nyp[1],nxp[4],nyp[4],c);

  line(nxp[6],nyp[6],nxp[2],nyp[2],c);
  line(nxp[1],nyp[1],nxp[5],nyp[5],c);
  line(nxp[3],nyp[3],nxp[7],nyp[7],c);
  line(nxp[4],nyp[4],nxp[8],nyp[8],c);

  line(nxp[5],nyp[5],nxp[6],nyp[6],c);
  line(nxp[7],nyp[7],nxp[6],nyp[6],c);
  line(nxp[7],nyp[7],nxp[8],nyp[8],c);
  line(nxp[5],nyp[5],nxp[8],nyp[8],c);
end;

procedure givenew;
begin
  for a:=0 to 100 do
  begin
    if zp[a]<>0 then
    begin
      nxp[a]:=trunc(arctan(xp[a]/(zp[a]))/degreeofvision*266);
      nyp[a]:=trunc(arctan(yp[a]/(zp[a]))/degreeofvision*199);
    end else
    begin
      nxp[a]:=266;
      nyp[a]:=199;
    end;
  end;
end;

procedure agivenew;
begin
  td:=320;
  for a:=0 to 100 do
  begin
{    if zp[a]<>0 then}
    begin
      nxp[a]:=10*xp[a]*(td-zp[a]*10)div td;
      nyp[a]:=10*yp[a]*(td-zp[a]*10)div td;
    end;{ else
    begin
      nxp[a]:=266;
      nyp[a]:=199;
    end; }
  end;
end;

procedure change(xpp,ypp,zpp:integer);
begin
  for a:=0 to 10 do
  begin
    xp[a]:=xp[a]+xpp;
    yp[a]:=yp[a]+ypp;
    zp[a]:=zp[a]+zpp;
  end;
  agivenew;
end;

begin
  degreeofvision:=0.785398163;
  vgamode(1);
  giveshape;
  change(1,1,5);
  makeshape(15);
  repeat
    ch:=readkey;
    makeshape(0);
    if ch='q' then change(1,0,0);
    if ch='w' then change(-1,0,0);
    if ch='a' then change(0,1,0);
    if ch='s' then change(0,-1,0);
    if ch='z' then change(0,0,1);
    if ch='x' then change(0,0,-1);
    if ch='+' then degreeofvision:=degreeofvision+0.017453292;
    if ch='-' then degreeofvision:=degreeofvision-0.017453292;
    if (ch='+')or(ch='-')then givenew;
    makeshape(15);
  until ch=#27;
end.