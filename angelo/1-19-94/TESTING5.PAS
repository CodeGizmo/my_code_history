uses crt,vgaliza;
var
  a,b:word;
  ch:char;
  p:pointer;
  myseg,myofs:word;
  counter:word;
  fs:string;
  f:file;
  col:array[0..255,0..2]of byte;

begin
  directvideo:=false;
  writeln('pasok uno');
  getmem(p,16002);
  writeln('pasok getmem');
  vgamode(1);
  writeln('pasok graph');
  while not(keypressed)do
  begin
    fs:='pictures\bounce.ani';
    assign(f,fs);
    reset(f,1);
    blockread(f,col,1);
    blockread(f,col,768);
    for a:=0 to 255 do
        myup(a,col[a,0],col[a,1],col[a,2]);
    for a:=0 to 29 do
    begin
      blockread(f,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(0,0,p^,0);
    end;
    close(f);

    fs:='pictures\waves.ani';
    assign(f,fs);
    reset(f,1);
    blockread(f,col,1);
    blockread(f,col,768);
    for a:=0 to 255 do
        myup(a,col[a,0],col[a,1],col[a,2]);
    for a:=0 to 29 do
    begin
      blockread(f,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(0,0,p^,0);
    end;
    close(f);

    fs:='pictures\sphrplan.ani';
    assign(f,fs);
    reset(f,1);
    blockread(f,col,1);
    blockread(f,col,768);
    for a:=0 to 255 do
        myup(a,col[a,0],col[a,1],col[a,2]);
    for a:=0 to 29 do
    begin
      blockread(f,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(0,0,p^,0);
    end;
    close(f);

    fs:='pictures\dna.ani';
    assign(f,fs);
    reset(f,1);
    blockread(f,col,1);
    blockread(f,col,768);
    for a:=0 to 255 do
        myup(a,col[a,0],col[a,1],col[a,2]);
    for a:=0 to 29 do
    begin
      blockread(f,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(0,0,p^,0);
    end;
    close(f);

  end;
  vgamode(mtext);
end.

