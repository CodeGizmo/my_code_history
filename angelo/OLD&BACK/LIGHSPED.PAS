uses graphyey,crt;
var
  x,a:word;
  y:byte;
  xx:array[0..100]of integer;
  xinc:array[0..100]of shortint;
  yy:array[0..100]of integer;
  yinc:array[0..100]of shortint;
  c:array[0..100]of byte;
  lastx,lasty:word;
begin
  agraphmode;
  asm
    pushf
    cli
    mov ax,0b000h
    mov es,ax
    mov di,0
    mov ax,0
    mov cx,7fffh
    rep stosw
    popf
  end;
  for y:=0 to 100 do
  begin
    yinc[y]:=random(51)-25;
    xinc[y]:=random(51)-25;
    c[y]:=random(16);
    xx[y]:=0;
    yy[y]:=0;
  end;
  a:=0;

  repeat
    lastx:=320+xx[a];
    lasty:=100+yy[a];
    plot(lastx,lasty,c[a]);
    xx[a]:=xx[a]+xinc[a];
    inc(yy[a],yinc[a]);
    if(xx[a]>319)or(xx[a]<-320)or(yy[a]>99)or(yy[a]<-100)then
    begin
      xx[a]:=0;xinc[a]:=random(51)-25;
      yy[a]:=0;yinc[a]:=random(51)-25;
    end;
    plot(320+xx[a],100+yy[a],c[a]);
    plot(lastx,lasty,0);
    inc(a);
    if a>100 then a:=0;
  until keypressed;
end.