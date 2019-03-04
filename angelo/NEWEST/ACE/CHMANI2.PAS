unit chmani2;
{Encoded: 1993-1994}
{1st revision: Saturday, October 29, 1994}
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
  charpos,
  charx,chary                   :word;

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
    orer:=1 shl(ch and 7);
    charpos:=(ch shr 3)*charsize;
    for d1:=0 to charheight-1 do
      for d2:=0 to charwidth-1 do
      begin
        if(myptr(mychar^)[charpos]and orer)>0 then yeyan(charx+d2,chary+d1,tc);
        inc(charpos);
      end;
  end;
end;{putchar2}

procedure putcharb(ch:byte);
var d1,d2:word;
begin
  with font[curchar] do if charok then
  begin
    orer:=1 shl(ch and 7);
    charpos:=(ch shr 3)*charsize;
    for d1:=0 to charheight-1 do
      for d2:=0 to charwidth-1 do
      begin
        if(myptr(mychar^)[charpos]and orer)>0 then yeyan(charx+d2,chary+d1,tc)
                                     else yeyan(charx+d2,chary+d1,tb);
        inc(charpos);
      end;
  end;
end;{putcharb}

procedure newchar(width,height,charnum:byte);
begin
  if charoks then
  begin
    curchar:=charnum;
    with font[curchar] do
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
var
  f:file;
  newcharwidth,
  newcharheight,
  newcharsize:byte;
begin
  with font[charnum] do
  begin
    {$I-}
    assign(f,filename);
    reset(f,1);
    if filesize(f)>0 then
    begin
      blockread(f,newcharwidth,1);
      blockread(f,newcharheight,1);
      newcharsize:=newcharwidth*newcharheight;
      if newcharsize>0 then
      begin
        if charok then freemem(mychar,charsize)else charok:=true;
        charwidth:=newcharwidth;
        charheight:=newcharheight;
        charsize:=newcharsize;
        getmem(mychar,charsize);
        blockread(f,mychar^,charsize*32);
      end;
    end;
    close(f);
    {$i+}
  end;
end;{charsave}

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



