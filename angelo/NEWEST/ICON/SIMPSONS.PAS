unit simpsons;
{created by: LANUZA, Angelo Lian
 Address: 234 Purple Rd., Gatchalian Subd., Las Pinas Metro Manila
 Tel #: dial 109 for a cellular call to 079-27-30

                   Copyright 1994, April...
                    All Rights Reserved!
}
interface
uses crt;
var
  buncom,bcom   :longint;
  com,uncom     :longint;
  compresssize,
  upos,cpos     :word;
  showcompleted :boolean;      {maybe temp}
  every:word;
type
  myptr=array[0..65530]of byte;


procedure huffmanc(var bufin,bufout;unhuffsize:word);
procedure huffmanu(var bufin,bufout);

implementation
           {temporary}
var
  comppos:word;
  orer,mybyte:byte;

procedure normalc(var bufin,bufout;size:word);
begin
  myptr(bufout)[0]:=0;
  myptr(bufout)[1]:=lo(size);
  myptr(bufout)[2]:=hi(size);
  move(bufin,myptr(bufout)[comppos],size);
end;{normalc}

procedure normalu(var bufin,bufout);
var size:word;
begin
  size:=myptr(bufout)[comppos]+myptr(bufout)[comppos+1]shl 8;
  inc(comppos,2);
  move(myptr(bufin)[3],bufout,size);
end;{normalu}

var
  d1,d2,d3,d4                     :word;
  pin,pout                        :pointer;
  sorted,equiv                    :array[0..255]of byte;
  weights                         :array[0..255]of word;
  neww                            :array[0..511]of word;
  sizein,sizeout{,sizeread}         :word;
  ch                              :char;

var
  grandma,this             :word;
  mother                   :array[0..511]of word;
  ff,ss                    :array[256..511]of word;
  bits                     :array[0..511]of byte;
  ready                    :array[0..511]of boolean;
  sizes                    :array[0..255]of byte;
  tot_ready                :word;
  lastlight0,lastlight1    :word;



procedure clearweights;
begin
  for d1:=0 to 255 do
  begin
    weights[d1]:=0;
    sorted[d1]:=d1;
  end;
  for d1:=0 to 511 do neww[d1]:=0;
end;

procedure quicksort(l,r:byte);
var
  ll,rr:byte;
  ave:word;
begin
  ave:=(weights[sorted[l]]+weights[sorted[r]])div 2;
  ll:=l;
  rr:=r;
  repeat
    while(weights[sorted[ll]]<ave)do inc(ll);
    while(weights[sorted[rr]]>ave)do dec(rr);
    if ll<=rr then
    begin
      d4:=sorted[ll];
      sorted[ll]:=sorted[rr];
      sorted[rr]:=d4;
      inc(ll);
      dec(rr);
    end;
  until ll>rr;
  if l<rr then quicksort(l,rr);
  if r>ll then quicksort(ll,r);
end;{quicksort}

procedure sort;
begin
  quicksort(0,255);
  for d1:=0 to 255 do
  begin
    neww[d1]:=weights[sorted[d1]];
    equiv[sorted[d1]]:=d1;
  end;
end;{sort}

procedure getready;
var d:word;
begin
  tot_ready:=0;
  for d:=0 to 255 do
  begin
    if neww[d]>0 then
    begin
      ready[d]:=true;
      inc(tot_ready);
    end else ready[d]:=false;
    sizes[d]:=0;
  end;
  for d:=256 to 511 do ready[d]:=false;
end;{getready}

procedure getsizes(inisize:byte;this:word);
begin
  if this<256 then
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
  for d:=0 to 255 do
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
  stem:=256;
  leaf:=256-tot_ready;
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
  d:=256;
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
  if this<>grandma then
  begin
    convert(mother[this]);
    addbit(bits[this]);
  end;
end;{convert}

var unpos:word;
procedure huffmanc(var bufin,bufout;unhuffsize:word);
begin
  uncom:=unhuffsize;
  pin:=@bufin;
  pout:=@bufout;
  buncom:=unhuffsize;
  clearweights;
  for d1:=0 to unhuffsize-1 do inc(weights[myptr(bufin)[d1]]);
  sort;
  buildtree2;
  com:=0;
  for d1:=0 to 255 do
  begin
    com:=com+longint(sizes[d1]*neww[d1]);
  end;
  bcom:=(com+7)div 8;
  compresssize:=bcom+512+5;
  if buncom>bcom+512+2 then
  begin
    initbit;
    myptr(bufout)[comppos]:=1;
    myptr(bufout)[comppos+1]:=lo(buncom);
    myptr(bufout)[comppos+2]:=hi(buncom);
    myptr(bufout)[comppos+3]:=lo(bcom);
    myptr(bufout)[comppos+4]:=hi(bcom);
    inc(comppos,5);
    for d1:=0 to 255 do
    begin
      myptr(bufout)[comppos]:=lo(weights[d1]);
      inc(comppos);
      myptr(bufout)[comppos]:=hi(weights[d1]);
      inc(comppos);
    end;
    for unpos:=0 to unhuffsize-1 do
    begin
      convert(equiv[myptr(bufin)[unpos]]);
    end;
    if orer<128 then myptr(bufout)[comppos]:=mybyte;
  end else
  begin
    comppos:=0;
    myptr(bufout)[comppos]:=0;
    inc(comppos);
    myptr(bufout)[comppos]:=lo(buncom);
    myptr(bufout)[comppos+1]:=hi(buncom);
    inc(comppos,2);
    move(bufin,myptr(bufout)[comppos],unhuffsize);
    compresssize:=unhuffsize+3;
  end;
end;{huffmanc}

procedure huffmanu(var bufin,bufout);

  procedure initgetbit;
  begin
    mybyte:=myptr(bufin)[comppos];
    inc(comppos);
    orer:=128;
  end;{initgetbit}

  function getbit:byte;
  begin
    getbit:=mybyte and orer;
    orer:=orer shr 1;
    if orer=0 then
    begin
      orer:=128;
      mybyte:=myptr(bufin)[comppos];
      inc(comppos);
    end;
  end;{getbit}

  var unconverted:byte;
  procedure unconvert(thisbit:byte;this:word);
  begin
    if thisbit=0 then this:=ff[this] else this:=ss[this];
    if this>255 then unconvert(getbit,this)else unconverted:=this;
  end;{unconvert}

begin
  pin:=@bufin;
  pout:=@bufout;
  comppos:=0;
  if myptr(bufin)[comppos]=0 then
  begin
    inc(comppos);
    buncom:=myptr(bufin)[comppos]+(word(myptr(bufin)[comppos+1])shl 8);
    inc(comppos,2);
    move(myptr(bufin)[comppos],bufout,buncom);
  end else
  begin
    inc(comppos);
    buncom:=myptr(bufin)[comppos]+(word(myptr(bufin)[comppos+1])shl 8);
    inc(comppos,2);
    bcom:=myptr(bufin)[comppos]+(word(myptr(bufin)[comppos+1])shl 8);
    inc(comppos,2);
    for d1:=0 to 255 do
    begin
      weights[d1]:=myptr(bufin)[comppos]+(word(myptr(bufin)[comppos+1])shl 8);
      inc(comppos,2);
      sorted[d1]:=d1;
    end;
    sort;
    buildtree2;
    initgetbit;
    for unpos:=0 to buncom-1 do
    begin
{      unconvert(getbit,grandma);
      myptr(bufout)[unpos]:=sorted[unconverted];}
      This:=grandma;
      repeat
        if getbit=0 then this:=ff[this]else this:=ss[this];
      until this<=255;
      myptr(bufout)[unpos]:=sorted[this];
    end;
  end;
end;{huffmanu}

begin
  every:=20;
end.

