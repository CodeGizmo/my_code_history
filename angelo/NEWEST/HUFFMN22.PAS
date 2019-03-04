uses crt,dos,vgaliza2;
var
  d1,d2,d3,d4                :word;
  p                          :pointer;
  f                          :file;
  filename                   :string;
  sorted                     :array[0..255]of byte;
  weights                    :array[0..255]of word;
  neww                       :array[0..511]of word;
  size,x,y                   :word;
  ch                         :char;

type
  myptr=array[0..65530]of byte;
  word2=^word;

procedure loadfirst(filename:string;var buf);
begin
  {$I-}
  assign(f,filename);
  reset(f,1);
  size:=filesize(f);
  blockread(f,buf,size);
  close(f);
  {$I+}
end;{loadfirst}

procedure clearweights;
begin
  for d1:=0 to 255 do
  begin
    weights[d1]:=0;
    sorted[d1]:=d1;
  end;
  for d1:=0 to 511 do neww[d1]:=0;
end;

procedure getweights(var buf);
var pos:word;
    bufseg,bufofs:word;
begin
{  bufseg:=seg(buf);
  bufofs:=ofs(buf);}
  for pos:=0 to size-1 do inc(weights[myptr(buf)[pos]{mem[bufseg:bufofs+pos]}]);
end;{getweights}

procedure sortmax;
var max:byte;
begin
  for d1:=0 to 255 do
  begin
    max:=d1;
    for d2:=d1 to 255 do
    begin
      if weights[sorted[max]]<weights[sorted[d2]]then
      begin
        max:=d2;
      end;
    end;
    d3:=sorted[max];
    sorted[max]:=sorted[d1];
    sorted[d1]:=d3;
    neww[d1]:=weights[d3];
  end;
end;{sort}

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
end;{sort}

var
  ff,ss                    :array[256..511]of word;
  bits                     :array[0..511]of byte;
  ready                    :array[0..511]of boolean;
  sizes                    :array[0..255]of byte;
  tot_ready                :word;
  lastlight0,lastlight1    :word;
{  xpos,ypos     :array[0..511]of word;
  x1,x2         :word;}

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

procedure showsizes;
var d:byte;
    com,uncom:longint;
begin
  com:=0;uncom:=0;
  for d:=0 to 127 do
  begin
    gotoxy((d div  25)*10+1,(d mod 25)+1);
    write(d:3,':',sizes[d]:5);
    com:=com+longint(sizes[d]*neww[d]);
    uncom:=uncom+8*longint(neww[d]);
  end;
  ch:=readkey;
  for d:=0 to 127 do
  begin
    gotoxy((d div  25)*10+1,(d mod 25)+1);
    write(d+128:3,':',sizes[d+128]:5);
    com:=com+longint(sizes[d+128]*neww[d+128]);
    uncom:=uncom+8*longint(neww[d+128]);
  end;
  gotoxy(70,23);write(uncom);
  gotoxy(70,24);write(com);
  gotoxy(70,25);write(com/uncom*100:0:2,'%');
  ch:=readkey;
end;{showsizes}

function lightest0:word;
var d:word;
begin
  d:=0{d1-256};
  while not(ready[d])do inc(d);
  lastlight0:=d;
  for d:=d to 511 do
    if ready[d]and(neww[lastlight0]>neww[d])then lastlight0:=d;
  lightest0:=lastlight0;
end;

function lightest1:word;
var d:word;
begin
  d:=0{d1-256};
  while not(ready[d])do inc(d);
  lastlight1:=d;
  for d:=d to 511 do
    if ready[d]and(neww[lastlight1]>neww[d])then lastlight1 :=d;
  lightest1:=lastlight1;
end;

procedure buildtree;
var d:word;
begin
  getready;
  d:=256;
  while tot_ready>1 do
  begin
    ff[d]:=lightest0;
    ready[lastlight0]:=false;
    bits[lastlight0]:=0;

    ss[d]:=lightest1;
    ready[lastlight1]:=false;
    bits[lastlight1]:=1;

    neww[d]:=neww[lastlight0]+neww[lastlight1];
    ready[d]:=true;
    inc(d);
    dec(tot_ready);
  end;
  getsizes(0,d-1);
  clrscr;
  showsizes;
  ch:=readkey;
end;

procedure testhuffman;
begin
  for d1:=0 to 255 do
    if weights[sorted[d1]]>0 then ready[d1]:=true else ready[d1]:=false;
  for d1:=256 to 511  do ready[d1]:=false;

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
    myptr(ptr($a000,0)^)[comppos]:=mybyte;
    mybyte:=0;
    inc(comppos);
  end;
end;{addbit}

procedure addbit2(mybit:byte);
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

begin
  clrscr;
  getmem(p,65535);
  loadfirst('tasm.exe',p^);
  clearweights;
  if ioresult=0 then
  begin
    getweights(p^);
    sortmin;
    repeat
      ch:=readkey;
      case ch of
        'f':for x:=0 to 127 do
            begin
              gotoxy((x div  25)*10+1,(x mod 25)+1);
              write(x:3,':',weights[x]:5);
            end;
        's':begin
              for x:=0 to 127 do
              begin
                gotoxy((x div  25)*10+1,(x mod 25)+1);
                write((x+128):3,':',weights[x+128]:5);
              end;
              gotoxy(65,25);write('size is ',size:5);
            end;
        'x':for x:=0 to 127 do
            begin
              gotoxy((x div  25)*10+1,(x mod 25)+1);
              write(sorted[x]:3,':',neww[x]:5);
            end;
        'y':begin
              for x:=0 to 127 do
              begin
                gotoxy((x div  25)*10+1,(x mod 25)+1);
                write((sorted[x+128]):3,':',neww[x+128]:5);
              end;
            end;
        'a':sortmin;
        'b':{sortmax;}buildtree;
      end;
    until ch=#27;
  end else writeln('Error reading');

  writeln('If you''re ready press ENTER');
  readln;
  vgamode(1);
  for d1:=0 to 65535 do for d2:=0 to 31 do
  begin
{    myptr(ptr($a000,0)^)[d1]:=d1;}
    addbit2({myptr(p^)[d1]}d1);
  end;
  vgamode(mtext);
  writeln('finish');
  readln;
  freemem(p,65535);
end.