uses crt,dos,rolfazil,vgaliza3;
var f:file;
    s,filename:string;
    dinfo:searchrec;
    p,p2:pointer;
begin
  directvideo:=false;
  vgamode(1);
  getmem(p,65535);
  getmem(p2,65535);
  chdir('e:\utils');
  findfirst('*.*',archive,dinfo);
  showcompleted:=true;
  every:=350;
  while doserror=0 do
  begin
    aload(dinfo.name,p^);
{    uncompress(p^,ptr($a000,0)^);}
    if myfilesize>64000 then myfilesize:=64000;
    move(ptr($a000,0)^,p2^,myfilesize);
    slidewc(p2^,p^,myfilesize,5);
    move(p^,ptr($a000,0)^,compresssize);
    slidec(p^,p2^,compresssize,1);
    move(p^,ptr($a000,0)^,compresssize);
{    asave(copy(dinfo.name,1,pos('.',dinfo.name))+'w65',p2^,compresssize);}
    gotoxy(1,12);write(dinfo.name);
    findnext(dinfo);
  end;
  chdir('e:\angelo\newest');
end.

