uses crt,vgaliza3;
var
  f:file;
  ave,t,d,x,y,z,a,b:word;
  p,p2:pointer;
type
  myptr=array[0..65500]of byte;
  word2=^word;
begin
  getmem(p,65530);
  getmem(p2,65530);
  vgamode(1);
  assign(f,'lizhel.tif');
  reset(f);
  blockread(f,p^,filesize(f));
  close(f);
  directvideo:=false;

{  for x:=0 to 255 do
    myup(x,x shr 2,x shr 2,x shr 2);
  for y:=0 to 199 do
    for x:=0 to 150 do
    begin
      yeyan(x,y,myptr(p^)[162+x+y*151]);
    end;
  for y:=0 to 255 do
  begin
    for x:=0 to 255 do
      myup(x,(x*y div 255)shr 2,(x*y div 255)shr 2,(x*y div 255)shr 2);
    retr;
  end;

  for y:=255 downto 0 do
  begin
    for x:=0 to 255 do
      myup(255-x,255-(x*y div 255)shr 2,255-(x*y div 255)shr 2,255-(x*y div 255)shr 2);
    retr;
  end;
  for x:=0 to 15 do
  myup(x,x*63 div 15,x*63 div 15,x*63 div 15);}
  for z:=63 to 63 do
  begin
    gotoxy(20,1);write(z:3);
    for d:=0 to z do
      myup(d,d*63 div z,d*63 div z,d*63 div z);
    for d:=0 to 63 do
      myup(d+64,d*63 div 63,d*63 div 63,d*63 div 63);
    for y:=0 to 199 do
      for x:=0 to 150 do
      begin
        yeyan(x+160,y,(myptr(p^)[162+x+y*151]*64 div 255)+64);
        yeyan(x,y,(myptr(p^)[162+x+y*151]*z div 255));
{        yeyan(x+160,y,(myptr(p2^)[162+x+(y shr 1)*151]*z div 255));}
      end;
  end;
  move(ptr($a000,0)^,p2^,65530);
  gseg:=seg(p2^);
  repeat
  for z:=7 downto 1 do
  begin
    d:=z;
    for y:=0 to (79 div d)-1 do
    for x:=0 to (59 div d)-1 do
    begin
      t:=0;
      for a:=0 to d-1 do
        for b:=0 to d-1 do
          t:=t+yeyun(50+a+x*(d),50+b+y*(d));
      ave:=t div (d) div (d);
      for a:=0 to d-1 do
        for b:=0 to d do
          yeyan(50+a+x*(d),50+b+y*(d),ave);
    end;
{    readkey;}
  end;
  for z:=2 to 6 do
  begin
    d:=z;
    for y:=0 to (79 div d)-1 do
    for x:=0 to (59 div d)-1 do
    begin
      t:=0;
      for a:=0 to d-1 do
        for b:=0 to d-1 do
          t:=t+yeyun(50+a+x*(d),50+b+y*(d));
      ave:=t div (d) div (d);
      for a:=0 to d-1 do
        for b:=0 to d do
          yeyan(50+a+x*(d),50+b+y*(d),ave);
    end;
{    readkey;}
  end;
  until keypressed and(readkey=#27);
{  getthis(0,0,319,199,p^);
  assign(f,'lizhel.all');
  rewrite(f,1);
  blockwrite(f,p^,65000);
  close(f);}
end.