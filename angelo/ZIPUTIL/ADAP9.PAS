uses crt,vgaliza3,rolfazil;
var
  buncom,bcom   :longint;
  com,uncom     :longint;
  compresssize,
  upos,cpos     :word;
  showcompleted :boolean;      {maybe temp}
  every:word;
  uncomcount:word;
  indexpat,
  countpat,
  nopat:array[0..319]of word;
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
        else begin cachesearch(chars[abc]-1);exit;end;
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

procedure slidewc2(var bufin,bufout;usize:word;cbits:byte);
var
  start           :array[0..255]of word;
  max,chars,head  :array[0..255]of word;

      procedure initialize;
      var
        i:word;
        lmax:word;
      begin
        abcbuf:={wmaxindexf*2}65000;
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
        else begin cachesearch(chars[abc]-1);end;
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
    uncomcount:=uncomcount+wncount;
    if wncount>318 then inc(nopat[319])else inc(nopat[wncount]);
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
      if wncount>0 then
      begin
        savenomatch;
        wncount:=0;
      end;
      if windexest>318 then inc(indexpat[319])else inc(indexpat[windexest]);
      if wcountest>318 then inc(countpat[319])else inc(countpat[wcountest]);
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
    uncomcount:=uncomcount+wncount;
    if wncount>318 then inc(nopat[319])else inc(nopat[wncount]);
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
      if wncount>0 then
      begin
        savenomatch;
        wncount:=0;
      end;
      if windexest>318 then inc(indexpat[319])else inc(indexpat[windexest]);
      if wcountest>318 then inc(countpat[319])else inc(countpat[wcountest]);
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

var bufinseg:word;
    bufinofs:word;
procedure slidewc4(var bufin,bufout;usize:word;cbits:byte);
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
    bufinseg:=seg(bufin);
    bufinofs:=ofs(bufin);
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
      asm
      pusha
             Push ds
             mov  dx,bufinseg
             mov  bx,upos
             add  bx,bufinofs
             mov  si,startheadofs
             mov  es,dx

             mov  ax,countlimit
             inc  ax
             sub  ax,wcountest
             mov  wcountest,ax

             mov  cx,ss:upto
             inc  cx
        @nextndexs:
             Push cx
             push ds
             mov  ds,abcseg
             std
             lodsw
             pop  ds

             mov  cx,upos
             sub  cx,ax
             dec  cx
             cmp  cx,wmaxindex
             ja   @endcachepop

             cmp  si,startofs
             jae  @goon
             mov  si,startmaxofs
        @goon:
             mov  cx,countlimit
             inc  cx

             mov  di,ax
             push ds
             mov  ds,dx
             push si
             mov  si,bx
             cld
             repe cmpsb
             pop  si
             pop  ds

             cmp  cx,wcountest
             jb   @newcountest
             pop  cx
             loop @nextndexs
             jmp  @endcache
        @newcountest:
             mov  wcountest,cx
             mov  uposindex,ax
             cmp  cx,0
             jz   @endcachepop
             pop  cx
             loop @nextndexs
        @endcachepop:
             pop  cx
        @endcache:
             mov  cx,countlimit
             inc  cx
             sub  cx,wcountest
             mov  wcountest,cx
             mov  windex,ax
             pop  ds
             popa
      end;
      windexest:=upos-uposindex-1;
      if(windex>wmaxindex)or(countest>wmaxcount)then labas:=true;
{        for ndexs:=0 to upto do
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
        end;}
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
    uncomcount:=uncomcount+wncount;
    if wncount>318 then inc(nopat[319])else inc(nopat[wncount]);
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
      if wncount>0 then
      begin
        savenomatch;
        wncount:=0;
      end;
      if windexest>318 then inc(indexpat[319])else inc(indexpat[windexest]);
      if wcountest>318 then inc(countpat[319])else inc(countpat[wcountest]);
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



procedure initpats;
var t:word;
begin
  for t:=0 to 319 do
  begin
    countpat[t]:=0;
    indexpat[t]:=0;
    nopat[t]:=0;
  end;
end;

var x,y:word;
procedure teller;
begin
    vgamode(mtext);
    writeln('uncompressed count= ',uncomcount:6);
    readkey;
    vgamode(1);
    for x:=0 to 319 do
    begin
      if nopat[x]>199 then bar(x,199,x+nopat[x]div 200,0,1)else
      for y:=199 downto 199-nopat[x] do yeyan(x,y,2);
    end;
    readkey;
    for x:=0 to 319 do
    begin
      if indexpat[x]>199 then bar(x,199,x+indexpat[x]div 200,0,3)else
      for y:=199 downto 199-indexpat[x] do yeyan(x,y,4);
    end;
    readkey;
    clear;
    for x:=0 to 319 do
    begin
      if countpat[x]>199 then bar(x,199,x+countpat[x]div 200,0,5) else
      for y:=199 downto 199-countpat[x] do yeyan(x,y,4);
    end;
end;

var
  p:pointer;
  ch:char;
begin
  directvideo:=false;
  vgamode(1);
  getmem(p,65000);
  aload('e:\angelo\newest\pictures\newbunny.liz',p^);
{  aload('e:\angelo\newest\newdraw7.exe',p^);}
{  aload('e:\angelo\newest\ziputils\a.arj',p^);}
  readkey;
  clear;
  uncompress(p^,ptr($a000,0)^);
{  move(p^,ptr($a000,0)^,64000);}
{  for x:=0 to 319 do
  begin
    for y:=0 to 179 do yeyan(x,y,random(256));
    for y:=180 to 199 do yeyan(x,y,0);
  end;}
  ch:=readkey;
  repeat
    move(ptr($a000,0)^,p^,64000);
    slidewc4(p^,ptr($a000,0)^,64000,8);
    ch:=readkey;
    move(ptr($a000,0)^,p^,64000);
    clear;
    slidewu(p^,ptr($a000,0)^);
    ch:=readkey;
    move(ptr($a000,0)^,p^,64000);
    initpats;
    slidewc3(p^,ptr($a000,0)^,64000,8);
    move(ptr($a000,0)^,p^,64000);
{    teller;}
    readkey;
    clear;
    slidewu(p^,ptr($a000,0)^);
    ch:=readkey;
  until ch=#27;
end.