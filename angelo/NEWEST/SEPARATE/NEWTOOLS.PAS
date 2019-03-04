program ewan;
uses crt,dos;
const
  up=#72;
  down=#80;
  right=#77;
  left=#75;
  pgup=#73;
  pgdn=#81;
  home=#71;
  last=#79;

var
  quit                                  :boolean;
  ch                                    :char;
  p                                     :pointer;
  lastsector,lasttrack                  :integer;
  a,b,c,d,e,g,h,i,j,k,l,
  bufseg,bufofs                         :word;
  head,sector,track,No_of_sectors,drive :integer;
  regs                                  :registers;

procedure showsector;
begin
  c:=0;
  d:=(sector-1)*512;
  for a:=1 to 23 do
    for b:=0 to 21 do
    begin
      mem[$b800:a*160+117+b*2]:=$1e;
      mem[$b800:a*160+116+b*2]:=mem[bufseg:bufofs+c+d];
      inc(c);
    end;
  for a:=0 to 5 do
  begin
    mem[$b800:3957+a*2]:=$1e;
    mem[$b800:3956+a*2]:=mem[bufseg:bufofs+c+d];
    inc(c);
  end;
  textcolor(yellow);
  gotoxy(59,1);write('track=',track,' sec=',sector,' head=',head,'  ');
end;

procedure readsector;
begin
  regs.es:=bufseg;
  regs.bx:=bufofs;
  regs.ah:=$02;
  regs.al:=No_of_sectors;
  regs.dl:=drive;
  regs.ch:=track;
  regs.cl:=sector;
  regs.dh:=head;
  intr($13,regs);
  showsector;
end;

procedure writesector;
begin
  regs.es:=bufseg;
  regs.bx:=bufofs;
  regs.ah:=$03;
  regs.al:=No_of_sectors;
  regs.ch:=track;
  regs.cl:=sector;
  regs.dh:=head;
  regs.dl:=drive;
  intr($13,regs);
  showsector;
end;

procedure clearsector;
begin
  for a:=0 to 512 do
    memw[$b800:4000+a]:=0;
end;

{procedure format(shead,lhead,strack,ltrack:byte);
begin
  for e:=strack to ltrack do
  begin
    for d:=shead to lhead do
    begin
      regs.ah:=$18;
      regs.ch:=No_of_tracks;
      regs.cl:=No_of_sectors;
      regs.dl:=drive;
      intr($13,regs);
      for b:=1 to 16 do
      begin
        fa[b,1]:=e;
        fa[b,2]:=d;
        fa[b,3]:=b;
        fa[b,4]:=2;
      end;
      regs.ah:=$5;
      regs.al:=10;
      regs.dh:=d;
      regs.dl:=drive;
      regs.ch:=e;
      regs.cl:=0;
      regs.es:=$ba00;
      regs.bx:=0;
      intr($13,regs);

      regs.ah:=$3;
      regs.al:=15;
      regs.ch:=e;
      regs.cl:=1;
      regs.dh:=d;
      regs.dl:=drive;
      regs.es:=$ba00;
      regs.bx:=$0;
      intr($13,regs);
      gotoxy(1,1);
      writeln(d,' ',e,'   ');
    end;
  end;
end;

procedure formatdisk;
begin
  format(0,1,0,82);
  clearsector;
  loc[0]:=235;loc[2]:=144;
  loc[$b]:=0;loc[$c]:=2;
  loc[$d]:=2;
  loc[$e]:=1;loc[$f]:=0;
  loc[$10]:=2;
  loc[$11]:=112;loc[$12]:=0;
  loc[$13]:=2400 mod 256;loc[$14]:=2400 div 256;
  loc[$15]:=253;
  loc[$16]:=2;loc[$17]:=0;
  loc[$18]:=15;loc[$19]:=0;
  loc[$1a]:=2;loc[$1b]:=0;
  loc[$1c]:=0;loc[$1d]:=0;
  sector:=1;
  track:=0;
  head:=0;
  writesector;
  sector:=2;
  clearsector;
  loc[0]:=253;
  writesector;
  sector:=4;
  clearsector;
  loc[0]:=253;
  writesector;
  sector:=1;
end;             }

procedure nextsector;
begin
  inc(sector);
  if sector>lastsector then
  begin
    sector:=1;
    inc(head);
    if head>1 then
    begin
      head:=0;
      inc(track);
{      readsector;}
    end;
  end;
  readsector;
end;

procedure prevsector;
begin
  dec(sector);
  if sector<1 then
  begin
    sector:=lastsector;
    dec(head);
    if head<0 then
    begin
      head:=1;
      if track>0 then
      begin
        dec(track);
{        readsector;}
      end else
      begin
        sector:=1;
        head:=0;
      end;
    end;
  end;
  readsector;
end;

procedure getcommand;
begin
  ch:=readkey;
  if ch=#0 then
  begin
    ch:=readkey;
    case ch of
      #45:quit:=true;
      up:;
      down:;
      right:;
      left:;
      pgup:nextsector;
      pgdn:prevsector;
      home:;
      last:;
    end;
  end else
  begin
  end;
end;

procedure initialize;
begin
  quit:=false;
  getmem(p,65535);
  bufseg:=seg(p^);
  bufofs:=ofs(p^);
  drive:=1;
  head:=0;
  track:=0;
  sector:=1;
  no_of_sectors:=1;
  lastsector:=18;
  lasttrack:=80;
end;

(*var
  f:file;
begin
  repeat
  until keypressed;
  initialize;
  assign(f,'d:\disk');
  rewrite(f,1);
  for track:=0 to 79 do
    for head:=0 to 1 do
      for sector:=1 to 18 do
      begin
        readsector;
{        showsector;}
        blockwrite(f,p^,512);
      end;
  close(f);
  repeat
    Writeln('ABOUT TO COPY');
  until keypressed and(readkey=#13);
  reset(f,1);
  for track:=79 downto 0 do
    for head:=0 to 1 do
      for sector:=1 to 18 do
      begin
        blockread(f,p^,512);
{        showsector;}
        writesector;
      end;
  close(f);
end.*)

begin
  initialize;
  readsector;
  repeat
    getcommand;
    showsector;
  until quit;
end.






























