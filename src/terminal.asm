INPUT_SIZE  equ 32
CMD_HELP    equ 1
CMD_CLR     equ 2
CMD_RAND    equ 3

term_run:
    ld BC, shell
    call print_str
_loop:
    call kb_poll
    jr z, _loop
    
    call kb_read
    cp KEY_ENTER
    jr z, _cmd_exe
    
    call term_input
    jr _wait_release
    
_cmd_exe:
    call cmd_execute
    ld BC, shell
    call print_str

_wait_release:
    call kb_poll
    jr nz, _wait_release

    jr _loop

;------------------------
; A = input character   ;
;------------------------
term_input:
    ld B, A

    ; Check buffer capacity
    ld A, (input_length)
    cp INPUT_SIZE
    ret NC

    ; HL = input_buffer + input_length
    ld HL, input_buffer
    ld E, A
    ld D, 0
    add HL, DE

    ; Store character
    ld (HL), B

    ; Increment input length
    ld A, (input_length)
    inc A
    ld (input_length), A

    ; Print character
    ld A, B
    call print_char
    ret

cmd_execute:
    ld A, (input_length)
    ld E, A
    ld D, 0

    ld HL, input_buffer
    add HL, DE
    ; put null terminator
    ld (HL), 0 

    call command_execute

    ; Clear input buffer
    xor A
    ld (input_length), A
    ret

command_execute:
    ld DE, cmd_map
_next_cmd:
     ld HL, input_buffer

_cmp_loop:
    ld A, (DE)
    cp (HL)
    jr nz, _next

    or A
    jr z, _found

    inc HL
    inc DE
    jr _cmp_loop

_next:
    ; Skip the remaining characters of this command
    ld A, (DE)
    inc DE
    or A
    jr nz, _next

    inc DE
    ; DE now points to the next command
    ld A, (DE)
    or A
    jr z, _cmd_unknown
    jr _next_cmd

_found:
    inc DE
    ld A, (DE)

    cp CMD_HELP
    jr z, _cmd_help

    cp CMD_CLR
    jr z, _cmd_clr

    cp CMD_RAND
    jr z, _cmd_rand

_cmd_help:
    call cmd_help
    ret
_cmd_clr:
    call cmd_clr
    ret
_cmd_rand:
    call cmd_rand
    ret
_cmd_unknown:
    ld BC, unknown
    call print_str
    ret

cmd_map:
    db "HELP", 0, CMD_HELP
    db "CLR", 0, CMD_CLR
    db "RAND", 0, CMD_RAND

unknown:
    defb 13, "UNKNOWN COMMAND", 13, 0

shell:
    defb 13, "MATRIZX>", 0

input_buffer:
    defs INPUT_SIZE, 0

input_length:
    db 0