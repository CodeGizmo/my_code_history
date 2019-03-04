uses vgaliza3,crt;
begin
  asm
    mov ax,0013h
    int 10h
    mov ax,007eh
    mov bx,64
    mov cx,48
    mov dx,0
    int 10h
  end;
  pset(0,0,1);
  readkey;
end.
