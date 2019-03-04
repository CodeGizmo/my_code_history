uses crt,graph;

var a,b,c1,c2:word;
    gd,gm:integer;
    c,x,y,lx,ly:integer;
    putactive:boolean;

function ifhigh:byte;
begin
  asm
    mov dx,037Ah
    mov al,0ffh
    out dx,al
    mov dx,0379h
    in  al,dx
    mov byte ptr a,al
  end;
  ifhigh:=a;
end;

function iflow:byte;
begin
  asm
    mov dx,037Ah
    mov al,0h
    out dx,al
    mov dx,0379h
    in  al,dx
    mov byte ptr a,al
  end;
  iflow:=a;
end;

function is_but:boolean;
begin
  c1:=0;
  c2:=0;
  for b:=1 to 5 do
  begin
    if (iflow and $80)=$80 then
      inc(c1);
    if (ifhigh and $80)=$80 then
      inc(c2);
  end;
  if c1=c2 then is_but:=false else is_but:=true;
  delay(6);
end;

function is_down:boolean;
begin
  c1:=0;
  c2:=0;
  for b:=1 to 5 do
  begin
    if (iflow and $40)=$40 then
      inc(c1);
    if (ifhigh and $40)=$40 then
      inc(c2);
  end;
  if c1=c2 then is_down:=false else is_down:=true;
  delay(6);
end;

function is_right:boolean;
begin
  c1:=0;
  c2:=0;
  for b:=1 to 5 do
  begin
    if (iflow and $20)=$20 then
      inc(c1);
    if (ifhigh and $20)=$20 then
      inc(c2);
  end;
  if c1=c2 then is_right:=false else is_right:=true;
  delay(6);
end;

function is_up:boolean;
begin
  c1:=0;
  c2:=0;
  for b:=1 to 5 do
  begin
    if (iflow and $10)=$10 then
      inc(c1);
    if (ifhigh and $10)=$10 then
      inc(c2);
  end;
  if c1=c2 then is_up:=false else is_up:=true;
  delay(6);
end;

function is_left:boolean;
begin
  c1:=0;
  c2:=0;
  for b:=1 to 5 do
  begin
    if (iflow and $08)=$08 then
      inc(c1);
    if (ifhigh and $08)=$08 then
      inc(c2);
  end;
  if c1=c2 then is_left:=false else is_left:=true;
  delay(6);
end;
const z:byte=$ff;
var ch:char;

{begin
  repeat
  if keypressed then ch:=readkey;
  if ch=#13 then
  begin
    ch:=' ';
    z:=not(z);
    port[$378]:=z;
  end;
  write(port[$379]:4);
  until ch=#27;
end.}

begin
  gd:=9;
  gm:=0;
  initgraph(gd,gm,'');
  setgraphmode(vgahi);
  cleardevice;
  x:=320;
  y:=240;
  lx:=x;
  ly:=y;
  c:=0;
  putactive:=false;
  setwritemode(xorput);
  line(lx,0,lx,479);
  line(0,ly,639,ly);
  repeat
    lx:=x;
    ly:=y;
    if is_up then
    begin
      dec(y);
      if y<0 then y:=0;
    end;
    if is_down then
    begin
      inc(y);
      if y>479 then y:=479;
    end;
    if is_left then
    begin
      dec(x);
      if x<0 then x:=0;
    end;
    if is_right then
    begin
      inc(x);
      if x>639 then y:=639;
    end;
    setwritemode(xorput);
    line(lx,0,lx,479);
    line(0,ly,639,ly);
    if is_but then
    begin
      putactive:=not(putactive);
      delay(200);
    end;
    if putactive then putpixel(x,y,1);
    line(x,0,x,479);
    line(0,y,639,y);
  until keypressed;
  closegraph;
end.

