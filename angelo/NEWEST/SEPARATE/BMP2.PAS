uses vgaliza2,crt,dos;
var
  f:file;
  s:string;
  p:pointer;
  a,b,c,w:word;
  red,grn,blu,wht:array[0..255,0..3]of byte;
  ch:char;

begin
  getmem(p,65535);
  directvideo:=false;
  vgamode(1);
  s:='pictures\lcol2.bmp';
    assign(f,s);
    reset(f,1);
    blockread(f,red[0],53);
    blockread(f,red[0],1024);
    seek(f,223*80);
    blockread(f,ptr(seg(p^),ofs(p^){+2})^,6000);
    close(f);
    memw[seg(p^):ofs(p^)]:=320*199+223;
    putthis(0,0,p^,0);
{    w:=0;
  repeat
  begin
    assign(f,s);
    reset(f,1);
    seek(f,w);
    blockread(f,red[0],768);
    close(f);}
    for a:=0 to 255 do myup(a,a  shr 2,a shr 2,a shr  2);
    myup(0,0,0,0);
{    for a:=0 to 63 do
      myup(64+64+a,a,a,a);}
{    for a:=0 to 63 do
      myup(64+a,a,a,a);}
{    for a:=0 to 255 do
      myup(a,a shr 2,a shr 2,a shr 2);}
      ch:=readkey;
{     inc(w);
  end;
  until ch=#27{keypressed};
{  w:=0;a:=0;
  while(mem[seg(p^):ofs(p^)+w]<>0)or(a>10)do
  begin
    inc(w);
    if(mem[seg(p^):ofs(p^)+w]<>0)then inc(a);
  end;
  writeln(w:6);
  readln;}
end.