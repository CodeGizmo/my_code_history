program slimmer;
uses vgaliza3,crt;
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
begin
  n:=0;
  vgamode(1);
  getmem(pout,65535);
{  pout:=ptr($a000,0);}
  readkey;
  repeat
    initialize;
{    for y:=0 to 3 do}
    for x:=0 to 31999 do
    begin
      pushbytenbits(8,1);
      pushbytenbits(8,0);
    end;
    inc(n);
  until keypressed;
  readkey;
end.