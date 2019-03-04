uses crt;
var ch:char;
    I:integer;
    mystatus,myname:string;

procedure frameout(x1,y1,x2,y2:integer;c:char);
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
    for x:=x1 to x2 do write(c);
    write(#186{'º'});
  end;
  gotoxy(x1-1,y2+1);
  write(#200{'È'});
  for x:=x1 to x2 do write(#205{'Í'});
  write(#188{'¼'});
end;

procedure getinfo;
begin
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

procedure centerread(y:integer;s1:string;var s:string);
var
    d:integer;
begin
  s:='';
  centerwrite(y,s1+s);
  ch:=readkey;
  while not(ch in[#13,#27]) do
  begin
    if (ch=#8)and(length(s)>0)then
      begin
        gotoxy(40-(length(s1+s)-1)div 2,y);
        for i:=1 to length(s1+s) do write(' ');
        delete(s,length(s),1)
      end
      else if (length(s1+s)<76)then s:=s+ch;
    centerwrite(y,s1+s);
    ch:=readkey;
  end;
end;

begin
  clrscr;
  mystatus:='friend';
  myname:='Angelo Lian Lanuza';
{  repeat}
    for I:=0 to 11 do
      frameout(13-I,13-I,68+I,12+I,'°');
    frameout(20,4,60,11,' ');
    centerwrite(4,'This is a Personal Dos Diskette of');
    centerwrite(5,'Miss Roselle Antonio Carreon');
    centerwrite(7,'Given this day');
    centerwrite(8,'Monday, May 9,1994');
    centerwrite(10,'by');
    centerwrite(11,'Someone who always LOVES and CARE . . .');
{    centerwrite(25,'Press: <ESC> to quit or <e> to see and edit some information');}
{    ch:=readkey
  until ch=#27;}
    gotoxy(69,25);write('by: A.L.L.');
  repeat
  until keypressed;
end.
