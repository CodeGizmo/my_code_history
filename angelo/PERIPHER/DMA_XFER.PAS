Procedure dup(a16toa19:byte;source,dest,count:word);
begin
  asm
    mov  al,a16toa19       {program latch (B)}
    shr  al,4
    out  10h,al

    out  0d8h,al            {clear F/L}

    mov  ax,source         {program source}
    out  0c0h,al
    mov  al,ah
    out  0c0h,al

    mov  ax,dest           {program destination}
    out  0c4h,al
    mov  al,ah
    out  0c4h,al

    mov  ax,count          {program count}
    dec  ax                {adjust count}
    out  0c6h,al
    mov  al,ah
    out  0c6h,al

    mov  al,88h            {program mode}
    out  0d6h,al
    mov  al,85h
    out  0d6h,al

    mov  al,1              {enable block move}
    out  0d0h,al

    mov  al,0eh            {unmask channel 0}
    out  0deh,al

    mov  al,4              {request DMA}
    out  0d2h,al

  @again:
    in   al,0d0h
    test al,1
    jz   @again
  end;
end;

begin
  Writeln('angelo');
  dup($B8,0,2000,2000);
end.