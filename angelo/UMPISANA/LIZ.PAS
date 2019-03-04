uses dos,crt,azil2;
var
  f1,f2:file;
  s:string;
  di:searchrec;
  p1,p2:pointer;
  pos,totsize:longint;
  tocomp:word;

begin
  getmem(p1,32768);
  getmem(p2,45000);
  if paramcount>0 then
  begin
    FindFirst(paramstr(1), Archive, Di);
    if doserror=0 then
    while DosError = 0 do
    begin
      Writeln('Compressing',Di.Name);
      assign(f1,di.name);
      s:=pos
      assign(f2,s);
      reset(f1,1);
      rewrite(f2,1);
      slidewc(p1^,p2^,tocomp);
      close(f2);
      close(f1);
      FindNext(Di);
    end else writeln('File not found.');
  end;
  freemem(p,40000);
end.