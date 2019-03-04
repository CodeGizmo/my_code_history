uses crt;
{March 1995}
{Thursday, June 1,1995, 10:26PM}
{Tuesday, June 6,1995, 3:19PM}
type myptr=array[0..65530]of byte;

const
  tabledef:array[0..267]of byte=($88,$FC,   {)MOV}
                                 $C6,$FE,
                                 $B0,$F0,
                                 $A0,$FE,
                                 $A2,$FE,
                                 $8E,$FF,
                                 $8C,$FF,
                                 $FF,$FF,   {PUSH}
                                 $50,$F8,
                                 $06,$E7,
                                 $8F,$FF,   {POP}
                                 $58,$F8,
                                 $07,$E7,

                                 $86,$FE,   {XCHG}
                                 $90,$f8,
                                 $E4,$FE,   {IN}
                                 $EC,$FE,
                                 $E6,$FE,   {OUT}
                                 $EE,$FE,
                                 $D7,$FF,   {XLAT}
                                 $8D,$FF,   {LEA}
                                 $C5,$FF,   {LDS}
                                 $C4,$FF,   {LES}
                                 $9F,$FF,   {LAHF}
                                 $9E,$FF,   {SAHF}
                                 $9C,$FF,   {PUSHF}
                                 $9D,$FF,   {POPF}

                                 $00,$FC,   {ADD}
                                 $80,$FC,
                                 $04,$FE,
                                 $10,$FC,   {ADC}
                                 $80,$FC,
                                 $14,$FE,
                                 $FE,$FE,   {INC}
                                 $40,$F8,
                                 $37,$FF,   {AAA}
                                 $27,$FF,   {DAA}

                                 $28,$FC,   {SUB}
                                 $80,$FC,
                                 $2C,$FE,
                                 $18,$FC,   {SBB}
                                 $10,$FC,
                                 $1C,$FE,
                                 $FE,$FE,   {DEC}
                                 $48,$F8,
                                 $F6,$FE,

                                 $38,$FC,   {CMP}
                                 $80,$FC,
                                 $3C,$FE,
                                 $3F,$FF,   {AAS}
                                 $2F,$FF,   {DAS}
                                 $F6,$FE,   {MUL}
                                 $F6,$FE,   {IMUL}
                                 $D4,$FF,   {AAM}
                                 $F6,$FE,   {DIV}
                                 $F6,$FE,   {IDIV}
                                 $D5,$FF,   {AAD}
                                 $98,$FF,   {CBW}
                                 $99,$FF,   {CWD} {59TH}

                                 $F6,$FE,   {NOT}
                                 $D0,$FC,   {SHL/SAL}
                                 $D0,$FC,   {SHR}
                                 $D0,$FC,   {SAR}
                                 $D0,$FC,   {ROL}
                                 $D0,$FC,   {ROR}
                                 $D0,$FC,   {RCL}
                                 $D0,$FC,   {RCR}

                                 $20,$FC,   {AND}
                                 $80,$Fc,
                                 $24,$FE,
                                 $84,$FE,   {TEST}
                                 $F6,$FE,
                                 $A8,$FE,
                                 $08,$FC,   {OR}
                                 $80,$Fc,
                                 $0C,$FE,
                                 $30,$FC,   {XOR}
                                 $80,$Fc,
                                 $34,$FE,

                                 $F2,$FE,   {REP}
                                 $A4,$FE,   {MOVS}
                                 $A6,$FE,   {CMPS}
                                 $AE,$FE,   {SCAS}
                                 $AC,$FE,   {LODS}
                                 $AA,$FE,   {STOS}

                                 $E8,$FF,   {CALL}
                                 $FF,$FF,
                                 $9A,$FF,
                                 $FF,$FF,
                                 $E9,$FF,   {JMP}
                                 $EB,$FF,
                                 $FF,$FF,
                                 $EA,$FF,
                                 $FF,$FF,
                                 $C3,$FF,   {RET}
                                 $C2,$FF,
                                 $CB,$FF,
                                 $CA,$FF,

                                 $74,$FF,   {JE/JZ}
                                 $7C,$FF,   {JL/JNGE}
                                 $7E,$FF,   {JLE/JNG}
                                 $72,$FF,   {JB/JNAE}
                                 $76,$FF,   {JBE/JNA}
                                 $7A,$FF,   {JP/JPE}
                                 $70,$FF,   {JO}
                                 $78,$FF,   {JS}
                                 $75,$FF,   {JNE/JNZ}
                                 $7D,$FF,   {JNL/JGE}
                                 $7F,$FF,   {JNLE/JG}
                                 $73,$FF,   {JNB/JAE}
                                 $77,$FF,   {JNBE/JA}
                                 $7B,$FF,   {JNP/JPO}
                                 $71,$FF,   {JNO}

                                 $79,$FF,   {JNS}
                                 $E2,$FF,   {LOOP}
                                 $E1,$FF,   {LOOPZ/LOOPE}
                                 $E0,$FF,   {LOOPNZ/LOOPNE}
                                 $E3,$FF,   {JCXZ}
                                 $CD,$FF,   {INT}
                                 $CC,$FF,
                                 $CE,$FF,   {INTO}
                                 $CF,$FF,   {IRET}

                                 $F8,$FF,   {CLC}
                                 $F5,$FF,   {CMC}
                                 $F9,$FF,   {STC}
                                 $FC,$FF,   {CLD}
                                 $FD,$FF,   {STD}
                                 $FA,$FF,   {CLI}
                                 $FB,$FF,   {STI}
                                 $F4,$FF,   {HLT}
                                 $9B,$FF,   {WAIT}
                                 $D8,$F8,   {ESC}
                                 $F0,$FF,   {LOCK}
                                 $26,$E7    {SEGMENT}
                              {(});

  maxtcount=267;
  tmnempos:array[0..133]of word=(2,2,2,2,2,2,2,{)MOV}
                                6,6,6,        {PUSH}
                                11,11,11,     {POP}
                                15,15,        {XCHG}
                                20,20,        {IN}
                                23,23,        {OUT}
                                27,           {XLAT}
                                32,           {LEA}
                                36,           {LDS}
                                40,           {LES}
                                44,           {LAHF}
                                49,           {SAHF}
                                54,           {PUSHF}
                                60,           {POPF}
                                65,65,65,     {ADD}
                                69,69,69,     {ADC}
                                73,73,        {INC}
                                77,           {AAA}
                                81,           {DAA}
                                85,85,85,     {SUB}
                                89,89,89,     {SBB}
                                93,93,        {DEC}
                                97,           {NEG}
                                101,101,101,  {CMP}
                                105,          {AAS}
                                109,          {DAS}
                                113,          {MUL}
                                117,          {IMUL}
                                122,          {AAM}
                                126,          {DIV}
                                130,          {IDIV}
                                135,          {AAD}
                                139,          {CBW}
                                143,          {CWD}
                                147,          {NOT}
                                151,          {SHL}
                                155,          {SHR}
                                159,          {SAR}
                                163,          {ROL}
                                167,          {ROR}
                                171,          {RCL}
                                175,          {RCR}
                                179,179,179,  {AND}
                                183,183,183,  {TEST}
                                188,188,188,  {OR}
                                191,191,191,  {XOR}

                                195,          {REP}
                                199,          {MOVS}
                                204,          {CMPS}
                                209,          {SCAS}
                                214,          {LODS}
                                219,          {STOS}
                                224,224,224,224,{CALL}
                                229,229,229,229,229,{JMP}
                                233,233,285,285,{RET}
                                237,          {JZ}
                                240,          {JL}
                                243,          {JLE}
                                247,          {JB}
                                250,          {JBE}
                                254,          {JPE}
                                258,          {JO}
                                261,          {JS}
                                264,          {JNZ}
                                268,          {JGE}
                                272,          {JG}
                                275,          {JAE}
                                279,          {JA}
                                282,          {JPO}
                                286,          {JNO}
                                290,          {JNS}
                                294,          {LOOP}
                                299,          {LOOPZ}
                                305,          {LOOPNZ}
                                312,          {JCXZ}
                                317,390,      {INT}
                                321,          {INTO}
                                326,          {IRET}
                                331,          {CLC}
                                335,          {CMC}
                                339,          {STC}
                                343,          {CLD}
                                347,          {STD}
                                351,          {CLI}
                                355,          {STI}
                                359,          {HLT}
                                363,          {WAIT}
                                368,          {ESC}
                                372,          {LOCK}
                                377           {SEGMENT OVERIDE}
                            {(});

  mnemonicc1:array[0..253]of char='db'+
                                 '3mov'+
                                 '4push'+
                                 '3pop'+
                                 '4xchg'+
                                 '2in'+
                                 '3out'+
                                 '4xlat'+
                                 '3lea'+
                                 '3lds'+
                                 '3les'+
                                 '4lahf'+
                                 '4sahf'+
                                 '5pushf'+
                                 '4popf'+
                                 '3add'+
                                 '3adc'+
                                 '3inc'+
                                 '3aaa'+
                                 '3daa'+
                                 '3sub'+
                                 '3sbb'+
                                 '3dec'+
                                 '3neg'+
                                 '3cmp'+
                                 '3aas'+
                                 '3das'+
                                 '3mul'+
                                 '4imul'+
                                 '3aam'+
                                 '3div'+
                                 '4idiv'+
                                 '3aad'+
                                 '3cbw'+
                                 '3cwd'+
                                 '3not'+
                                 '3shl'+
                                 '3shr'+
                                 '3sar'+
                                 '3rol'+
                                 '3ror'+
                                 '3rcl'+
                                 '3rcr'+
                                 '3and'+
                                 '4test'+
                                 '2or'+
                                 '3xor'+

                                 '3rep'+
                                 '4movs'+
                                 '4cmps'+
                                 '4scas'+
                                 '4lods'+
                                 '4stos'+
                                 '4call'+
                                 '3jmp'+
                                 '3ret'+
                                 '2jz'+
                                 '2jl'+
                                 '3jle'+
                                 '2jb'+
                                 '3jbe';
  mnemonicc2:array[254..395]of char='3jpe'+
                                 '2jo'+
                                 '2js'+
                                 '3jnz'+
                                 '3jge'+
                                 '2jg'+
                                 '3jae'+
                                 '2ja'+
                                 '3jpo'+
                                 '3jno'+
                                 '3jns'+
                                 '4loop'+
                                 '5loopz'+
                                 '6loopnz'+
                                 '4jcxz'+
                                 '3int'+
                                 '4into'+
                                 '4iret'+
                                 '3clc'+
                                 '3cmc'+
                                 '3stc'+
                                 '3cld'+
                                 '3std'+
                                 '3cli'+
                                 '3sti'+
                                 '3hlt'+
                                 '4wait'+
                                 '3esc'+
                                 '4lock'+
                                 '7SEGMENT'+
                                 '4retf'+
                                 '5int 3';

  base:array[0..15]of char='0123456789ABCDEF';
var
  mnemonic1:array[0..253]of byte absolute mnemonicc1;
  mnemonic2:array[254..395]of byte absolute mnemonicc2;
  d1, d2, d3, d4,
  x, y,
  tcounter,
  mnemp, mneml,
  pc, index              :word;
  bufmachine, bufasm     :pointer;
  opcode                 :byte;
  withpc, withopcode,
  nomatch                :boolean;

function tohex(n:word;digit:byte):byte;
begin
  tohex:=byte(base[(n shr (digit shl 2))and$F]);
end;

procedure space(n:byte);
begin
  for n:=0 to n-1 do
  begin
    myptr(bufasm^)[index+n]:=byte(' ');
    write(' ');
  end;
  inc(index,n+1);
end;

procedure writepc;
var pcc:word;
begin
  pcc:=pc+256;
  myptr(bufasm^)[index]:=tohex(pcc,3);
  myptr(bufasm^)[index+1]:=tohex(pcc,2);
  myptr(bufasm^)[index+2]:=tohex(pcc,1);
  myptr(bufasm^)[index+3]:=tohex(pcc,0);
  write(chr(tohex(pcc,3))+chr(tohex(pcc,2))+chr(tohex(pcc,1))+chr(tohex(pcc,0)));
  inc(index,4);
  space(1);
end;

procedure writew(n:word);
begin
  myptr(bufasm^)[index]:=tohex(n,3);
  myptr(bufasm^)[index+1]:=tohex(n,2);
  myptr(bufasm^)[index+2]:=tohex(n,1);
  myptr(bufasm^)[index+3]:=tohex(n,0);
  write(char(tohex(n,3))+char(tohex(n,2))+char(tohex(n,1))+char(tohex(n,0)));
  inc(index,4);
end;

procedure writeb(n:word);
begin
  myptr(bufasm^)[index]:=tohex(n,1);
  myptr(bufasm^)[index+1]:=tohex(n,0);
  write(char(tohex(n,1))+char(tohex(n,0)));
  inc(index,2);
end;

procedure writeopcode;
begin
  myptr(bufasm^)[index]:=tohex(opcode,1);
  myptr(bufasm^)[index+1]:=tohex(opcode,0);
  write(char(tohex(opcode,1))+char(tohex(opcode,0)));
  inc(index,2);
end;

procedure CR;
begin
  myptr(bufasm^)[index]:=13;
  myptr(bufasm^)[index+1]:=10;
  inc(index,2);
  writeln;
end;

function mnemonic(n:word):byte;
begin
  if n<254 then
    mnemonic:=mnemonic1[n]
    else mnemonic:=mnemonic2[n];
end;

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
  {11-int}                     2,1,3,
  {9-b/w strings}              2,1,3,
                               1,4,1,
                               2,1,3,0,0,1,1,0,1,1,0,0,0,
                               1,1,1,1,1,1,1,1,

                               2,1,3,
                               2,1,3,
                               2,1,3,
                               2,1,3,
                               0,9,9,9,9,9,

                               7,1,0,1,
                               7,6,1,0,1,
                               0,0,0,0,6,6,6,6,6,6,
                                 6,6,6,6,6,6,6,6,6,6,
                                 6,6,6,6,

                               11,0,0,0,
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
    segf:=false;
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
  if (nomatch or ((level2[tcounter shr 1]<>2)and not(with3)))
     and not(tcounter in[6,8])then segsingit;
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
    if not(level2[tcounter shr 1]in[0,9])then space(8-mneml);
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
{      wordf:=false;
      myptr(bufasm^)[index]:=byte('+');
      inc(index);
      writeimm;}
      writew(shortint(myptr(bufmachine^)[pc])+pc+1+256);
      inc(pc);
    end else if level2[tcounter shr 1]=7 then
    begin
{      wordf:=true;
      myptr(bufasm^)[index]:=byte('+');
      inc(index);
      writeimm;}
      writew(integer(myptr(bufmachine^)[pc]+
                    (myptr(bufmachine^)[pc+1]shl 8))+pc+2+256);
      inc(pc,2);
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
        direction:=(opcode and 2)=2;
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
        direction:=(opcode and 2)=0;
        if direction then
        begin
          writerm;
          myptr(bufasm^)[index]:=byte(',');
          inc(index);
        end;
        myptr(bufasm^)[index]:=sreg[reg shl 1];
        myptr(bufasm^)[index+1]:=sreg[(reg shl 1)+1];
        inc(index,2);
        if not(direction) then
        begin
          myptr(bufasm^)[index]:=byte(',');
          inc(index);
          writerm;
        end;
      end;
    end else if opcode=$cd then
    begin
      wordf:=false;
      writeimm;
    end else if level2[tcounter shr 1]=9 then
    begin
      if (opcode and 1)=1 then myptr(bufasm^)[index]:=byte('w')
                          else myptr(bufasm^)[index]:=byte('b');
      inc(index);
    end else if level2[tcounter shr 1]=8 then
    begin
    end;
  end;
  CR;
end;

procedure initdisasm;
begin
  pc:=0;
  index:=0;
  withpc:=true;
  withopcode:=true;
end;
var
  f:file;
begin
  clrscr;
  initdisasm;
  getmem(bufasm,65535);
  getmem(bufmachine,65535);

  assign(f,'c:\utils\fm80'{'c:\utils\fm80.com'{'e:\with3.com'});
  reset(f,1);
  blockread(f,bufmachine^,533);
  close(f);

{  for d1:=0 to 532 do myptr(bufmachine^)[d1]:=d1;}
  for d4:=0 to 532 do begin disasm;{delay(50)};end;

  assign(f,'unasm.asm');
  rewrite(f,1);
  blockwrite(f,bufasm^,index);
  close(f);
{  for d1:=0 to 1000 do
  begin
    for d2:=3 downto 0 do
    write(char(tohex(d1,d2)));
    writeln;
    delay(50);
  end;}
end.