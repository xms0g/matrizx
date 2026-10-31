cmd_help:
    ld BC, help_str
    call print_str
    ret

cmd_clr:
    call clr_screen
    ret

cmd_rain:
    call rain_run
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
    defb "CLR   Clear screen", 13
    defb "RAIN  Digital rain", 13
    defb "RAND  Generate random byte", 13, 0