SCREEN      equ $4000
ATTRIBUTES  equ $5800
ROM_FONT    equ $3D00
COLUMNS     equ 32
ROWS        equ 24

; ---------------
; A = char      ;
; ---------------
print_char:
    rst $10
    ret
; ---------------
; HL=str      ;
; ---------------
print_str:
_loop:
    ld A, (HL)
    cp 0
    jr z, _done
    call print_char
    inc HL
    jr _loop
_done:
    ret

clr_screen:
    ld HL,SCREEN
    ld DE,SCREEN+1
    ld BC,17FFh
    ld (HL), 0
    ldir

    ; Reset ROM print position
    ld BC, $1821       ; B=24, C=33 (inverted coordinates)
    ld HL, SCREEN
    ld ($5C88), BC     ; S_POSN
    ld ($5C84), HL     ; DF_CC

    ret

init_video:
    call clr_screen
    ; Clear color attributes (768 bytes)
    ld HL,ATTRIBUTES
    ld DE,ATTRIBUTES+1
    ld BC,02FFh
    ld (HL),0
    ldir

    ; Green ink on black paper
    ld A, $04
    ld ($5C8D), A   ; ATTR_P
    ld ($5C8F), A   ; ATTR_T
    ret