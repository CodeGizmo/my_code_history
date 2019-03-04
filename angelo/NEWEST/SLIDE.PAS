Program slide_window_compressor;
uses crt,vgaliza3,rolfazil{,slidew};
var p,p1,p2                :pointer;
    a,n,d                  :word;
    ch                     :char;
    pcs:word;
begin
  vgamode(1);
  getmem(p,65535);
  getmem(p1,65535);
  getmem(p2,65535);
  aload('pictures\newbunny.liz'{'vgaliza3.bak'{},p^);
  clear;
{  move(p^,ptr($a000,0)^,myfilesize);}
{  uncompress(p^,ptr($a000,0)^);
  compresssize:=64000;          }
{  compress(ptr($a000,0)^,p^,64000);}
  huffmanc(p^,ptr($a000,0)^,myfilesize);
{  slidewc(p^,ptr($a000,0)^,myfilesize,14);}
  move(ptr($a000,0)^,p^,compresssize);
  pcs:=compresssize;
{  pcs:=myfilesize;}
{  pcs:=64000;}
  n:=0;d:=2;
  repeat
    n:=0;
    compresssize:=pcs;
{    move(ptr($a000,0)^,p^,compresssize);}
    slidec(p^,ptr($a000,0)^,compresssize,3);
{    huffmanc(p^,ptr($a000,0)^,compresssize);}
{    move(ptr($a000,0)^,p^,compresssize);}
    repeat
      inc(n);
{      huffmanc(p^,ptr($a000,0)^,compresssize);}
      slidec(p^,ptr($a000,0)^,compresssize, d);
{      slidewc(p^,ptr($a000,0)^,compresssize, d);}
      move(ptr($a000,0)^,p^,compresssize);
  {    readkey;}
      vgamode(mtext);
      writeln('compress size using ',d:2,' bits is',compresssize:6);
      writeln('and the depth is ',n:2,' original size is ',myfilesize);
      ch:=readkey;
      vgamode(1);
    until (ch=#27)or(ch='1')or(n>12);


    for a:=1 to n do
    begin
      readkey;
      instantu(p^,ptr($a000,0)^);
{      huffmanu(p^,ptr($a000,0)^);}
{      slideu(p^,ptr($a000,0)^);}
      move(ptr($a000,0)^,p^,64000);
    end;
{    huffmanu(p^,ptr($a000,0)^);}
    ch:=readkey;
    dec(d);
  until (d>14)or(ch=#27);
end.