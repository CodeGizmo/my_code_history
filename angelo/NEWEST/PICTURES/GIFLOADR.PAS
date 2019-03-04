uses crt,vgaliza3;
var
  p:pointer;
  f:file;
  a:word;
  b:byte;
  buffer:array[0..161]of byte;
begin
  getmem(p,65535);
  vgamode(1);
  assign(f,'liz&me.tif');
  reset(f,1);
{  seek(f,filesize(f)-64000);}
  blockread(f,buffer,162);
  blockread(f,p^,64000);
  for a:=0 to 255 do myup(a,a shr 2, a shr 2, a shr 2);
  move(p^,ptr($a000,0)^,64000);
  readkey;
  vgamode(mtext);
  for a:=0 to 161 do
  begin
    write(a:3,':',buffer[a]:3,' ');
  end;
  readkey;
end.