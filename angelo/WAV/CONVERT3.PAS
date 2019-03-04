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
var total:word;
    pass:byte;
begin
  for pos:=0 to max shr shift do
  begin
    total:=myptr(p^)[(pos shl shift)+pass];
    for pass:=1 to 1 shl shift do
      if myptr(p^)[(pos shl shift)+pass]>total then
        total:=myptr(p^)[(pos shl shift)+pass];
    myptr(pout^)[opos]:=total;
    if opos>=32767 then
    begin
      blockwrite(fout,pout^,32768);
      opos:=0;
    end else inc(opos);
  end;
end;

var
  code:integer;
begin
  if paramcount>1 then
  begin
    shift:=1;
    if paramcount>2 then val(paramstr(3),shift,code);
    opos:=0;
    getmem(p,65535);
    getmem(pout,32768);
    assign(fout,paramstr(2));
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
