uses vgaliza3,crt;
var
  ch:char;
  d1,d2:word;
  c:word;
function back(x,y:word;c:byte):byte;
begin
  back:=((yeyun(x-1,y)+yeyun(x,y-1)+yeyun(x+1,y)+yeyun(x,y+1)+yeyun(x,y)))div 5;
end;
procedure fractal(x1,y1,x2,y2:word);
begin
  yeyan(x1,y1,back(x1,y1,c));
  yeyan(x1,y2,back(x1,y1,c));
  yeyan(x2,y1,back(x1,y1,c));
  yeyan(x2,y2,back(x1,y1,c));
  inc(c);
  if not((x1=x2)or(y1=y2))then
  begin
    fractal(x1,y1,(x2+x1)shr 1,(y2+y1)shr 1);
    fractal(((x2+x1)shr 1)+1,y1,x2,((y2+y1)shr 1));
    fractal(((x2+x1)shr 1)+1,((y2+y1)shr 1)+1,x2,y2);
    fractal(x1,((y2+y1)shr 1)+1,(x2+x1)shr 1,y2);
  end;
end;

begin
  vgamode(3);
  for d1:=0 to 64000  do yeyan(random(320),random(400),random(256));
  for d1:=0 to 1000 do line(random(320),random(400),random(320),random(400),random(256));
  for d1:=0 to 1000 do yeyan(random(320),random(400),255);
{  mix(0,63   ,0 ,63,0 ,0 ,63,63);
  mix(64,127 ,63,63,0 ,63,63,0 );
  mix(128,191,63,0 ,63,63,0 ,0 );
  mix(192,255,0 ,0 ,63,0 ,0 ,63);}
  mix(0,255,0,63,0,63,0,63);
  c:=0;
  repeat
  fractal(80,80,239,239);
  until keypressed;
  ch:=readkey;
end.