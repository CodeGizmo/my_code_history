uses crt;
var
  shift:byte;
  f,fout:file;
  p,pout:pointer;
  opos,o,s:word;
  a,b,c,d:word;
  max,x,y:word;
{  buf:array[0..1024]of byte;}
type
  myptr=array[0..65500]of byte;

var
  on,off:byte;
  qualvol:array[0..8192]of byte;
  fader,fade,outcomevol:byte;
  beat,counter,pos:word;

procedure tring;
begin
  for pos:=0 to max shr shift do
  begin
    myptr(pout^)[opos]:=myptr(p^)[pos shl shift];
    if opos>=32767 then
    begin
      blockwrite(fout,pout^,32768);
      opos:=0;
    end else inc(opos);
  end;
end;

begin
  if paramcount>0 then
  begin
    shift:=3;
    opos:=0;
    getmem(p,65535);
    getmem(pout,32768);
    assign(fout,'new3.wav');
    rewrite(fout,1);
    assign(f,paramstr(1));
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
    if opos>0 then blockwrite(fout,pout^,opos+1);
    close(f);
    close(fout);
  end;
end.
