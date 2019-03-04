const
  wregg:array[0..15]of char='axcxdxbxspbpsidi';
  bregg:array[0..15]of char='alcldlblahchdhbh';
  mregp:array[0..7]of byte=(0,6,12,18,24,27,30,33);
  mregl:array[0..7]of byte=(6,6,6,6,3,3,3,3);
  mregg:array[0..35]of char='[bx+si'+
                          '[bx+di'+
                          '[bp+si'+
                          '[bp+di'+
                          '[si'+
                          '[di'+
                          '[bp'+
                          '[bx';
  sregg:array[0..7]of char='escsssds';
var
  wreg:array[0..15]of byte absolute wregg;
  breg:array[0..15]of byte absolute bregg;
  mreg:array[0..35]of byte absolute mregg;
  sreg:array[0..7]of byte absolute sregg;
  disp, data,
  flags:word;

const
  level2:array[0..133]of byte=(2,1,10,10,10,10,10,{)}
                               1,4,5,
  {0-nothing}                  1,4,5,
  {1-with3}
  {2-with reg}                 2,0,
  {3-immediate only}           0,0,
  {4-register only}            0,0,0,2,2,2,0,0,0,0,
  {5-segment register}         2,1,3,
  {6-ip-inc8}                  2,1,3,
  {7-ip-inc16}                 1,4,0,0,
  {10-special mov}
                               2,1,3,
                               2,1,3,
                               1,4,1,
                               2,1,3,0,0,1,1,0,1,1,0,0,0,
                               1,1,1,1,1,1,1,1,

                               2,1,3,
                               2,1,3,
                               2,1,3,
                               2,1,3,
                               0,0,0,0,0,0,

                               7,1,0,1,
                               7,6,1,0,1,
                               0,0,0,0,6,6,6,6,6,6,
                                 6,6,6,6,6,6,6,6,6,6,
                                 6,6,6,6,

                               0,0,0,0,
                               0,0,0,0,0,0,0,0,0,0,0,5
                            {(});
  tabledef3:array[0..133]of byte=(2,$0,0,0,0,0,0,{)}
                                  $6,0,0,
                                  $0,0,0,

                                  2,0,
                                  0,0,
                                  0,0,0,2,2,2,0,0,0,0,
                                  2,$0,0,
                                  2,$2,0,
                                  $0,0,0,0,

                                  2,$5,0,
                                  2,$3,0,
                                  $1,0,$3,
                                  2,$7,0,0,0,$4,$5,0,$6,$7,0,0,0,
                                  $2,$4,$5,$7,$0,$1,$2,$3,

                                  2,$4,0,
                                  2,$0,0,
                                  2,$1,0,
                                  2,$6,0,
                                  0,0,0,0,0,0,

                                  0,$2,0,$3,
                                  0,0,$4,0,$5,
                                  0,0,0,0,0,0,0,0,0,0,
                                    0,0,0,0,0,0,0,0,0,0,
                                    0,0,0,0,

                                  0,0,0,0,
                                  0,0,0,0,0,0,0,0,0,0,0,0
                               {(});
  immf  :array[0..133]of byte=(4,3,0,0,0,0,0,{)}
                               1,0,0,
                               1,0,0,
  {3-immediate present}
  {4-direction present}        2,0,
                               0,0,
                               0,0,0,2,2,2,0,0,0,0,
                               4,3,0,
                               4,3,0,
                               1,0,0,0,

                               4,3,0,
                               4,3,0,
                               1,0,1,
                               4,3,0,0,0,1,1,0,1,1,0,0,0,
                               1,1,1,1,1,1,1,1,

                               4,3,0,
                               2,3,0,
                               4,3,0,
                               4,3,0,
                               0,0,0,0,0,0,

                               0,1,0,1,
                               0,0,1,0,1,
                               0,0,0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,0,0,
                                 0,0,0,0,

                               0,0,0,0,
                               0,0,0,0,0,0,0,0,0,0,0,0
                            {(});

  wf    :array[0..133]of byte=(5,5,0,5,5,0,0,{)}
  {5-maybe word or byte}       1,0,0,
                               1,0,0,

                               5,0,
                               5,5,
                               5,5,0,2,2,2,0,0,0,0,
                               5,5,5,
                               5,5,5,
                               5,0,0,0,

                               5,5,5,
                               5,5,5,
                               5,0,5,
                               5,5,5,0,0,5,5,0,5,5,0,0,0,
                               5,5,5,5,5,5,5,5,

                               5,5,5,
                               5,5,5,
                               5,5,5,
                               5,5,5,
                               0,5,5,5,5,5,

                               0,1,0,1,
                               0,0,1,0,1,
                               0,0,0,0,0,0,0,0,0,0,
                                 0,0,0,0,0,0,0,0,0,0,
                                 0,0,0,0,

                               0,0,0,0,
                               0,0,0,0,0,0,0,0,0,0,0,0
                            {(});
var
  with3,withreg:boolean;
  segreg,
  opcode2,mode,reg,rm:byte;
  segf,
  wordf,direction:boolean;

procedure writerm;
begin
  if mode=3 then
  begin
    if wordf then
    begin
      myptr(bufasm^)[index]:=wreg[rm shl 1];
      myptr(bufasm^)[index+1]:=wreg[(rm shl 1)+1];
    end else
    begin
      myptr(bufasm^)[index]:=breg[rm shl 1];
      myptr(bufasm^)[index+1]:=breg[(rm shl 1)+1];
    end;
    inc(index,2);
  end else if mode=0 then
  begin
    if segf then
    begin
      myptr(bufasm^)[index]:=sreg[segreg shl 1];
      myptr(bufasm^)[index+1]:=sreg[(segreg shl 1)+1];
      myptr(bufasm^)[index+2]:=byte(':');
      inc(index,3);
    end;
    if rm=6 then
    begin
      myptr(bufasm^)[index]:=byte('[');
      inc(index);
      writew(myptr(bufmachine^)[pc]+myptr(bufmachine^)[pc+1]shl 8);
      myptr(bufasm^)[index]:=byte(']');
      inc(index);
      inc(pc,2);
    end else
    begin
      for d1:=0 to mregl[rm]-1 do
      begin
        myptr(bufasm^)[index+d1]:=mreg[mregp[rm]+d1];
      end;
      inc(index,mregl[rm]);
      myptr(bufasm^)[index]:=byte(']');
      inc(index);
    end;
  end else
  begin
    if segf then
    begin
      myptr(bufasm^)[index]:=sreg[segreg shl 1];
      myptr(bufasm^)[index+1]:=sreg[(segreg shl 1)+1];
      myptr(bufasm^)[index+2]:=byte(':');
      inc(index,3);
    end;
    for d1:=0 to mregl[rm]-1 do
    begin
      myptr(bufasm^)[index+d1]:=mreg[mregp[rm]+d1];
    end;
    inc(index,mregl[rm]);
    myptr(bufasm^)[index]:=byte('+');
    inc(index);
    if mode=2 then
    begin
      writew(myptr(bufmachine^)[pc]+myptr(bufmachine^)[pc+1]shl 8);
      myptr(bufasm^)[index]:=byte(']');
      inc(index);
      inc(pc,2);
    end else
    begin
      writeb(myptr(bufmachine^)[pc]);
      myptr(bufasm^)[index]:=byte(']');
      inc(index);
      inc(pc);
    end;
  end;
end;

procedure writeimm;
begin
  if wordf then
  begin
    writew(myptr(bufmachine^)[pc]+myptr(bufmachine^)[pc+1]shl 8);
    inc(pc,2);
  end else
  begin
    writeb(myptr(bufmachine^)[pc]);
    inc(pc);
  end;
end;

procedure writereg;
begin
  if not(direction) then
  begin
    writerm;
    myptr(bufasm^)[index]:=byte(',');
    inc(index);
  end;
  if wordf then
  begin
    myptr(bufasm^)[index]:=wreg[reg shl 1];
    myptr(bufasm^)[index+1]:=wreg[(reg shl 1)+1];
  end else
  begin
    myptr(bufasm^)[index]:=breg[reg shl 1];
    myptr(bufasm^)[index+1]:=breg[(reg shl 1)+1];
  end;
  inc(index,2);
  if direction then
  begin
    myptr(bufasm^)[index]:=byte(',');
    inc(index);
    writerm;
  end;
end;

procedure segsingit;
begin
  if segf then
  begin
    myptr(bufasm^)[index]:=sreg[segreg shl 1];
    myptr(bufasm^)[index+1]:=sreg[(segreg shl 1)+1];
    myptr(bufasm^)[index+2]:=byte(':');
    inc(index,3);
    CR;
    if withpc then
    begin
      dec(pc);
      writepc;
      inc(pc);
    end;
    if withopcode then
    begin
      writeb(opcode);
      space(1);
    end;
  end;
end;

procedure FindMatch;
var op2ok:boolean;
begin
  nomatch:=true;
  op2ok:=true;
  while (tcounter<maxtcount)and(nomatch)do
  begin
    if tabledef[tcounter]=(opcode and tabledef[tcounter+1])then
    begin
      with3:=level2[tcounter shr 1]=1;
      if with3 then
      begin
        if op2ok then
        begin
          op2ok:=false;
          opcode2:=myptr(bufmachine^)[pc];
          mode:=(opcode2 shr 6)and 3;
          reg:=(opcode2 shr 3)and 7;
          rm:=opcode2 and 7;
          wordf:=(opcode and 1)=1;
        end;
        if tabledef3[tcounter shr 1]=reg then nomatch:=false
        else inc(tcounter,2);
      end else nomatch:=false;
    end else inc(tcounter,2);
  end;
end;{FindMatch}

procedure disasm;
begin
  if withpc then writepc;
  opcode:=myptr(bufmachine^)[pc];
  inc(pc);
  if withopcode then begin writeb(opcode);space(1);end;
  tcounter:=0;
  findmatch;
  if not(nomatch)and(tcounter=266)then
  begin
    segf:=true;
    segreg:=(opcode shr 3)and 3;
    opcode:=myptr(bufmachine^)[pc];
    inc(pc);
    tcounter:=0;
    findmatch;
  end else segf:=false;
  if nomatch or ((level2[tcounter shr 1]<>2)and not(with3))then segsingit;
  if nomatch then
  begin
    myptr(bufasm^)[index]:=mnemonic(0);
    myptr(bufasm^)[index+1]:=mnemonic(1);
    inc(index,2);
    write(char(mnemonic(0))+char(mnemonic(1)));
    space(6);
    writeopcode;
  end else
  begin
    mnemp:=tmnempos[tcounter shr 1];
    mneml:=mnemonic(mnemp)-byte('0');
    inc(mnemp);
    for d1:=0 to mneml-1 do
    begin
      myptr(bufasm^)[index+d1]:=mnemonic(mnemp+d1);
      write(char(mnemonic(mnemp+d1)));
    end;
    for d1:=mneml to 6 do write(' ');
    inc(index,mneml);
    if level2[tcounter shr 1]<>0 then space(8-mneml);
    if with3 then
    begin
      inc(pc);
      writerm;
      if immf[tcounter shr 1]=3 then
      begin
        myptr(bufasm^)[index]:=byte(',');
        inc(index);
        writeimm;
      end;
    end else if level2[tcounter shr 1]=2{withreg}then
    begin
      opcode2:=myptr(bufmachine^)[pc];
      inc(pc);
      mode:=(opcode2 shr 6)and 3;
      reg:=(opcode2 shr 3)and 7;
      rm:=opcode2 and 7;
      if wf[tcounter shr 1]=5 then wordf:=(opcode and 1)=1 else wordf:=true;
      {below is looking for direction}
      if immf[tcounter shr 1]=4 then direction:=(opcode and 2)=2
                                else direction:=true;
      writereg;
    end else if level2[tcounter shr 1]=3 then
    begin
      if wf[tcounter shr 1]=5 then wordf:=(opcode and 1)=1 else wordf:=true;
      if wordf then
      begin
        myptr(bufasm^)[index]:=byte('a');
        myptr(bufasm^)[index+1]:=byte('x');
      end else
      begin
        myptr(bufasm^)[index]:=byte('a');
        myptr(bufasm^)[index+1]:=byte('l');
      end;
      myptr(bufasm^)[index+2]:=byte(',');
      inc(index,3);
      writeimm;
    end else if level2[tcounter shr 1]=4 then
    begin
      reg:=opcode and 7;
      myptr(bufasm^)[index]:=wreg[reg shl 1];
      myptr(bufasm^)[index+1]:=wreg[(reg shl 1)+1];
      inc(index,2);
    end else if level2[tcounter shr 1]=5 then
    begin
      reg:=(opcode and $18)shr 3;
      myptr(bufasm^)[index]:=sreg[reg shl 1];
      myptr(bufasm^)[index+1]:=sreg[(reg shl 1)+1];
      inc(index,2);
    end else if level2[tcounter shr 1]=6 then
    begin
      wordf:=false;
      myptr(bufasm^)[index]:=byte('+');
      inc(index);
      writeimm;
    end else if level2[tcounter shr 1]=7 then
    begin
      wordf:=true;
      myptr(bufasm^)[index]:=byte('+');
      inc(index);
      writeimm;
    end else if (tcounter>=4)and(tcounter<14)then
    begin
      if tcounter=4 then
      begin
        wordf:=(opcode and 8)=8;
        reg:=opcode and 7;
        if wordf then
        begin
          myptr(bufasm^)[index]:=wreg[reg shl 1];
          myptr(bufasm^)[index+1]:=wreg[(reg shl 1)+1];
        end else
        begin
          myptr(bufasm^)[index]:=breg[reg shl 1];
          myptr(bufasm^)[index+1]:=breg[(reg shl 1)+1];
        end;
        myptr(bufasm^)[index+2]:=byte(',');
        inc(index,3);
        writeimm;
      end else if tcounter in[6,8]then
      begin
        wordf:=(opcode and 1)=1;
        direction:=(opcode and 2)=1;
        mode:=0;
        rm:=6;
        if direction then
        begin
          writerm;
          myptr(bufasm^)[index]:=byte(',');
          inc(index);
        end;
        myptr(bufasm^)[index]:=byte('a');
        if wordf then
          myptr(bufasm^)[index+1]:=byte('x')
        else
          myptr(bufasm^)[index+1]:=byte('l');
        inc(index,2);
        if not(direction) then
        begin
          myptr(bufasm^)[index]:=byte(',');
          inc(index);
          writerm;
        end;
      end else
      begin
        opcode2:=myptr(bufmachine^)[pc];
        inc(pc);
        mode:=(opcode2 shr 6)and 3;
        reg:=(opcode2 shr 3)and 3;
        rm:=opcode2 and 7;
        wordf:=true;

      end;
    end else if level2[tcounter shr 1]=8 then
    begin
    end else if level2[tcounter shr 1]=8 then
    begin
    end else if level2[tcounter shr 1]=8 then
    begin
    end;
  end;
  CR;
end;