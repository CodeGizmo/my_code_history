uses crt,vgaliz,printer;
var
  a,b,c:byte;
  ch:char;
  myseg,myofs:word;
  aw,bw:word;
  x,y:word;

procedure print(xprn,yprn,cha,textcolor:byte);
var
  a,b:byte;
begin
  for a:=0 to 7 do
    for b:=0 to 7 do
      yeyan((xprn shl 3)+b,(yprn shl 3)+a,textcolor*((mem[50500:624+a+cha*8]shr(7-b))and 1));
end;

procedure printr(cha:byte);
var myc:byte;
begin
  for a:=0 to 7 do
  begin
    myc:=0;
    for b:=0 to 7 do
    begin
      myc:=(((mem[50500:624+b+cha*8]shr(7-a))and 1)shl(7-b))or myc;
    end;
    write(lst,char(myc));
  end;
end;

var condenseline:byte;
procedure printrc(cha:byte);
var myc:byte;
begin
  for a:=0 to 3 do
  begin
    myc:=0;
    for b:=0 to 7 do
    begin
      myc:=(((mem[50500:624+b+cha*8]shr(7-(a shl 1)-condenseline))and 1)shl(7-b))or myc;
    end;
    write(lst,char(myc));
  end;
end;

var s:array[0..127]of byte;
begin
{  readln;
  write(lst,#27,'@');
  write(lst,#27,'Z',#64,#1);
  for x:=0 to 39 do
    printr(y*40+x);}
  readln;
end.

