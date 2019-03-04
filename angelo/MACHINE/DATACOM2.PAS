program DATACOMP;

uses crt,dos,graph{,slides};

var
  code,
  menu,
  d,
  graphdriver,graphmode :integer;
  quit                  :boolean;
  ch                    :char;
  compmode              :byte;
  edisplay              :boolean;
  pass                  :word;


const
  left  = #75;
  right = #77;
  filename:string='*.*';
  destined:string='LANUZA.ALL';
  bc:byte=4;
procedure boxout(ymin:integer;c1,c2:byte);
var
  d:integer;
begin
  for d:=239 downto ymin do
  begin
    setcolor(c1);
    moveto(d,d);
    lineto(639-d,d);
    lineto(639-d,479-d);
    lineto(d,479-d);
    lineto(d,d);
    setcolor(c2);
    moveto(d+1,d+1);
    lineto(638-d,d+1);
    lineto(638-d,478-d);
    lineto(d+1,478-d);
    lineto(d+1,d+1);
  end;
end;

procedure boxin;
var
  d:integer;
begin
  for d:=0 to 239 do
  begin
    setcolor(0);
    moveto(d,d);
    lineto(639-d,d);
    lineto(639-d,479-d);
    lineto(d,479-d);
    lineto(d,d);
  end;
end;

procedure l(x1,y1,x2,y2:integer;c:byte);
var d:integer;
begin
  if x1>x2 then
  begin
    d:=y1;
    y1:=y2;
    y2:=d;
    d:=x1;
    x1:=x2;
    x2:=d;
  end;
  setcolor(c);
  line(x1,y1,x2,y2);
end;


procedure lubogan(x1,y1,x2,y2:integer);
var lym:byte;
    dum:integer;
begin
  if x1>x2 then begin dum:=x1;x1:=x2;x2:=dum;end;
  if y1>y2 then begin dum:=y1;y1:=y2;y2:=dum;end;
  setcolor(8);
  line(x1,y1,x2,y1);
  setcolor(15);
  line(x1,y2,x2,y2);
  line(x2,y1,x2,y2);
  setcolor(8);
  line(x1,y1,x1,y2);

end;{lubogan}

procedure angatan(x1,y1,x2,y2:integer);
var lym:byte;
    dum:integer;
begin
  if x1>x2 then begin dum:=x1;x1:=x2;x2:=dum;end;
  if y1>y2 then begin dum:=y1;y1:=y2;y2:=dum;end;
  setcolor(15);
  line(x1,y1,x2,y1);
  setcolor(8);
  line(x1,y2,x2,y2);
  line(x2,y1,x2,y2);
  setcolor(15);
  line(x1,y1,x1,y2);
end;{angatan}

procedure puttitle;
begin
  settextstyle(gothicfont,horizdir,5);
  settextjustify(centertext,centertext);
  setcolor(0);
  outtextxy(320,100,'WELCOME');
  settextstyle(gothicfont,horizdir,3);
  outtextxy(320,140,'to');
  settextstyle(TRIPLEXfont,horizdir,7);
  setcolor(8);
  for d:=9 downto 0 do
  begin
    outtextxy(320+d,180+d,'DATA COMPRESSION');
  end;
  setcolor(15);
  outtextxy(320,180,'DATA COMPRESSION');
  settextstyle(triplexfont,horizdir,2);
  outtextxy(320,240,'(The Basic)');
  setcolor(0);
  settextstyle(defaultfont,horizdir,1);
  outtextxy(320,280,'Programmed by  :  LANUZA, Angelo L.      ');
  outtextxy(320,300,'Submitted on   :  Tuesday, March 5, 1996 ');
  outtextxy(320,320,'for the subject:  KODP 351L - A581       ');
  outtextxy(320,340,'Submitted to   :  Ms. Noemi Bulaong      ');
end;

procedure initialize;
begin
  graphdriver:=detect;
  detectgraph(graphdriver,graphmode);
  initgraph(graphdriver,graphmode,'d:\tp7\bgi');
  delay(4100);
  boxout(0,8,7);
  l(0,0,639,0,15);
  l(0,0,0,479,15);
  l(639,479,0,479,8);
  l(639,479,639,0,8);
  l(1,1,638,1,15);
  l(1,1,1,478,15);
  l(638,478,1,478,8);
  l(638,478,638,1,8);
  l(2,2,637,2,15);
  l(2,2,2,477,15);
  l(637,477,2,477,8);
  l(637,477,637,2,8);
  l(3,3,636,3,15);
  l(3,3,3,476,15);
  l(636,476,3,476,8);
  l(636,476,636,3,8);

  l(14,14,625,14,8);
  l(14,14,14,401,8);
  l(625,401,14,401,15);
  l(625,401,625,14,15);
  l(15,15,624,15,15);
  l(15,15,15,400,15);
  l(624,400,15,400,8);
  l(624,400,624,15,8);

  l(14,14,625,14,8);
  l(14,14,14,401,8);
  l(625,401,14,401,15);
  l(625,401,625,14,15);
  l(15,15,624,15,15);
  l(15,15,15,400,15);
  l(624,400,15,400,8);
  l(624,400,624,15,8);

  puttitle;

  quit:=false;
  menu:=0;
end;

procedure initmenus;
begin
  setcolor(0);
  settextjustify(centertext,centertext);
  settextstyle(defaultfont,horizdir,1);
  outtextxy(320,460,'COMPRESS   UNCOMPRESS   SETTINGS   DESTINATION   FILENAMES   HELP   EXIT');
end;

procedure setmenu(m:integer;c:byte);
begin
  setcolor(c);
  settextjustify(centertext,centertext);
  settextstyle(defaultfont,horizdir,1);
  case m of
    0:outtextxy(320,460,'COMPRESS                                                                ');
    1:outtextxy(320,460,'           UNCOMPRESS                                                   ');
    2:outtextxy(320,460,'                        SETTINGS                                        ');
    3:outtextxy(320,460,'                                   DESTINATION                          ');
    4:outtextxy(320,460,'                                                 FILENAMES              ');
    5:outtextxy(320,460,'                                                             HELP       ');
    6:outtextxy(320,460,'                                                                    EXIT');
  end;
  angatan( 30,452, 97,467);
  angatan(118,452,202,467);
  angatan(222,452,289,467);
  angatan(309,452,403,467);
  angatan(421,452,497,467);
  angatan(517,452,555,467);
  angatan(573,452,610,467);
  case m of
    0:lubogan( 30,452, 97,467);
    1:lubogan(118,452,202,467);
    2:lubogan(222,452,289,467);
    3:lubogan(309,452,403,467);
    4:lubogan(421,452,497,467);
    5:lubogan(517,452,555,467);
    6:lubogan(573,452,610,467);
  end;
end;

procedure help;
begin
  setfillstyle(solidfill,7);
  bar(16,16,623,399);
  setcolor(0);
  settextstyle(triplexfont,horizdir,2);
  outtextxy(320,100,'       CONTROL KEYS ASSIGNED FOR THE PLAYERS      ');
  settextstyle(defaultfont,horizdir,1);
  outtextxy(320,130,'  Player 1: Right arrow - turns 90 degrees clockwise        ');
  outtextxy(320,150,'             Left arrow - turns 90 degrees counter-clockwise');
  outtextxy(320,180,'  Player 2:           z - turns 90 degrees clockwise        ');
  outtextxy(320,200,'                      x - turns 90 degrees counter-clockwise');
  outtextxy(320,230,'  Player 3:           , - turns 90 degrees clockwise        ');
  outtextxy(320,250,'                      . - turns 90 degrees counter-clockwise');
  outtextxy(320,280,'  Player 4:           1 - turns 90 degrees clockwise        ');
  outtextxy(320,300,'                      2 - turns 90 degrees counter-clockwise');
  if readkey=#0 then ch:=readkey;
  setfillstyle(solidfill,7);
  bar(16,16,623,399);
  setcolor(0);
  settextstyle(triplexfont,horizdir,2);
  outtextxy(320,100,'RULES OF THE GAME');
  settextstyle(defaultfont,horizdir,1);
  outtextxy(320,130,'* Each player has 5 lives.                                          ');
  outtextxy(320,150,'* A player will lose a life if he bumps to the wall,                ');
  outtextxy(320,170,'  bumps an opponent or bumps himself.                               ');
  outtextxy(320,190,'* he can gain a level higher if he passes along a circular object   ');
  outtextxy(320,210,'* A bonus life will be given every 20 levels.                       ');
  outtextxy(320,230,'* A maximum of 100 levels can be achieve.                           ');
  outtextxy(320,250,'* Pressing p pauses the game.                                       ');
  outtextxy(320,270,'* the speed increases by a factor of 1.2 at a desired amount of time');
  outtextxy(320,290,'* Minimum player is 1 and Maximum players is 4.                     ');
  outtextxy(320,310,'* Player 1 starts from bottom, player 2 from top                    ');
  outtextxy(320,330,'  player 3 from left and player 4 from right.                       ');
  ch:=readkey;
  setfillstyle(solidfill,7);
  bar(16,16,623,399);
  puttitle;
end;

procedure menuhandler;
begin
  if ch in[left,right]then
  begin
    setmenu(menu,0);
    if ch=left then dec(menu)
      else inc(menu);
    menu:=(menu+7)mod 7;
    setmenu(menu,15);
  end;
end;



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
var wcountest,wcount,
    windexest,windex,
    wmaxindex,wmaxindexf,wmaxindexm,
    wncount,
    wmaxcount,
    myword,
    lupos
    :word;
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
  uncom:=usize;
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
    end;                    {maybe temp}
    if (showcompleted)and(lupos+every<upos)then
    begin
      gotoxy(1,23);
      write('Cpos: ',cpos:6,'   upos: ',upos:6);clreol;
      writeln;
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

procedure slidewu(var bufin,bufout);
var cbits:byte;
    usize:word;
    fullok:boolean;
    last0:byte;
begin
  if (myptr(bufin)[0]=4)or(myptr(bufin)[0]=12) then
  repeat
  begin
    last0:=myptr(bufin)[0];
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
  if myptr(bufin)[0]=12 then move(myptr(bufout)[0],myptr(bufin)[0],usize+1);
  until last0=4;
end;{slidewu}



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
  lubogan(399,49,601,60);
  for y:=0 to 9 do
  begin
    setcolor(14);
    line(400,50+y,400+longint(upos)*200 div uncom,50+y);
    setcolor(7);
    line(400+(longint(upos)*200 div uncom)+1,50+y,600,50+y);
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





var
  TmrIntVec : Procedure;
{$F+}
procedure Timetick; interrupt;
var count:byte;
begin
  count:=(count+1)and 7;
  if count=0 then edisplay:=true;
{  sound(longint(upos+1)*1000 div (uncom+1));}
{  delay(1);
  nosound;}
  inline ($9C);
  TmrIntVec;
end;
{$F-}

procedure inittimer;
begin
  GetIntVec($8,@TmrIntVec);
  SetIntVec($8,Addr(Timetick));
end;

procedure uninit;
begin
  SetIntVec($8,@TmrIntVec);
  nosound;
end;



var
  f,fc          :file;
  dinfo         :searchrec;
  pu,pc         :pointer;
  totalfiles    :word;
  fpos          :longint;

procedure maximum(insize:word);
var lcs,lsize:word;
begin
  compresssize:=insize;
  repeat
    lsize:=compresssize;
    bc:=4;
    slidewc2(pu^,pc^,lsize,bc);
    repeat
      inc(bc);
      lcs:=compresssize;
      slidewc2(pu^,pc^,lsize,bc);
      if(compresssize>=lcs)then dec(bc);
    until(compresssize>=lcs)or(bc>=12);
    if bc=4 then
    repeat
      dec(bc);
      lcs:=compresssize;
      slidewc2(pu^,pc^,lsize,bc);
      if(compresssize>=lcs)then inc(bc);
    until(compresssize>=lcs)or(bc<=1);
    slidewc2(pu^,pc^,lsize,bc);
    inc(pass);
    if compresssize<lsize then
    begin
      move(pc^,pu^,compresssize);
{      lsize:=compresssize;}
    end;
  until(compresssize>=lsize){and(compresssize>lsize)};
  if pass>1 then
  begin
    compresssize:=lsize;
    move(pu^,pc^,lsize);
  end;
end;

procedure performcomp;
begin
  Assign(f,dinfo.name);
  reset(f,1);
  if dinfo.size<=64000 then
  begin
    blockread(f,pu^,dinfo.size);
    pass:=0;
    if compmode=0 then slidewc2(pu^,pc^,dinfo.size,bc)
                  else maximum(dinfo.size);
    blockwrite(fc,pc^,compresssize);
    close(f)
  end else
  begin
    repeat
      blockread(f,pu^,64000);
      pass:=0;
      if compmode=0 then slidewc2(pu^,pc^,64000,bc)
                    else maximum(64000);
      blockwrite(fc,pc^,compresssize);
      fpos:=filepos(f);
    until (dinfo.size-fpos)<64000;
    if fpos<dinfo.size then
    begin
      blockread(f,pu^,Dinfo.size-fpos);
      pass:=0;
      if compmode=0 then slidewc2(pu^,pc^,dinfo.size-fpos,bc)
                    else maximum(dinfo.size-fpos);
      blockwrite(fc,pc^,compresssize);
    end;
    close(f);
  end;
end;

procedure compress;
begin
  getmem(pu,65000);
  getmem(pc,65500);
  assign(fc,destined);
  rewrite(fc,1);
  seek(fc,2);
  totalfiles:=0;
  FindFirst(filename,Archive,Dinfo);
  while doserror=0 do
  begin
    if dinfo.name<>destined then
    begin
      settextjustify(lefttext,centertext);
      settextstyle(defaultfont,horizdir,1);
      setcolor(0);
      outtextxy(500,440,dinfo.name);

      blockwrite(fc,dinfo.name[0],1);
      blockwrite(fc,dinfo.name[1],integer(dinfo.name[0]));
      blockwrite(fc,dinfo.time,4);
      blockwrite(fc,dinfo.size,4);
      inc(totalfiles);

      if (dinfo.size>0)then performcomp;

      setcolor(7);
      outtextxy(500,440,dinfo.name);
    end;
    findnext(dinfo);
  end;
  seek(fc,0);
  blockwrite(fc,totalfiles,2);
  close(fc);
  freemem(pc,65500);
  freemem(pu,64000);
end;

procedure uncompress;
var n:word;
    lpos,accusize:longint;
    us,cs:word;
begin
  getmem(pu,64000);
  getmem(pc,65500);
  assign(fc,destined);
  reset(fc,1);
  blockread(fc,totalfiles,2);
  for n:=1 to totalfiles do
  begin
    blockread(fc,dinfo.name[0],1);
    blockread(fc,dinfo.name[1],integer(dinfo.name[0]));
    blockread(fc,dinfo.time,4);
    blockread(fc,dinfo.size,4);
    if dinfo.size=0 then
    begin
      assign(f,dinfo.name);
      rewrite(f,1);
      close(f);
      reset(f,1);
      setftime(f,dinfo.time);
      close(f);
    end else
    begin
      assign(f,dinfo.name);
      rewrite(f,1);
      lpos:=filepos(fc);
      blockread(fc,pc^,1);
      blockread(fc,us,2);inc(us);
      blockread(fc,cs,2);
      seek(fc,lpos);
      blockread(fc,pc^,cs);
      if dinfo.size<=64000 then
      begin
        slidewu(pc^,pu^);
        blockwrite(f,pu^,us);
        close(f);
      end else
      begin
        accusize:=0;
        repeat
          slidewu(pc^,pu^);
          blockwrite(f,pu^,us);
          accusize:=accusize+us;
          if accusize<dinfo.size then
          begin
            lpos:=filepos(fc);
            blockread(fc,pc^,1);
            blockread(fc,us,2);inc(us);
            blockread(fc,cs,2);
            seek(fc,lpos);
            blockread(fc,pc^,cs);
          end;
        until accusize=dinfo.size;
        close(f);
        reset(f,1);
        setftime(f,dinfo.time);
        close(f);
      end;
    end;
  end;
  close(fc);
  freemem(pc,65500);
  freemem(pu,64000);
end;

procedure settings;
begin
  setfillstyle(solidfill,7);
  bar(16,16,623,399);
  setcolor(0);
  settextstyle(Triplexfont,horizdir,2);
  outtextxy(320,130,'COMPRESSION SETTINGS');
  outtextxy(320,160,'1 NORMAL MODE ');
  outtextxy(320,190,'2 MAXIMUM MODE');
  setcolor(15);
  outtextxy(320,160,'     1                    ');
  outtextxy(320,190,'2                ');
  repeat
    ch:=readkey;
  until ch in[#27,'1','2'];
  if ch<>#27 then compmode:=ord(ch)-byte('1');
  bar(16,16,623,399);
  puttitle;
end;

function getstring(ss:string;x,y:word):string;
var s:string;
begin
  s:=ss;
  settextjustify(lefttext,centertext);
  settextstyle(defaultfont,horizdir,1);
  setcolor(0);
  outtextxy(x,y,s);
  repeat
    if ch=#0 then ch:=readkey;
    ch:=readkey;
    if (ch>=#32)and(ch<=#122)and(ch<>' ')then
    begin
      s[byte(s[0])+1]:=upcase(ch);
      inc(s[0]);
      setcolor(0);
      outtextxy(x,y,s);
    end else
    if(ch=#8)and(s[0]>#0)then
    begin
      setcolor(7);
      outtextxy(x,y,s);
      dec(s[0]);
      setcolor(0);
      outtextxy(x,y,s);
    end;
  until(ch=#27)or(ch=#13);
  setcolor(7);
  outtextxy(x,y,s);
  getstring:=s;
end;

procedure destination;
begin
  destined:=getstring(destined,10,410);
end;

procedure filenames;
begin
  filename:=getstring(filename,10,440);
end;


const auto:boolean=false;
begin
  inittimer;
  checkbreak:=true;
  initialize;
  if (paramcount>0) then
  begin
    auto:=true;
    ch:=#13;
    if paramstr(1)='c'then menu:=0
      else if paramstr(1)='u'then menu:=1;
  end;
  if paramcount>1 then destined:=paramstr(2);
  if paramcount>2 then filename:=paramstr(3);
  if paramcount>3 then val(paramstr(4),bc,code);
  initmenus;
  setmenu(menu,15);
  repeat
    if not(auto)then ch:=readkey;
    case ch of
      #00:begin
            ch:=readkey;
            case ch of
              #45:quit:=true;
            end;
            menuhandler;
         end;
      #13:begin
            case menu of
              0:compress;
              1:uncompress;
              2:settings;
              3:destination;
              4:filenames;
              5:help;
              6:quit:=true;
            end;
          end;
      '1'..'9':bc:=ord(ch)-ord('0');
    end;
  until quit or auto;
  boxin;
  closegraph;
  writeln('Thanks for using my data compression program.  Have a nice day!');
  uninit;
end.