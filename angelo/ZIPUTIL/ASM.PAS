      asm
      pusha
             Push ds
             mov  dx,bufinseg
             mov  bx,upos
             add  bx,bufinofs
             mov  si,startheadofs
             mov  es,dx

             mov  ax,countlimit
             inc  ax
             sub  ax,wcountest
             mov  wcountest,ax

             mov  cx,ss:upto
             inc  cx
        @nextndexs:
             Push cx
             push ds
             mov  ds,abcseg
             std
             lodsw
             pop  ds

             mov  cx,upos
             sub  cx,ax
             dec  cx
             cmp  cx,wmaxindex
             ja   @endcachepop

             cmp  si,startofs
             jae  @goon
             mov  si,startmaxofs
        @goon:
             mov  cx,countlimit
             inc  cx

             mov  di,ax
             push ds
             mov  ds,dx
             push si
             mov  si,bx
             cld
             repe cmpsb
             pop  si
             pop  ds

             cmp  cx,wcountest
             jb   @newcountest
             pop  cx
             loop @nextndexs
             jmp  @endcache
        @newcountest:
             mov  wcountest,cx
             mov  uposindex,ax
             cmp  cx,0
             jz   @endcachepop
             pop  cx
             loop @nextndexs
        @endcachepop:
             pop  cx
        @endcache:
             mov  cx,countlimit
             inc  cx
             sub  cx,wcountest
             mov  wcountest,cx
             mov  windex,ax
             pop  ds
             popa
      end;
      windexest:=upos-uposindex-1;
      if(windex>wmaxindex)or(countest>wmaxcount)then labas:=true;