procedure aload(filename:string;var buf);
var
  f:file;
begin
  assign(f,filename);
  reset(f,1);
  blockread(f,buf,filesize(f));
  close(f);
end;{aload}
begin
  asm
    mov  ah,0
    mov  al,19
    int  10h
  end;
  aload('newbunny',ptr($9000,0)^);
  move(ptr($9000,0)^,ptr($a000,0)^,64000);
  readln;
  asm
    mov  ah,0
    mov  al,3
    int  10h
  end;

end.

