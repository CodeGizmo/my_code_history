uses crt,vgaliza3,rolfazil;
var
  buncom,bcom   :longint;
  com,uncom     :longint;
  compresssize,
  upos,cpos     :word;
  showcompleted :boolean;      {maybe temp}
  every:word;
type
  myptr=array[0..65530]of byte;
  wordptr=array[0..32766]of word;

var
  maxindexf,maxindexm,maxindex,
  countest,indexest,
  index,count,maxcount,ncount :byte;
  lupos:word;{temporary}

  var
    abc                   :byte;
    ndexs                 :word;
  var
    abcpos                :pointer;



procedure slidec2(var bufin,bufout;usize:word;cbits:byte);
var
  start,max,chars,head  :array[0..255]of word;
  procedure initialize;
  var
    i:word;
    lmax:word;
  begin
    getmem(abcpos,maxindexf*2+256);
    for i:=0 to 255 do
      max[i]:=0;
    for i:=0 to usize-1 do
      inc(max[myptr(bufin)[i]]);
    for i:=0 to 255 do
    begin
      lmax:=max[i];
      max[i]:=longint(max[i]*maxindexf*2)div usize;
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
    freemem(abcpos,maxindexf*2+256);
  end;
  procedure search_match;

  begin
    ABC:=myptr(bufin)[upos];
    countest:=1;
    {if chars[ABC]>0 then}
    begin
{      if chars[ABC]>max[ABC]then}
      begin
        index:=0;
        for ndexs:=0 to max[abc]-1 do
        begin
          index:=upos-wordptr(abcpos^)[start[abc]+((head[abc]+max[abc]-ndexs)mod max[abc])]-1;
          if index>maxindex then exit;
          if myptr(bufin)[upos-1-index]<>myptr(bufin)[upos]then
          begin
            write('NOT A MATCH!');
            readkey;
          end else
          begin
            write('A MATCH!');
            readkey;
          end;
          count:=0;
          while(myptr(bufin)[upos-1-index+count]=myptr(bufin)[upos+count])
               and(count<=maxcount)and(upos+count<=usize)do inc(count);
          if count>countest then
          begin
            countest:=count;
            indexest:=index;
            if countest>maxcount then exit;
          end;
        end;
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
      end;{ else
      begin
        for ndexs:=0 to chars[abc]-1 do
        begin
          index:=upos-wordptr(abcpos^)[start[abc]+((head[abc]-ndexs)mod max[abc])]-1;
          if index>maxindex then exit;
          count:=0;
          while(myptr(bufin)[upos-1-index+count]=myptr(bufin)[upos+count])
               and(count<=maxcount)and(upos+count<=usize)do inc(count);
          if count>countest then
          begin
            countest:=count;
            indexest:=index;
            if countest>maxcount then exit;
          end;
        end;
      end;}
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
    if (upos-maxindexf)>0 then dec(chars[myptr(bufin)[upos-maxindexf-1]]);
  end;

begin
  uncom:=usize;
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
  initialize;
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
      for upos:=upos to upos+countest do
      begin
        moving;
{        inc(upos);}
      end;
{      upos:=upos+countest;}
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

var
  p,p2:pointer;
  ch:char;
begin
  directvideo:=false;
  vgamode(1);
  getmem(p,65000);
  getmem(p2,65000);
  aload('e:\angelo\newest\pictures\newbunny.liz',p^);
  uncompress(p^,ptr($a000,0)^);
  repeat
    move(ptr($a000,0)^,p2^,64000);
    slidec2(p2^,ptr($a000,0)^,64000,2);
    ch:=readkey;
{    move(ptr($a000,0)^,p2^,compresssize);
    slidec2(p2^,ptr($a000,0)^,compresssize,2);
    ch:=readkey;}
    move(ptr($a000,0)^,p2^,64000);
    clear;
    slideu(p2^,ptr($a000,0)^);
{    move(ptr($a000,0)^,p2^,64000);
    clear;
    slideu(p2^,ptr($a000,0)^);}

    ch:=readkey;
  until ch=#27;
end.