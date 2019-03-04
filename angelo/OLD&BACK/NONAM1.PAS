uses vgayey;
var
  x,y:word;
  p:pointer;
  p1,p2:byte;
  col:array[0..15]of byte;
  red,grn,blu:array[0..15]of byte;
  r,g,b:byte;

begin
  col[0]:=0;
  col[1]:=2;
  col[2]:=4;
  col[3]:=6;
  col[4]:=8;
  col[5]:=10;
  col[6]:=12;
  col[7]:=14;
  col[8]:=1;
  col[9]:=3;
  col[10]:=5;
  col[11]:=7;
  col[12]:=9;
  col[13]:=11;
  col[14]:=13;
  col[15]:=15;
  vgamode(1);
  aload('bunny.all',ptr($9000,0)^);
  gseg:=$9000;
  getmem(p,65535);
  for x:=0 to 319 do
  for y:=0 to 199 do
  begin
    p1:=col[agetplot(x shl 1,y)];
    p2:=col[agetplot((x shl 1)+1,y)];
    yeyan(x,y,p1);
    if p2=0 then yeyan(x,y,0);
  end;
  for x:=0 to 15 do getdac(x,red[x],grn[x],blu[x]);
  readln;
  for x:=0 to 255 do
  begin
    r:=(red[x and 15]+red[x shr 4]);
    g:=(grn[x and 15]+grn[x shr 4]);
    b:=(blu[x and 15]+blu[x shr 4]);
    myup(x,r,g,b);
  end;
  gseg:=$a000;
  getthis(0,0,319,199,p^);

  readln;
end.



