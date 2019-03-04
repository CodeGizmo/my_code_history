uses crt;
type
  myptr = array[0..65534]of byte;
  wptr  = array[0..32766]of word;
var
  buncom,bcom   :longint;
  com,uncom     :longint;
  compresssize  :word;

  comppos       :word;
  orer,mybyte   :byte;

  d1,d3,d4      :word;
  pin,pout      :pointer;
  sorted,equiv  :array[0..15]of byte;
  weights       :array[0..15]of word;
  neww          :array[0..31]of word;

  grandma,this  :word;
  mother        :array[0..31]of word;
  ff,ss         :array[16..31]of word;
  bits          :array[0..31]of byte;
  ready         :array[0..31]of boolean;
  sizes         :array[0..15]of byte;
  tot_ready     :word;
  lastlight0,
  lastlight1    :word;

procedure clearweights;
begin
  for d1:=0 to 15 do
  begin
    weights[d1]:=0;
    sorted[d1]:=d1;
  end;
  for d1:=0 to 31 do neww[d1]:=0;
end;

procedure quicksort(l,r:byte);
var
  ll,rr:byte;
  ave:word;
  ave_rem:word;
  total:longint;
begin
  total:=(weights[sorted[l]]+weights[sorted[r]]);
  ave:=total div 2;
  ave_rem:=ave+(total mod 2);
  ll:=l;
  rr:=r;
  {The bug is that the ave is an integer that when an odd number is divided
   to 2 will result to an integer too}
  repeat
    while(weights[sorted[ll]]<ave_rem)do inc(ll);
    if ll>15 then
    begin
      writeln('sobra ang ll ->',ll:6);
      repeat until 1=0;
    end;
    while(weights[sorted[rr]]>ave)do dec(rr);
    if rr>15 then
    begin
      writeln('sobra ang rr ->',rr:6);
      repeat until 1=0;
    end;
    if ll<=rr then
    begin
      d4:=sorted[ll];
      sorted[ll]:=sorted[rr];
      sorted[rr]:=d4;
      inc(ll);
      if ll>15 then
      begin
        writeln('sobra ang ll ->',ll:6);
        repeat until 1=0;
      end;
      dec(rr);
      if rr>15 then
      begin
        writeln('sobra ang rr ->',rr:6);
        repeat until 1=0;
      end;
    end;
  until ll>rr;
  if l<rr then quicksort(l,rr);
  if r>ll then quicksort(ll,r);
end;{quicksort}

procedure sort;
begin
  quicksort(0,15);
  for d1:=0 to 15 do
  begin
    neww[d1]:=weights[sorted[d1]];
    equiv[sorted[d1]]:=d1;
  end;
end;{sort}

procedure getready;
var d:word;
begin
  tot_ready:=0;
  for d:=0 to 15 do
  begin
    if neww[d]>0 then
    begin
      ready[d]:=true;
      inc(tot_ready);
    end else ready[d]:=false;
    sizes[d]:=0;
  end;
  for d:=16 to 31 do ready[d]:=false;
end;{getready}

procedure getsizes(inisize:byte;this:word);
begin
  if neww[this]=0 then
  begin
    writeln('Kaya pala wala yung character ->',this:6);
    readln;
  end;
  if this<16 then
  begin
    sizes[this]:=inisize;
  end else
  begin
    getsizes(inisize+1,ff[this]);
    getsizes(inisize+1,ss[this]);
  end;
end;{getsizes}

procedure addsizes;
var d:byte;
begin
  com:=0;uncom:=0;
  for d:=0 to 15 do
  begin
    com:=com+longint(sizes[d]*neww[d]);
    uncom:=uncom+8*longint(neww[d]);
  end;
end;{addsizes}

var
  stem          :word;
  leaf          :byte;
  lastlight     :word;
procedure searchleaf;
begin
  stem:=16;
  leaf:=16-tot_ready;
end;{searchleaf}

function light0:word;
begin
  if ready[leaf]and((neww[stem]>=neww[leaf])or not(ready[stem]))then
  begin
    lastlight0:=leaf;
    inc(leaf);
  end else
  begin
    lastlight0:=stem;
    inc(stem);
  end;
  light0:=lastlight0;
end;{lightest}

function light1:word;
begin
  if ready[leaf]and((neww[stem]>=neww[leaf])or not(ready[stem]))then
  begin
    lastlight1:=leaf;
    inc(leaf);
  end else
  begin
    lastlight1:=stem;
    inc(stem);
  end;
  light1:=lastlight1;
end;{lightest}

procedure buildtree2;
var d:word;
begin
  getready;
  searchleaf;
  d:=16;
  while tot_ready>1 do
  begin
    ff[d]:=light0;
    mother[lastlight0]:=d;
    ready[lastlight0]:=false;
    bits[lastlight0]:=0;

    ss[d]:=light1;
    mother[lastlight1]:=d;
    ready[lastlight1]:=false;
    bits[lastlight1]:=1;

    neww[d]:=neww[lastlight0]+neww[lastlight1];
    ready[d]:=true;
    inc(d);
    dec(tot_ready);
  end;
  grandma:=d-1;
  getsizes(0,d-1);
  addsizes;
end;

procedure initbit;
begin
  mybyte:=0;
  orer:=128;
  comppos:=0;
end;{initbit}

procedure addbit(mybit:byte);
begin
  if mybit>0 then mybyte:=mybyte or orer;
  orer:=orer shr 1;
  if orer=0 then
  begin
    orer:=128;
    myptr(pout^)[comppos]:=mybyte;
    mybyte:=0;
    inc(comppos);
  end;
end;{addbit}

procedure convert(this:word);
begin
  if neww[this]=0 then
  begin
    writeln('Kaya pala wala yung character');
    readln;
    halt;
  end;
  if this<>grandma then
  begin
    convert(mother[this]);
    addbit(bits[this]);
  end;
end;{convert}

function base2(b:word):word;
begin
  if b<256 then
  begin
    if b<16 then
    begin
      if b<4 then
      begin
        if b<2 then b:=0
        else b:=1
      end else
      begin
        if b<8 then b:=2
        else b:=3
      end
    end else
    begin
      if b<64 then
      begin
        if b<32 then b:=4
        else b:=5
      end else
      begin
        if b<128 then b:=6
        else b:=7
      end
    end
  end else
  begin
    if b<4096 then
    begin
      if b<1024 then
      begin
        if b<512 then b:=8
        else b:=9
      end else
      begin
        if b<2048 then b:=10
        else b:=11
      end
    end else
    begin
      if b<16384 then
      begin
        if b<8192 then b:=12
        else b:=13
      end else
      begin
        if b<32768 then b:=14
        else b:=15
      end
    end
  end;
  if b>15 then halt;
  base2:=b;
end;

var unpos:word;
procedure huffmanc(bufin,bufout:pointer;unhuffsize:word);
begin
  uncom:=unhuffsize;
  pin:=bufin;
  pout:=bufout;
  buncom:=unhuffsize;
  clearweights;
  for d1:=0 to (unhuffsize shr 1)-1 do
  begin
    inc(weights[base2(wptr(bufin^)[d1])]);
{    gotoxy(1,1);writeln(base2(wptr(bufin)[d1]));
    for d3:=0 to 15 do
    begin
      gotoxy(1,d3+2);writeln(weights[d3]:6);
    end;
{    writeln('press any key to continue');
    readkey;}
  end;
  sort;
  buildtree2;
  com:=0;
  for d1:=0 to 15 do
  begin
    com:=com+longint(sizes[d1]*neww[d1]);
  end;
  bcom:=(com+7)div 8;
  compresssize:=bcom+32+5;
  if buncom>bcom+32+2 then
  begin
    initbit;
    myptr(bufout^)[comppos]:=1;
    myptr(bufout^)[comppos+1]:=lo(buncom);
    myptr(bufout^)[comppos+2]:=hi(buncom);
    myptr(bufout^)[comppos+3]:=lo(bcom);
    myptr(bufout^)[comppos+4]:=hi(bcom);
    inc(comppos,5);
    for d1:=0 to 15 do
    begin
      myptr(bufout^)[comppos]:=lo(weights[d1]);
      inc(comppos);
      myptr(bufout^)[comppos]:=hi(weights[d1]);
      inc(comppos);
    end;
    for unpos:=0 to (unhuffsize shr 1)-1 do
    begin
      convert(equiv[base2(wptr(bufin^)[unpos])]);
{      gotoxy(1,1);write('The current position is',unpos:6);}
    end;
    if orer<128 then myptr(bufout^)[comppos]:=mybyte;
  end else
  begin
    comppos:=0;
    myptr(bufout^)[comppos]:=0;
    inc(comppos);
    myptr(bufout^)[comppos]:=lo(buncom);
    myptr(bufout^)[comppos+1]:=hi(buncom);
    inc(comppos,2);
    move(bufin,myptr(bufout^)[comppos],unhuffsize);
    compresssize:=unhuffsize+3;
  end;
end;{huffmanc}

var
  p:pointer;
  po:pointer;
  dd:word;
  pp:^wptr;

const  rr:word=0;
begin
clrscr;
  getmem(p,65535);
  getmem(po,65535);
  pp:=p;
{repeat}
  randomize;
repeat
  for
  dd:=
  0 to 29999 do wptr(p^)[dd]:={ 8000 shr (dd and 15)}random(65535)and $fFfF;
{  readkey;}
{repeat}
  inc(rr);
  wptr(p^)[1]:=12345;
  myptr(p^)[0]:=0;
  myptr(p^)[1]:=0;
  huffmanc(p,po,60000);
  writeln('compressed: ',Compresssize:6,rr:6);
{  readln;}
until keypressed;
  freemem(p,65535);
  freemem(po,65535);
end.