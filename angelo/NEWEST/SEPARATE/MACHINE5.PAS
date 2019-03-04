udses crt;
var ch:char;
    I:integer;
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
      chosen:=readkey
  until (ch=#27)or(chosen=#27);
end.
