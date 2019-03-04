uses crt,newint09;
var
  a,lastkey:byte;
begin
  clrscr;
  gotomyint9;
  for a:=0 to 255 do
    mykey[a]:=0;
  key:=0;
  repeat
    for a:=0 to 255 do
    mem[$b800:a shl 1]:=mykey[a];
    mem[$b800:2000]:=key;
    mem[$b800:2002]:=bkey;
    gotoxy(1,24);writeln(key:4,bkey:4);
  until key=$1;
  goaway;
end.