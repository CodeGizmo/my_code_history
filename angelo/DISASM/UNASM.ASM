0100 E9 jmp     01E6
0103 00 add     [bx+si],al
0105 00 add     [bx+si],al
0107 00 add     [bx+si],al
0109 00 add     [bx+si],al
010B 00 add     [bx+si],al
010D 00 add     [bx+si],al
010F 00 add     [bx+si],al
0111 4E dec     si
0112 65 db      65
0113 77 ja      0142
0115 57 push    di
0116 61 db      61
0117 72 jb      017E
0119 00 add     [bx+si],al
011B 12 adc     dl,[di+20]
011E EB jmp     0128
0120 4E dec     si
0121 65 db      65
0122 77 ja      0151
0124 57 push    di
0125 61 db      61
0126 72 jb      018D
0128 FA cli
0129 80 cmp     ah,04
012C 77 ja      016C
012E 80 cmp     ah,02
0131 72 jb      016C
0133 80 cmp     dl,03
0136 77 ja      016C
0138 50 push    ax
0139 06 push    es
013A 57 push    di
013B 33 xor     ax,ax
013D 8E mov     es,ax
013F 26 mov     ax,es:[007A]
0143 26 mov     di,es:[0078]
0148 8E mov     es,ax
014A A0 mov     al,[011B]
014D 26 mov     es:[di+04],al
0151 B8 mov     ax,0040
0154 8E mov     es,ax
0156 BF mov     di,0090
0159 33 xor     ax,ax
015B 8A mov     al,dl
015D 09 or      di,ax
015F 26 mov     al,es:[di]
0162 24 and     al,DF
0164 0C or      al,07
0166 26 mov     es:[di],al
0169 5F pop     di
016A 07 pop     es
016B 58 pop     ax
016C F7 test    [0103],0010
0172 74 jz      0179
0174 2E jmp     cs:[0109]
0179 2E or      cs:[0103],2E10
0180 8F pop     [010D]
0184 2E pop     cs:[010F]
0189 2E call    cs:[0109]
018E 9C pushf
018F FA cli
0190 2E push    cs:[010F]
0195 2E push    cs:[010D]
019A 2E and     cs:[0103],CFEF
01A1 80 cmp     ah,9F
01A4 74 jz      01AB
01A6 2E jmp     cs:[0105]
01AB 2E mov     ax,cs:[0107]
01AF 8E mov     ds,ax
01B1 2E mov     dx,cs:[0105]
01B6 B8 mov     ax,2516
01B9 CD int     21
01BB 2E mov     ax,cs:[010B]
01BF 8E mov     ds,ax
01C1 2E mov     dx,cs:[0109]
01C6 B8 mov     ax,2513
01C9 CD int     21
01CB BB mov     bx,002C
01CE 2E mov     ax,cs:[bx]
01D1 8E mov     es,ax
01D3 B4 mov     ah,49
01D5 CD int     21
01D7 8C mov     ax,cs
01D9 8E mov     es,ax
01DB B4 mov     ah,49
01DD CD int     21
01DF FB sti
01E0 B4 mov     ah,4C
01E2 CD int     21
01E4 00 add     [bx+si],al
01E6 8C mov     ax,cs
01E8 8E mov     ds,ax
01EA 8E mov     es,ax
01EC 26 mov     al,es:[0082]
01F0 A2 mov     [011D],al
01F3 26 mov     al,es:[0084]
01F7 3C cmp     al,6C
01F9 74 jz      0201
01FB 3C cmp     al,4C
01FD 74 jz      0201
01FF EB jmp     0206
0201 B0 mov     al,95
0203 A2 mov     [011C],al
0206 B8 mov     ax,3513
0209 CD int     21
020B B9 mov     cx,0008
020E BE mov     si,0111
0211 89 mov     di,bx
0213 83 add     di,FC02
0217 F3 rep
0218 A6 cmpsb
0219 74 jz      021D
021B EB jmp     023A
021D 8C mov     ax,cs
021F 8E mov     ds,ax
0221 8E mov     es,ax
0223 80 cmp     [011D],52
0228 74 jz      028E
022A 80 cmp     [011D],72
022F 74 jz      028E
0231 B4 mov     ah,09
0233 BA mov     dx,029C
0236 CD int     21
0238 EB jmp     01E0
023A B8 mov     ax,3516
023D CD int     21
023F 8C mov     [0107],es
0243 89 mov     [0105],bx
0247 B8 mov     ax,2516
024A BA mov     dx,01A1
024D CD int     21
024F B8 mov     ax,3513
0252 CD int     21
0254 8C mov     [010B],es
0258 89 mov     [0109],bx
025C B8 mov     ax,2513
025F BA mov     dx,011E
0262 CD int     21
0264 8C mov     ax,cs
0266 8E mov     ds,ax
0268 8E mov     es,ax
026A 80 cmp     [011D],39
026F 75 jnz     027B
0271 B0 mov     al,09
0273 A2 mov     [011B],al
0276 BA mov     dx,02C2
0279 EB jmp     027E
027B BA mov     dx,02F6
027E B0 mov     al,20
0280 26 mov     es:[0082],al
0284 B4 mov     ah,09
0286 CD int     21
0288 BA mov     dx,01E6
028B FB sti
028C CD int     27
028E BA mov     dx,032B
0291 B4 mov     ah,09
0293 CD int     21
0295 B4 mov     ah,9F
0297 CD int     16
0299 E9 jmp     01E0
029C 46 inc     si
029D 4D dec     bp
029E 38 cmp     [bx+si],dh
02A0 20 and     [bx+di+73],ch
02A3 20 and     [bx+di+6C],ah
02A6 72 jb      030D
02A8 61 db      61
02A9 64 db      64
02AA 79 jns     02CC
02AC 69 db      69
02AD 6E db      6E
02AE 73 jae     0324
02B0 61 db      61
02B1 6C db      6C
02B2 6C db      6C
02B3 65 db      65
02B4 64 db      64
02B5 20 and     [di],ch
02B7 20 and     [bx+di+62],ah
02BA 6F db      6F
02BB 72 jb      0331
02BD 69 db      69
02BE 6E db      6E
02BF 67 db      67
02C0 07 pop     es
02C1 24 and     al,46
02C3 4D dec     bp
02C4 38 cmp     [bx+si],dh
02C6 20 and     [bx+di+73],ch
02C9 20 and     [si+6F],ch
02CC 61 db      61
02CD 64 db      64
02CE 65 db      65
02CF 64 db      64
02D0 20 and     [bx+si],ch
02D2 39 cmp     [bx+di],bp
02D4 2E and     cs:[bx+si],ah
02D7 55 push    bp
02D8 73 jae     033F
02DA 20 and     [bp+4D],al
02DD 38 cmp     [bx+si],dh
02DF 20 and     [bp+si+20],dl
02E2 74 jz      0353
02E4 20 and     [bp+si+65],dh
02E7 6D db      6D
02E8 6F db      6F
02E9 76 jbe     0350
02EB 20 and     [bp+72],ah
02EE 6F db      6F
02EF 6D db      6D
02F0 20 and     [bp+si+41],dl
02F3 4D dec     bp
02F4 2E cs:
02F5 24 and     al,46
02F7 4D dec     bp
02F8 38 cmp     [bx+si],dh
02FA 20 and     [bx+di+73],ch
02FD 20 and     [bp+6F],ch
0300 77 ja      0322
0302 69 db      69
0303 6E db      6E
0304 73 jae     037A
0306 61 db      61
0307 6C db      6C
0308 6C db      6C
0309 65 db      65
030A 64 db      64
030B 2E and     cs:[di+73],dl
030F 65 db      65
0310 20 and     [bp+4D],al
0313 38 cmp     [bx+si],dh
0315 2A sub     ch,[bp+si]
0317 2A sub     ch,[bp+si]
0319 2A sub     cl,[bp+si+8A8A]
031D 8A mov     cl,[bp+si+2A8A]
0321 2A sub     ch,[bp+si]
0323 06 push    es
0324 06 push    es
0325 06 push    es
0326 06 push    es
0327 06 push    es
0328 71 jno     039B
032A 18 sbb     [bx+si],bl
032C 18 sbb     [bx+si],bl
032E 18 sbb     [bx+si],bl
0330 18 sbb     [bx+si],bl
0332 18 sbb     [bx+si],bl
0334 18 sbb     [bx+si],bl
0336 18 sbb     [bx+si],bl
0338 18 sbb     [bx+si],bl
033A 18 sbb     [bx+si],bl
033C 18 sbb     [bx+si],bl
033E 18 sbb     [bx+si],bl
0340 18 sbb     [bx+si],bl
0342 18 sbb     [bx+si],bl
0344 18 sbb     [bx+si],bl
0346 18 sbb     [bx+si],bl
0348 18 sbb     [bx+si],bl
034A 18 sbb     [bx+si],bl
034C 18 sbb     [bx+si],bl
034E 06 push    es
034F 06 push    es
0350 06 push    es
0351 06 push    es
0352 00 add     [bp+si],ch
0354 2A sub     ch,[bp+si]
0356 2A sub     ch,[bp+si]
0358 72 jb      03CC
035A 0C or      al,2A
035C 29 sub     [bp+si],ax
035E 2D sub     ax,2D2D
0361 2A sub     cl,[bp+si+2A8A]
0365 2A sub     ch,[bp+si]
0367 2A sub     ch,[bp+si]
0369 2A sub     cl,[bp+si+8A8A]
036D 8A mov     cl,[bp+si+8A8A]
0371 2A sub     ch,[bp+si]
0373 06 push    es
0374 06 push    es
0375 06 push    es
0376 06 push    es
0377 06 push    es
0378 71 jno     03EB
037A 18 sbb     [bx+si],bl
037C 18 sbb     [bx+si],bl
037E 18 sbb     [bx+si],bl
0380 18 sbb     [bx+si],bl
0382 18 sbb     [bx+si],bl
0384 18 sbb     [bx+si],bl
0386 18 sbb     [bx+si],bl
0388 18 sbb     [bx+si],bl
038A 18 sbb     [bx+si],bl
038C 18 sbb     [bx+si],bl
038E 18 sbb     [bx+si],bl
0390 18 sbb     [bx+si],bl
0392 18 sbb     [bx+si],bl
0394 18 sbb     [bx+si],bl
0396 18 sbb     [bx+si],bl
0398 18 sbb     [bx+si],bl
039A 18 sbb     [bx+si],bl
039C 18 sbb     [bx+si],bl
039E 06 push    es
039F 06 push    es
03A0 06 push    es
03A1 06 push    es
03A2 00 add     [bp+si],ch
03A4 2A sub     ch,[bp+si]
03A6 2A sub     ch,[bp+si]
03A8 72 jb      041C
03AA 0C or      al,2A
03AC 29 sub     [bx+di],bp
03AE 2D sub     ax,2D2D
03B1 8A mov     cl,[bp+si+2A8A]
03B5 2A sub     ch,[bp+si]
03B7 2A sub     ch,[bp+si]
03B9 2A sub     ch,[bp+si]
03BB 8A mov     cl,[bp+si+8A8A]
03BF 8A mov     cl,[bp+si+2A2A]
03C3 06 push    es
03C4 06 push    es
03C5 06 push    es
03C6 06 push    es
03C7 06 push    es
03C8 71 jno     043B
03CA 18 sbb     [bx+si],bl
03CC 18 sbb     [bx+si],bl
03CE 18 sbb     [bx+si],bl
03D0 18 sbb     [bx+si],bl
03D2 18 sbb     [bx+si],bl
03D4 18 sbb     [bx+si],bl
03D6 18 sbb     [bx+si],bl
03D8 18 sbb     [bx+si],bl
03DA 18 sbb     [bx+si],bl
03DC 18 sbb     [bx+si],bl
03DE 18 sbb     [bx+si],bl
03E0 18 sbb     [bx+si],bl
03E2 18 sbb     [bx+si],bl
03E4 18 sbb     [bx+si],bl
03E6 18 sbb     [bx+si],bl
03E8 18 sbb     [bx+si],bl
03EA 18 sbb     [bx+si],bl
03EC 18 sbb     [bx+si],bl
03EE 06 push    es
03EF 06 push    es
03F0 06 push    es
03F1 06 push    es
03F2 00 add     [bp+si],ch
03F4 2A sub     ch,[bp+si]
03F6 2A sub     ch,[bp+si]
03F8 72 jb      046C
03FA 0C or      al,0C
03FC 29 sub     [bx+di],bp
03FE 2D sub     ax,2D2D
0401 79 jns     038D
0403 8A mov     ch,[bp+si]
0405 2A sub     ch,[bp+si]
0407 2A sub     ch,[bp+si]
0409 2A sub     ch,[bp+si]
040B 8A mov     cl,[bp+si+8A8A]
040F 8A mov     cl,[bp+si+2A8A]
0413 06 push    es
0414 06 push    es
0415 06 push    es
0416 06 push    es
0417 06 push    es
0418 71 jno     048B
041A 18 sbb     [bx+si],bl
041C 18 sbb     [bx+si],bl
041E 18 sbb     [bx+si],bl
0420 18 sbb     [bx+si],bl
0422 18 sbb     [bx+si],bl
0424 18 sbb     [bx+si],bl
0426 18 sbb     [bx+si],bl
0428 18 sbb     [bx+si],bl
042A 18 sbb     [bx+si],bl
042C 18 sbb     [bx+si],bl
042E 18 sbb     [bx+si],bl
0430 18 sbb     [bx+si],bl
0432 18 sbb     [bx+si],bl
0434 18 sbb     [bx+si],bl
0436 18 sbb     [bx+si],bl
0438 18 sbb     [bx+si],bl
043A 18 sbb     [bx+si],bl
043C 18 sbb     [bx+si],bl
043E 06 push    es
043F 06 push    es
0440 06 push    es
0441 06 push    es
0442 00 add     [bp+si],ch
0444 2A sub     ch,[bp+si]
0446 2A sub     ch,[bp+si]
0448 72 jb      04BC
044A 2A sub     cl,[si]
044C 29 sub     [bx+di],bp
044E 2D sub     ax,2D2D
0451 79 jns     03DD
0453 8A mov     ch,[bp+si]
0455 2A sub     ch,[bp+si]
0457 2A sub     ch,[bp+si]
0459 2A sub     ch,[bp+si]
045B 2A sub     cl,[bp+si+8A8A]
045F 8A mov     cl,[bp+si+2A8A]
0463 06 push    es
0464 06 push    es
0465 06 push    es
0466 06 push    es
0467 06 push    es
0468 71 jno     0482
046A 18 sbb     [bx+si],bl
046C 18 sbb     [bx+si],bl
046E 18 sbb     [bx+si],bl
0470 18 sbb     [bx+si],bl
0472 18 sbb     [bx+si],bl
0474 18 sbb     [bx+si],bl
0476 18 sbb     [bx+si],bl
0478 18 sbb     [bx+si],bl
047A 18 sbb     [bx+si],bl
047C 18 sbb     [bx+si],bl
047E 18 sbb     [bx+si],bl
0480 18 sbb     [bx+si],bl
0482 18 sbb     [bx+si],bl
0484 18 sbb     [bx+si],bl
0486 18 sbb     [bx+si],bl
0488 18 sbb     [bx+si],bl
048A 18 sbb     [bx+si],bl
048C 18 sbb     [bx+si],bl
048E 06 push    es
048F 06 push    es
0490 06 push    es
0491 06 push    es
0492 00 add     [bp+si],ch
0494 2A sub     ch,[bp+si]
0496 2A sub     ch,[bp+si]
0498 72 jb      050C
049A 2A sub     ch,[bx+di]
049C 29 sub     [si],cx
049E 2D sub     ax,2D2D
04A1 79 jns     042D
04A3 8A mov     ch,[bp+si]
04A5 2A sub     ch,[bp+si]
04A7 2A sub     ch,[bp+si]
04A9 2A sub     ch,[bp+si]
04AB 2A sub     cl,[bp+si+8A8A]
04AF 8A mov     cl,[bp+si+2A8A]
04B3 06 push    es
04B4 06 push    es
04B5 06 push    es
04B6 06 push    es
04B7 06 push    es
04B8 71 jno     04D2
04BA 18 sbb     [bx+si],bl
04BC 18 sbb     [bx+si],bl
04BE 18 sbb     [bx+si],bl
04C0 18 sbb     [bx+si],bl
04C2 18 sbb     [bx+si],bl
04C4 18 sbb     [bx+si],bl
04C6 18 sbb     [bx+si],bl
04C8 18 sbb     [bx+si],bl
04CA 18 sbb     [bx+si],bl
04CC 18 sbb     [bx+si],bl
04CE 18 sbb     [bx+si],bl
04D0 18 sbb     [bx+si],bl
04D2 18 sbb     [bx+si],bl
04D4 18 sbb     [bx+si],bl
04D6 18 sbb     [bx+si],bl
04D8 18 sbb     [bx+si],bl
04DA 18 sbb     [bx+si],bl
04DC 18 sbb     [0606],al
04E0 06 push    es
04E1 06 push    es
04E2 2A sub     ch,[bp+si]
04E4 2A sub     ch,[bp+si]
04E6 2A sub     ch,[bp+si]
04E8 72 jb      055C
04EA 2A sub     ch,[bx+di]
04EC 29 sub     [si],cx
04EE 2D sub     ax,2D2D
04F1 79 jns     047D
04F3 8A mov     ch,[bp+si]
04F5 2A sub     ch,[bp+si]
04F7 2A sub     ch,[bp+si]
04F9 2A sub     ch,[bp+si]
04FB 2A sub     cl,[bp+si+8A8A]
04FF 8A mov     cl,[bp+si+8A8A]
0503 06 push    es
0504 06 push    es
0505 06 push    es
0506 06 push    es
0507 06 push    es
0508 71 jno     0522
050A 18 sbb     [bx+si],bl
050C 18 sbb     [bx+si],bl
050E 18 sbb     [bx+si],bl
0510 18 sbb     [bx+si],bl
0512 18 sbb     [bx+si],bl
0514 18 sbb     [bx+si],bl
0516 18 sbb     [bx+si],bl
0518 18 sbb     [bx+si],bl
051A 18 sbb     [bx+si],bl
051C 18 sbb     [bx+si],bl
051E 18 sbb     [bx+si],bl
0520 18 sbb     [bx+si],bl
0522 18 sbb     [bx+si],bl
0524 18 sbb     [bx+si],bl
0526 18 sbb     [bx+si],bl
0528 18 sbb     [bx+si],bl
052A 18 sbb     [bx+si],bl
052C 18 sbb     [0606],al
0530 06 push    es
0531 06 push    es
0532 2A sub     ch,[bp+si]
0534 2A sub     ch,[bp+si]
0536 2A sub     ch,[bp+si]
0538 72 jb      05AC
053A 2A sub     ch,[bx+di]
053C 29 sub     [bp+si],bp
053E 0A or      ch,[di]
0540 2D sub     ax,8A79
0543 8A mov     ch,[bp+si]
0545 2A sub     ch,[bp+si]
0547 2A sub     ch,[bp+si]
0549 2A sub     ch,[bp+si]
054B 2A sub     ch,[bp+si]
054D 09 or      [bp+si+8A8A],cx
0551 8A mov     cl,[bp+si+0606]
0555 06 push    es
0556 06 push    es
0557 06 push    es
0558 71 jno     0572
055A 18 sbb     [bx+si],bl
055C 18 sbb     [bx+si],bl
055E 18 sbb     [bx+si],bl
