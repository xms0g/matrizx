	org $8000

    jp start

    include "random.asm"
    include "video.asm"
    include "commands.asm"
    include "terminal.asm"
    include "keyboard.asm"
    
start:
    call init_video
    call init_rnd
    
    ld BC, init_msg
    call print_str

main_loop:
    call term_run

init_msg:
    defb "MATRIZX v0.1", 13
    defb "Z80 CYBERNETIC SYSTEM", 13, 0

end $8000
