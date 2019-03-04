uses crt;
var
  ch:char;
  a,p:word;
begin
  clrscr;
  repeat
    for a:=0 to 1999 do
      mem[$b800:a shl 1]:=mem[$9000:p*2000+a];
      if keypressed then
      begin
        ch:=readkey;
        if ch='+'then inc(p);
        if ch='-'then dec(p);
      end;
  until ch=#27;

end.