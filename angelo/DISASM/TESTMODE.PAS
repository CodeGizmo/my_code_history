uses crt,dos,vgaliza3;
var
  regs:registers;
  mode:word;
  maxx,maxy:word;
  x,y,z:word;
  ch:char;
  xxx:boolean;
begin
  vgamode(1);
  directvideo:=false;
  for mode:=530 to $37f do
  begin
    regs.ah:=$4f;
    regs.al:=02;
    regs.bx:=mode;
    intr($10,regs);

{    for x:=0 to 199 do}
    for x:=0 to 65535 do mem[$a000:x]:=random(256);
{      for y:=0 to 199 do pset(x,y,x+y);
      begin
{        regs.ah:=$4f;
        regs.al:=02;
        regs.bx:=mode;
        intr($10,regs);
      end;}
    writeln('The Mode is ',mode);
    writeln('The quick brown fox jumps over the lazy dog.');
    ch:=readkey;
    if ch in['+','-','*','/'] then
    begin
      maxx:=320;
      maxy:=200;
      xxx:=true;
      repeat
        if xxx then
        begin
          if ch='+' then inc(maxx);
          if ch='-' then dec(maxx);
          if ch='*' then inc(maxx,10);
          if ch='/' then dec(maxx,10);
        end else
        begin
          if ch='+' then inc(maxy);
          if ch='-' then dec(maxy);
          if ch='*' then inc(maxy,10);
          if ch='/' then dec(maxy,10);
        end;
        for x:=0 to 65535 do mem[$a000:x]:=0;
        for x:=0 to maxx do mem[$a000:x]:=random(256);
        for y:=0 to 25 do mem[$a000:y*maxx]:=random(256);
        for y:=0 to 25 do mem[$a000:y*maxx+4]:=15;
        if ch='s' then
        begin
          regs.ah:=$4f;
          regs.al:=02;
          regs.bx:=4;
          intr($10,regs);
          writeln('mode is', mode);
          writeln('X : ',maxx);
          readkey;
          regs.ah:=$4f;
          regs.al:=02;
          regs.bx:=mode;
          intr($10,regs);
        end;
        ch:=readkey;
      until not(ch in['+','-','*','/','s']);
    end;
{    if ch='+' then for x:=0 to 65535 do begin mem[$a000:x]:=random(256);if readkey=#27 then x:=65535;end;}
    if ch=#27 then exit;
  end;
end.