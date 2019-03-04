uses crt;
var a,la:byte;
 b:word;
begin
  clrscr;
  b:=0;
  repeat
    la:=a;
    a:=port[$60];
    if (a<>la)and(a<128) then
    begin
{      port[$60]:=$1c;}
      mem[$40:$1a]:=mem[$40:$1c];
      mem[$b800:b shl 1]:=a;
      b:=b+1;
      if b>1999 then b:=0;
    end;

{    if a<128 then mem[$b800:a shl 1]:=a else mem[$b800:(a-128)shl 1]:=0;}
  until port[$60]=1;
end.