unit azil2;
{created by: LANUZA, Angelo Lian}
{Address: 234 Purple Rd., Gatchalian Subd., Las Pinas Metro Manila}
{Tel #: dial 109 for a cellular call to 079-27-30}
interface

var
  buncom,bcom   		:longint;
  com,uncom     		:longint;
  compresssize,
  upos,cpos     		:word;
  showcompleted 		:boolean;      {maybe temp}
  every				:word;
  realtocomp,
  xupos,yupos,
  xcpos,ycpos,
  xcomplete,ycomplete,
  xestimate,yestimate		 :word;
  supos,scpos,scomplete,sestimate:boolean;
  addupos,addcpos,realtotal	 :longint;
type
  myptr=array[0..65530]of byte;

procedure showupos(x,y:word);
procedure showcpos(x,y:word);
procedure showcomplete(x,y:word);
procedure showestimate(x,y:word);
procedure huffmanc(var bufin,bufout;unhuffsize:word);
procedure huffmanu(var bufin,bufout);
procedure slidec(var bufin,bufout;usize:word;cbits:byte);
procedure slideu(var bufin,bufout);
procedure slidewc(var bufin,bufout;usize:word;cbits:byte);
procedure slidewu(var bufin,bufout);
procedure instantu(var bufin,bufout);

implementation
uses crt;           {temporary}
var
  comppos:word;
  orer,mybyte:byte;

procedure showupos(x,y:word);
begin
  xupos:=x;
  yupos:=y;
  supos:=true;
end;{showuposxy}

procedure showcpos(x,y:word);
begin
  xcpos:=x;
  ycpos:=y;
  scpos:=true;
end;{showuposxy}

procedure showcomplete(x,y:word);
begin
  xcomplete:=x;
  ycomplete:=y;
  scomplete:=true;
end;{showuposxy}

procedure showestimate(x,y:word);
begin
  xcomplete:=x;
  ycomplete:=y;
  scomplete:=true;
end;{showuposxy}

procedure shower;
begin
  if showcompleted then
  begin
    gotoxy(1,23);
    write('Cpos: ',cpos+addcpos:6,'   upos: ',upos+addupos:6);clreol;
    writeln;
    writeln('Estimated compression: ',(cpos+addcpos)/(upos+addupos)*100:3:3,'%');
    write('Percent Completed: ',(upos+addupos)/realtotal*100:3:3,'%');
  end;
  if supos then
  begin
    gotoxy(xupos,yupos);
    write(upos+addupos:6);
  end;
  if scpos then
  begin
    gotoxy(xcpos,ycpos);
    write(cpos+addcpos:6);
  end;
  if scomplete then
  begin
    gotoxy(xcomplete,ycomplete);
    write((upos/uncom*realtocomp+addupos)/(realtotal)*100:3:3,'%');
  end;
  if sestimate then
  begin
    gotoxy(xestimate,yestimate);
    write((cpos+addcpos)/(upos+addcpos)*100:3:3,'%');
  end;
end;{shower}

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

var
  maxindexf,maxindexm,maxindex,
  countest,indexest,
  index,count,maxcount,ncount :byte;
  lupos:word;{temporary}

procedure slidec(var bufin,bufout;usize:word;cbits:byte);

  procedure search_match;
  begin
    countest:=1;
    index:=0;
    repeat
      count:=0;
      while(myptr(bufin)[upos-1-index+count]=myptr(bufin)[upos+count])
           and(count<=maxcount)and(upos+count<=usize)do inc(count);
      if count>countest then
      begin
        countest:=count;
        indexest:=index;
        if countest>maxcount then exit;
      end;
      inc(index);
    until(index>maxindex)or(index>=upos)or(upos+countest>usize);
  end;{search_match}

  procedure savenomatch;
  begin
    myptr(bufout)[cpos]:=127+ncount;
    inc(cpos);
    move(myptr(bufin)[upos-ncount],myptr(bufout)[cpos],ncount);
    cpos:=cpos+ncount;
  end;{savenomatch}

begin
  uncom:=usize;
  dec(usize);
  myptr(bufout)[0]:=3;
  myptr(bufout)[1]:=lo(usize);
  myptr(bufout)[2]:=hi(usize);
  myptr(bufout)[5]:=cbits;
  myptr(bufout)[6]:=myptr(bufin)[0];
  cpos:=7;
  upos:=1;
  maxcount:=1 shl cbits;
  maxindexf:=(1 shl(8-cbits))-1;
  maxindexm:=(1 shl(7-cbits))-1;
  ncount:=0;
  maxindex:=maxindexm;
  lupos:=upos;{temp}
  repeat
    search_match;
    if countest>1 then
    begin
      if ncount>0 then
      begin
        savenomatch;
        ncount:=0;
      end;
      myptr(bufout)[cpos]:=(indexest shl cbits)+countest-2;
      maxindex:=maxindexm;
      inc(cpos);
      upos:=upos+countest;
    end else
    begin
      maxindex:=maxindexf;
      inc(ncount);
      inc(upos);
      if ncount>127 then
      begin
        savenomatch;
        ncount:=0;
        maxindex:=maxindexm;
      end;
    end;                {maybe temp}
    if(lupos+every<upos)then
    begin
      shower;
      lupos:=upos;
    end;
  until upos>usize;
  if ncount>0 then savenomatch;
  myptr(bufout)[3]:=lo(cpos);
  myptr(bufout)[4]:=hi(cpos);
  compresssize:=cpos;
end;{slidec}

procedure slideu(var bufin,bufout);
var cbits:byte;
    usize:word;
    fullok:boolean;
begin
  if myptr(bufin)[0]=3 then
  begin
    cbits:=myptr(bufin)[5];
    usize:=myptr(bufin)[1]+(word(myptr(bufin)[2])shl 8);
    myptr(bufout)[0]:=myptr(bufin)[6];
    cpos:=7;
    upos:=1;
    maxcount:=(1 shl cbits)-1;
    repeat
      fullok:=false;
      repeat
        ncount:=myptr(bufin)[cpos];
        inc(cpos);
        if ncount>=128 then
        begin
          ncount:=ncount-127;
          if ncount<128 then fullok:=true;
          move(myptr(bufin)[cpos],myptr(bufout)[upos],ncount);
          upos:=upos+ncount;
          cpos:=cpos+ncount;
        end else
        begin
          index:=ncount shr cbits;
          ncount:=ncount and maxcount;
          for ncount:=0 to ncount+1 do
          begin
            myptr(bufout)[upos]:=myptr(bufout)[upos-1-index];
            inc(upos);
          end;
        end;
      until fullok or(upos>usize);
      if upos<usize then
      begin
        ncount:=myptr(bufin)[cpos];
        inc(cpos);
        index:=ncount shr cbits;
        ncount:=ncount and maxcount;
        for ncount:=0 to ncount+1 do
        begin
          myptr(bufout)[upos]:=myptr(bufout)[upos-1-index];
          inc(upos);
        end;
      end;
    until upos>usize;
  end;
end;{slideu}

var wcountest,wcount,
    windexest,windex,
    wmaxindex,wmaxindexf,wmaxindexm,
    wncount,
    wmaxcount,
    myword
    :word;
procedure slidewc(var bufin,bufout;usize:word;cbits:byte);

  procedure search_match;
  begin
    wcountest:=2;
    windex:=0;
    repeat
      wcount:=0;
      while(myptr(bufin)[upos-1-windex+wcount]=myptr(bufin)[upos+wcount])
           and(wcount<=wmaxcount)and(upos+wcount<=usize)do inc(wcount);
      if wcount>wcountest then
      begin
        wcountest:=wcount;
        windexest:=windex;
        if wcountest>wmaxcount then exit;
      end;
      inc(windex);
    until(windex>wmaxindex)or(windex>=upos)or(upos+wcountest>usize);
  end;{search_match}

  procedure savenomatch;
  begin
    myptr(bufout)[cpos]:=127+wncount;
    inc(cpos);
    move(myptr(bufin)[upos-wncount],myptr(bufout)[cpos],wncount);
    cpos:=cpos+wncount;
  end;{savenomatch}

begin
  uncom:=usize;
  dec(usize);
  myptr(bufout)[0]:=4;
  myptr(bufout)[1]:=lo(usize);
  myptr(bufout)[2]:=hi(usize);
  myptr(bufout)[5]:=cbits;
  myptr(bufout)[6]:=myptr(bufin)[0];
  cpos:=7;
  upos:=1;
  wmaxcount:=(1 shl cbits)+1;
  wmaxindexf:=(1 shl(16-cbits))-1;
  wmaxindexm:=(1 shl(15-cbits))-1;
  wncount:=0;
  wmaxindex:=wmaxindexm;
  lupos:=upos;{temp}
  repeat
    search_match;
    if wcountest>2 then
    begin
      if wncount>0 then
      begin
        savenomatch;
        wncount:=0;
      end;
      myword:=(windexest shl cbits)+wcountest-3;
      myptr(bufout)[cpos]:=hi(myword);
      inc(cpos);
      myptr(bufout)[cpos]:=lo(myword);
      inc(cpos);
      wmaxindex:=wmaxindexm;
      upos:=upos+wcountest;
    end else
    begin
      wmaxindex:=wmaxindexf;
      inc(wncount);
      inc(upos);
      if wncount>127 then
      begin
        savenomatch;
        wncount:=0;
        wmaxindex:=wmaxindexm;
      end;
    end;                    {maybe temp}
    if(lupos+every<upos)then
    begin
      shower;
      lupos:=upos;
    end;
  until upos>usize;
  if wncount>0 then savenomatch;
  myptr(bufout)[3]:=lo(cpos);
  myptr(bufout)[4]:=hi(cpos);
  compresssize:=cpos;
end;{slidewc}

procedure slidewu(var bufin,bufout);
var cbits:byte;
    usize:word;
    fullok:boolean;
begin
  if myptr(bufin)[0]=4 then
  begin
    cbits:=myptr(bufin)[5];
    usize:=myptr(bufin)[1]+(word(myptr(bufin)[2])shl 8);
    myptr(bufout)[0]:=myptr(bufin)[6];
    cpos:=7;
    upos:=1;
    wmaxcount:=(1 shl cbits)-1;
    repeat
      fullok:=false;
      repeat
        wncount:=myptr(bufin)[cpos];
        inc(cpos);
        if wncount>=128 then
        begin
          wncount:=wncount-127;
          if wncount<128 then fullok:=true;
          move(myptr(bufin)[cpos],myptr(bufout)[upos],wncount);
          upos:=upos+wncount;
          cpos:=cpos+wncount;
        end else
        begin
          wncount:=(wncount shl 8)+(myptr(bufin)[cpos]);
          inc(cpos);
          windex:=wncount shr cbits;
          wncount:=wncount and wmaxcount;
          for wncount:=0 to wncount+2 do
          begin
            myptr(bufout)[upos]:=myptr(bufout)[upos-1-windex];
            inc(upos);
          end;
        end;
      until fullok or(upos>usize);
      if upos<usize then
      begin
        wncount:=(myptr(bufin)[cpos]shl 8)+(myptr(bufin)[cpos+1]);
        inc(cpos,2);
        windex:=wncount shr cbits;
        wncount:=wncount and wmaxcount;
        for wncount:=0 to wncount+2 do
        begin
          myptr(bufout)[upos]:=myptr(bufout)[upos-1-windex];
          inc(upos);
        end;
      end;
    until upos>usize;
  end;
end;{slidewu}

procedure instantu(var bufin,bufout);
var compressmode:byte;
    segin,ofsin,segout,ofsout:word;
    pin,pout:pointer;
begin
  segin:=seg(bufin);
  ofsin:=ofs(bufin);
  segout:=seg(bufout);
  ofsout:=ofs(bufout);
  pin:=ptr(segin,ofsin);
  pout:=ptr(segout,ofsout);
  compressmode:=myptr(pin^)[0];
  case compressmode of
    0:normalu(pin^,pout^);
    1:huffmanu(pin^,pout^);
    3:slideu(pin^,pout^);
    4:slidewu(pin^,pout^);
  end;
end;{instantu}

begin
  every:=20;
end.

