uses crt,dos;
var
  regs:registers;
  a,b,c,d:word;
  stat:byte;
  z:longint;
function getser1:byte;
begin
  regs.ah:=2;
  regs.dx:=0;
  intr($14,regs);
  stat:=regs.ah;
  getser1:=regs.al;
end;

procedure putser1(ser:byte);
begin
  regs.ah:=1;
  regs.al:=ser;
  regs.dx:=0;
  intr($14,regs);
end;

function getser2:byte;
begin
  regs.ah:=2;
  regs.dx:=1;
  intr($14,regs);
  stat:=regs.ah;
  getser2:=regs.al;
end;

procedure putser2(ser:byte);
begin
  regs.ah:=1;
  regs.al:=ser;
  regs.dx:=1;
  intr($14,regs);
end;

function status(ser:word):byte;
begin
  regs.ah:=3;
  regs.dx:=ser;
  intr($14,regs);
  status:=regs.ah;
end;

procedure initialize;
begin
  regs.ah:=0;
  regs.al:=$ff;
  regs.dx:=1;
  intr($14,regs);

  regs.ah:=0;
  regs.al:=$ff;
  regs.dx:=0;
  intr($14,regs);

  asm
    mov dx,3fbh
    in  al,dx
    or  al,80h
    out dx,al

    mov dx,3f8h
    mov al,01h
    out dx,al
    inc dx
    mov al,00h
    out dx,al

    mov dx,3fbh
    in  al,dx
    and al,7fh
    out dx,al



    mov dx,2fbh
    in  al,dx
    or  al,80h
    out dx,al

    mov dx,2f8h
    mov al,01h
    out dx,al
    inc dx
    mov al,00h
    out dx,al

    mov dx,2fbh
    in  al,dx
    and al,7fh
    out dx,al
  end;
{  mem[$40:$7c]:=1;
  mem[$40:$7d]:=1;}
end;
var
  s:string;
begin
  s:='The quick brown fox jumps over the lazy dog.'#13#10+
     'What a day to discover something out of a book.'#13#10+
     '______________________________________________________'#13#10;
  initialize;
  clrscr;
  a:=1;
  z:=0;
  readkey;
  putser2(0);
  repeat
    putser1(byte(s[a]));
{    delay(100);}
    write(char(getser2{port[$2f8]s[a]}));
    port[$2fc]:=3;
{    asm

    end;
{    getser2;}
{    putser2(byte(s[a]));}
{    write(char(getser1));}
{    getser1;}

    inc(a);
    inc(z);
    if a>length(s) then a:=1;
  until keypressed;
  writeln(z);
  readkey;
  readkey;
end.