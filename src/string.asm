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