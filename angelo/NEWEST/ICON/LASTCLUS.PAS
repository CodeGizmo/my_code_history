uses crt,dos;
var
  f,f2:file;
  size:longint;
  p:pointer;
begin
  getmem(p,1024);
  assign(f,'a:synd.a04');
  reset(f,1);
{  size:=filesize(f);
  seek(f,size-1023-4767);}
  blockread(f,p^,1024);
{  assign(f2,'lastclus');
  rewrite(f,1);
  blockwrite(f2,p^,1024);
  close(f2);}
  close(f);

end.