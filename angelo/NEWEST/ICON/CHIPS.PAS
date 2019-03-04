uses crt,vgaliza3;
var s,ms:byte;
begin
  asm
    mov ah,5fh
    mov al,0
    int 10h
    mov s,al
    mov ms,bh
  end;
  if s=$5f then writeln('Extended VGA control function supported');
  writeln('memory size is ',ms,'       ');
  readln;
end.