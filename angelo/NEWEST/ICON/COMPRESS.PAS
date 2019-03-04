UNIT COMPRESS;{Version 1.0 (April 1994)}
{created by: LANUZA, Angelo Lian
 Address: 234 Purple Rd., Gatchalian Subd., Las Pinas Metro Manila
 Tel #: dial 109 for a cellular call to 079-27-30
}
INTERFACE
VAR
  result_size,
  upos,cpos     :WORD;
TYPE
  myptr=array[0..65530]of BYTE;

PROCEDURE slidec(VAR bufin,bufout;usize:WORD;cbits:BYTE);
PROCEDURE slideu(VAR bufin,bufout);

IMPLEMENTATION

VAR
  maxindexf,maxindexm,maxindex,
  countest,indexest,
  index,count,maxcount,ncount :BYTE;

PROCEDURE slidec(VAR bufin,bufout;usize:WORD;cbits:BYTE);

  PROCEDURE search_match;
  BEGIN
    countest:=1;
    index:=0;
    REPEAT
      count:=0;
      WHILE(myptr(bufin)[upos-1-index+count]=myptr(bufin)[upos+count])
           AND(count<=maxcount)AND(upos+count<=usize)DO INC(count);
      IF count>countest THEN
      BEGIN
        countest:=count;
        indexest:=index;
        IF countest>maxcount THEN EXIT;
      END;
      INC(index);
    UNTIL(index>maxindex)OR(index>=upos)OR(upos+countest>usize);
  END;{search_match}

  PROCEDURE savenomatch;
  BEGIN
    myptr(bufout)[cpos]:=127+ncount;
    INC(cpos);
    MOVE(myptr(bufin)[upos-ncount],myptr(bufout)[cpos],ncount);
    cpos:=cpos+ncount;
  END;{savenomatch}

BEGIN
  DEC(usize);
  myptr(bufout)[0]:=3;
  myptr(bufout)[1]:=LO(usize);
  myptr(bufout)[2]:=HI(usize);
  myptr(bufout)[5]:=cbits;
  myptr(bufout)[6]:=myptr(bufin)[0];
  cpos:=7;
  upos:=1;
  maxcount:=1 SHL cbits;
  maxindexf:=(1 SHL(8-cbits))-1;
  maxindexm:=(1 SHL(7-cbits))-1;
  ncount:=0;
  maxindex:=maxindexm;
  REPEAT
    search_match;
    IF countest>1 THEN
    BEGIN
      IF ncount>0 THEN
      BEGIN
        savenomatch;
        ncount:=0;
      END;
      myptr(bufout)[cpos]:=(indexest SHL cbits)+countest-2;
      maxindex:=maxindexm;
      INC(cpos);
      upos:=upos+countest;
    END ELSE
    BEGIN
      maxindex:=maxindexf;
      inc(ncount);
      inc(upos);
      IF ncount>127 THEN
      BEGIN
        savenomatch;
        ncount:=0;
        maxindex:=maxindexm;
      END;
    END;
  UNTIL upos>usize;
  IF ncount>0 THEN savenomatch;
  myptr(bufout)[3]:=LO(cpos);
  myptr(bufout)[4]:=HI(cpos);
  result_size:=cpos;
END;{slidec}

PROCEDURE slideu(VAR bufin,bufout);
VAR cbits:BYTE;
    usize:WORD;
    fullok:BOOLEAN;
BEGIN
  IF myptr(bufin)[0]=3 THEN
  BEGIN
    cbits:=myptr(bufin)[5];
    usize:=myptr(bufin)[1]+(WORD(myptr(bufin)[2])shl 8);
    result_size:=usize+1;
    myptr(bufout)[0]:=myptr(bufin)[6];
    cpos:=7;
    upos:=1;
    maxcount:=(1 SHL cbits)-1;
    REPEAT
      fullok:=false;
      REPEAT
        ncount:=myptr(bufin)[cpos];
        inc(cpos);
        IF ncount>=128 THEN
        BEGIN
          ncount:=ncount-127;
          IF ncount<128 THEN fullok:=true;
          MOVE(myptr(bufin)[cpos],myptr(bufout)[upos],ncount);
          upos:=upos+ncount;
          cpos:=cpos+ncount;
        END ELSE
        BEGIN
          index:=ncount SHR cbits;
          ncount:=ncount AND maxcount;
          FOR ncount:=0 TO ncount+1 DO
          BEGIN
            myptr(bufout)[upos]:=myptr(bufout)[upos-1-index];
            inc(upos);
          END;
        END;
      UNTIL fullok OR(upos>usize);
      IF upos<usize THEN
      BEGIN
        ncount:=myptr(bufin)[cpos];
        INC(cpos);
        index:=ncount SHR cbits;
        ncount:=ncount AND maxcount;
        FOR ncount:=0 TO ncount+1 DO
        BEGIN
          myptr(bufout)[upos]:=myptr(bufout)[upos-1-index];
          INC(upos);
        END;
      END;
    UNTIL upos>usize;
  END;
END;{slideu}

END.

