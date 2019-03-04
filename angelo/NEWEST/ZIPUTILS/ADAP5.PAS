uses crt,vgaliza3,rolfazil;
var
  buncom,bcom   :longint;
  com,uncom     :longint;
  compresssize,
  upos,cpos     :word;
  showcompleted :boolean;      {maybe temp}
  every:word;
  uncomcount:word;
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

procedure slidec2(var bufin,bufout;usize:word;cbits:byte);
var
  start           :array[0..255]of word;
  max,chars,head  :array[0..255]of word;

      procedure initialize;
      var
        i:word;
        lmax:word;
      begin
        abcbuf:=maxindexf*2{256};
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
        else cachesearch(chars[abc]-1);
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
        abcbuf:=wmaxindexf*2;
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
          windex:=upos-memw[abcseg:abcofs+(startabc+headabc)shl 1]-1;
          if windex>wmaxindex then begin labas:=true;exit;end;
          if headabc=0 then headabc:=maxabc-1 else dec(headabc);
          wcount:=0;
          while(myptr(bufin)[upos-1-windex+wcount]=myptr(bufin)[upos+wcount])
               and(wcount<=wmaxcount)and(upos+wcount<=usize)do inc(wcount);
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
        else cachesearch(chars[abc]-1);
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
    uncomcount:=uncomcount+wncount;
    myptr(bufout)[cpos]:=127+wncount;
    inc(cpos);
    move(myptr(bufin)[upos-wncount],myptr(bufout)[cpos],wncount);
    cpos:=cpos+wncount;
  end;{savenomatch}

  procedure moving;
  begin
    abc:=myptr(bufin)[upos];
    head[abc]:=(head[abc]+1)mod max[abc];
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

var
  p:pointer;
  ch:char;
  t:word;
begin
  directvideo:=false;
  vgamode(1);
  getmem(p,65000);
  aload('e:\angelo\newest\pictures\newbunny.liz',p^);
{  aload('e:\angelo\newest\newdraw7.exe',p^);}
  t:=0;
  readkey;
  uncompress(p^,ptr($a000,0)^);
{  move(p^,ptr($a000,0)^,64000);}
  ch:=readkey;
  repeat
    move(ptr($a000,0)^,p^,64000);
    slidewc(p^,ptr($a000,0)^,64000,6);
    ch:=readkey;
    move(ptr($a000,0)^,p^,64000);
    clear;
    slidewu(p^,ptr($a000,0)^);
    ch:=readkey;
    move(ptr($a000,0)^,p^,64000);
    slidewc2(p^,ptr($a000,0)^,64000,6);
    move(ptr($a000,0)^,p^,64000);
    vgamode(mtext);
    writeln('uncompressed count= ',uncomcount:6);
    ch:=readkey;
    vgamode(1);
    clear;
    slidewu(p^,ptr($a000,0)^);
    ch:=readkey;
  until ch=#27;
end.