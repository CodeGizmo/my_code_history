uses crt;
var
 d,di,df,b:real;
 s:string;
begin
  clrscr;
  write('Enter a Decimal Number -> ');
  readln(d);
  di:=int(d);
  df:=frac(d);
  s:='';
  repeat
    s:=char(trunc(di-int(di/2)*2)+byte('0'))+s;
    di:=int(di/2);
  until di=0;
  write(s);
  write('.');
  s:='';
  repeat
    s:=char(trunc(int(df*2))+byte('0'))+s;
    df:=frac(df*2);
  until df=0;
  write(s);
  readln;
end.