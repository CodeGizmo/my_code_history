program slimmer;
uses vgaliza3,crt,dos;
{Created: Wed, Nov 2, 1994; 4:52PM}
var
  bitpos,
  bytebits:byte;
  bytepos:word;
  pout:pointer;
type
  myptr=array[0..65500]of byte;
procedure PushByteNBits(bitn,bits:byte);
begin
  if bitn>(7-bitpos)then
  begin
    bitpos:=bitn-(8-bitpos);
    myptr(pout^)[bytepos]:=bytebits or(bits shr bitpos);
    inc(bytepos);
    bytebits:=bits shl(8-bitpos);
  end else
  begin
    bitpos:=bitpos+bitn;
    bytebits:=bytebits or(bits shl(8-bitpos));
  end;
end;{PushByteNBits}

procedure initialize;
begin
  bitpos:=0;
  bytepos:=0;
  bytebits:=0;
end;

var
  n,x,y:word;
  h1,m1,s1,hs1,
  h2,m2,s2,hs2:word;
  t,rate:real;
begin
  n:=0;
  vgamode(1);
  getmem(pout,65535);
  pout:=ptr($a000,0);
  readkey;
  gettime(h1,m1,s1,hs1);
  repeat
    initialize;
{    for y:=0 to 3 do}
    for x:=0 to 63999 do
    begin
      pushbytenbits(1,13);
    end;
    inc(n);
  until keypressed;
  gettime(h2,m2,s2,hs2);
  readkey;
  vgamode(mtext);
  t:=(hs2-hs1+s2*100-s1*100)/100;
  writeln('Elapsed time=',t:5:2,' count=',n:6,' rate=',n/t:6:2);
  readkey;
end.


