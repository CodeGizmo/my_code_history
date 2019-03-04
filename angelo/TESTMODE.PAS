uses crt;
procedure cmode(m:byte);
begin
  asm
    mov ah,0
    mov al,m
    int 10h
  end;
end;
var
  m:byte;
begin
  m:=$0;
  repeat
    cmode(m);
    writeln('Angelo Lian Lanuza',m:6);
    delay(3500);
{    readln;}
    inc(m);
    if keypressed then begin readkey;readkey;end;
  until m=255;
end.