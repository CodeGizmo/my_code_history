uses dos,crt;
var
  ch:char;
  regs:registers;
  sector,track,head:shortint;
  a,b,c,d,e,f:integer;
  loc:array[0..511]of byte absolute $b800:4000;
  fi:file;
  filename:string;
  fa:array[1..16,1..4]of byte absolute $ba00:0;
  table:array[0..10]of byte absolute 0:$78;

procedure save(filename:string);
begin
  assign(fi,filename);
  rewrite(fi);
  blockwrite(fi,ptr($b800,4000)^,4);
  close(fi);
end;{bsave}

procedure savesector;
begin
  gotoxy(1,1);write('Filename: ');
  read(filename);
  save(filename);
end;

procedure showsector;
begin
  c:=0;
  for a:=1 to 23 do
    for b:=0 to 21 do
    begin
      mem[$b800:a*160+117+b*2]:=$1e;
      mem[$b800:a*160+116+b*2]:=mem[$b800:4000+c];
      inc(c);
    end;
  for a:=0 to 5 do
  begin
    mem[$b800:3957+a*2]:=$1e;
    mem[$b800:3956+a*2]:=mem[$b800:4000+c];
    inc(c);
  end;
  textcolor(yellow);
  gotoxy(59,1);write('track=',track,' sec=',sector,' head=',head,'  ');
end;

procedure readsector;
begin
  regs.es:=$b800;
  regs.bx:=4000;
  regs.ah:=$02;
  regs.al:=$01;
  regs.dl:=0;
  regs.ch:=track;
  regs.cl:=sector;
  regs.dh:=head;
  regs.dl:=0;
  intr($13,regs);
  showsector;
end;

procedure writesector;
begin
  regs.es:=$b800;
  regs.bx:=4000;
  regs.ah:=$03;
  regs.al:=$1;
  regs.ch:=track;
  regs.cl:=sector;
  regs.dh:=head;
  regs.dl:=0;
  intr($13,regs);
  showsector;
end;

procedure clearsector;
begin
  for a:=0 to 512 do
    memw[$b800:4000+a]:=0;
end;

procedure format(shead,lhead,strack,ltrack:byte);
begin
  for e:=strack to ltrack do
  begin
    for d:=shead to lhead do
    begin
      regs.ah:=$18;
      regs.ch:=80;
      regs.cl:=15;
      regs.dl:=0;
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
      regs.dl:=0;
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
      regs.dl:=0;
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
end;

procedure expand;
begin
  head:=0;
  sector:=1;
  track:=0;
  readsector;
  loc[$13]:=774 mod 256;
  loc[$14]:=774 div 256;
  writesector;
  format(0,1,40,42);
  gotoxy(1,1);write('No. of bytes/sector ',loc[$b]+loc[$c]*256);
  gotoxy(1,2);write('No. of sectors per cluster ',loc[$d]);
  gotoxy(1,3);write('No. of sectors in reserved area ',loc[$e]+loc[$f]*256);
  gotoxy(1,4);write('No. of copies of FAT ',loc[$10]);
  gotoxy(1,5);write('No. of root directory entry ',loc[$11]+loc[$12]*256);
  gotoxy(1,6);write('Total No. of sectors ',loc[$13]+loc[$14]*256);
  gotoxy(1,7);write('DOS media descriptor ',loc[$15]);
  gotoxy(1,8);write('Number of sectors/FAT ',loc[$16]+loc[$17]*256);
  gotoxy(1,9);write('Number of sectors/track ',loc[$18]+loc[$19]*256);
  gotoxy(1,10);write('Number of heads ',loc[$1a]+loc[$1b]*256);
  gotoxy(1,11);write('Number of hidden sectors ',loc[$1c]+loc[$1d]*256);
end;

begin
  for a:=0 to $7fff do
  mem[$b800:a]:=0;
  table[0]:=34;
  table[1]:=5;
  table[2]:=0;
  table[3]:=0;
  table[4]:=0;
  table[5]:=0;
  table[6]:=0;
  table[7]:=240;
  table[8]:=108;
  table[9]:=19;
  table[10]:=245;
  clrscr;
  sector:=1;
  track:=0;
  head:=0;
  repeat
    ch:=readkey;
    case ch of
      'q':begin inc(track);readsector end;
      'w':begin dec(track);if track<0 then track:=0;readsector end;
      'a':begin inc(sector);readsector end;
      's':begin dec(sector);readsector end;
      '\':begin if head=0 then head:=1 else head:=0 end;
      'D':begin
            for d:=0 to 1 do
              for e:=0 to 41 do
                for f:=1 to 9 do
                begin
                  sector:=f;
                  track:=e;
                  head:=d;
                  readsector;
                  writesector;
                end;
          end;
      'B':begin
            loc[0]:=$fd;
            loc[1]:=$b8;loc[2]:=$00;loc[3]:=$b8;
            loc[4]:=$8e;loc[5]:=$d8;
            loc[6]:=$8e;loc[7]:=$c0;
            loc[8]:=$be;loc[9]:=$9e;loc[10]:=$0f;
            loc[11]:=$bf;loc[12]:=$a0;loc[13]:=$0f;
            loc[14]:=$b9;loc[15]:=$d0;loc[16]:=$07;
            loc[17]:=$f3;loc[18]:=$a5;
            loc[19]:=$e2;loc[20]:=$f3;
            writesector;
          end;
      'S':savesector;
      'F':begin write('Are you sure?');readln(ch);if ch='y' then formatdisk end;
      '=':writesector;
      'E':expand;
      'p':begin loc[0]:=ord('p');writesector end;
      'o':begin loc[0]:=ord('o');writesector end;
    end;
    readsector;
  until ch=#27;
end.



