uses crt,dos,vgaliza3,rolfazil;
var p1,p2:pointer;
  size:word;
{begin
  vgamode(1);
  getmem(p1,65535);
  getmem(p2,65535);
  aload('pictures\newbunny.liz',p1^);
  uncompress(p1^,ptr($a000,0)^);

  size:=memw[seg(p1^):ofs(p1^)];
  delay(500);
  move(p1^,ptr($a000,0)^,size);

  huffmanc(ptr($a000,0)^,p2^,size);
  delay(1000);
  clear;
  move(p2^,ptr($a000,0)^,bcom+512+5);

  delay(1500);
  clear;
  huffmanc(p2^,ptr($a000,0)^,bcom+512+5);

  delay(1500);
  vgamode(mtext);
  writeln('The compressed size is ',bcom+512+5);
  delay(1000);

  vgamode(1);
  clear;
  move(p2^,ptr($a000,0)^,bcom+512+5);

  delay(500);
  clear;
  uncompress(p1^,ptr($a000,0)^);

  delay(500);
  huffmanc(ptr($a000,0)^,p2^,64000);
  delay(1000);
  sound(500);
  delay(200);
  nosound;

  clear;
  move(p2^,ptr($a000,0)^,bcom+512+5);

  huffmanc(ptr($a000,0)^,p2^,bcom+512+5);
  sound(500);
  delay(200);
  nosound;
  delay(1000);
  vgamode(mtext);
  writeln('The compressed size is ',bcom+512+5);
  delay(1000);
  vgamode(1);

  huffmanc(ptr($a000,0)^,p2^,bcom+512+5);
  vgamode(mtext);
  writeln('The compressed size is ',bcom+512+5);
  delay(1000);
  vgamode(1);
  sound(500);
  delay(200);
  nosound;
  clear;

  move(p2^,ptr($a000,0)^,bcom+512+5);
  vgamode(mtext);
  writeln('The compressed size is ',bcom+512+5);
  delay(1000);
  vgamode(1);
  sound(500);
  delay(200);
  nosound;


  clear;
  huffmanu(p2^,ptr($a000,0)^);
  move(ptr($a000,0)^,p2^,64000);

  huffmanu(p2^,ptr($a000,0)^);
  move(ptr($a000,0)^,p2^,64000);
  huffmanu(p2^,ptr($a000,0)^);
  sound(1000);
  delay(100);
  nosound;
end.}

























begin
  vgamode(1);
  getmem(p1,65535);
  getmem(p2,65535);
  aload('pictures\newbunny.liz',p1^);
  uncompress(p1^,ptr($a000,0)^);

{  size:=memw[seg(p1^):ofs(p1^)];
  move(p1^,ptr($a000,0)^,size);

  huffmanc(ptr($a000,0)^,p2^,size);
  move(p2^,ptr($a000,0)^,bcom+512+5);

  huffmanc(p2^,ptr($a000,0)^,bcom+512+5);
  move(p2^,ptr($a000,0)^,bcom+512+5);

  uncompress(p1^,ptr($a000,0)^);}

  huffmanc(ptr($a000,0)^,p2^,64000);
  move(p2^,ptr($a000,0)^,bcom+512+5);

{  huffmanc(ptr($a000,0)^,p2^,bcom+512+5);}
  huffmanc(ptr($a000,0)^,p2^,bcom+512+5);
  move(p2^,ptr($a000,0)^,bcom+512+5);
{  clear;}

{  huffmanu(p2^,ptr($a000,0)^);
  clear;}

  move(ptr($a000,0)^,p2^,64000);
  clear;
  huffmanu2(p2^,ptr($a000,0)^);

  move(ptr($a000,0)^,p2^,64000);
  clear;
  huffmanu2(p2^,ptr($a000,0)^);
  readkey;
end.

