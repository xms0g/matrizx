term_run:
    ld BC, shell
    call print_str
_loop:
    call kb_poll
    jr z, _loop
    
    call kb_read
    call print_char

_wait_release:
    call kb_poll
    jr NZ, _wait_release

    jr _loop

shell:
    defb 13, "MATRIZX>", 0