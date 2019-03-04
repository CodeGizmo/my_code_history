program approximation;
uses crt;
var
  X:extended;
  terms:longint;
  ch:char;

function factorial_of(f:longint):extended;
var
  count:longint;
  factored:extended;
begin
  factored:=1;
  if f>0 then
  begin
    for count:=1 to f do
    begin
      factored:=factored*count;
    end;
  end;
{  if factored=0 then factored:=2147483647;}
  factorial_of:=factored;
end;

function raise(x:extended;e:longint):extended;
var
  result:extended;
  count:longint;
begin
  result:=1;
  for count:=1 to e do result:=result*x;
  raise:=result;
end;

function COS(x:extended;t:longint):extended;
var
  result:extended;
  count:longint;
  sign:integer;
begin
  result:=1;
  sign:=-1;
{  if t>16 then t:=16;}
  for count:=1 to t do
  begin
    result:=result+sign*raise(x,count*2)/factorial_of(count*2);
    sign:=sign*(-1);
  end;
  cos:=result;
end;

function e(x:extended;t:longint):extended;
var
  result:extended;
  count:longint;
begin
{  if t>33 then t:=33;}
  result:=1;
  for count:=1 to t do
  begin
    result:=result+raise(x,count)/factorial_of(count);
  end;
  e:=result;
end;

begin
  repeat
    clrscr;
    write('Enter value for X -> ');
    readln(X);
    write('Enter number of terms -> ');
    readln(terms);
    writeln('e raised to X is ',e(x,terms),' ',exp(x));
    writeln('Cosine of X is ',cos(x,terms):0:terms,' ',system.cos(x));
    writeln;
    writeln('Press any key to continue or press <ESC> to exit');
    ch:=readkey;
  until ch=#27;
end.