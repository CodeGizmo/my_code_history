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
begin
  clrscr;
  if paramcount>0 then oks:=false else oks:=true;
  number:=0;
  getmem(p,65535);

  total:=0;
  FindFirst('*.*', Archive, Di);
  while DosError = 0 do
  begin
    inc(total);
    findnext(di);
  end;

  FindFirst('*.*', Archive, Di);
  while DosError = 0 do
  begin
    inc(number);
    Write(number:6,' out of',total:6,' (',(number/total)*100:3:2,'%) ');
    if oks then writeln(di.name);
    protect(di.name);
    FindNext(Di);
  end;
  freemem(p,65535);
end.
