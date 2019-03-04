uses crt,vgaliza3;
var x,y,a,b:word;
begin
  vgamode(1);
  asm
    mov ax,4f02h
    mov bx,101h
    int 10h
  end;
  for a:=0 to 3 do
  begin
    asm
      mov ax,4f05h
      mov bx,0h
      mov dx,a
      int 10h
    end;
    for x:=0 to 65535 do mem[$a000:x]:=a+1;
  end;
  readkey;
end.
