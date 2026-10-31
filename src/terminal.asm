tm_run:
_loop:
    call kb_poll
    jr z, _loop
    
    call kb_read

_wait_release:
    call kb_poll
    jr NZ, _wait_release

    jr _loop

shell:
    defb 13, "MATRIZX>", 0