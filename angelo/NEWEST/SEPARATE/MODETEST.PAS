uses vgaliza,crt;
var
  x,y:integer;
  a:byte;
  ch:char;

procedure beep;
begin
  sound(1200);
  delay(50);
  nosound;
end;
begin
  beep;
  directvideo:=false;
  for a:=80 to 255 do
  begin
{    vgamode(128+mtexthi);}
    vgamode(a);
    beep;
    for x:=0 to 319 do
    for y:=10 to 199 do
      yeyan(x,y,x*y);
    beep;
    writeln('Mode is',a);
{    ch:=readkey;}
    delay(200);
  end;
end.