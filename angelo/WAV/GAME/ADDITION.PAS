procedure cursorhide;
begin
  asm
    mov ah,1
    mov ch,50
    mov cl,50
    int 10h
  end;
end;

procedure cursorshow;
begin
  asm
    mov ah,1
    mov ch,7
    mov cl,8
    int 10h
  end;
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
    for x:=x1 to x2 do write(#176{' '});
    write(#186{'º'});
  end;
  gotoxy(x1-1,y2+1);
  write(#200{'È'});
  for x:=x1 to x2 do write(#205{'Í'});
  write(#188{'¼'});
end;

procedure frameoutcb(x1,y1,x2,y2:integer;c,b:byte);
var x,y:integer;
begin
  gotoxy(x1-1,y1-1);
  textcolor(c);
  textbackground(b);
  write(#201{'É'});
  for x:=x1 to x2 do write(#205{'Í'});
  write(#187{'»'});
  for y:=y1 to y2 do
  begin
    gotoxy(x1-1,y);
    write(#186{'º'});
    for x:=x1 to x2 do write(#176{' '});
    write(#186{'º'});
  end;
  gotoxy(x1-1,y2+1);
  write(#200{'È'});
  for x:=x1 to x2 do write(#205{'Í'});
  write(#188{'¼'});
end;

procedure frameoutcb2(x1,y1,x2,y2:integer;c,b:byte;cb:char);
var x,y:integer;
begin
  gotoxy(x1-1,y1-1);
  textcolor(c);
  textbackground(b);
  write(#201{'É'});
  for x:=x1 to x2 do write(#205{'Í'});
  write(#187{'»'});
  for y:=y1 to y2 do
  begin
    gotoxy(x1-1,y);
    write(#186{'º'});
    for x:=x1 to x2 do write(cb{' '});
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
  gotoxy(41-length(s)div 2,y);
  write(s)
end;

procedure centerwritewithframe(y:integer;s:string);
begin
  frameout(41-length(s)div 2,y,41+(length(s)-1)div 2,y);
  gotoxy(41-length(s)div 2,y);
  write(s)
end;

procedure centerread(y:integer;var s:string);
var
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
      else if (length(s)<76){and((ch in['0'..'9'])or((ch='.')and(pos('.',s)=0)))}then s:=s+ch;
    if length(s)>10 then frameout(41-length(s)div 2,y,41+(length(s)-1)div 2,y)
      else  frameout(36,y,45,y);
    centerwrite(y,s);
    ch:=readkey;
  end;
end;

procedure frameread(x,y1,y2:integer;var s:string);
var size,a,b,c,d:integer;
begin
  cursorshow;
  s:='';
  frameoutcb2(41-((x)shr 1),y1,40+((x+1)shr 1),y2,yellow,blue,' ');
  ch:=readkey;
  size:=0;
  gotoxy(41-((x+1)shr 1)+(size mod x),y1+(size div x));
  while ch<>#13 do
  begin
    if (ch=#8)then
    begin
      if size>0 then
      begin
        mem[$b800:(((y1-1)+((size-1) div x))*80
                      +40-((x+1)shr 1)+((size-1) mod x))shl 1]:=byte(' ');
        dec(size);
        gotoxy(41-((x+1)shr 1)+(size mod x),y1+(size div x));
      end;
    end else
    begin
      if size<256 then
      begin
        inc(size);
        s[size]:=ch;
      end;
    end;
    if size>0 then
    for a:=1 to size do
    begin
      mem[$b800:(((y1-1)+((a-1) div x))*80+40-((x+1)shr 1)+((a-1) mod x))shl 1]:=byte(s[a]);
      gotoxy(41-((x+1)shr 1)+(a mod x),y1+(a div x));
    end;
    ch:=readkey;
  end;
  s[0]:=char(size);
end;
