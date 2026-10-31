SCREEN      equ 4000h
ATTRIBUTES  equ 5800h

; ---------------
; A = char      ;
; ---------------
print_char:
    rst $10
    ret
; ---------------
; BC = str      ;
; ---------------
print_str:
_loop:
    ld A, (BC)
    cp 0
    jr z, _done
    call print_char
    inc BC
    jr _loop
_done:
    ret

; ---------------
; A = byte      ;
; ---------------
print_byte:
    ld B, A

    ; Print hundreds
    ld C, 0
_hundreds:
    ld A, B
    cp 100
    jr c, _tens

    sub 100
    ld B, A
    inc C
    jr _hundreds

_tens:
    ld A, C
    or A
    jr z, _print_tens

    add A, '0'
    call print_char

_print_tens:
    ld C, 0
_tens_loop:
    ld A, B
    cp 10
    jr c, _units

    sub 10
    ld B, A
    inc C
    jr _tens_loop

_units:
    ld A, C
    or A
    jr nz, _print_tens_digit

    ; Print units
    ld A, B
    add A, '0'
    call print_char
    ret

_print_tens_digit:
    ld A, C
    add A, '0'
    call print_char

    ld A, B
    add A, '0'
    call print_char
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