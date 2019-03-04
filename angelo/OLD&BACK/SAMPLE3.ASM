.286c
eseg    segment
  editor       db ' angelo: jmp angelo',13,10
  edit_pos     dw editor
  edit_lpos    dw edit_pos
  compiler     db 16384 dup(0)
  comp_tot     dw ?
  comp_pos     dw ?
eseg    ends

dseg    segment
  mnems3       db 3,'jmp'
  mnems_tot    dw 1
  tot_labels   dw 0
  labels       db 4096 dup(0)
  label_pos    dw 512 dup(0)
  tot_vars     dw 0
  vars         db 4096 dup(0)
  var_pos      dw 512 dup(0)
dseg    ends

sseg    segment para stack
  stacks       db  1024 dup(0)
sseg    ends


  spc          equ 20h
  cr           equ 13
  di_ptr       equ byte ptr es:[di]
p macro aa
      mov al,aa
      call print
endm
code    segment
        assume cs:code,ds:dseg,es:eseg
begin:
        pusha
        call   initialize
        call   pass1
        mov    di,0


        jmp ending
pass1   proc
  findfirst:
        mov    di,edit_pos
        mov    cx,edit_lpos
        sub    cx,edit_pos
        mov    al,spc
        repe   scasb
        jcxz   pass1_ends
        mov    edit_pos,di
        cmp    di_ptr,cr
        je     next_line
  get_word:
        mov    di,edit_pos
        mov    cx,edit_lpos
        sub    cx,edit_pos
        cmp    di_ptr,61h               ;{a}
        jb     special_word
        cmp    di_ptr,7ah               ;{z}
        ja     special_word
  r1:
        cmp    di_ptr,3ah               ;{:}
        je     label_found
        cmp    di_ptr,spc
        je     finish_get_word
        inc    di
        ;{cmp  special}
        loop   r1
  finish_get_word:
  label_found:
  special_word:
  next_line:
  pass1_ends:
        ret
pass1   endp

print   proc
        push es
        mov  cx,0b800h
        mov  es,cx
        stosb
        pop  es
print   endp


initialize proc
        mov    ax,dseg
        mov    ds,ax
        mov    ax,eseg
        mov    es,ax
        mov    tot_labels,0
        mov    tot_vars,0
        mov    di,0
        mov    si,0
        ret
initialize endp
ending:
        popa
        mov    ah,4ch
        int    21h
code    ends
        end begin