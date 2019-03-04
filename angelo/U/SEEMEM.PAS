uses crt;
var
  a:word;
  ch:char;
begin
  clrscr;
  repeat
    if keypressed then ch:=readkey;
    for a:=80 to 1999 do
      mem[$b800:a shl 1]:=mem[0:a];
    gotoxy(1,1);writeln(memw[$40:$1a]:6,memw[$40:$1c]:6,mem[$40:$1e+memw[$40:$1a]-30]:6,mem[$40:$1e+memw[$40:$1a]-29]:6);
  until ch=#27;
end.