uses crt,dos;
var
  buncom,bcom,
  d1,d2,d3,d4                     :word;
  p1,p2                           :pointer;
  sorted,equiv                    :array[0..255]of byte;

  weights                         :array[0..255]of word;
  neww                            :array[0..511]of word;
  ch                              :char;
var dirinfo:searchrec;
var fin:file;
    sizeread:word;

type
  myptr=array[0..65530]of byte;
  word2=^word;
  longint2=^longint;

procedure clearweights;
begin
  for d1:=0 to 255 do
  begin
    weights[d1]:=0;
    sorted[d1]:=d1;
  end;
  for d1:=0 to 511 do neww[d1]:=0;
end;

procedure getweights;
begin
  for d4:=0 to sizeread-1 do inc(weights[myptr(p1^)[d4]]);
end;{getweights}

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

var
  grandma                  :word;
  mother                   :array[0..511]of word;
  ff,ss                    :array[256..511]of word;
  bits                     :array[0..511]of byte;
  ready                    :array[0..511]of boolean;
  sizes                    :array[0..255]of byte;
  tot_ready                :word;
  lastlight0,lastlight1    :word;

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

var
  tcom,tuncom,com,uncom:longint;
  numfiles:word;
procedure addsizes;
var d:byte;
begin
  com:=0;uncom:=0;
  for d:=0 to 255 do
  begin
    com:=com+longint(sizes[d]*neww[d]);
    uncom:=uncom+8*longint(neww[d]);
  end;
  bcom:=(com+7)div 8;
  buncom:=uncom div 8;
  tcom:=tcom+com;
  tuncom:=tuncom+uncom;
  clrscr;
  writeln('FILENAME: ',dirinfo.name:13,' ',numfiles);
  writeln('              Uncompressed       Compressed');
  writeln('by bits  :',uncom:15,com:15);
  writeln('by bytes :',uncom div 8:15,com div 8:15);
  writeln('Percent compressed (ideal) : ',com*100 div uncom,'%');
  writeln('Precent compressed (real)  : ',(com+512*8)*100 div uncom,'%');
  writeln;
  writeln('     C U M U L A T I V E :');
  writeln('              Uncompressed       Compressed');
  writeln('by bits  :',tuncom:15,tcom:15);
  writeln('by bytes :',tuncom div 8:15,tcom div 8:15);
  writeln('Percent compressed (ideal) : ',tcom*100 div tuncom,'%');
  writeln('Precent compressed (real)  : ',(tcom+512*numfiles)*100 div tuncom,'%');
end;{addsizes}

var
  stem          :word;
  leaf          :byte;
  lastlight     :word;
procedure searchleaf;
begin
  stem:=256;
{  while not(ready[leaf])do inc(leaf);}
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

var
  comppos,myword,orer2:word;
  orer,mybyte:byte;
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
    myptr(p2^)[comppos]:=mybyte;
    mybyte:=0;
    inc(comppos);
    if comppos>buncom then
    begin
      writeln('comppos exceeds!');
      readkey;
    end;
  end;
end;{addbit}

var count:word;
procedure convert(this:word);
begin
  inc(count);
  if count>255 then
  begin
    write('Nag exceed nga!');
    readkey;
  end;
  if this<>grandma then
  begin
    convert(mother[this]);
    addbit(bits[this]);
  end;
end;{convert}

procedure check;
begin
  d2:=0;
  gotoxy(1,1);
  writeln('grandma=',grandma);
  for d1:=0 to 255 do
  begin
    writeln('grandma=',grandma);
    convert(equiv[myptr(p1^)[d1]]);
    if wherey=25 then
    begin
      gotoxy(1,2);
      ch:=readkey;
    end;
  end;
end;{check}

var unpos:word;
procedure huffmanc;
begin
  buncom:=sizeread;
  clearweights;
  for d1:=0 to sizeread-1 do inc(weights[myptr(p1^)[d1]]);
  sort;
  buildtree2;
  com:=0;
{  buncom:=0;}
  for d1:=0 to 255 do
  begin
    com:=com+longint(sizes[d1]*neww[d1]);
{    buncom:=buncom+neww[d1];}
  end;
  bcom:=(com+7)div 8;
  if buncom>bcom+512+2 then
  begin
    initbit;
    myptr(p2^)[comppos]:=1;
    inc(comppos);
    word2(myptr(p2^)[comppos])^:=buncom;
    inc(comppos,2);
    word2(myptr(p2^)[comppos])^:=bcom;
    inc(comppos,2);
    for d1:=0 to 255 do
    begin
      word2(myptr(p2^)[comppos])^:=weights[d1];
      inc(comppos,2);
    end;
{    check;}
    if buncom<>sizeread then
    begin
      writeln('Mali sa itaas');
      readkey;
    end;
    for unpos:=0 to buncom-1 do
    begin
      count:=0;
      convert(equiv[myptr(p1^)[unpos]]);
    end;
    if orer<128 then myptr(p2^)[comppos]:=mybyte;
  end else
  begin
      if buncom<>sizeread then
    begin
      writeln('Mali sa baba');
      readkey;
    end;
    comppos:=0;
    myptr(p2^)[comppos]:=0;
    inc(comppos);
    word2(myptr(p2^)[comppos])^:=buncom;
    inc(comppos,2);
{    for unpos:=0 to sizeread-1 do
    begin
      myptr(p2^)[comppos]:=myptr(p1^)[unpos];
      inc(comppos);
    end;}
    writeln('R E T A I N');
(*    move(p1^,{ptr(seg(p2^),ofs(p2^)+3)^}p2^,5500);*)
{    readkey;}
  end;
end;{huffmanc}

procedure initialize;
begin
  getmem(p2,65500);
  getmem(p1,65500);
 { p2:=ptr($b800,0);}
end;{initialize}

procedure uninit;
begin
end;{uninit}

{begin
  initialize;
  repeat
    frameout(2,2,79,23,yellow,blue);
    ch:=readkey;
  until ch=#27;
  uninit;
end.}

{begin
end.}


procedure loadfirst(filename:string;var buf);
begin
  assign(fin,filename);
  reset(fin,1);
  blockread(fin,buf,4*512*18,sizeread);
  close(fin);
end;{loadfirst}

procedure loadnext(var buf);
begin
  blockread(fin,buf,4*512*18,sizeread);
end;{loadnext}


begin
  initialize;
  clrscr;
  chdir('e:\angelo\newest');
  readkey;
  repeat
    findfirst('*.*',archive,dirinfo);
    tcom:=0;
    tuncom:=0;
    numfiles:=1;
    while {true}(doserror=0)and(not(keypressed)) do
    begin
      loadfirst(dirinfo.name,p1^);
      buncom:=sizeread;
      clearweights;
      getweights;
      sort;
      buildtree2;
      huffmanc;
      findnext(dirinfo);
      inc(numfiles);
    end;
  until true or (keypressed and(readkey=#27));
  uninit;
  sound(500);
  delay(50);
  nosound;
  readkey;
  chdir('e:\angelo\newest');
end.

