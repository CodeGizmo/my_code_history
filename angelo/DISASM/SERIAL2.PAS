uses crt,dos;
var
  regs:registers;
  a,b,c,d:word;
  stat:byte;

function getser:byte;
begin
  regs.ah:=2;
  regs.dx:=1;
  intr($14,regs);
  stat:=regs.ah;
  getser:=regs.al;
end;

procedure putser(ser:byte);
begin
  regs.ah:=1;
  regs.al:=ser;
  regs.dx:=1;
  intr($14,regs);
end;

procedure initialize;
begin
  regs.ah:=0;
  regs.al:=$ef;
  regs.dx:=1;
  intr($14,regs);
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
  repeat
    write(char(getser));
    putser(byte(s[a]));
    inc(a);
    if a>length(s) then a:=1;
  until keypressed;
end.