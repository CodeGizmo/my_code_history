uses crt;
type myptr=array[0..65530]of byte;

const
  tabledef:array[0..267]of byte=($88,$FC,   {MOV}
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
                                 $80,$FE,
                                 $24,$FE,
                                 $84,$FE,   {TEST}
                                 $F6,$FE,
                                 $A8,$FE,
                                 $08,$FC,   {OR}
                                 $80,$FE,
                                 $0C,$FE,
                                 $30,$FC,   {XOR}
                                 $80,$FE,
                                 $34,$FE,

                                 $F2,$FE,   {REP}
                                 $A4,$FE,   {MOVS}
                                 $A6,$FE,   {CMPS}
                                 $AE,$FE,   {SCAS}
                                 $AC,$FE,   {LODS}
                                 $AA,$FE,   {STDS}

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
                                 );

  maxtcount=267;
  tmnempos:array[0..133]of word=(2,2,2,2,2,2,2,{MOV}
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
                                219,          {STDS}
                                224,224,224,224,{CALL}
                                229,229,229,229,229,{JMP}
                                233,233,233,233,{RET}
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
                                317,317,      {INT}
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
                               );

  mnemonicc1:array[0..253]of char='dB'+
                                 '3MOV'+
                                 '4PUSH'+
                                 '3POP'+
                                 '4XCHG'+
                                 '2IN'+
                                 '3OUT'+
                                 '4XLAT'+
                                 '3LEA'+
                                 '3LDS'+
                                 '3LES'+
                                 '4LAHF'+
                                 '4SAHF'+
                                 '5PUSHF'+
                                 '4POPF'+
                                 '3ADD'+
                                 '3ADC'+
                                 '3INC'+
                                 '3AAA'+
                                 '3DAA'+
                                 '3SUB'+
                                 '3SBB'+
                                 '3DEC'+
                                 '3NEG'+
                                 '3CMP'+
                                 '3AAS'+
                                 '3DAS'+
                                 '3MUL'+
                                 '4IMUL'+
                                 '3AAM'+
                                 '3DIV'+
                                 '4IDIV'+
                                 '3AAD'+
                                 '3CBW'+
                                 '3CWD'+
                                 '3NOT'+
                                 '3SHL'+
                                 '3SHR'+
                                 '3SAR'+
                                 '3ROL'+
                                 '3ROR'+
                                 '3RCL'+
                                 '3RCR'+
                                 '3AND'+
                                 '4TEST'+
                                 '2OR'+
                                 '3XOR'+

                                 '3REP'+
                                 '4MOVS'+
                                 '4CMPS'+
                                 '4SCAS'+
                                 '4LODS'+
                                 '4STDS'+
                                 '4CALL'+
                                 '3JMP'+
                                 '3RET'+
                                 '2JZ'+
                                 '2JL'+
                                 '3JLE'+
                                 '2JB'+
                                 '3JBE';
  mnemonicc2:array[254..384]of char='3JPE'+
                                 '2JO'+
                                 '2JS'+
                                 '3JNZ'+
                                 '3JGE'+
                                 '2JG'+
                                 '3JAE'+
                                 '2JA'+
                                 '3JPO'+
                                 '3JNO'+
                                 '3JNS'+
                                 '4LOOP'+
                                 '5LOOPZ'+
                                 '6LOOPNZ'+
                                 '4JCXZ'+
                                 '3INT'+
                                 '4INTO'+
                                 '4IRET'+
                                 '3CLC'+
                                 '3CMC'+
                                 '3STC'+
                                 '3CLD'+
                                 '3STD'+
                                 '3CLI'+
                                 '3STI'+
                                 '3HLT'+
                                 '4WAIT'+
                                 '3ESC'+
                                 '4LOCK'+
                                 '7SEGMENT';


  base:array[0..15]of char='0123456789ABCDEF';
var
  mnemonic1:array[0..253]of byte absolute mnemonicc1;
  mnemonic2:array[254..384]of byte absolute mnemonicc2;
  d1, d2, d3, d4,
  x, y,
  tcounter,
  mnemp, mneml,
  pc, index              :word;
  bufmachine, bufasm     :pointer;
  opcode                 :byte;
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
{    write(' ');}
  end;
  inc(index,n+1);
end;

procedure writepc;
begin
  myptr(bufasm^)[index]:=tohex(pc,3);
  myptr(bufasm^)[index+1]:=tohex(pc,2);
  myptr(bufasm^)[index+2]:=tohex(pc,1);
  myptr(bufasm^)[index+3]:=tohex(pc,0);
{  write(char(tohex(pc,3))+char(tohex(pc,2))
       +char(tohex(pc,1))+char(tohex(pc,0)));}
  inc(index,4);
end;

procedure writeopcode;
begin
  myptr(bufasm^)[index]:=tohex(opcode,1);
  myptr(bufasm^)[index+1]:=tohex(opcode,0);
{  write(char(tohex(opcode,1))+char(tohex(opcode,0)));}
  inc(index,2);
end;

procedure CR;
begin
  myptr(bufasm^)[index]:=13;
  myptr(bufasm^)[index+1]:=10;
  inc(index,2);
{  writeln;}
end;

function mnemonic(n:word):byte;
begin
  if n<254 then
    mnemonic:=mnemonic1[n]
    else mnemonic:=mnemonic2[n];
end;

procedure disasm;
begin
  writepc;
  space(1);
  opcode:=myptr(bufmachine^)[pc];
  inc(pc);
  nomatch:=true;
  tcounter:=0;
  while (tcounter<maxtcount)and(nomatch) do
  begin
    if tabledef[tcounter]=(opcode and tabledef[tcounter+1])then
    begin
      nomatch:=false;
    end else inc(tcounter,2);
  end;
  if nomatch then
  begin
    myptr(bufasm^)[index]:=mnemonic(0);
    myptr(bufasm^)[index+1]:=mnemonic(1);
    inc(index,2);
{    write(char(mnemonic[0])+char(mnemonic(1)));}
    space(4);
    writeopcode;
  end else
  begin
    mnemp:=tmnempos[tcounter shr 1];
    mneml:=mnemonic(mnemp)-byte('0');
    inc(mnemp);
    for d1:=0 to mneml-1 do
    begin
      myptr(bufasm^)[index+d1]:=mnemonic(mnemp+d1);
{      write(char(mnemonic[mnemp+d1]));}
    end;
{    for d1:=mneml to 6 do write(' ');}
    inc(index,mneml);
    space(6-mneml);
{    myptr(bufasm^)[index]:=mnemonic[3];
    myptr(bufasm^)[index+1]:=mnemonic[4];
    myptr(bufasm^)[index+2]:=mnemonic[5];
    inc(index,3);
    space(3);}
  end;
  CR;
end;

procedure initdisasm;
begin
  pc:=0;
  index:=0;
end;
var
  f:file;
begin
  clrscr;
  initdisasm;

{  assign(f,'*.*');
  rewrite(f,1);
  blockwrite(f,bufmachine^,index);
  close(f);}

  getmem(bufasm,65535);
  getmem(bufmachine,65535);
  for d1:=0 to 3255 do myptr(bufmachine^)[d1]:=d1;
  for d4:=0 to 3255 do begin disasm;{delay(50)};end;

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