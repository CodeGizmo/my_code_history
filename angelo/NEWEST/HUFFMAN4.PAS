uses crt,dos;
var
  d1,d2,d3,d4                     :word;
  pin,pout                        :pointer;
  fin,fout                        :file;
  filein,fileout,filelist         :string;
  sorted,equiv                    :array[0..255]of byte;

  weights                         :array[0..255]of word;
  neww                            :array[0..511]of word;
  sizein,sizeout,sizeread         :word;
  ch                              :char;
  dirinfo                         :searchrec;

type
  myptr=array[0..65530]of byte;
  word2=^word;
  longint2=^longint;
procedure frameout(x1,y1,x2,y2,f,b:integer);
var x,y:integer;
begin
  textcolor(f);
  textbackground(b);
  gotoxy(x1-1,y1-1);
  write(#201{'É'});
  for x:=x1 to x2 do write(#205{'Í'});
  write(#187{'»'});
  for y:=y1 to y2 do
  begin
    gotoxy(x1-1,y);
    write(#186{'º'});
    for x:=x1 to x2 do write(' ');
    write(#186{'º'});
  end;
  gotoxy(x1-1,y2+1);
  write(#200{'È'});
  for x:=x1 to x2 do write(#205{'Í'});
  write(#188{'¼'});
end;

procedure frameclear(x1,y1,x2,y2:integer);
var x,y:integer;
begin
  for y:=y1-1 to y2+1 do
  begin
    gotoxy(x1-1,y);
    for x:=x1-1 to x2+1 do write(' ');
  end;
end;

procedure loadfirst(filename:string;var buf);
begin
  assign(fin,filename);
  reset(fin,1);
  blockread(fin,buf,sizein,sizeread);
  close(fin);
end;{loadfirst}

procedure loadnext(var buf);
begin
  blockread(fin,buf,sizein,sizeread);
end;{loadnext}

procedure closein;
begin
  close(fin);
end;

procedure savefirst(filename:string;var buf);
begin
  assign(fout,filename);
  rewrite(fout,1);
  blockwrite(fout,buf,sizeout);
end;{savefirst}

procedure savenext(var buf);
begin
  blockwrite(fout,buf,sizeout);
end;{savenext}

procedure closeout;
begin
  close(fout);
end;{closeout}

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
  for d4:=0 to sizeread-1 do inc(weights[myptr(pin^)[d4]]);
end;{getweights}

procedure sortmin;
var min:byte;
begin
  for d1:=0 to 255 do
  begin
    min:=d1;
    for d2:=d1 to 255 do
    begin
      if weights[sorted[min]]>weights[sorted[d2]]then
      begin
        min:=d2;
      end;
    end;
    d3:=sorted[min];
    sorted[min]:=sorted[d1];
    sorted[d1]:=d3;
    neww[d1]:=weights[d3];
  end;
  for d1:=0 to 255 do equiv[sorted[d1]]:=d1;
end;{sort}

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
  tcom,tuncom,buncom,bcom:longint;
  numfiles:word;
procedure addsizes;
var d:byte;
    com,uncom:longint;
begin
  com:=0;uncom:=0;
  for d:=0 to 255 do
  begin
    com:=com+longint(sizes[d]*neww[d]);
    uncom:=uncom+8*longint(neww[d]);
  end;
  tcom:=tcom+com;
  tuncom:=tuncom+uncom;
  clrscr;
  writeln('FILENAME: ',dirinfo.name:13,' ',numfiles);
  inc(numfiles);
  writeln('              Uncompressed       Compressed');
  writeln('by bits  :',uncom:15,com:15);
  writeln('by bytes :',uncom div 8:15,com div 8:15);
  writeln('Percent compressed (ideal) : ',com*100 div uncom,'%');
  writeln('Precent compressed (real)  : ',(com+1024)*100 div uncom,'%');
  writeln;
  writeln('     C U M U L A T I V E :');
  writeln('              Uncompressed       Compressed');
  writeln('by bits  :',tuncom:15,tcom:15);
  writeln('by bytes :',tuncom div 8:15,tcom div 8:15);
  writeln('Percent compressed (ideal) : ',tcom*100 div tuncom,'%');
  writeln('Precent compressed (real)  : ',(tcom+1024)*100 div tuncom,'%');
end;{addsizes}

function lightest0:word;
var d:word;
begin
  d:=0;
  while not(ready[d])do inc(d);
  lastlight0:=d;
  for d:=d to 511 do
    if ready[d]and(neww[lastlight0]>neww[d])then lastlight0:=d;
  lightest0:=lastlight0;
end;

function lightest1:word;
var d:word;
begin
  d:=0;
  while not(ready[d])do inc(d);
  lastlight1:=d;
  for d:=d to 511 do
    if ready[d]and(neww[lastlight1]>neww[d])then lastlight1 :=d;
  lightest1:=lastlight1;
end;

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

procedure buildtree;
var d:word;
begin
  getready;
  d:=256;
  while tot_ready>1 do
  begin
    ff[d]:=lightest0;
    mother[lastlight0]:=d;
    ready[lastlight0]:=false;
    bits[lastlight0]:=0;

    ss[d]:=lightest1;
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
    myptr(pout^)[comppos]:=mybyte;
    mybyte:=0;
    inc(comppos);
    if comppos>=sizeout then
    begin
      savenext(pout^);
      comppos:=0;
    end;
  end;
end;{addbit}

{procedure addbit2(mybit:byte);
begin
  if mybit>0 then myword:=myword or orer2;
  orer2:=orer2 shr 1;
  if orer2=0 then
  begin
    orer2:=32768;
    word2(myptr(ptr($a000,0)^)[comppos])^:=myword;
    myword:=0;
    inc(comppos,2);
  end;
end;{addbit}

procedure convert(this:byte);
begin
  if this<>grandma then
  begin
    convert(mother[this]);
    addbit(bits[this]);
  end;
end;{convert}

var unpos:word;
procedure HUFFMAN;
begin
  clearweights;
  getweights;
  sort;
  buildtree2;
  if buncom>bcom+512 then
  begin
    myptr(pout^)[comppos]:=1;
    inc(comppos);
    longint2(myptr(pout^)[comppos])^:=buncom;
    inc(comppos,4);
    longint2(myptr(pout^)[comppos])^:=bcom;
    inc(comppos,4);
    for d1:=0 to 255 do
    begin
      word2(myptr(pout^)[comppos])^:=weights[d1];
      inc(comppos,2);
    end;
    for unpos:=0 to sizein-1 do
      convert(equiv[myptr(pin^)[unpos]]);
  end;
end;{huffman}

procedure compress;
begin

end;

procedure initialize;
begin
  sizein:=7*18*512;
  sizeout:=4*18*512;
  getmem(pin,sizein);
  getmem(pout,sizein+512);
  filelist:='*.*';
end;{initialize}

procedure uninit;
begin
  freemem(pin,sizein);
  freemem(pout,sizeout);
end;{uninit}

{begin
  initialize;
  repeat
    frameout(2,2,79,23,yellow,blue);
    ch:=readkey;
  until ch=#27;
  uninit;
end.}



begin
  initialize;
  clrscr;
  chdir('e:\angelo\newest\pictures');
  readkey;
  repeat
    findfirst('*.*',archive,dirinfo);
    tcom:=0;
    tuncom:=0;
    numfiles:=1;
    while {true}(doserror=0)and(not(keypressed)) do
    begin
      loadfirst(dirinfo.name,pin^);
      clearweights;
      if ioresult=0 then
      begin
        getweights;
        sort;
      end else writeln('Error reading');
      buildtree2;
      readkey;
      findnext(dirinfo);
    end;
  until true or (keypressed and(readkey=#27));
  uninit;
  sound(500);
  delay(50);
  nosound;
  readkey;
  chdir('e:\angelo\newest');
end.

