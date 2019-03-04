unit compress;
{created by: LANUZA, Angelo Lian}
{Address: 234 Purple Rd., Gatchalian Subd., Las Pinas Metro Manila}
{Tel #: dial 109 for a cellular call to 079-27-30}
interface
uses crt;
var
  result_size,
  upos,cpos     :word;
type
  myptr=array[0..65530]of byte;

procedure slidec(var bufin,bufout;usize:word;cbits:byte);
procedure slideu(var bufin,bufout);

implementation

var
  maxindexf,maxindexm,maxindex,
  countest,indexest,
  index,count,maxcount,ncount :byte;

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
    end;
  until upos>usize;
  if ncount>0 then savenomatch;
  myptr(bufout)[3]:=lo(cpos);
  myptr(bufout)[4]:=hi(cpos);
  result_size:=cpos;
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
    result_size:=usize+1;
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

end.

