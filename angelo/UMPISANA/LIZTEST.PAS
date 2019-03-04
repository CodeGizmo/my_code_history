uses dos,crt,azil2;
var
  f1,f2:file;
  s:string;
  di:searchrec;
  p1,p2:pointer;
  x,totsize:longint;
  tocomp:word;
  lcs:word;

begin
  getmem(p1,32768);
  getmem(p2,45000);
  if paramcount>0 then
  begin
    FindFirst(paramstr(1), Archive, Di);
    if doserror=0 then
    while DosError = 0 do
    begin
      addcpos:=0;
      addupos:=0;
      cpos:=0;
      upos:=0;
      realtotal:=0;
      Write('Compressing ',Di.Name,' ');showcomplete(wherex,wherey);
      if pos('.',di.name)=0 then s:=di.name+'.'
        else s:=copy(di.name,1,pos('.',di.name));
      if paramcount>1 then s:=s+paramstr(2)
        else s:=s+'liz';
      assign(f1,di.name);
      assign(f2,s);
      reset(f1,1);
      rewrite(f2,1);
      totsize:=filesize(f1);
      x:=0;
      realtotal:=totsize;
      addcpos:=0;
      every:=256;
      repeat
        addupos:=x;
        if totsize-x>32768 then tocomp:=32768 else tocomp:=totsize-x;
        realtocomp:=tocomp;
        x:=x+tocomp;
        blockread(f1,p1^,tocomp);
{        case method of
          1:huffmanc(p1^,p2^,tocomp);
          2:slidec(p1^,p2^,tocomp,count2);
          3:slidewc(p1^,p2^,tocomp,count3);
        end;}
        slidewc(p1^,p2^,tocomp,5);
        repeat
          lcs:=compresssize;
          slidec(p2^,p1^,lcs,2);
          if lcs>compresssize then move(p1^,p2^,compresssize);
        until lcs<=compresssize;
        repeat
          lcs:=compresssize;
          slidec(p2^,p1^,lcs,1);
          if lcs>compresssize then move(p1^,p2^,compresssize);
        until lcs<=compresssize;
        addcpos:=addcpos+lcs;
        blockwrite(f2,p2^,lcs);
      until x>=totsize;
      close(f2);
      close(f1);
      gotoxy(xupos,yupos);
      writeln('  ',compresssize/totsize*100:2:2,'%');
      FindNext(Di);
    end else writeln('File not found.');
  end else
  begin
    clrscr;
    writeln('Hi! I''m Angelo L. Lanuza, creator of this program.');
    writeln('This is my first archive compression program called liztest');
    writeln('RELEASE 1, Version 1.00');
    writeln('DATE & TIME CREATED: Friday, June 17, 1994, 11:29:47 PM');
    writeln;
    writeln('INFORMATION:');
    writeln('Format: LIZTEST *.* [ext [method [count] ] ]');
    writeln('Examples: LIZTEST *.pas');
    writeln('          LIZTEST back*.* arj 2 5');
    writeln;
    writeln('ext -> is the resulting extension of the compressed file');
    writeln('method -> 1 - for huffman compression');
    writeln('          2 - for byte window compression');
    writeln('          3 - for word window compression (default)');
    writeln('count -> 1) Not used in huffman compression');
    writeln('         2) If method 2 is used, then the valid range is from 1 to 6(default:2)');
    writeln('         3) If method 3 is used, then the valid range is from 1 to 14(default:6)');
    writeln('              NOTE: A lesser count means a longer compressing time,but');
    writeln('                    usually result in a more compressed file.');
    writeln;
    writeln('NOTICE: This is just a testing program, therefore this is not');
    writeln('        yet a fully automated decompressing program.');
  end;
  freemem(p2,45000);
  freemem(p1,32768);
end.