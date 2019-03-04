VGA_SEGMENT     equ 0a000h       ;
SC_INDEX        equ 3c4h         ;Sequence Controller Index register
GC_INDEX        equ 3ceh         ;Graphics Controller Index register
CRTC_INDEX      equ 3d4h
MAP_MASK        equ 2            ;Map Mask register index in SC
MEMORY_MODE     equ 4
MAX_SCAN_LINE   equ 9
START_ADDRESS_HIGH equ 0ch
UNDERLINE	    equ 14h
MODE_CONTROL    equ 17h
READ_MAP        equ 4            ;Read Map register index in GC
GRAPHICS_MODE   equ 5
MISCELLANEOUS   equ 6
SCREEN_WIDTH    equ 320          ;# of pixels across screen
SCREEN_HEIGHT   equ 400
WORD_OUTS_OK    equ 0            ;set to 0 to assemble for
                                                                                  ; computer that can't handle
                                                                                  ; words outs to indexed VGA registers

_DATA segment public byte 'DATA'
_DATA           ends

OUT_WORD        macro
if WORD_OUTS_OK
                        out dx,ax
else
                  out  dx,al
                  inc  dx
                  xchg ah,al
                  out  dx,al
                  dec  dx
                  xchg ah,al
endif
						endm

CONSTANT_TO_INDEXED_REGISTER macro ADDRESS,INDEX,VALUE
			 mov  dx,ADDRESS
			 mov  ax,(VALUE shl 8) + INDEX
			 OUT_WORD
			 endm


		

_TEXT     segment byte public 'CODE'
          assume cs:_TEXT,ds:_DATA

; void Set320x400Mode()
;
; Returns: nothing

						public _Set320x400Mode
_Set320x400Mode proc far
					 mov  ax,0013h
					 int  10h

					 mov  dx,SC_INDEX
					 mov  al,MEMORY_MODE
					 out  dx,al
					 inc  dx
					 in   al,dx
					 and  al,not 08h
					 or   al,04h
					 out  dx,al
					 mov  dx,GC_INDEX
					 mov  al,GRAPHICS_MODE
					 out  dx,al
					 inc  dx
					 in   al,dx
					 and  al,not 10h
					 out  dx,al
					 dec  dx

					 mov  al,MISCELLANEOUS
					 out  dx,al
					 inc  dx
					 in   al,dx
					 and  al,not 02h
					 out  dx,al

					 CONSTANT_TO_INDEXED_REGISTER SC_INDEX,MAP_MASK,0fh

					 mov  ax,VGA_SEGMENT
					 mov  es,ax
					 sub  di,di
					 mov  ax,di
					 mov  cx,8000h
					 cld
					 rep  stosw

					 mov  dx,CRTC_INDEX
					 mov  al,MAX_SCAN_LINE
					 out  dx,al
					 inc  dx
					 in   al,dx
					 and  al,not 1fh
					 out  dx,al
					 dec  dx

					 mov  al,UNDERLINE
					 out  dx,al
					 inc  dx
					 in   al,dx
					 and  al,not 40h
					 out  dx,al
					 dec  dx
					 mov  al,MODE_CONTROL
					 out  dx,al
					 inc  dx
					 in   al,dx
					 or   al,40h

					 out  dx,al
					 ret
_Set320x400Mode endp



DParms struc
                 dw ?
                 dw ?
DrawX  dw ?
DrawY  dw ?
Color  dw ?   ; 0-255
DParms ends

; void Draw320x400Dot(int X,int Y, int Color)
;
; Returns: Nothing

					  public _Draw320x400Dot
_Draw320x400Dot proc far
                 push  bp
                 mov   bp,sp
                 push  si
                 push  di
                 mov   ax,VGA_SEGMENT
                 mov   es,ax
                 mov   ax,SCREEN_WIDTH/4
                                                ;there are 4 pixels at each address, so
                                                ; each 360-pixel row is 90 bytes wide
                                                ; in each plane

                 mul   [bp+DrawY]
                 mov   di,[bp+DrawX]
                 shr   di,1
                 shr   di,1
                 add   di,ax
                 mov   cl,byte ptr [bp+DrawX]
                 and   cl,3
                 mov   ah,1
                 shl   ah,cl

                 mov   al,MAP_MASK
                 mov   dx,SC_INDEX
                 OUT_WORD

                 mov   al,byte ptr [bp+Color]
                 stosb
                 pop   di
                 pop   si
                 pop   bp
                 ret
_Draw320x400Dot endp

RParms struc
                 dw ?
                 dw ?
ReadX  dw ?
ReadY  dw ?
RParms ends

; int Read320x400Mode(int X,int Y)
;
; Returns: pixel color
					  public _Read320x400Dot
_Read320x400Dot proc far
                 push  bp
                 mov   bp,sp
                 push  si
                 push  di
                 mov   ax,VGA_SEGMENT
                 mov   es,ax
                 mov   ax,SCREEN_WIDTH/4

                 mul   [bp+DrawY]
                 mov   si,[bp+DrawX]
                 shr   si,1
                 shr   si,1
                 add   si,ax
                 mov   ah,byte ptr [bp+DrawX]

                 and   ah,3
                 mov   al,READ_MAP
                 mov   dx,GC_INDEX
                 OUT_WORD

                 lods  byte ptr es:[si]
                 sub   ah,ah
                 pop   di
                 pop   si
                 pop   bp
_Read320x400Dot endp
_TEXT ends
                end
