program approximation;
uses crt;
var
  t,X:extended;
  terms:longint;
  ch:char;

{var
  fresult:extended;
  fcount:longint;
function factorial_of(f:longint):extended;
begin
  if f>fcount then
    for fcount:=fcount+1 to f do
      fresult:=fresult*fcount
  else if f<fcount then
    begin
      fresult:=1;
      for fcount:=1 to f do fresult:=fresult*fcount;
    end;
  factorial_of:=fresult;
end;

procedure refresh_factoring;
begin
  fresult:=1;
  fcount:=1;
end;

var
  rresult:extended;
  rcount:longint;
function raise(x:extended;e:longint):extended;
begin
  if e>rcount then
    for rcount:=rcount+1 to e do
      rresult:=rresult*x
  else if e<rcount then
    begin
      rresult:=1;
      for rcount:=1 to e do rresult:=rresult*x;
    end;
  raise:=rresult;
end;

procedure refresh_raise;
begin
  rresult:=1;
  rcount:=1;
end;

function SIN(xx:extended;t:longint):extended;
var
  x,result:extended;
  count:longint;
  sign:longint;
begin
  x:=xx-trunc(xx/pi/2)*pi*2;
  result:=x;
  sign:=-1;
  for count:=1 to t do
  begin
    result:=result+sign*raise(x,count*2+1)/factorial_of(count*2+1);
    sign:=sign*(-1);
  end;
  sin:=result;
end;}

function SIN2(xx:extended;t:longint):extended;
var
  x,result,raised,factored:extended;
  count:longint;
  sign:longint;
begin
  x:=xx-trunc(xx/pi/2)*pi*2;
  result:=x;
  sign:=-1;
  raised:=x;
  factored:=1;
  for count:=1 to t do
  begin
    inc(t);
    raised:=raised*x*x;
    factored:=factored*(count*2)*(count*2+1);
    result:=result+sign*raised/factored;
    sign:=sign*(-1);
  end;
  sin2:=result;
end;

{function e(x:extended;t:longint):extended;
var
  result: extended;
  count:longint;
begin
  result:=1;
  for count:=1 to t do
  begin
    result:=result+raise(x,count)/factorial_of(count);
  end;
  e:=result;
end;}

function e2(x:extended;t:longint):extended;
var
  result,raised,factored: extended;
  count:longint;
begin
  result:=1;
  raised:=1;
  factored:=1;
  for count:=1 to t do
  begin
    raised:=raised*x;
    factored:=factored*count;
    result:=result+raised/factored;
  end;
  e2:=result;
end;

procedure frameout(x1,y1,x2,y2:integer);
var x,y:integer;
begin
  gotoxy(x1-1,y1-1);
  write('É');{#201}
  for x:=x1 to x2 do write('Í');{#205}
  write('»');{#187}
  for y:=y1 to y2 do
  begin
    gotoxy(x1-1,y);
    write('º');{#186}
    for x:=x1 to x2 do write(' ');
    write('º');
  end;
  gotoxy(x1-1,y2+1);
  write('È');{#200}
  for x:=x1 to x2 do write('Í');
  write('¼');{#188}
end;

function extostr(x:extended):string;
var s:string;
begin
  str(x,s);
  extostr:=s;
end;

function inttostr(x:integer):string;
var s:string;
begin
  str(x,s);
  inttostr:=s;
end;

procedure centerwrite(y:integer;s:string);
begin
  gotoxy(41-length(s)div 2,y);
  write(s)
end;

procedure centerread(y:integer;var x:extended);
var s:string;
    d:integer;
begin
  s:='';
  frameout(36,y,45,y);
  centerwrite(y,s);
  ch:=readkey;
  while ch<>#13 do
  begin
    if (ch=#8)then delete(s,length(s),1)
      else if (length(s)<78)and(ch in['0'..'9','.'])then s:=s+ch;
    if length(s)>10 then frameout(41-length(s)div 2,y,41+(length(s)-1)div 2,y)
      else  frameout(36,y,45,y);
    centerwrite(y,s);
    ch:=readkey;
  end;
  val(s,x,d);
end;

var
  t1,t2:word;
  s:string;

begin
  {refresh_factoring;
  refresh_raise;}
  repeat
    clrscr;
    for t1:=0 to 11 do
      frameout(13-t1,13-t1,68+t1,12+t1);
    centerwrite(10,'Enter A Value for X');
    centerread(12,X);
    centerwrite(15,'Enter Number of Terms');
    centerread(17,t);
    terms:=trunc(t);
    centerwrite(19,'Using our own made e raised to X gives '+extostr(e2(x,terms)));
    centerwrite(20,'Using Pascal''s e raised to X gives '+extostr(exp(x)));
    centerwrite(22,'Using our own made Sine of X gives '+extostr(sin2(x,terms)));
    centerwrite(23,'Using Pascal''s Sine of X gives '+extostr(system.sin(x)));
    centerwrite(25,'Press any key to continue or press <ESC> to exit');
    ch:=readkey;
  until ch=#27;
end.