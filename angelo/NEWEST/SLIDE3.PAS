Program slide_window_compressor;
uses crt,vgaliza3,rolfazil,slidew;
var p,p1,p2                :pointer;
    a,n,d                  :word;
    ch                     :char;
    pcs:word;
begin
  vgamode(1);
  getmem(p,65535);
  getmem(p1,65535);
  getmem(p2,65535);
  aload('rolfazil.bak'{'vgaliza3.bak'{},p^);
  clear;
  move(p^,ptr($a000,0)^,myfilesize);
  slidewc(p^,ptr($a000,0)^,myfilesize, 4);
  move(ptr($a000,0)^,p^,compresssize);
      vgamode(mtext);
      writeln('compress size using ',d:2,' bits is',wcompresssize:6);
      writeln('and the depth is ',n:2,' original size is ',myfilesize);
      ch:=readkey;
      vgamode(1);
    begin
      readkey;
{      slideu(p^,ptr($a000,0)^);}
      slidewu(p^,ptr($a000,0)^);
      move(ptr($a000,0)^,p^,64000);
    end;
{    huffmanu(p^,ptr($a000,0)^);}
    ch:=readkey;
    dec(d);
  until (d>14)or(ch=#27);
end.