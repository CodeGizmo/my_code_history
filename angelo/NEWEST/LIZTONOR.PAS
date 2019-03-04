uses crt,dos,vgaliza3;
var dirinfo:searchrec;
    filename:string;
    p1,p2:pointer;
begin
  directvideo:=false;
  getmem(p1,65535);
  getmem(p2,65535);
  vgamode(1);
  chdir('e:\angelo\newest\pictures');
  findfirst('*.liz',archive,dirinfo);
  repeat
    aload(dirinfo.name,p1^);
    uncompress(p1^,p2^);
    move(p2^,ptr($a000,0)^,64000);
    filename:=copy(dirinfo.name,1,pos('.',dirinfo.name))+'nor';
    asave(filename,p2^,64000{+2+256*3});
    readkey;
    findnext(dirinfo);
  until doserror<>0;
  chdir('e:\angelo\newest');
end.