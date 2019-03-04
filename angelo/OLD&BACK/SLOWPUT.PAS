uses vgayey,crt;


function getpoint(px,py:word):word;
var
    pc:byte;
BEGIN
asm
        MOV   ES,gSEG
        MOV   SI,PX
        CMP   SI,639
        JA    @END_PLOT
        MOV   DI,SI
        shr   di,1
        shr   di,1
        MOV   DL,BYTE PTR PY
        CMP   DL,199
        JA    @END_PLOT
        MOV   DH,DL
        SHR   DH,1
        shr   dh,1
        MOV   AL,160
        MUL   DH
        ADD   DI,AX
        MOV   Cx,3
        and   dx,cx
        ROR   DX,1
        ROR   DX,1
        ROR   DX,1
        ADD   DI,DX
        and   si,cx
        sub   cx,si
        add   cl,cl
        mov   bl,es:byte ptr[di]
        mov   bh,es:byte ptr 32768[di]
        mov   ax,1100000011b
        shl   ax,cl
        and   bx,ax
        shr   bx,cl
        shl   bh,1
        shl   bh,1
        add   bl,bh
        mov   bh,0
        mov   word ptr pc,bx
@END_PLOT:
end;
        getpoint:=pc;
END;{getplot}

var
  z:array[0..1024]of word;
  zy:array[0..9,0..9]of byte;
  ship:array[0..255]of byte;
  p:pointer;
  aseg,bseg,x,y,xx,yy:word;
  a,a1,a2,dummy:word;
  ch:char;
begin
  vgamode(1);
  clear;
  getmem(p,65535);
  aload('bunny.all',p^);
  gseg:=seg(p^);
  for a:=0 to 1023 do
  begin
    z[a]:=a;
  end;

  repeat
    a1:=random(1024);
    a2:=random(1024);
    dummy:=z[a1];
    z[a1]:=z[a2];
    z[a2]:=dummy;
  until keypressed;
  ch:=readkey;

  for a:=0 to 1023 do
  begin
    a1:=z[a]and 31;
    a2:=z[a]shr 5;
    for y:=0 to 3 do
    begin
      yy:=(y shl 5)+a2;
      for x:=0 to 9 do
      begin
        xx:=(x shl 5)+a1;
        yeyan(xx,yy,getpoint(xx,yy));
      end;
    end;
  end;
  gseg:=$a7d0;
  repeat linepg(random(320),random(100)+100,random(320),random(100)+100) until keypressed;
  readln;
end.