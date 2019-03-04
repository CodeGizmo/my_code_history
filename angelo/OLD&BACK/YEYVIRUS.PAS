uses vgayey,crt;
var
  x,y,a,b,lx,ly,c:array[0..255]of word;
  z,pos:word;
  viruses,wx,wy:byte;
  buf:pointer;
begin
  getmem(buf,65535);
  viruses:=250;
  randomize;
  vgamode(1);
  aload('bugbunny.liz',buf^);
  explode(buf^,ptr($a000,0)^);
  readln;
  for z:=0 to viruses do begin x[z]:=160;y[z]:=160;lx[z]:=160;ly[z]:=160;end;
  for z:=0 to viruses do c[z]:=random(16)+16;
  repeat
    for z:=0 to viruses do
    begin
      a[z]:=lx[z];b[z]:=ly[z];
      lx[z]:=x[z];ly[z]:=y[z];
      x[z]:=x[z]+random(11)-5;
      y[z]:=y[z]+random(11)-5;
    end;
    retr;
    for z:=0 to viruses do
    begin
      line(lx[z],ly[z],x[z],y[z],c[z]);
      line(lx[z],ly[z],a[z],b[z],0);
    end;
  until keypressed;
end.