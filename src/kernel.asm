	org $8000

    jp start

    include "constants.inc"
    include "video.asm"
    include "terminal.asm"
    include "keyboard.asm"
    
start:
    call init_video
    
    ld BC, init_msg
    call print_str
    
    ld BC, shell
    call print_str

main_loop:
    call tm_run

init_msg:
    defb "MATRIZX v0.1", 13
    defb "Z80 CYBERNETIC SYSTEM", 13, 0

end $8000
