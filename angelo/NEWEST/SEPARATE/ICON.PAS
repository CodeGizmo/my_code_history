uses crt;

procedure frameout(x1,y1,x2,y2:integer);
var x,y:integer;
begin
  gotoxy(x1-1,y1-1);
  write(#201{'�'});
  for x:=x1 to x2 do write(#205{'�'});
  write(#187{'�'});
  for y:=y1 to y2 do
  begin
    gotoxy(x1-1,y);
    write(#186{'�'});
    for x:=x1 to x2 do write(' ');
    write(#186{'�'});
  end;
  gotoxy(x1-1,y2+1);
  write(#200{'�'});
  for x:=x1 to x2 do write(#205{'�'});
  write(#188{'�'});
end;

procedure frameclear(x1,y1,x2,y2:integer);
var x,y:integer;
begin
  for y:=y1-1 to y2+1 do
  begin
    gotoxy(x1-1,y);
    for x:=x1-1 to x2+1 do write(' ');
  end;
end;

procedure centerwrite(y:integer;s:string);
begin
  gotoxy(40-(length(s)-1)div 2,y);
  write(s)
end;

