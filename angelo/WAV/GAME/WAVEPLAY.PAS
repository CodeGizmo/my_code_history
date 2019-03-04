unit waveplay;
interface
  procedure play(s:string;mydelays,rapids:byte);

implementation
uses crt;
var
  f:file;
  p:pointer;
  o,s:word;
  a,b,c,d:word;
  max,x,y:word;
  mydelay,rapid:byte;
type
  myptr=array[0..65500]of byte;

var
  on,off:byte;
  qualvol:array[0..8192]of byte;
  fader,fade,outcomevol:byte;
  beat,counter,pos:word;

procedure tring;
begin
  for pos:=0 to max do
  begin
    for a:=0 to mydelay do
    begin
      outcomevol:=myptr(p^)[pos]shr rapid;
      port[$61]:=on;
      for beat:=0 to outcomevol do;
      port[$61]:=off;
      for beat:=outcomevol to 256shr rapid  do;
    end;
  {  if (pos and $ff)=$ff then
    begin
      gotoxy(1,y);
      for x:=1 to outcomevol shr 2 do write('o');
      for x:=outcomevol shr 2  to 80 do write(' ');
    end;}
  end;
end;

var code:integer;
procedure play(s:string;mydelays,rapids:byte);
begin
    mydelay:=mydelays;
    rapid:=rapids;
{    rapid:=0;
    mydelay:=0;}
    on:=port[$61]or 2;
    off:=port[$61]and not(3);
    getmem(p,65535);
    assign(f,s);
    reset(f,1);
    max:=64000;
    if filesize(f)<64000 then max:=filesize(f);
    repeat
      blockread(f,p^,max);
      tring;
      if (filesize(f)-filepos(f))<max then
      begin
        max:=filesize(f)-filepos(f);
      end;
    until (keypressed)or(filepos(f)>=filesize(f));
    close(f);
    freemem(p,65535);
end;
end.
