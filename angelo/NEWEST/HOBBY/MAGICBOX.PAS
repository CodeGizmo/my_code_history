uses crt;
var
  horpos,
  sum,s,
  z,
  n,nn,
  x,y  :word;
  table:array[1..100]of word;
  unused:array[1..100]of boolean;
  k:boolean;
  sumvert:array[1..10]of word;

function check2(a:integer):boolean;
var
  valid:boolean;
begin
  valid:=true;
  y:=a;
  sum:=0;
  for x:= 1 to nn do
    sum:=sum+table[(y-1)*nn+x];
  if sum<>s then valid:=false;
  check2:=valid;
end;

function check3(xx,a:integer):boolean;
var
  valid:boolean;
  m,j,
  k:word;
begin
  valid:=true;
{  k:=sumvert[xx];}
  k:=0;
  if (a>((nn) div 2)) then
  begin
    j:=n+a+1-nn;
    if j<=n then
    begin
      for m:=j to n do
        k:=k+m;
      for m:=1 to a do
        k:=k+table[(m-1)*nn+xx];
      if k<s then valid:=false;
    end else
    begin
      for m:=1 to a do
        k:=k+table[(m-1)*nn+xx];
      if k<>s then valid:=false;
    end;
  end;
  check3:=valid;
end;

function check:boolean;
var
  valid:boolean;
begin
  valid:=true;
  for y:= 1 to nn do
  begin
    sum:=0;
    for x:= 1 to nn do
      sum:=sum+table[(y-1)*nn+x];
    if sum<>s then valid:=false;
  end;
  for x:= 1 to nn do
  begin
    sum:=0;
    for y:= 1 to nn do
      sum:=sum+table[(y-1)*nn+x];
    if sum<>s then valid:=false;
  end;
  sum:=0;
  for x:= 1 to nn do
    sum:=sum+table[(x-1)*nn+x];
  if sum<>s then valid:=false;
  sum:=0;
  for x:= 1 to nn do
    sum:=sum+table[(x-1)*nn+(nn-x+1)];
  if sum<>s then valid:=false;
  check:=valid;
end;




procedure show;
begin
  for y:=1 to nn do
    begin
      for x:=1 to nn do
      begin
        gotoxy(x*4+1,y);
        write(table[(y-1)*nn+x]:4);
      end;
      writeln;
    end;
end;

procedure next;
var
  cur:integer;
begin
  for cur:=1 to n do
  begin
{    if z=(n-(nn shl 2)) then begin gotoxy(1,24);write(cur:4);end;}
(*{    if z=(n-{(nn shl 1)}-6) then show;}*)
    if k and(z=n-(nn shl 1)-3) then show;
    if unused[cur] then
    begin
      table[z]:=cur;
      if z<n then
      begin
        horpos:=((z-1)mod nn)+1;
        sumvert[horpos]:=sumvert[horpos]+cur;
        if check3(horpos,((z-1)div nn)+1) then
        begin
          if (z mod nn)=0 then
          begin
            if check2(z div nn)then
            begin
              inc(z);
              unused[cur]:=false;
              next;
              unused[cur]:=true;
              dec(z);
            end;
          end else
          begin
            inc(z);
            unused[cur]:=false;
            next;
            unused[cur]:=true;
            dec(z);
          end;
          if keypressed then begin k:=not(k);readkey;end;
        end;
        sumvert[horpos]:=sumvert[horpos]-table[z];
      end;
      if z=n then
      begin
        if check then
        begin
{          clrscr;}
          for y:=1 to nn do
          begin
            for x:=1 to nn do
            begin
              gotoxy(x*4+1,y+10);
              write(table[(y-1)*nn+x]:4);
            end;
            writeln;
          end;
{          readkey;}
        end;
      end;
    end;
  end;
end;



begin
  k:=false;
  clrscr;
  nn:=4;
  n:=nn*nn;
  s:=0;
  for x:=1 to n do s:=s+x;
  s:=s div nn;
  z:=1;
  for x:=1 to 10 do sumvert[x]:=0;
  for x:=1 to n do unused[x]:=true;
  next;
end.