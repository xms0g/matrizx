KEY_ENTER       equ $0D
KEY_BACKSPACE   equ $08
KEY_CAPS_SHIFT  equ $01
KEY_SYMBOL      equ $02

kb_poll:
    ld BC, $00FE
    in A, (C)
    and $1F
    cp $1F
    ret

kb_read:
    ld HL, kb_map
    ld D, 8

_row_loop:
    ld B, (HL)
    inc HL

    ld C, $FE
    in A, (C)
    and $1F

    ld E, 5

_key_loop:
    srl A
    jr NC, _key_pressed

    inc HL
    dec E
    jr NZ, _key_loop

    dec D
    jr NZ, _row_loop
    ret

_key_pressed:
    ld A, (HL)
    ret
    
kb_map:
    db $FE, KEY_CAPS_SHIFT, 'Z', 'X', 'C', 'V'
    db $FD, 'A', 'S', 'D', 'F', 'G'
    db $FB, 'Q', 'W', 'E', 'R', 'T'
    db $F7, '1', '2', '3', '4', '5'
    db $EF, '0', '9', '8', '7', '6'
    db $DF, 'P', 'O', 'I', 'U', 'Y'
    db $BF, KEY_ENTER, 'L', 'K', 'J', 'H'
    db $7F, ' ', KEY_SYMBOL, 'M', 'N', 'B'
