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
    maxabc:=max[abc];
    startabc:=start[abc];
    headabc:=head[abc];
    abcseg:=seg(abcpos^);
        for ndexs:=0 to upto do
        begin
          windex:=upos-memw[abcseg:(startabc+headabc)shl 1]-1;
          if windex>wmaxindex then begin labas:=true;exit;end;
          if headabc=0 then headabc:=maxabc-1 else dec(headabc);
          wcount:=0;
          while(myptr(bufin)[upos-1-windex+wcount]=myptr(bufin)[upos+wcount])
               and(wcount<=wmaxcount)and(upos+wcount<=usize)do inc(wcount);
          if wcount>wcountest then
          begin
            wcountest:=wcount;
            windexest:=windex;
            if wcountest>wmaxcount then exit;
          end;
        end;
  end;

  procedure moving;
  begin
    abc:=myptr(bufin)[upos];
    head[abc]:=(head[abc]+1)mod max[abc];
    inc(chars[abc]);
    wordptr(abcpos^)[start[abc]+head[abc]]:=upos;
    if upos>wmaxindexf then dec(chars[myptr(bufin)[upos-wmaxindexf-1]]);
  end;

  procedure search_match;
  begin
    ABC:=myptr(bufin)[upos];
    labas:=false;
    wcountest:=2;
    if chars[ABC]>0 then
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
  wmaxcount:=(1 shl cbits)+1;
  wmaxindexf:=(1 shl(16-cbits))-1;
  wmaxindexm:=(1 shl(15-cbits))-1;
  wncount:=0;
  wmaxindex:=wmaxindexm;
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
      for upos:=upos to upos+wcountest-1 do
        moving;
      inc(upos);
{      upos:=upos+wcountest;}
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
    if (showcompleted)and(lupos+every<upos)then
    begin
      gotoxy(1,23);
      writeln('Estimated compression: ',cpos/upos*100:3:3,'%');
      write('Percent Completed: ',upos/usize*100:3:3,'%');
      lupos:=upos
    end;
  until upos>usize;
  if wncount>0 then savenomatch;
  myptr(bufout)[3]:=lo(cpos);
  myptr(bufout)[4]:=hi(cpos);
  compresssize:=cpos;
end;{slidewc}