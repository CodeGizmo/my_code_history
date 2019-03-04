unit charmani;
interface
type
  chardef=record
            charok                :boolean;
            tc,tb,
            charwidth,charheight  :byte;
            charsize              :word;
            mychar                :pointer;
          end;
var
  font    :array[0..9]of chardef;
  curchar :byte;
  charx,chary                   :word;

procedure defchar(ch:byte;bitno:word;bit:byte);
procedure defcharxy(ch,x,y,bit:byte);
procedure defcharget(ch:byte;var buf);
procedure putchar2(ch:byte);
procedure putcharb(ch:byte);
procedure newchar(width,height,charnum:byte);
procedure charxy(x,y:word);
procedure charsave(filename:string;charnum:byte);
procedure charload(filename:string;charnum:byte);
procedure charinit;

implementation
uses vgaliza3;
type myptr=array[0..65000]of byte;

var
  charoks                       :boolean;
  orer                          :byte;
  charpos                       :word;


procedure defchar(ch:byte;bitno:word;bit:byte);
begin
  with font[curchar] do if charok then
  begin
    orer:=1 shl (ch and 7);
    charpos:=(ch shr 3)*charsize+bitno;
    if bit>0 then myptr(mychar^)[charpos]:=myptr(mychar^)[charpos]or orer
             else myptr(mychar^)[charpos]:=myptr(mychar^)[charpos]and not(orer);
  end;
end;{defchar}

procedure defcharxy(ch,x,y,bit:byte);
begin
  with font[curchar] do if charok then
  begin
    orer:=1 shl(ch and 7);
    charpos:=(ch shr 3)*charsize+y*charwidth+x;
    if bit>0 then myptr(mychar^)[charpos]:=myptr(mychar^)[charpos]or orer
             else myptr(mychar^)[charpos]:=myptr(mychar^)[charpos]and not(orer);
  end;
end;{defcharxy}

procedure defcharget(ch:byte;var buf);
var d1:word;
begin
  with font[curchar] do if charok then
  begin
    orer:=1 shl(ch and 7);
    charpos:=(ch shr 3)*charsize;
    for d1:=2 to charsize+1 do
    begin
      if myptr(buf)[d1]>0 then myptr(mychar^)[charpos]:=myptr(mychar^)[charpos]or orer
             else myptr(mychar^)[charpos]:=myptr(mychar^)[charpos]and not(orer);
      inc(charpos);
    end;
  end;
end;{defcharget}

procedure putchar2(ch:byte);
var d1,d2:word;
begin
  with font[curchar] do if charok then
  begin
    case ch of
      8:begin
          if charx=winx1 then
          begin
            chary:=chary-charheight;
            charx:=((winx2+1)div charwidth)*charwidth;
          end;
          charx:=charx-charwidth;

          orer:=1 shl(ch and 7);
          charpos:=(ch shr 3)*charsize;
          for d1:=chary to charheight+chary-1 do
            for d2:=charx to charwidth+charx-1 do
            begin
              if(myptr(mychar^)[charpos]and orer)>0 then yeyan(d2,d1,tc);
              inc(charpos);
            end;
        end;
      else repeat
          orer:=1 shl(ch and 7);
          charpos:=(ch shr 3)*charsize;
          for d1:=chary to charheight+chary-1 do
            for d2:=charx to charwidth+charx-1 do
            begin
              if(myptr(mychar^)[charpos]and orer)>0 then yeyan(d2,d1,tc);
              inc(charpos);
            end;

          charx:=charx+charwidth;
          if (charx+charwidth-1>winx2)then
          begin
            charx:=winx1;
            chary:=chary+charheight;
            if (chary+charheight-1>winy2)then
            begin
              chary:=winy1;
            end;
          end;
        until (ch<>13)or(charx=winx1);
    end;
  end;
end;{putchar2}

procedure putcharb(ch:byte);
var d1,d2:word;
begin
  with font[curchar] do if charok then
  begin
    case ch of
      8:begin
          if charx=winx1 then
          begin
            chary:=chary-charheight;
            charx:=((winx2+1)div charwidth)*charwidth;
          end;
          charx:=charx-charwidth;

          orer:=1 shl(ch and 7);
          charpos:=(ch shr 3)*charsize;
          for d1:=chary to charheight+chary-1 do
            for d2:=charx to charwidth+charx-1 do
            begin
              if(myptr(mychar^)[charpos]and orer)>0 then yeyan(d2,d1,tc) else
                                                         yeyan(d2,d1,tb);
              inc(charpos);
            end;
        end;
      else repeat
          orer:=1 shl(ch and 7);
          charpos:=(ch shr 3)*charsize;
          for d1:=chary to charheight+chary-1 do
            for d2:=charx to charwidth+charx-1 do
            begin
              if(myptr(mychar^)[charpos]and orer)>0 then yeyan(d2,d1,tc) else
                                                         yeyan(d2,d1,tb);
              inc(charpos);
            end;

          charx:=charx+charwidth;
          if (charx+charwidth-1>winx2)then
          begin
            charx:=winx1;
            chary:=chary+charheight;
            if (chary+charheight-1>winy2)then
            begin
              chary:=winy1;
            end;
          end;
        until (ch<>13)or(charx=winx1);
    end;
  end;
end;{putcharb}

procedure newchar(width,height,charnum:byte);
begin
  if charoks then
  begin
    curchar:=charnum;
    with font[charnum] do
    begin
      if charsize>0 then freemem(mychar,charsize*32);
      charwidth:=width;
      charheight:=height;
      charsize:=width*height;
      if charsize>0 then
      begin
        getmem(mychar,charsize*32);
        charok:=true;
      end else charok:=false;
    end;
  end;
end;{newchar}

procedure charxy(x,y:word);
begin
  charx:=x;
  chary:=y;
end;{charxy}

procedure charsave(filename:string;charnum:byte);
var f:file;
begin
  with font[charnum] do if charok then
  begin
    {$I-}
    assign(f,filename);
    rewrite(f,1);
    blockwrite(f,charwidth,1);
    blockwrite(f,charheight,1);
    blockwrite(f,mychar^,charsize*32);
    close(f);
    {$i+}
  end;
end;{charsave}

procedure charload(filename:string;charnum:byte);
var f:file;
begin
  with font[charnum] do if charok then
  begin
    {$I-}
    assign(f,filename);
    reset(f,1);
    blockread(f,charwidth,1);
    blockread(f,charheight,1);
    if charsize>0 then freemem(mychar,charsize*32);
    charsize:=charwidth*charheight;
    if charsize>0 then
    begin
      getmem(mychar,charsize*32);
      charok:=true;
      blockread(f,mychar^,charsize*32);
    end else charok:=false;
    close(f);
    {$i+}
  end;
end;{charload}

procedure charinit;
var d1:word;
begin
  charoks:=true;
  for d1:=0 to 9 do
  with font[d1] do
  begin
    charsize:=0;
    charok:=false;
    tc:=15;
    tb:=0;
  end;
  curchar:=0;
end;{charinit}

begin
  charinit;
end.



