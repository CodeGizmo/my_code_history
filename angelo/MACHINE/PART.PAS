var
  bufer:pointer;
  countcount,indexcount,z,ccpos,thesize,
  uncomcount:word;
  indexpat,
  countpat,
  nopat:array[0..319]of word;

  maxindexf,maxindexm,maxindex,
  countest,indexest,
  count,maxcount,ncount :byte;
  index:word;
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

procedure showfinished;
var y:integer;
begin
  lubogan(399,419,601,430);
  for y:=0 to 9 do
  begin
    setcolor(14);
    line(400,420+y,400+longint(upos)*200 div uncom,420+y);
    setcolor(7);
    line(400+(longint(upos)*200 div uncom)+1,420+y,600,420+y);
  end;
end;

procedure slidewc2(var bufin,bufout;usize:word;cbits:byte);
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
    inc(countcount);
    uncomcount:=uncomcount+wncount;
    if wncount>318 then inc(nopat[319])else inc(nopat[wncount]);

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
  if pass>0 then myptr(bufout)[0]:=12
            else myptr(bufout)[0]:=4;
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
  if uncom>0 then
  repeat
    if keypressed then
    begin
      chh:=readkey;
      if chh=#27 then exit;
    end;
    if edisplay then showfinished;
    search_match;
    if wcountest>2 then
    begin
      if wncount>0 then
      begin
        savenomatch;
        wncount:=0;
      end;
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
end;{slidewc2}