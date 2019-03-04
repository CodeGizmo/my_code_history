uses crt,vgaliza;
var
  a,b:word;
  ch:char;
  p:array[0..29]of pointer;
  myseg,myofs:word;
  counter:word;
  fs:string;
  f:file;
  col:array[0..255,0..2]of byte;

procedure aload2(filename:string;var buf;size:word);
var
  f:file;
begin
  assign(f,filename);
  reset(f,1);
  blockread(f,buf,size);
  close(f);
end;{aload}

begin
  for a:=0 to 29 do
  begin
    getmem(p[a],16002);
  end;
  while not(keypressed)do
  begin
  write('Type the filename ');
  readln(fs);
{  fs:='pictures\'+fs+'.ani';}
  assign(f,fs);
  reset(f,1);
  blockread(f,col,1);
  blockread(f,col,768);
  vgamode(1);
  for a:=0 to 255 do
      myup(a,col[a,0],col[a,1],col[a,2]);
  for a:=0 to 29 do
  begin
    blockread(f,ptr(seg(p[a]^),ofs(p[a]^)+2)^,16000);
    memw[seg(p[a]^):ofs(p[a]^)]:=99*320+159;
    putthis(0,0,p[a]^,0);
  end;
  close(f);



  repeat
    for a:=0 to 29 do
    begin
{       retr;}
      putthis(0,0,p[a]^,0);
    end;
  until keypressed;

  vgamode(mtext);
  end;
end.

