uses vgaliza2,crt,dos;
var
  f:file;
  s:string;
  p:pointer;
  a,b,c,w:word;
  red,grn,blu:array[0..255,0..3]of byte;
  ch:char;

begin
  getmem(p,65535);
  directvideo:=false;
  vgamode(1);
  s:='pictures\lcol2.bmp';
    assign(f,s);
    reset(f,1);
    blockread(f,red[0],0);
    blockread(f,red[0],768);
    blockread(f,ptr(seg(p^),ofs(p^)+2)^{ptr($a000,0)^},64000);
    close(f);
    memw[seg(p^):ofs(p^)]:=320*199+223;
    putthis(0,0,p^,0);

    w:=0;
  repeat
  begin
    assign(f,s);
    reset(f,1);
    seek(f,{filesize(f)-}w{-768});
    blockread(f,red[0],768);
(*    blockread(f,ptr(seg(p^),ofs(p^)+2)^{ptr($a000,0)^},64000);*)
    close(f);
    for a:=0 to 255 do
      myup(a,red[a,1],red[a,2],red[a,3]);
{    for w:=223 to 223 do
    begin}

    memw[seg(p^):ofs(p^)]:=320*199+w;
    putthis(0,0,p^,0);
      gotoxy(1,1);
      writeln('The width is ',w:6);
      ch:=readkey;
{delay(200);}
{    end;}
     inc(w);
  end;
  until ch=#27{keypressed};
end.