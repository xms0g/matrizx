cmd_help:
    ld BC, help_str
    call print_str
    ret

cmd_cls:
    call clr_screen
    ret

;----------------
; HL=addr       ;
;---------------;
cmd_peek:
    ld A, 13
    call print_char
    ld A, (HL)
    call print_byte
    ret

;----------------
; HL=addr       ;
; BC=value      ;
;---------------;
cmd_poke:
    ld (HL), C
    ret

cmd_rand:
    ld A, 13
    call print_char
    call rnd_byte
    call print_byte
    ret

cmd_rain:
    call rain_run
    ret

help_str:
    defb 13, 13, "AVAILABLE COMMANDS:", 13, 13
    defb "HELP  CLS  RAND", 13
    defb "PEEK  POKE RAIN", 13, 0