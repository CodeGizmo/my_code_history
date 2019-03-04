uses crt,vgaliza3;
var eb,leb:real;
    d:word;
    f:text;
begin
  clrscr;
  assign(f,'eb');
  rewrite(f);
  for d:=0 to 100 do
  begin
    eb:=3*d*(100-d)/(12.75*2);
    writeln(f,'d1=',d:4,'Km(cm);  d2=',(100-d):4,'Km eb=',eb:8:2,'m : ',eb/7.5:0:2,'cm');
    if (d mod 24)=23 then readkey;
  end;
  close(f);
  vgamode(3);
  eb:=0;
  for d:=0 to 100 do
  begin
    leb:=eb;
    eb:=round(3*d*(100-d)/(12.75*2)/7.5);
    line(d-1,round(leb),d,round(eb),15);
  end;
  readkey;
end.