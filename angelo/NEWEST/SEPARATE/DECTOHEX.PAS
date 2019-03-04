uses crt;
var
 d,di,df,b:real;
 s:string;

function hexa(d:integer):char;
begin
  if d<10 then hexa:=char(d+byte('0'))else hexa:=char(d+byte('A')-10);
end;

begin
  clrscr;
  write('Enter a Decimal Number -> ');
  readln(d);
  di:=int(d);
  df:=frac(d);
  s:='';
  repeat
    s:=hexa(trunc(di-int(di/16)*16))+s;
    di:=int(di/16);
  until di=0;
  write(s);
  write('.');
  s:='';
  repeat
    s:=hexa(trunc(int(df*16)))+s;
    df:=frac(df*16);
  until df=0;
  write(s);
  writeln;
  write(hexa(0)+hexa(9)+hexa(10)+hexa(15));
  readln;
end.