BYTE_LENGTH equ 4

;-------------------------------------------;
; Input:                                    ;
;   HL = address of null-terminated string  ;
;                                           ;
; Output:                                   ;
;   HL = parsed 16-bit integer              ;
;                                           ;
; Clobbers: AF, BC, DE                      ;
;-------------------------------------------;

str_atoi:
    ld DE, 0

_loop:
    ld A, (HL)
    or A
    jr z, _done

    sub '0'
    ld B, A

    ; DE = DE * 10
    push HL
    ld H, D
    ld L, E

    add HL, HL       ; *2
    push HL
    add HL, HL       ; *4
    add HL, HL       ; *8
    pop DE
    add HL, DE       ; *10

    ld D, H
    ld E, L

    ; DE += digit
    ld A, E
    add A, B
    ld E, A
    jr nc, _next
    inc D

_next:
    pop HL
    inc HL
    jr _loop

_done:
    ex DE, HL
    ret

;-------------------------------------------;
; Input:                                    ;
;   A = 8-bit integer to convert to string ;
;                                           ;
; Output:                                   ;
;   DE = address of null-terminated string  ;
;                                           ;
; Clobbers: AF, BC, DE                      ;
;-------------------------------------------;
str_itoa:
    ld B, A
    ld C, 0
    ld DE, byte_str
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
    ld (DE), A
    inc DE

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
    ld (DE), A
    inc DE

    jr _done
_print_tens_digit:
    ld A, C
    add A, '0'
    ld (DE), A
    inc DE

    ld A, B
    add A, '0'
    ld (DE), A
    inc DE
_done:
    xor A
    ld (DE), A
    ld DE, byte_str
    ret

byte_str:
    defs BYTE_LENGTH, 0