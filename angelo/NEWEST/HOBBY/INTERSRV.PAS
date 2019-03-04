uses crt;
var
  ch:char;
begin
  clrscr;
  repeat
    if keypressed then ch:=readkey;
{    if (port[$3fd]and 1)>0 then}
    begin
      write(port[$3fd]:4,port[$3f8]:4);
    end;
    if ch=#13 then port[$3f8]:=byte('A');
  until ch=#27;
end.