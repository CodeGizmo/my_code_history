uses crt,vgaliza;
var
  a,b:word;
  ch:char;
  p:pointer;
  fs1,fs2,fs3,fs4:string;
  f,f1,f2,f3,f4:file;
  col:array[0..3,0..255,0..2]of byte;
  cc:byte;
begin
  getmem(p,16002);vgamode(1);
  while not(keypressed)do
  begin
    fs1:='pictures\bounce.ani';
    fs2:='pictures\waves.ani';
    fs3:='pictures\sphrplan.ani';
    fs4:='pictures\dna.ani';
    assign(f1,fs1);
    assign(f2,fs2);
    assign(f3,fs3);
    assign(f4,fs4);
    reset(f1,1);
    reset(f2,1);
    reset(f3,1);
    reset(f4,1);
    blockread(f1,col,1);
    blockread(f1,col[0,0,0],768);
    blockread(f3,col,1);
    blockread(f3,col[1,0,0],768);
    blockread(f4,col,1);
    blockread(f4,col[2,0,0],768);
    blockread(f2,col,1);
    blockread(f2,col[3,0,0],768);
    inc(cc);
    cc:=cc and 3;
    for a:=0 to 255 do
    begin
        myup(a,col[cc,a,0],col[cc,a,1],col[cc,a,2]);
    end;

    for a:=0 to 29 do
    begin
      blockread(f1,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(0,0,p^,0);
      blockread(f2,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(160,0,p^,0);
      blockread(f3,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(0,100,p^,0);
      blockread(f4,ptr(seg(p^),ofs(p^)+2)^,16000);
      memw[seg(p^):ofs(p^)]:=99*320+159;
      putthis(160,100,p^,0);
    end;
    close(f4);
    close(f3);
    close(f2);
    close(f1);
  end;
  vgamode(mtext);
end.

