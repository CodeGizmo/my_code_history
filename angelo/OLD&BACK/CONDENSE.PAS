uses vgaliz,printer,crt;

var curx:word;
procedure printr(cha:byte);
var vert:byte;
begin
  for a:=0 to 7 do
  begin
    vert:=0;
    for b:=0 to 7 do
    begin
      vert:=(mem[50500:624+cha*8+b]shr(7-a)and 1)shl(7-b)or vert;
      yeyan((curx mod 40)*8+a,(curx div 40)*8+b,(mem[50500:624+cha*8+b]shr(7-a)and 1)* 15);
    end;
  end;
  inc(curx);
end;

procedure printrcu(cha:byte);
var vert:byte;
begin
  for a:=0 to 7 do
  begin
    vert:=0;
    for b:=0 to 3 do
    begin
      vert:=(mem[50500:624+cha*8+b*2]shr(7-a)and 1)shl(7-b)or vert;
      yeyan((curx mod 40)*8+a,(curx div 40)*8+b*2,(mem[50500:624+cha*8+b*2]shr(7-a)and 1)* 15);
    end;
    write(lst,char(vert));
  end;
  inc(curx);
end;

procedure printrcd(cha:byte);
var vert:byte;
begin
  for a:=0 to 7 do
  begin
    vert:=0;
    for b:=0 to 3 do
    begin
      vert:=(mem[50500:624+cha*8+b*2+1]shr(7-a)and 1)shl(7-b)or vert;
      yeyan((curx mod 40)*8+a,(curx div 40)*8+b*2+1,(mem[50500:624+cha*8+b*2+1]shr(7-a)and 1)* 15);
    end;
    write(lst,char(vert));
  end;
  inc(curx);
end;

var length:word;
    cur:word;
    lpos:word;
    lseg:word;
    last:word;
    x:word;
    ch:char;
procedure condense(var buf);
begin
  lseg:=seg(buf);
  last:=myfilesize;
  write(lst,#27,'@');
  write(lst,#27,'Z',#1,#0,#0,   #27,'3',#12,   #27,'J',#4);;;;;;;
  repeat
    write(lst,#27,'@');
    length:=0;
    cur:=lpos;
    while(cur<last)and(mem[lseg:cur]<>13)do begin inc(cur);inc(length)end;
    write(lst,#27,'3',#2);
    curx:=0;

{    ch:=readkey;}
    delay(100);
    write(lst,#27,'Z',char((length*8)and $ff),char((length*8)shr 8));
    for x:=1 to length do printrcu(mem[lseg:lpos+x-1]);
{    for x:=length to 256 do printrcu(0);}

    curx:=0;
    write(lst,#13,#13,#13,#13,#11);

{    ch:=readkey;}
    delay(100);
    write(lst,#27,'Z',char((length*8)and $ff),char((length*8)shr 8));
    for x:=1 to length do printrcd(mem[lseg:lpos+x-1]);
{    for x:=length to 256 do printrcd(0);}

{    write(lst,#27,'J',#10);}
    write(lst,#27,'J',#10);
    lpos:=cur+2;
  until lpos>last;
end;

var y,a,b:word;
    p:pointer;
    filename:string;
begin
  vgamode(1);
  directvideo:=false;
  {write(lst,#27,'@');
  repeat
    write(lst,#27,'3',#2);
    write(lst,#27,'Z',#0,#8);
    for x:=0 to 255 do printrcu(x);
    curx:=0;
    write(lst,#13,#11);
    write(lst,#27,'Z',#0,#8);
    for x:=0 to 255 do printrcd(x);
    ch:=readkey;
    write(lst,#27,'J',#8);
  until ch=#27;}
  getmem(p,65535);
  writeln('name of file to print in super micro:');
  readln(filename);
  if filename<>'cancel'then
  begin
    aload(filename,p^);
    condense(p^);
  end;
end.



