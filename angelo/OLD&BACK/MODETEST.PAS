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

procedure mode(m:byte);
begin
   asm
     mov ah,0
     mov al,m
     int 10h
   end;
end;

begin
  beep;
  directvideo:=false;

  gmis:=240;
  for a:=$62 to 255 do
  begin
{    vgamode(128+mtexthi);}
    mode(0);
    mode(a);
    beep;
    for x:=100 to 219 do
    for y:=50 to 150 do
      pset(x,y,x*y);
    for x:=0 to 319 do
    begin
      pset(x,0,x);
      pset(x,199,x);
    end;
    for y:=0 to 199 do
    begin
      pset(0,y,y);
      pset(319,y,y);
    end;
    line(0,0,319,199,14);
    beep;
    writeln('Mode is',a);
    ch:=readkey;
{    delay(200); }
  end;
end.