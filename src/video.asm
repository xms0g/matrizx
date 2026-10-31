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

clr_screen:
    ld HL,SCREEN
    ld DE,SCREEN+1
    ld BC,17FFh
    ld (HL),0
    ldir
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
    ld A, 04h
    ld ($5C8D), A   ; ATTR_P
    ld ($5C8F), A   ; ATTR_T
    ret