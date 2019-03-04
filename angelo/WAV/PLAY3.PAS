uses crt;
var
  f:file;
  p:pointer;
  o,s:word;
  a,b,c,d:word;
  max,x,y:word;
{  buf:array[0..1024]of byte;}
type
  myptr=array[0..65500]of byte;

function raise(x:byte;e:byte):byte;
var
  result:byte;
  count:byte;
begin
  result:=1;
  for count:=1 to e do result:=result*x;
  raise:=result;
end;


var
  on,off:byte;
  qualvol:array[0..8192]of byte;
  fader,fade,outcomevol:byte;
  beat,counter,pos:word;

procedure tring;
const shift=0;
begin
  for pos:=0 to max shr shift do
  begin
    for a:=1 to 4{raise(2,shift-1)} do
    begin
      outcomevol:=myptr(p^)[pos shl shift];
      port[$61]:=on;
      for beat:=0 to outcomevol do;
      port[$61]:=off;
      for beat:=outcomevol to 256  do;
    end;
  end;
end;

begin
  if paramcount>0 then
  begin
    on:=port[$61]or 2;
    off:=port[$61]and not(3);
    getmem(p,65535);
    assign(f,'new3.wav'{paramstr(1)});
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
  end;
end.
