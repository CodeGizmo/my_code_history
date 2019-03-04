	.386p
	ifndef	??version
?debug	macro
	endm
publicdll macro	name
	public	name
	endm
	endif
	?debug	V 300h
	?debug	S "TESTING.C"
	?debug	C E9C8B225200954455354494E472E43
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
	?debug	C E8010954455354494E472E43C8B22520
	?debug	L 2
	assume	cs:_TEXT
_main	proc	near
	?debug	B
	?debug	B
	?debug	L 4
	push	offset DGROUP:s@
	call	near ptr _printf
	add	sp,2
	?debug	L 5
	ret	
	?debug	E
	?debug	E
_main	endp
	?debug	C E9
	?debug	C FA00000000
_TEXT	ends
_DATA	segment word public use16 'DATA'
s@	label	byte
	db	'Angelo'
	db	0
_DATA	ends
_TEXT	segment byte public use16 'CODE'
_TEXT	ends
	public	_main
	extrn	_printf:near
_s@	equ	s@
	?debug	C EA0109
	?debug	C E31800000023010000
	?debug	C EC055F6D61696E181800
	?debug	C E31900000023040001
	?debug	C EB075F7072696E74661900
	?debug	C E60666706F735F740606000673697A655F740A06+
	?debug	C 00
	end
