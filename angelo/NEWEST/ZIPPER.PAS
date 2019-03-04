uses crt,rolfazil,vgaliza3;
var f:file;
    filename,s:string;
    p,p2:pointer;
    fsize:word;
    a,b,c,d:word;
begin
  directvideo:=false;
  getmem(p,65535);
  getmem(p2,65535);
  for a:=0 to 65534 do myptr(p^)[a]:=random(256);
  fsize:=65000;
{  filename:='pictures\newbunny.arj';
  assign(f,filename);
  reset(f,1);
  fsize:=filesize(f);}
  filename:='Toarj';
  assign(f,filename);
  rewrite(f,1);
  blockwrite(f,p^,fsize);
{  blockread(f,p^,fsize);}
  close(f);
  vgamode(1);
  for a:=3 to 7 do
  begin
    showcompleted:=true;
    vgamode(1);
    gotoxy(1,1);
    writeln('using compression technique : ',a:6);
    writeln('file size before compression: ',fsize:6);
    huffmanc(p^,ptr($a000,0)^,fsize);
    gotoxy(1,1);
    writeln('using compression technique : ',a:6);
    writeln('file size before compression: ',fsize:6);
    writeln('file size after compression : ',compresssize:6);
    writeln('compression ratio is : ',compresssize/fsize*100:6:3,'%');
    readln;
  end;
end.