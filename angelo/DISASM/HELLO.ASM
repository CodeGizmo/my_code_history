	.386p
	ifndef	??version
?debug	macro
	endm
publicdll macro	name
	public	name
	endm
	endif
	?debug	V 300h
	?debug	S "BORLANDC\EXAMPLES\HELLO.C"
	?debug	C E900104D1619424F524C414E44435C4558414D504C45535C48454C+
	?debug	C 4C4F2E43
	?debug	C E94019CA181B443A5C424F524C414E44435C494E434C5544455C53+
	?debug	C 5444494F2E48
	?debug	C E94019CA181B443A5C424F524C414E44435C494E434C5544455C5F+
	?debug	C 444546532E48
	?debug	C E94019CA181C443A5C424F524C414E44435C494E434C5544455C5F+
	?debug	C 4E46494C452E48
	?debug	C E94019CA181B443A5C424F524C414E44435C494E434C5544455C5F+
	?debug	C 4E554C4C2E48
_TEXT	segment byte public use16 'CODE'
_TEXT	ends
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP
_DATA	segment word public use16 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public use16 'BSS'
b@	label	byte
b@w	label	word
_BSS	ends
_TEXT	segment byte public use16 'CODE'
	?debug	C E80119424F524C414E44435C4558414D504C4553+
	?debug	C 5C48454C4C4F2E4300104D16
	?debug	L 7
	assume	cs:_TEXT
_main	proc	near
	?debug	B
	?debug	B
	?debug	L 9
	push	offset DGROUP:s@
	call	near ptr _printf
	add	sp,2
	?debug	L 10
	xor	ax,ax
	?debug	L 11
	ret	
	?debug	E
	?debug	E
_main	endp
	?debug	C E9
	?debug	C FA00000000
_TEXT	ends
_DATA	segment word public use16 'DATA'
s@	label	byte
	db	'Hello, world'
	db	10
	db	0
_DATA	ends
_TEXT	segment byte public use16 'CODE'
_TEXT	ends
	public	_main
	extrn	_printf:near
_s@	equ	s@
	?debug	C EA0109
	?debug	C E31800000023040000
	?debug	C EC055F6D61696E181800
	?debug	C E31900000023040001
	?debug	C EB075F7072696E74661900
	?debug	C E60666706F735F740606000673697A655F740A06+
	?debug	C 00
	end
