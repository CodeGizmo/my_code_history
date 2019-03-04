uses crt,vgaliza3,rolfazil;
var
  ch:char;
  nbits:array[1..6,0..20]of boolean;
  booleans:boolean;
  patterns:array[0..20]of byte;
  primebit:byte;
  lcsize:word;
  p:pointer;
  depth,d1,d2,d3,d4:byte;
  oks:boolean;
  sizeleast:word;
  bitleast:byte;
const
  stbit=1;
  endbit=2;

procedure searchdulo(s:word);
begin
  if oks then
  begin
    sound(100);
    delay(200);
    nosound;
    vgamode(mtext);
    writeln('Depth:',depth-1:3);
    write('PAttern:');
    for d2:=1 to depth-1 do write(patterns[d2]:2,',');
    writeln;
    writeln('Compressed size:',s:6);
    if readkey=#27 then halt;
    vgamode(1);
  end;
end;

procedure searchmax(s:word);
begin
  if oks and(s<sizeleast)then
  begin
    sound(100);
    delay(200);
    nosound;
    sizeleast:=s;
    vgamode(mtext);
    writeln('Depth:',depth-1:3);
    write('PAttern:');
    for d2:=1 to depth-1 do write(patterns[d2]:2);
    writeln;
    writeln('Compressed size:',s:6);
    if readkey=#27 then halt;
    vgamode(1);
    oks:=false
  end;
end;

procedure compa(lastsize:word);
var d:byte;
begin
  lcsize:=lastsize;
  oks:=true;
  for d:=stbit to endbit do
  begin
    patterns[depth]:=d;
    slidec(p^,ptr($a000,0)^,lastsize,d);
{    huffmanc(p^,ptr($a000,0)^,lastsize);}
    if compresssize<lastsize then
    begin
      oks:=false;
      inc(depth);
      move(ptr($a000,0)^,p^,compresssize);
      compa(compresssize);
      slideu(p^,ptr($a000,0)^);
{      huffmanu(ptr($a000,0)^,p^);}
      move(ptr($a000,0)^,p^,lastsize);
      patterns[depth]:=0;
      dec(depth);
    end else
    begin
      nbits[d,depth]:=true;
    end;
    move(p^,ptr($a000,0)^,lastsize);
  end;
  searchdulo(lastsize);
  searchmax(lastsize);
end;

procedure compbyleast(lastsize:word);
var d:byte;
begin
  lcsize:=lastsize;
  oks:=true;
  bitleast:=255;
  for d:=stbit to endbit do
  begin
    slidec(p^,ptr($a000,0)^,lastsize,d);
{    huffmanc(p^,ptr($a000,0)^,lastsize);}
    if compresssize<lastsize then
    begin
      bitleast:=d;
      sizeleast:=compresssize;
      oks:=false;
    end;
    patterns[depth]:=bitleast;
  end;
  searchdulo(lastsize);
  if bitleast<255 then
  begin
    inc(depth);
    slidec(p^,ptr($a000,0)^,lastsize,bitleast);
{    huffmanc(p^,ptr($a000,0)^,lastsize);}
    move(ptr($a000,0)^,p^,compresssize);
    compbyleast(compresssize);
    slideu(p^,ptr($a000,0)^);
{    huffmanu(ptr($a000,0)^,p^);}
    move(ptr($a000,0)^,p^,lastsize);
    dec(depth);
    move(p^,ptr($a000,0)^,lastsize);
  end;
end;

begin
  vgamode(1);
  getmem(p,65535);
  aload('pictures\foricons.liz',p^);
  move(p^,ptr($a000,0)^,64000);
  uncompress(p^,ptr($a000,0)^);
  compresssize:=64000;
{  move(ptr($a000,0)^,p^,compresssize);
  huffmanc(p^,ptr($a000,0)^,compresssize);
  move(ptr($a000,0)^,p^,compresssize);
  slidec(p^,ptr($a000,0)^,compresssize,2);
  move(ptr($a000,0)^,p^,compresssize);
  slidec(p^,ptr($a000,0)^,compresssize,2);
  move(ptr($a000,0)^,p^,compresssize);
  slidec(p^,ptr($a000,0)^,compresssize,2);
  move(ptr($a000,0)^,p^,compresssize);
  slidec(p^,ptr($a000,0)^,compresssize,2);
  move(ptr($a000,0)^,p^,compresssize);
  slidec(p^,ptr($a000,0)^,compresssize,1);
  move(ptr($a000,0)^,p^,compresssize);
  slidec(p^,ptr($a000,0)^,compresssize,2);
  move(ptr($a000,0)^,p^,compresssize);
  slidec(p^,ptr($a000,0)^,compresssize,2);
  move(ptr($a000,0)^,p^,compresssize);
  slidec(p^,ptr($a000,0)^,compresssize,2);
  vgamode(mtext);
  writeln('compresssize:',compresssize);
  readkey;
  vgamode(1);}

{  for primebit:=stbit to endbit do}
  begin
    depth:=1;
    sizeleast:=65535;
    move(ptr($a000,0)^,p^,compresssize);
{    compa(compresssize);}
    compbyleast(compresssize);
  end;
  readkey;
end.