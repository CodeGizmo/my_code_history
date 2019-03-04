uses crt;
var
  a:word;
  editor:array[0..16383]of byte;
  edpos:word;
  worksize:word;
  labels:array[0..16383]of byte;
  labelpos:word;
  segg,ofss:word;

procedure initialize;
begin
  asm
    jmp @loadit
  @angelo:
    db 3,'nop',3,'mov'
  @loadit:
    mov segg,seg(@angelo)
    mov ofss,offset(@angelo);
  end;
end;{initialize}

procedure chklabel;
begin
  repeat
    while (editor[edpos]=$20)and(edpos<worksize)do inc(edpos);
    while mem[segg:ofss+edpos]=ord(':')do
    begin

    end;
  until edpos>worksize;
end;{chklabel}
begin
end.






editor       db       'Angelo:',13,10,'taengtae: ',13,10,'wawa:'
             db       13,10,'yabayoo:'

edini        dw       editor
edpos        dw       0
worksize     dw       50
dcount       dw       0
directives   db       3,'nop',3,'mov',4,'push',3,'pop'    ;,........
drctvsini    dw       directives
drctvs       dw       0
maxdrctv     equ      3
labels       db       1024 dup(?)
labelini     dw       labels
labelpos     dw       0
totlabel     dw       0
labelno      dw       0
lcount       dw       0
labelbuf     dw       2048 dup(0)
labelbufini  dw       labelbuf
labelbufpos  dw       0
jmpbuf       dw       4096 dup(0)
jmpbufini    dw       jmpbuf
jmpbufpos    dw       0
compiler     db       16384 dup(0)
compini      dw       compiler
comppos      dw       0