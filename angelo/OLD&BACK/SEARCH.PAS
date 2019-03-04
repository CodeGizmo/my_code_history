var
  f:file;
  s:string;
  cloc,loc:word;
  size:word;
  sloc,ssize:byte;
  p:pointer;
  myseg,myofs:word;
begin
  writeln('Type the filename to search');
  s[0]:=#0;
  while s[0]=#0 do Readln(s);
  Assign(f,s);
  reset(f,1);
  size:=filesize(f);
  getmem(p,size);
  blockread(f,p^,size);
  close(f);
  myseg:=seg(p^);
  myofs:=ofs(p^);
  writeln('type the search string');
  s[0]:=#0;
  while s[0]=#0 do readln(s);
  ssize:=length(s);
  cloc:=0;
  repeat
    sloc:=1;
    loc:=0;
    while(sloc<ssize)and(loc+cloc<size)and
         (ord(s[sloc])=mem[myseg:myofs+cloc+loc])do
    begin
      inc(sloc);
      inc(loc);
    end;
    inc(cloc);
  until ((sloc=ssize)and(ord(s[sloc])=mem[myseg:myofs+cloc+loc-1]))or
        (cloc+sloc-1>size);
  if (cloc+sloc-1>size)then writeln('search string not found')else
     writeln('search string found at location ',cloc);
  readln;
end.