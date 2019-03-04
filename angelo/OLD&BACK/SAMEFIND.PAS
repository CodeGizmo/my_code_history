uses vgaliz;
var
  t:word;
  p1,p2:pointer;
  pseg1,pseg2,pos,pos1:word;
  xx:word;

procedure loadthis(fn:string);
begin
  getmem(p1,65535);
  getmem(p2,65535);
  pseg1:=seg(p1^);
  pseg2:=seg(p2^);
  pos:=0;
  pos1:=0;
  aload(fn,p2^);
  uncompress(p2^,p1^);
end;

procedure lookatsames;
begin
  for xx:=0 to 65535 do
  begin
    mem[$b800:0]:=xx shr 8;
    mem[$b800:2]:=xx and $ff;
    mem[pseg2:xx]:=0;
  end;
  repeat
    t:=0;
    while(mem[pseg1:pos]=mem[pseg1:pos+1])and(pos<65534)do
    begin
      inc(t);
      inc(pos);
      mem[$b800:0]:=pos shr 8;
      mem[$b800:2]:=pos and $ff;
    end;
    inc(t);
    inc(pos);
    mem[$b800:0]:=pos shr 8;
    mem[$b800:2]:=pos and $ff;
    if t=1 then inc(pos1)else inc(mem[pseg2:t]);
  until pos>65534;
  t:=1;
  writeln(1:6,pos1:6);
  for xx:=2 to 65535 do
  begin
    if t=23 then begin t:=1;readln;end;
    if mem[pseg2:xx]>0 then
    begin
      writeln(xx:6,mem[pseg2:xx]:6);
      inc(t);
    end;
  end;
  readln;
end;{lookatsames}

procedure lookatdisp;
begin
  for xx:=0 to 65535 do
  begin
    mem[$b800:0]:=xx shr 8;
    mem[$b800:2]:=xx and $ff;
    mem[pseg2:xx]:=0;
  end;
  pos:=0;
  repeat
    inc(memw[pseg2:mem[pseg1:pos]shl 1]);
    inc(pos)
  until pos>=65535;
  t:=1;
  writeln(1:6,pos1:6);
  for xx:=0 to 255 do
  begin
    if t=23 then begin t:=1;readln;end;
    writeln(xx:6,memw[pseg2:xx shl 1]:6);
    inc(t);
  end;
  readln;
end;{lookatdisp}

begin
  loadthis('newbunny.liz');
  lookatsames;
  lookatdisp;
end.