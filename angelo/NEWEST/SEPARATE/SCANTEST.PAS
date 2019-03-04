uses crt;
var a,b,c,d:word;
begin
  clrscr;
  a:=0;
  repeat
    port[$3eb]:=a;
    {port[$2ab];
    port[$26b];}
    inc(a);
    mem[$b800:0]:=port[$3eb];
    mem[$b800:2]:=port[$2ab];
    mem[$b800:4]:=port[$26b];
  until keypressed;
end.