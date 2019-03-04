program protection_coder;
uses crt;
var
  f:file;
  s:string;
  size:word;
  code:longint;
  ch:char;
  p:pointer;
  myseg,myofs:word;
  dummy:word;
begin
  writeln('type the filename');
  s[0]:=#0;
  while s[0]=#0 do readln(s);

  if s<>'cancel' then
  begin
    assign(f,s);
    reset(f,1);
    size:=filesize(f);
    getmem(p,size+3);
    blockread(f,p^,size);
    close(f);
    myseg:=seg(p^);
    myofs:=ofs(p^);
  end;

  writeln('what procedure? (P)rotect or (U)nprotect');
  repeat
    ch:=readkey;
  until ch in['p','u'];
  if ch='p' then
  begin
    if (mem[myseg:myofs]<>ord('A'))and(mem[myseg:myofs+1]<>ord('L'))
       and(mem[myseg:myofs+2]<>ord('L'))then
    begin
      writeln('type your code number ');
      readln(code);
      randseed:=code;
      for dummy:=0 to size-1 do mem[myseg:myofs+dummy]:=mem[myseg:myofs+dummy]+random(256);
      move(ptr(myseg,myofs)^,ptr(myseg,myofs+3)^,size);
      mem[myseg:myofs]:=ord('A');
      mem[myseg:myofs+1]:=ord('L');
      mem[myseg:myofs+2]:=ord('L');
      size:=size+3;
    end;
  end else
  begin
    if (mem[myseg:myofs]=ord('A'))and(mem[myseg:myofs+1]=ord('L'))
       and(mem[myseg:myofs+2]=ord('L'))then
    begin
      writeln('type your code number ');
      readln(code);
      randseed:=code;
      size:=size-3;
      move(ptr(myseg,myofs+3)^,ptr(myseg,myofs)^,size);
      for dummy:=0 to size-1 do mem[myseg:myofs+dummy]:=mem[myseg:myofs+dummy]-random(256);
    end;
  end;
  rewrite(f,1);
  blockwrite(f,p^,size);
  close(f);
end.