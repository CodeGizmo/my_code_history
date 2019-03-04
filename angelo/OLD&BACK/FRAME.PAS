uses vgayey,crt;
var
  ch:char;
procedure frame;
begin
  cc:=24;
  clear;
  line(5,5,314,5,20); line(5,5,5,194,20); line(314,5,314,194,20); line(5,194,314,194,20);
  line(158,5,161,5,24); line(158,194,161,194,24); line(157,5,157,194,20); line(162,5,162,194,20);
  filler(10,100,24);
  ch:=readkey;
end;{frame}
begin
  vgamode(1);
  frame;
end.