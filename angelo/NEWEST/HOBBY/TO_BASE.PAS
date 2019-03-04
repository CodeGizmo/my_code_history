program decimal_to_base;
{Started : Oct. 15, 1994; 10:32pm}
{Midway  : Oct. 15, 1994; 10:46pm}
{Finished: Oct. 15, 1994; 10:55pm}
uses crt;
var dd,nn:word;
function to_base(d,N:word):string;
var s,base:string;
begin
  if (n>16)or(n<=1)then to_base:='invalid base'
  else
  begin
    s:='';
    base:='0123456789ABCDEF';
    repeat
      s:=base[1+(d mod n)]+s;
      d:=d div n;
    until d=0;
    to_base:=s;
  end;
end;
begin
  clrscr;
  write('Input a number -> ');
  readln(dd);
  write('Enter the base conversion -> ');
  readln(nn);
  writeln('Equivalent to -> ',to_base(dd,nn));
  readln;
end.