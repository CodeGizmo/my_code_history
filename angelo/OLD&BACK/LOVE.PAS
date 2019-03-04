code    segment
        assume  cs:code,ds,code
        org     100h
begin   proc
        mov     ax,3510h
        int     21h
        mov     cs:cs10,es
        mov     cs:ip10,bx
        mov     dx,offset int10v
        mov     ax,2510h
        int     21h
        jmp     sadulo
ip10    dw      ?
cs10    dw      ?
key     db      ?
int10v:
        pushf
        cmp     ah,0
        jz      cont1
        jmp     wala
cont1:  cmp     al,4
        jae     cont2
        jmp     wala
cont2:  pushf
        mov    ax,6
        call    cs:dword ptr ip10
        push    ax
        push    bx
        push    cx
        push    dx
        push    ds

        mov    dx,3dah
t1:     in     al,dx
        test   al,8
        jz     t1
        mov    dx,3ddh
        mov    al,80h
        out    dx,al
        mov    dx,3d8h
        mov    al,02
        out    dx,al
        mov    dx,3d9h
        mov    al,0
        out    dx,al

        mov    dx,3d4h
        mov    bx,0
        mov    cx,10d
looper:
        mov    al,bl
        mov    ah,[bx]+hidata
        out    dx,ax
        inc    bl
        loop   looper
        pop     ds
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        jmp     theend
hidata  db     70h,50h,59h,0ah,40h,4,32h,38h,2,3,6,7,0,0,0,0
wala:
        jmp     cs:dword ptr ip10
theend:
        iret
sadulo:
        mov     dx,offset sadulo
        int     27h
begin   endp
code    ends
        end     begin





