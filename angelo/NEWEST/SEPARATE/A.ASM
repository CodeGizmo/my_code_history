.model  tpascal
locals @@
.data
extrn buffer:word,count:word
.code
extrn  rangeerror:near
public checkrange
checkrange proc near
mov bx,bx
push  ax
pop   ax
push ax
pop ax
push ax
pop ax
mov ax,ax
checkrange  endp
end
