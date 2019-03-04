program approximation;
uses crt;
var
  t,X:extended;
  I,terms:longint;
  chosen,ch:char;

function SIN(x:extended;t:longint):extended;
var
  result,raised,factored1,factored2:extended;
  count:longint;
  sign:longint;
begin
  x:=x-trunc(x/pi/2)*pi*2;
  result:=x;
  sign:=-1;
  raised:=x;
  factored1:=1;
  factored2:=1;
  for count:=1 to t do
  begin
    inc(t);
    raised:=raised*x*x;
    factored1:=factored1*(count*2);
    factored2:=factored2*(count*2+1);
    result:=result+sign*raised/factored1/factored2;
    sign:=sign*(-1);
  end;
  sin:=result;
end;

function e(x:extended;t:longint):extended;
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
  e:=result;
end;

procedure frameout(x1,y1,x2,y2:integer);
var x,y:integer;
begin
  gotoxy(x1-1,y1-1);
  write(#201{'É'});
  for x:=x1 to x2 do write(#205{'Í'});
  write(#187{'»'});
  for y:=y1 to y2 do
  begin
    gotoxy(x1-1,y);
    write(#186{'º'});
    for x:=x1 to x2 do write(' ');
    write(#186{'º'});
  end;
  gotoxy(x1-1,y2+1);
  write(#200{'È'});
  for x:=x1 to x2 do write(#205{'Í'});
  write(#188{'¼'});
end;

procedure frameclear(x1,y1,x2,y2:integer);
var x,y:integer;
begin
  gotoxy(x1-1,y1-1);
  for x:=x1-1 to x2+1 do write(' ');
  for y:=y1 to y2 do
  begin
    gotoxy(x1-1,y);
    write(' ');
    for x:=x1 to x2 do write(' ');
    write(' ');
  end;
  gotoxy(x1-1,y2+1);
  for x:=x1-1 to x2+1 do write(' ');
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

procedure centerwritewithframe(y:integer;s:string);
begin
  frameout(41-length(s)div 2,y,41+(length(s)-1)div 2,y);
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
    if (ch=#8)then
      begin
        frameclear(41-length(s)div 2,y,41+(length(s)-1)div 2,y);
        delete(s,length(s),1)
      end
      else if (length(s)<76)and((ch in['0'..'9'])or((ch='.')and(pos('.',s)=0)))then s:=s+ch;
    if length(s)>10 then frameout(41-length(s)div 2,y,41+(length(s)-1)div 2,y)
      else  frameout(36,y,45,y);
    centerwrite(y,s);
    ch:=readkey;
  end;
  val(s,x,d);
end;

begin
  repeat
    for I:=0 to 11 do
      frameout(13-I,13-I,68+I,12+I);
    frameout(41-13,3,41+12,6);
    centerwrite(3,'GROUP 7');
    centerwrite(4,'presents');
    centerwrite(6,'Sine''s & e''s approximation');
    centerwritewithframe(10,'Angelo');
    repeat
      chosen:=readkey
    until chosen in['q','e','s','b'];
    if chosen<>'q' then
    begin
      centerwrite(10,'Enter A Value for X');
      centerread(12,X);
      centerwrite(15,'Enter Number of Terms of Approximation');
      centerread(17,t);
      terms:=trunc(t);
      if chosen in['e','b']then
      begin
        centerwrite(19,'Using our own made e raised to X gives '+extostr(e(x,terms)));
        centerwrite(20,'Using Pascal''s e raised to X gives '+extostr(exp(x)));
      end;
      if chosen in['s','b']then
      begin
        centerwrite(22,'Using our own made Sine of X gives '+extostr(sin(x,terms)));
        centerwrite(23,'Using Pascal''s Sine of X gives '+extostr(system.sin(x)));
      end;
      centerwrite(25,'Press any key to continue or press <ESC> to exit');
      ch:=readkey;
    end;
  until (ch=#27)or(chosen='q');
end.