uses vgayey,crt;
var
  p,buf:pointer;
  a,x,y,zx,z,myx,myy:word;
  yi:byte;
  ch:char;
begin
  getmem(buf,65535);
  vgamode(1);
  aload('bugbunny.liz',buf^);
  explode(buf^,ptr($9000,0)^);
  move(ptr($9000,0)^,ptr($a000,0)^,64000);
  clear;
  gseg:=$9000;
  repeat
  for x:=0 to 320 do
  begin
    myx:=160+trunc(50*sin(x*pi/160))-gofs;
    myy:=100+trunc(50*cos(x*pi/160));
    movesphere(myx,myy,19,myx,myy);
    movebar(x,0,x+20,199,x,0);
    movebar(0,0,319,10,0,x);
    line(x,0,x,199,0);
    movesphere(x,100,30,160,100);
    movesphere(160,x,10,160,100);
    retr;
    circle(myx,myy,20,0);
    circle(myx,myy,19,0);
    if keypressed then begin ch:=readkey; exit;end;
  end;
  until keypressed;
  ch:=readkey;
end.