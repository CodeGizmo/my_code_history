program mouse;
uses crt;
var
  a,x,y:word;
  b:array[0..4]of byte;
  c:byte;
  ch:char;
begin
  x:=0;
  y:=0;
  clrscr;
  gotoxy(1,1);
  a:=0;
  c:=0;
  repeat
  repeat
    if port[$3fd]=97 then
    begin
      b[c]:=port[$3f8];
{      write(port[$3f8]:4,port[$3f8]:4,port[$3f8]:4,port[$3f8]:4);
      inc(a);
      if a>99 then begin a:=0;gotoxy(1,1)end;  }
      gotoxy(1,1);write('x=',x,' y=',y,'    ');
      inc(c);
      if c=5 then c:=0;
      if c=1 then
      begin
        if b[1]>127 then dec(x)else inc(x);
      end else if c=2 then
      begin
        if b[2]>127 then inc(y)else dec(y);
      end;
    end;
  until keypressed;
  ch:=readkey;
  ch:=readkey;
  until ch=#27;
end.
