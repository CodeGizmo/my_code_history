uses dos,crt{,vgayey};
var
  ch:char;
  sector,track,head,bps:shortint;
  regs:registers;
  myoffset,mysegment:word;
  p:pointer;
  params:array[0..50,0..3]of byte;
  feedback:byte;
  fa:array[1..16,1..4]of byte absolute $9a00:0;
  a,b,c,x,y,z:word;

procedure verify(sector,head,track:byte);
begin
  regs.ah:=3;
  regs.al:=1;  {no. of sectors}
  regs.ch:=track;
  regs.cl:=sector;
  regs.dh:=head;
  regs.dl:=0;  {drive}
  intr($13,regs);
  feedback:=regs.ah;
end;{verify}

procedure readsector(sector,head,track:byte);
begin
  regs.ah:=2;
  regs.al:=1;  {no. of sectors}
  regs.ch:=track;
  regs.cl:=sector;
  regs.dh:=head;
  regs.dl:=0;  {drive}
  regs.bx:=myoffset;
  regs.es:=mysegment;
  intr($13,regs);
  verify(sector,head,track);
end;{readsector}

procedure writesector(sector,head,track:byte);
begin
  regs.ah:=3;
  regs.al:=1;  {no. of sectors}
  regs.ch:=track;
  regs.cl:=sector;
  regs.dh:=head;
  regs.dl:=0;  {drive}
  regs.bx:=myoffset;
  regs.es:=mysegment;
  intr($13,regs);
end;{writesector}

procedure format(head,track:byte);
begin
  regs.ah:=$18;
  regs.ch:=80;
  regs.cl:=15;
  regs.dl:=0;
  intr($13,regs);

  for b:=1 to 16 do
  begin
    fa[b,1]:=track;
    fa[b,2]:=head;
    fa[b,3]:=b;
    fa[b,4]:=2;
  end;

  regs.ah:=$5;
  regs.al:=10;
  regs.dh:=head;
  regs.dl:=0;
  regs.ch:=track;
  regs.cl:=0;
  regs.es:=$9a00;
  regs.bx:=0;
  intr($13,regs);

  for a:=0 to 15 do
  begin
    for x:=0 to 511 do
    begin
      mem[mysegment:myoffset+x]:=a+$30;
    end;
    writesector(a,head,track);
  end;
end;

var lo:byte;
function hi(bytes:byte):byte;
begin
  lo:=bytes and $f;
  bytes:=bytes shr 4;
  if bytes>9 then hi:=bytes+$37 else hi:=bytes+$30;
  if lo>9 then lo:=lo+$37 else lo:=lo+$30;
end;{byteto2bytehex}

var dummyb1,dummyb2:byte;
procedure showsector;
begin
  for b:=0 to 22 do
    for a:=0 to 21 do
    begin
      dummyb1:=mem[mysegment:myoffset+b*22+a];
      mem[$b800:160+b*160+a*2+116]:=dummyb1;
      mem[$b800:b*160+a shl 2+160+a div 2 shl 1]:=hi(dummyb1);
      mem[$b800:b*160+a shl 2+162+a div 2 shl 1]:=lo;
    end;
  for a:=0 to 5 do
      mem[$b800:a*2+3956]:=mem[mysegment:myoffset+505+a];
  gotoxy(59,1);write('sector',sector:2,',head',head,',track',track:2);
  gotoxy(50,1);write(feedback:3);
end;{showsector}

procedure mygoto;
begin
  gotoxy(1,1);write('sector:');read(sector);
  gotoxy(1,1);write('head:');read(head);
  gotoxy(1,1);write('track:');read(track);
end;{mygoto}

procedure obeykey;
begin
  ch:=readkey;
  case ch of
    'w':inc(sector);
    'q':begin dec(sector);if sector=0 then sector:=1;end;
    's':begin inc(head);if head=2 then head:=0;end;
    'x':inc(track);
    'z':begin dec(track);if track<0 then track:=0;end;
    'G':mygoto;
    'F':format(0,39);
    '+':begin
          inc(sector);
          if sector>15 then
          begin
            inc(head);
            if head>1 then
            begin
              inc(track);
              head:=0;
            end;
            sector:=1;
          end;
        end;
    '-':begin
          dec(sector);
          if sector<1 then
          begin
            dec(head);
            if head<0 then
            begin
              dec(track);
              head:=1;
            end;
            sector:=15;
          end;
          if track<0 then begin track:=0;head:=0;sector:=1;end;
        end;
  end;
end;{obeykey}

procedure initialize;
begin
  clrscr;
  getmem(p,32768);
  myoffset:=ofs(p^);
  mysegment:=seg(p^);
  sector:=1;
  head:=0;
  track:=0;
end;{initialize}

begin
  initialize;
  for dummyb1:=0 to 79 do
    mem[$b800:dummyb1*2]:=dummyb1;
  repeat
    readsector(sector,head,track);
    showsector;
    obeykey;
  until ch=#27;
  freemem(p,32768);
end.