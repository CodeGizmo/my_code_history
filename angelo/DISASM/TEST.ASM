dseg segment
     db 12h,34h,56h,78h,90h,0abh,0cdh,0efh
dseg ends
cseg segment
     assume cs:cseg,ds:dseg
pname proc near
      nop
      nop
      nop
      nop
      ret
pname endp
cseg  ends
      end