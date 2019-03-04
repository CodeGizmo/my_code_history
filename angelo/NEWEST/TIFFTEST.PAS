uses crt,vgaliza3;
var p:pointer;
    x,y:integer;
    f:file;
    fsize:word;
    o,start:word;
type myptr=array[0..65000]of byte;
begin
  getmem(p,10000);
  for x:=0 to 8255 do
    myptr(p^)[x]:=12;
  assign(f,'pictures\tifftest.tif');
  reset(f,1);
  fsize:=filesize(f);
  start:=fsize-256*20;
  seek(f,start);
  blockread(f,p^,256*20);
  vgamode(1);
  o:=0;
  for y:=0 to 19 do
    for x:=0 to 255 do
    begin
      yeyan(x,y,myptr(p^)[o]);
      inc(o);
    end;
{  for x:=0 to 256*20-1 do
    myptr(p^)[x]:=x;
  for y:=0 to 19 do
    for x:=0 to 255 do
    begin
      yeyan(x,y+20,myptr(p^)[o]);
      inc(o);
    end;
  seek(f,start);
  blockwrite(f,p^,256*20);}
  close(f);
  readkey;
end.