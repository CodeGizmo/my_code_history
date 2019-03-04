uses crt,vgaliza3;
var
  buncom,bcom   :longint;
  com,uncom     :longint;
  compresssize,
  upos,cpos     :word;
  showcompleted :boolean;      {maybe temp}
  every:word;

  bufer:pointer;
  countcount,indexcount,z,ccpos,thesize,
  uncomcount:word;

  indexdisp,
  indexpat,
  countdisp,
  countpat,
  nodisp,
  nopat:array[0..1280]of word;
type
  myptr=array[0..65530]of byte;
  wordptr=array[0..32766]of word;
var
  maxindexf,maxindexm,maxindex,
  countest,indexest,
  count,maxcount,ncount :byte;
  index:word;
  lupos:word;{temporary}
    abc                              :byte;
    ndexs                            :word;
    abcpos                           :pointer;
    lastindex                        :byte;
    abcofs,
    maxabc,startabc,headabc,abcseg   :word;
    labas                            :boolean;
    abcbuf                           :word;
    uposindex,
    startheadofs,
    countlimit,
    startofs,
    startmaxofs:word;

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

procedure slidec2(var bufin,bufout;usize:word;cbits:byte);
var
  start           :array[0..255]of word;
  max,chars,head  :array[0..255]of word;

      procedure initialize;
      var
        i:word;
        lmax:word;
      begin
        abcbuf:=maxindexf*4{256};
        if abcbuf<256 then abcbuf:=256;
        getmem(abcpos,abcbuf);
        for i:=0 to 255 do
          max[i]:=0;
        for i:=0 to usize-1 do
          inc(max[myptr(bufin)[i]]);
        for i:=0 to 255 do
        begin
          lmax:=max[i];;
          max[i]:=max[i]*longint(abcbuf-256) div usize;
          if (max[i]=0)and(lmax>0)then max[i]:=1;
          chars[i]:=0;
          head[i]:=0;
        end;
        start[0]:=0;
        for i:=1 to 255 do
          start[i]:=start[i-1]+max[i-1];
      end;

  procedure uninit;
  begin
    freemem(abcpos,abcbuf);
  end;

  procedure cachesearch(upto:word);
  begin
    labas:=false;
    maxabc:=max[abc];
    startabc:=start[abc];
    headabc:=head[abc];
    abcseg:=seg(abcpos^);
    abcofs:=ofs(abcpos^);
        for ndexs:=0 to upto do
        begin
          index:=upos-memw[abcseg:abcofs+(startabc+headabc)shl 1]-1;
          if index>maxindex then begin labas:=true;exit;end;
          if headabc=0 then headabc:=maxabc-1 else dec(headabc);
          count:=0;
          while(myptr(bufin)[upos-1-index+count]=myptr(bufin)[upos+count])
               and(count<=maxcount)and(upos+count<=usize)do inc(count);
          if count>countest then
          begin
            countest:=count;
            indexest:=index;
            if countest>maxcount then begin labas:=true;exit;end;
          end;
        end;
  end;

  procedure search_match;
  begin
    ABC:=myptr(bufin)[upos];
    countest:=1;
    if chars[ABC]>0 then
    begin
      if chars[abc]>max[abc]then cachesearch(max[abc]-1)
        else begin cachesearch(chars[abc]-1);end;
      if labas then exit;
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
    end;
  end;{search_match}

  procedure savenomatch;
  begin
    myptr(bufout)[cpos]:=127+ncount;
    inc(cpos);
    move(myptr(bufin)[upos-ncount],myptr(bufout)[cpos],ncount);
    cpos:=cpos+ncount;
  end;{savenomatch}

  procedure moving;
  begin
    abc:=myptr(bufin)[upos];

    head[abc]:=(head[abc]+1)mod max[abc];
    inc(chars[abc]);
    wordptr(abcpos^)[start[abc]+head[abc]]:=upos;
    if upos>maxindexf then dec(chars[myptr(bufin)[upos-maxindexf-1]]);
  end;

begin
  uncom:=usize;
  dec(usize);
  myptr(bufout)[0]:=3;
  myptr(bufout)[1]:=lo(usize);
  myptr(bufout)[2]:=hi(usize);
  myptr(bufout)[5]:=cbits;
  myptr(bufout)[6]:=myptr(bufin)[0];
  maxcount:=1 shl cbits;
  maxindexf:=(1 shl(8-cbits))-1;
  maxindexm:=(1 shl(7-cbits))-1;
  ncount:=0;
  maxindex:=maxindexm;
  initialize;
  cpos:=7;
  upos:=0;
  moving;
  inc(upos);
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
      for upos:=upos to upos+countest-1 do
      begin
        moving;
      end;
      inc(upos);
    end else
    begin
      maxindex:=maxindexf;
      inc(ncount);
      moving;
      inc(upos);
      if ncount>127 then
      begin
        savenomatch;
        ncount:=0;
        maxindex:=maxindexm;
      end;
    end;                {maybe temp}
  until upos>usize;
  if ncount>0 then savenomatch;
  myptr(bufout)[3]:=lo(cpos);
  myptr(bufout)[4]:=hi(cpos);
  compresssize:=cpos;
  uninit;
end;{slidec2}

var wcountest,wcount,
    windexest,windex,
    wmaxindex,wmaxindexf,wmaxindexm,
    wncount,
    wmaxcount,
    myword
    :word;

procedure slidewc3(var bufin,bufout;usize:word;cbits:byte);
var
  start           :array[0..255]of word;
  max,chars,head  :array[0..255]of word;

      procedure initialize;
      var
        i:word;
        lmax:word;
      begin
        abcbuf:={wmaxindexf*4{}64000;
        if abcbuf<256 then abcbuf:=256;
        getmem(abcpos,abcbuf);
        for i:=0 to 255 do
          max[i]:=0;
        for i:=0 to usize-1 do
          inc(max[myptr(bufin)[i]]);
        for i:=0 to 255 do
        begin
          lmax:=max[i];;
          max[i]:=max[i]*longint(abcbuf-256) div usize;
          if (max[i]=0)and(lmax>0)then max[i]:=1;
          chars[i]:=0;
          head[i]:=0;
        end;
        start[0]:=0;
        for i:=1 to 255 do
          start[i]:=start[i-1]+max[i-1];
      end;

  procedure uninit;
  begin
    freemem(abcpos,abcbuf);
  end;

  procedure cachesearch(upto:word);
  begin
    labas:=false;
    maxabc:=max[abc];
    startabc:=start[abc];
    headabc:=head[abc];
    abcseg:=seg(abcpos^);
    abcofs:=ofs(abcpos^);
      startheadofs:=abcofs+(startabc+headabc)shl 1;
      if wmaxcount<=(usize-upos)then countlimit:=wmaxcount
        else countlimit:=usize-upos;
      startofs:=abcofs+(startabc shl 1);
      startmaxofs:=abcofs+(startabc+maxabc-1)shl 1;
        for ndexs:=0 to upto do
        begin
          uposindex:=memw[abcseg:startheadofs];
          windex:=upos-uposindex-1;
          if windex>wmaxindex then begin labas:=true;exit;end;
          if startheadofs=startofs then startheadofs:=startmaxofs
                                   else dec(startheadofs,2);
          wcount:=0;
          while(myptr(bufin)[uposindex+wcount]=myptr(bufin)[upos+wcount])
               and(wcount<=countlimit)do inc(wcount);
          if wcount>wcountest then
          begin
            wcountest:=wcount;
            windexest:=windex;
            if wcountest>wmaxcount then begin labas:=true;exit;end;
          end;
        end;
  end;

  procedure search_match;
  begin
    ABC:=myptr(bufin)[upos];
    wcountest:=2;
    if chars[ABC]>0 then
    begin
      if chars[abc]>max[abc]then cachesearch(max[abc]-1)
        else begin cachesearch(chars[abc]-1);exit;end;
      if labas then exit;
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
    end;
  end;{search_match}

  procedure savenomatch;
  begin
  {}{}{}{}{}{}{}{}
    inc(countcount);
    uncomcount:=uncomcount+wncount;
    if wncount>(maxx-1) then inc(nopat[maxx])else inc(nopat[wncount]);
    if base2(wncount)>(maxx-1) then inc(nopat[maxx])else inc(nodisp[base2(wncount)]);
    move(myptr(bufin)[upos-wncount],myptr(bufer^)[ccpos],wncount);
    ccpos:=ccpos+wncount;

  {}{}{}{}{}{}{}{}
    myptr(bufout)[cpos]:=127+wncount;
    inc(cpos);
    move(myptr(bufin)[upos-wncount],myptr(bufout)[cpos],wncount);
    cpos:=cpos+wncount;
  end;{savenomatch}

  procedure moving;
  begin
    abc:=myptr(bufin)[upos];
    inc(head[abc]);
    if head[abc]=max[abc]then head[abc]:=0;
    inc(chars[abc]);
    wordptr(abcpos^)[start[abc]+head[abc]]:=upos;
    if upos>wmaxindexf then dec(chars[myptr(bufin)[upos-wmaxindexf-1]]);
  end;

begin
  uncomcount:=0;
  countcount:=0;
  indexcount:=0;
  uncom:=usize;
  dec(usize);
  myptr(bufout)[0]:=4;
  myptr(bufout)[1]:=lo(usize);
  myptr(bufout)[2]:=hi(usize);
  myptr(bufout)[5]:=cbits;
  myptr(bufout)[6]:=myptr(bufin)[0];
  wmaxcount:=(1 shl cbits)+1;
  wmaxindexf:=(1 shl(16-cbits))-1;
  wmaxindexm:=(1 shl(15-cbits))-1;
  wncount:=0;
  wmaxindex:=wmaxindexm;
  initialize;
  cpos:=7;
  upos:=0;
  moving;
  inc(upos);
  lupos:=upos;{temp}
  repeat
    search_match;
    if wcountest>2 then
    begin
      if base2(windexest)>(maxx-1){318} then inc(indexdisp[maxx])else inc(indexdisp[base2(windexest)]);
      if wncount>0 then
      begin
        savenomatch;
        wncount:=0;
      end;
      if windexest>(maxx-1){318} then inc(indexpat[maxx])else inc(indexpat[windexest]);
      if wcountest>(maxx-1){318} then inc(countpat[maxx])else inc(countpat[wcountest]);
      if base2(wcountest)>(maxx-1){318} then inc(countpat[maxx])else inc(countdisp[base2(wcountest)]);
      inc(indexcount);
      myword:=(windexest shl cbits)+wcountest-3;
      myptr(bufout)[cpos]:=hi(myword);
      inc(cpos);
      myptr(bufout)[cpos]:=lo(myword);
      inc(cpos);
      wmaxindex:=wmaxindexm;
      for upos:=upos to upos+wcountest-1 do moving;
      inc(upos);
    end else
    begin
      wmaxindex:=wmaxindexf;
      inc(wncount);
      moving;
      inc(upos);
      if wncount>127 then
      begin
        savenomatch;
        wncount:=0;
        wmaxindex:=wmaxindexm;
      end;
    end;                    {maybe temp}
  until upos>usize;
  if wncount>0 then savenomatch;
  myptr(bufout)[3]:=lo(cpos);
  myptr(bufout)[4]:=hi(cpos);
  compresssize:=cpos;
  uninit;
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

procedure initpats;
var t:word;
begin
  for t:=0 to maxx do
  begin
    countpat[t]:=0;
    indexpat[t]:=0;
    nopat[t]:=0;
  end;
end;

var x,y:word;
procedure teller;
begin
    svgamode(3);
    writeln('bit count= ',z:3,'      file size= ',thesize:6);
    writeln('countsaved count= ',countcount:6);
    uncomcount:=0;
    for x:=0 to maxx do uncomcount:=uncomcount+nopat[x]*x;
    writeln('uncompressed count= ',uncomcount:6);
    writeln('index count= ',indexcount:6);
    writeln('compressed count= ',compresssize:6,' ',compresssize/thesize*100:3:2,'%');
    writeln('compressed check= ',countcount+indexcount*2+7+uncomcount:6);
    begin
      writeln('    0..1     ->',indexdisp[0]:6);
      writeln('    2..3     ->',indexdisp[1]:6);
      writeln('    4..7     ->',indexdisp[2]:6);
      writeln('    8..15    ->',indexdisp[3]:6);
      writeln('   16..31    ->',indexdisp[4]:6);
      writeln('   32..63    ->',indexdisp[5]:6);
      writeln('   64..127   ->',indexdisp[6]:6);
      writeln('  128..255   ->',indexdisp[7]:6);
      writeln('  256..511   ->',indexdisp[8]:6);
      writeln('  512..1023  ->',indexdisp[9]:6);
      writeln(' 1024..2047  ->',indexdisp[10]:6);
      writeln(' 2048..4095  ->',indexdisp[11]:6);
      writeln(' 4096..8191  ->',indexdisp[12]:6);
      writeln(' 8192..16383 ->',indexdisp[13]:6);
      writeln('16384..32767 ->',indexdisp[14]:6);
      writeln('32768..65535 ->',indexdisp[15]:6);
    end;
    readkey;
    svgamode($107);
    for x:=0 to maxx do
    begin
      for y:=maxy downto maxy-nopat[x] do syeyan3(x,y,1);
    end;
    readkey;
    for x:=0 to maxx do
    begin
      for y:=maxy downto maxy-(nodisp[x shr 4]div 8) do syeyan3(x,y,2);
    end;
    readkey;
    for x:=0 to maxx do
    begin
      for y:=maxy downto maxy-indexpat[x] do syeyan3(x,y,3);
    end;
    readkey;
    for x:=0 to maxx do
    begin
      for y:=maxy downto maxy-(indexdisp[x shr 4]div 8) do syeyan3(x,y,4);
    end;
    readkey;
{    clear;}
    for x:=0 to maxx do
    begin
      for y:=maxy downto maxy-countpat[x] do syeyan3(x,y,6);
    end;
    readkey;
    for x:=0 to maxx do
    begin
      for y:=maxy downto maxy-(countdisp[x shr 4]div 8) do syeyan3(x,y,7);
    end;
end;

var
  p:pointer;
  ch:char;
begin
  for x:=0 to maxx do
  begin
    nopat[x]:=0;
    nodisp[x]:=0;
    countpat[x]:=0;
    countdisp[x]:=0;
    indexpat[x]:=0;
    indexdisp[count]:=0;
  end;
  directvideo:=false;
  svgamode($107);
  getmem(p,65000);
  getmem(bufer,65000);
{  aload('e:\angelo\newest\pictures\newbunny.liz',p^);}
{  aload('e:\angelo\newest\newdraw7.exe',p^);}
  aload({'adap8.bak}'all',p^);
{  aload('e:\angelo\newest\ziputils\a.arj',p^);}
  readkey;
  clear;
{  uncompress(p^,ptr($a000,0)^);
  thesize:=64000;}
  move(p^,ptr($a000,0)^,myfilesize);
  thesize:=myfilesize;
{  for x:=0 to 319 do
  begin
    for y:=0 to 179 do syeyan3(x,y,random(256));
    for y:=180 to 199 do syeyan3(x,y,0);
  end;}
  ch:=readkey;
  z:=10;
  repeat
{    move(ptr($a000,0)^,p^,64000);
    slidewc2(p^,ptr($a000,0)^,64000{myfilesize,z);
    ch:=readkey;
    move(ptr($a000,0)^,p^,64000);
    clear;
    slidewu(p^,ptr($a000,0)^);
    ch:=readkey;}
    move(ptr($a000,0)^,p^,thesize);
    initpats;
    ccpos:=0;
    slidewc3(p^,ptr($a000,0)^,thesize,z);
    move(ptr($a000,0)^,p^,thesize);
    teller;
    dec(z);
    ch:=readkey;
    clear;
    slidewu(p^,ptr($a000,0)^);
    ch:=readkey;
    if ch=#13 then
    begin
      z:=8;
      thesize:=ccpos;
      ccpos:=0;
      move(bufer^,ptr($a000,0)^,thesize);
      ch:=readkey;
    end;
    if ch='\' then
    begin
      z:=8;
      thesize:=compresssize;
      ccpos:=0;
      move(p^,ptr($a000,0)^,thesize);
      ch:=readkey;
    end;
    while ch in['+']do begin inc(z);ch:=readkey;end;
  until ch=#27;
end.