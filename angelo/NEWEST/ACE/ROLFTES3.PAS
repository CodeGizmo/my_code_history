program rolftest;
uses crt,rolfazil,vgaliza3;
var
  p1,p2:pointer;
  pat,maxpat:array[0..49]of byte;
  patno,maxpatno:byte;
  maxsize:word;
  fout:text;
  min,max:array[0..20]of byte;

procedure findmax(size:word);
var
  bitcount:byte;
  csize:word;
begin
  if keypressed then exit;
  gotoxy(1,1);writeln(size:6);
  for patno:=1 to patno do
    write(pat[patno]:2);
  gotoxy(1,3);writeln(maxsize:6);
  for maxpatno:=1 to maxpatno do
    write(maxpat[maxpatno]:2);
  inc(patno);
  for bitcount:=min[patno] to max[patno] do
  begin
    slidec(p1^,p2^,size,bitcount);
    if compresssize<size then
    begin

      csize:=compresssize;

      pat[patno]:=bitcount;
{      write(fout,csize:6,':');
      for patno:=1 to patno do
        write(fout,pat[patno]:2);
      writeln(fout,'    ');}
      if maxsize>csize then
      begin
        maxsize:=csize;
        for maxpatno:=1 to patno do
          maxpat[maxpatno]:=pat[maxpatno];
      end;
{      move(p2^,p1^,csize);
      move(p1^,ptr($a000,0)^,csize);
      findmax(csize);
      move(p1^,p2^,csize);
      slideu(p2^,p1^);
      move(p1^,ptr($a000,0)^,size);}
    end;
  end;
  dec(patno);
end;{findmax}

begin
  max[1]:=6;
  max[2]:=5;
  max[3]:=4;
  max[4]:=3;
  max[5]:=2;
  max[6]:=2;
  max[7]:=2;
  max[8]:=2;
  for patno:=9 to 20 do max[patno]:=2;
  min[1]:=2;
  for patno:=2 to 20 do min[patno]:=1;
  patno:=0;
  maxpatno:=0;
  maxsize:=65535;
  directvideo:=false;
  getmem(p1,65530);
  getmem(p2,65530);
  aload('e:\angelo\newest\pictures\all1.arj',p2^);
  vgamode(1);
  move(p2^,p1^,myfilesize);
  move(p1^,ptr($a000,0)^,myfilesize);
  assign(fout,'rolftest.txt');
  rewrite(fout);
  findmax(myfilesize);
      write(fout,maxsize:6,':');
      for maxpatno:=1 to maxpatno do
        write(fout,maxpat[maxpatno]:2);
  close(fout);
  readkey;
end.