uses crt;
var ch:char;
const a:byte=0;
begin
  repeat
    if keypressed then
    begin
      ch:=readkey;
      if ch=#13 then
      begin
        a:=not(a);
        port[$378]:=a;
      end;
    end;
    write(port[$379]:4);
  until ch=#27;
end.