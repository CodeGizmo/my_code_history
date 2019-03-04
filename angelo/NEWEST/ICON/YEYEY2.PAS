uses dos,crt;
var
  di:searchrec;
  p:pointer;
type myptr=array[0..65530]of byte;
procedure protect(s:string);
var
  f:file;
  fsize,left,pos,fpos:longint;
begin
  assign(f,s);
  reset(f,1);
  fsize:=filesize(f);
  if fsize>65500 then
  begin
    fpos:=0;
    while (fsize-fpos)>65500 do
    begin
      blockread(f,p^,65500);
      for pos:=0 to 65499 do
        myptr(p^)[pos]:=not(myptr(p^)[pos]);
      seek(f,fpos);
      blockwrite(f,p^,65500);
      fpos:=fpos+65500
    end;
    left:=fsize-fpos;
    blockread(f,p^,left);
    for pos:=0 to left-1 do
      myptr(p^)[pos]:=not(myptr(p^)[pos]);
    seek(f,fpos);
    blockwrite(f,p^,left);
  end else
  begin
    blockread(f,p^,fsize);
    for pos:=0 to fsize-1 do
      myptr(p^)[pos]:=not(myptr(p^)[pos]);
    seek(f,0);
    blockwrite(f,p^,fsize);
  end;
  close(f);
end;{protect}


var number,total:word;
    oks:boolean;
    tsize,cursize:longint;
begin
  clrscr;
  if paramcount>0 then oks:=false else oks:=true;
  number:=0;
  getmem(p,65535);

  total:=0;
  FindFirst('*.*', Archive, Di);
  tsize:=0;
  while DosError = 0 do
  begin
    tsize:=tsize+di.size;
    inc(total);
    findnext(di);
  end;

  FindFirst('*.*', Archive, Di);
  cursize:=0;
  while DosError = 0 do
  begin
    inc(number);
    cursize:=cursize+di.size;
    Write(number:5,' out of ',total,' (',(number/total)*100:3:2,'%) ');
    write(cursize:7,' of ',tsize,' (',(cursize/tsize)*100:3:2,'%) ');
    if oks then write(di.name);
    writeln;
    protect(di.name);
    FindNext(Di);
  end;
  freemem(p,65535);
end.
