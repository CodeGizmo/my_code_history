const
  wregg:array[0..15]of char='AXCXDXBXSPBPSIDI';
  bregg:array[0..15]of char='ALCLDLBLAHCHDHBH';
  mregp:array[0..7]of byte=(0,6,12,18,24,27,30,33);
  mregl:array[0..7]of byte=(6,6,6,6,3,3,3,3);
  mregg:array[0..35]of char='[BX+SI'+
                          '[BX+DI'+
                          '[BP+SI'+
                          '[BP+DI'+
                          '[SI'+
                          '[DI'+
                          '[BP'+
                          '[BX';
  sregg:array[0..7]of char='ESCSSSDS';
  df  :word=$80;
  wf  :word=$40;
  modf:word=$20;
  regf:word=$10;
  rmf :word=8;
  immf:word=4;
  ef  :word=2;
  sf  :word=1;
var
  wreg:array[0..15]of byte absolute wregg;
  breg:array[0..15]of byte absolute bregg;
  mreg:array[0..7]of byte absolute mregg;
  sreg:array[0..7]of byte absolute sregg;
  disp, data,
  flags:word;
  modd, reg, rm, sr:byte;
procedure writeregs(w:boolean;reg:byte);
begin
  if w then
  begin
    myptr(bufasm^)[index]:=wreg[reg shl 1];
    myptr(bufasm^)[index+1]:=wreg[(reg shl 1)+1];
  end else
  begin
    myptr(bufasm^)[index]:=breg[reg shl 1];
    myptr(bufasm^)[index+1]:=breg[(reg shl 1)+1];
  end;
  inc(index,2);
end;

procedure writemreg(modd,reg:byte);
var dd:byte;
begin
  for dd:=0 to mregl[reg]-1 do
    myptr(bufasm^)[index+dd]:=mreg[mregp[reg]+dd];
  inc(index,mregl[reg]);
  if modd=1 then
  begin
    myptr(bufasm^)[index]:=byte('+');
    inc(index);
    writeb(disp);
  end else if modd=2 then
  begin
    myptr(bufasm^)[index]:=byte('+');
    inc(index);
    writew(disp);
  end;
  myptr(bufasm^)[index]:=byte(']');
  inc(index);
end;