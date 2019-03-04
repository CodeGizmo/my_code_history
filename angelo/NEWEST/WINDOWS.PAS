uses crt;
var
  d1,d2:word;
  ch:char;

var
  wintext,winback:byte;
procedure makewindow(x1,y1,x2,y2:byte);
begin
  if x1>x2 then begin d1:=x1;x1:=x2;x2:=d1;end;
  if y1>y2 then begin d1:=y1;y1:=y2;y2:=d1;end;
  wintext:=wintext and $f;
  winback:=winback and $f;
  for d1:=y1  to y2 do
    for d2:=x1 to x2 do mem[$b800:d1*160+d2 shl 1]:=$20;
  for d1:=y1  to y2 do
    for d2:=x1 to x2 do mem[$b800:d1*160+d2 shl 1 +1]:=wintext+winback shl 4;
  for d1:=x1+1 to x2-1 do
  begin
    mem[$b800:y1*160+d1 shl 1]:=205;
    mem[$b800:y2*160+d1 shl 1]:=205;
  end;
  for d1:=y1+1 to y2-1 do
  begin
    mem[$b800:d1*160+x1 shl 1]:=186;
    mem[$b800:d1*160+x2 shl 1]:=186;
  end;
  mem[$b800:y1*160+x1 shl 1]:=201;
  mem[$b800:y1*160+x2 shl 1]:=187;
  mem[$b800:y2*160+x1 shl 1]:=200;
  mem[$b800:y2*160+x2 shl 1]:=188;
end;

begin
  clrscr;
  for d1:=0 to 1999 do mem[$b800:d1 shl 1 +1]:=$7f;

  repeat
    wintext:=random(16);
    winback:=random(16);
    makewindow(random(80),random(25),random(80),random(25));
{    ch:=readkey;}
  until ch=#27;
end.