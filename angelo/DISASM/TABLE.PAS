  tabledef:array[0..267]of byte=( $88,$FC,   {MOV}
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
                                 $D8,$FF,   {ESC}
                                 $F0,$FF,   {LOCK}
                                 $26,$FF    {SEGMENT}
