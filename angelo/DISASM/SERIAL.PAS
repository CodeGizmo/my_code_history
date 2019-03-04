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
  s:='Hi! Hello! It''s working! '#13#10;
  initialize;
  clrscr;
  repeat
    for a:=1 to length(s) do
    begin
      write(getser:3,':',stat:3,'|');
      putser(byte(s[a]));
    end;
  until keypressed;
end.