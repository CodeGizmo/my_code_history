code segment
assume cs:code
     org 100h
begin:
push ax
push [bx]
push [bx+1]
push [bx+03ffh]
code ends
     end begin