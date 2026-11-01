cmd_help:
    ld BC, help_str
    call print_str
    ret

cmd_cls:
    call clr_screen
    ret

;----------------
; BC=addr       ;
;---------------;
cmd_peek:
    ld A, (BC)
    ret

;----------------
; BC=addr       ;
; D=value       ;
;---------------;
cmd_poke:
    ld A, D
    ld (BC), A
    ret

cmd_rand:
    call rnd_byte
    ld B, A
    ld A, 13
    call print_char
    ld A, B
    call print_byte
    ret

help_str:
    defb 13, 13, "AVAILABLE COMMANDS:", 13, 13
    defb "HELP  Show commands", 13
    defb "CLS   Clear screen", 13
    defb "PEEK  Read memory address", 13
    defb "POKE  Write memory address", 13
    defb "RAND  Generate random byte", 13, 0