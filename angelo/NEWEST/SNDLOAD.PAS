uses crt,vgaliza3;
var
  p:pointer;
  x,y,a,b:word;
  f:file;
  on,off:byte;
  s:string;
  h:word;
type
  myptr=array[0..65530]of byte;
begin
  on:=port[$61]or 2;
  off:=port[$61]and not(3);
  getmem(p,65000);
  vgamode(3);
  assign(f,'d:\sbpro\winappl\fm.wav');
  reset(f,1);
  blockread(f,p^,65535);
  close(f);
    h:=0;
  begin
    for x:=0 to 65000 do
    begin
  {    if myptr(p^)[x]>h then h:=myptr(p^)[x];}
      port[$61]:=on;
      for a:=0 to myptr(p^)[x] do;
      port[$61]:=off;
      inc(x);
      for a:=0 to myptr(p^)[x] do;
    end;
  end;
  for x:=0 to 9 do
  begin
    sound(1000);
    delay(100);
    nosound;
  end;
  vgamode(mtext);
{  str(h,s);
  putstring('h='+s);}
  readkey;
end.








uses crt,vgaliza;
var
  on,off                    :byte;
  ch                        :char;
  a,b,c,d,a1,a2,a3,a4,loop  :word;
  counter                   :word;
  soundon                   :boolean;
  mytime                    :word;
  myvol                     :byte;
  mydur                     :word;
  pat                       :array[0..255]of byte;

procedure tring(time:word;vol:byte;dur:word);
var
  loops:word;
  tvol:byte;
begin
  if vol>time then vol:=time;
  loops:=(4860 div time)*dur;
  for loop:=0 to loops do
  begin
     tvol:=vol-vol*loop div loops;
     for a:=0 to time-tvol do; port[$61]:=on;
     for a:=0 to tvol  do; port[$61]:=off;
  end;
end;

procedure trings(time:word;dur:word);
var
  loops:word;
  tvol:byte;
begin
  loops:=(4860 div time)*dur;
  for loop:=0 to loops do
  begin
     tvol:=255*loop div loops;
     for a:=0 to time-pat[tvol] do; port[$61]:=on;
     for a:=0 to pat[tvol] do; port[$61]:=off;
  end;
end;

procedure initialize;
begin
  on:=port[$61]or 2;
  off:=port[$61]and not(3);
  counter:=0;
  soundon:=true;
  mytime:=1000;
  myvol:=13;
  mydur:=100;

  for a:=0 to 255 do
    pat[255-a]:=a ;
end;{initialize}

begin
  initialize;
  ch:=#0;
  readkey;
  repeat
    if keypressed then
    begin
      ch:=readkey;
      if ch='t' then trings(mytime,mydur);
      if ch='s' then soundon:=not(soundon);
    end;
    if soundon then tring(mytime,myvol,mydur);
    inc(counter);
  until ch=#27;
  writeln('the count is ',counter:6);
  readkey;
end.


time=1000;vol=13