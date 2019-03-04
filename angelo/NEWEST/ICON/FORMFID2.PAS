uses crt;
type
  myptr=array[0..65000]of byte;
var
  cpos,posi,lupos,upos,compresssize
  :word;
  uncount,maxcount,maxindex,index,count,countest
  :byte;

procedure compress(var pin,pout;size:word;bc:byte);
  procedure saveuncompress;
  begin
    myptr(pout)[cpos]:=$80+uncount;
    inc(cpos);
    for posi:=lupos to upos-1 do
    begin
      myptr(pout)[cpos]:=myptr(pin)[posi];
      inc(cpos);
    end;
  end;
  procedure findmaxcount;
  begin
    countest:=1;
    repeat

    until index>maxindex;
  end;
begin
  maxcount:=(1 shl bc)+1;
  maxindex:=($80 shr bc)-1;
  index:=0;
  upos:=1;
  count:=0;
  cpos:=0;
  repeat
    findmaxcount;
    if countest>=2 then
    begin
      if uncount>0 then
      begin
        saveuncompress;
      end;
      myptr(pout)[cpos]:=(index shl bc)+countest;
      inc(cpos);
      inc(upos,countest);
      lupos:=upos;
    end else
    begin
      inc(uncount);
      if uncount>=127 then
      begin
        saveuncompress;
        lupos:=upos;
      end;
    end;
  until upos>=size;
  if uncount>0 then saveuncompress;
  compresssize:=cpos;
end;
begin
end.