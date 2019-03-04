unit slidew;
interface
var
  wmaxindexf,wmaxindexm,wmaxindex,
  wcountest,windexest,
  windex,wcount,wmaxcount,wncount,upos,cpos,myword,
  wcompresssize                                         :word;
type
  myptr=array[0..65530]of byte;

procedure slidewc(var bufin,bufout;usize:word;cbits:byte);
procedure slidewu(var bufin,bufout);

implementation
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
    end;
  until upos>usize;
  if wncount>0 then savenomatch;
  myptr(bufout)[3]:=lo(cpos);
  myptr(bufout)[4]:=hi(cpos);
  wcompresssize:=cpos;
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


begin
end.