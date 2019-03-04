uses crt,vgaliza3;
var
  f:file;
  p:pointer;
  o,s:word;
  a,b,c,d:word;
  max,x,y:word;
  buf:array[0..1024]of word;
type
  myptr=array[0..65500]of byte;
  myptrw=array[0..32000]of word;

var
  on,off:byte;
  qualvol:array[0..8192]of byte;
  fader,fade,outcomevol:byte;
  beat,counter,pos:word;

procedure tring;
begin
  for pos:=0 to max do
  begin
    outcomevol:=myptr(p^)[pos]shr 3;
    yeyan(pos,outcomevol,fader);
    port[$61]:=on;
    for beat:=0 to outcomevol do;
    port[$61]:=off;
    for beat:=outcomevol to 118 do;
  end;
end;
var
  quick:boolean;
  ch:char;

begin
  on:=port[$61]or 2;
  off:=port[$61]and not(3);
  getmem(p,65535);
  vgamode(3);
  assign(f,'d:\hslib\he08a3.wav'{c:\sbpro\winappl\letters.wav'});
  reset(f,1);
  max:=64000;
  blockread(f,p^,max);
  a:=0;
  repeat
    for x:=0 to 319 do
    begin
      yeyan(x,buf[x],0);
      yeyan(x,myptrw(p^)[(x+a)shl 1]shr 8,15);
      buf[x]:=myptrw(p^)[(x+a)shl 1]shr 8;
    end;
    if quick then inc(a,5) else inc(a);
    if keypressed then
    begin
      ch:=readkey;
      if ch=#13 then quick:=not(quick);
    end;
  until (ch=#27) or(a>max);
{  repeat
    tring;
    if (filesize(f)-filepos(f))>max then blockread(f,p^,max)else
    begin
      max:=filesize(f)-filepos(f);
      blockread(f,p^,max);
    end;
  until (keypressed)or(filepos(f)>=filesize(f));}
  close(f);
end.
