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

procedure centerwrite(y:integer;s:string);
begin
  gotoxy(40-(length(s)-1)div 2,y);
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
    if (ch=#8)and(length(s)>0)then
      begin
        frameclear(40-(length(s)-1)div 2,y,40+length(s)div 2,y);
        delete(s,length(s),1)
      end
      else if (length(s)<76)and((ch in['0'..'9'])or((ch='.')and(pos('.',s)=0)))then s:=s+ch;
    if length(s)>10 then frameout(40-(length(s)-1)div 2,y,40+length(s)div 2,y)
      else  frameout(36,y,45,y);
    centerwrite(y,s);
    ch:=readkey;
  end;
  val(s,x,d);
end;

procedure printscreen(s:string);
var f:file;
    p:pointer;
    a,b:integer;
type
  myptr=array[0..5000]of byte;
begin
  getmem(p,4000);
  assign(f,s);
  rewrite(f,1);
  for a:=0 to 24 do
  begin
    for b:=0 to 79 do
    begin
      myptr(p^)[b]:=mem[$b800:b*2+a*160];
    end;
    myptr(p^)[80]:=13;
    myptr(p^)[81]:=10;
    blockwrite(f,p^,82);
  end;
  close(f);
end;

begin
  repeat
    for I:=0 to 11 do
      frameout(13-I,13-I,68+I,12+I);
    frameout(28,3,53,7);
    centerwrite(3,'A631 - GROUP 7');
    centerwrite(4,'Under Mr. Sia');
    centerwrite(5,'presents');
    centerwrite(7,'Sine''s & e''s approximation');
    centerwrite(11,'L E A D E R:');
    centerwrite(12,'LANUZA, Angelo L.');
    centerwrite(14,'M E M B E R S:');
    centerwrite(15,'GOROSPE, Daniel Francis G.');
    centerwrite(16,'JIMENEZ, Vincent E.');
    centerwrite(17,'HINAHON, Marites B.');
    centerwrite(18,'HUFALAR Jr., Mario Danilo N.');
    centerwrite(19,'RATUM, Ferdinand C.');
    centerwrite(25,'Press: <ESC> to quit, <e> for e raised to x, <s> for Sine of x, or <b> for both');
    printscreen('sample1.wrt');
    repeat
      chosen:=readkey
    until chosen in[#27,'e','s','b'];
    frameclear(40-14,10,40+13,18);
    if chosen<>#27 then
    begin
      centerwrite(10,'Enter A Value for X');
      centerread(12,X);
      centerwrite(15,'Enter Number of Terms of Approximation');
      centerread(17,t);
      terms:=trunc(t);
      if chosen in['e','b']then
      begin
        centerwrite(19,'Using our group made e raised to X gives '+extostr(e(x,terms)));
        centerwrite(20,'   Using Pascal''s e raised to X gives    '+extostr(exp(x)));
      end;
      if chosen in['s','b']then
      begin
        centerwrite(22,'Using our group made Sine of X gives '+extostr(sin(x,terms)));
        centerwrite(23,'   Using Pascal''s Sine of X gives    '+extostr(system.sin(x)));
      end;
      gotoxy(1,25);clreol;
      centerwrite(25,'Press any key to continue or press <ESC> to exit');
      printscreen('sample2.wrt');
      ch:=readkey;
    end;
  until (ch=#27)or(chosen=#27);
end.