uses mytimer,vgayey2;
var a,x,y:word;
    p:pointer;
begin
  vgamode(1);
  readln;
  clockon;
  for a:=0 to 10 do
    for x:=0 to 319 do
    for y:=0 to 199 do
    mem[$a000:x+y*320]:=a;
  clockoff;
  vgamode($ff);
  writeln(dt:8:8);
  readln;
end.