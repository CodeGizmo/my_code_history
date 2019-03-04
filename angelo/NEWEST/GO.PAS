{$m $4000,0,0}
uses crt,dos;
var
  di:searchrec;
  s,d:string;
begin
  FindFirst('*.*_', Archive, Di);
  while DosError = 0 do
  begin
    s:=di.name;
    if copy(s,pos('.',s),4)='.DL_'then
      s:=s+' dest\'+copy(s,1,pos('.',s))+'dll' else
    if copy(s,pos('.',s),4)='.EX_'then
      s:=s+' dest\'+copy(s,1,pos('.',s))+'exe' else
    if copy(s,pos('.',s),4)='.CO_'then
      s:=s+' dest\'+copy(s,1,pos('.',s))+'com' else
    if copy(s,pos('.',s),4)='.SY_'then
      s:=s+' dest\'+copy(s,1,pos('.',s))+'sys' else
    if copy(s,pos('.',s),4)='.HL_'then
      s:=s+' dest\'+copy(s,1,pos('.',s))+'hlp' else
    if copy(s,pos('.',s),4)='.OV_'then
      s:=s+' dest\'+copy(s,1,pos('.',s))+'ovl' else
    begin
      s:=s+' dest\'+copy(s,1,length(s)-1);
      writeln(s);
      write('Enter Last letter: ');
      s:=s+readkey;
      s:=s+d;
    end;
    Writeln(s);
    delay(100);
    swapvectors;
    exec('e:\fromang\expand.exe',s);
    swapvectors;
    FindNext(Di);
  end;

end.