uses crt,vgaliza3,rolfazil;
var
  ch:char;
  nbits:array[1..6,0..20]of boolean;
  primebit:byte;
  lcsize:word;
  p:pointer;
  depth,d1,d2,d3,d4:byte;
const
  stbit=1;
  endbit=2;
procedure compa(biterns:byte;lastsize:word);
begin
  move(ptr($a000,0)^,p^,lastsize);
  lcsize:=lastsize;
  for d2:=stbit to endbit do
  begin
    slidec(p^,ptr($a000,0)^,lastsize,d2);
    if compresssize<lastsize then
    begin
      nbits[d2,depth]:=true;
      inc(depth);
      compa(biterns,compresssize);
      dec(depth);
      slideu(p^,ptr($a000,0)^);
      move(ptr($a000,0)^,p^,65535);
    end else
    begin
      nbits[d2,depth]:=false;
    end;
    move(p^,ptr($a000,0)^,lastsize);
  end;
end;

begin
  vgamode(1);
  getmem(p,65535);
  aload('pictures\foricons.liz',p^);
  uncompress(p^,ptr($a000,0)^);
  compresssize:=64000;
{  for primebit:=stbit to endbit do}
  begin
    depth:=1;
    compa(primebit,compresssize);
  end;
  readkey;
end.