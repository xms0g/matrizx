INPUT_SIZE  equ 32
ADDR_LENGTH equ 6
CMD_HELP    equ 1
CMD_CLS     equ 2
CMD_PEEK    equ 3
CMD_POKE    equ 4
CMD_RAND    equ 5
CMD_RAIN    equ 6

term_run:
    ld BC, shell
    call print_str
_loop:
    call kb_poll
    jr z, _loop
    
    call kb_read
    cp KEY_ENTER
    jr z, _parse_cmd
    
    call term_input
    jr _wait_release
    
_parse_cmd:
    call parse_cmd
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
    cp INPUT_SIZE-1
    ret nc

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

parse_cmd:
    ld A, (input_length)
    ld E, A
    ld D, 0

    ld HL, input_buffer
    add HL, DE
    ; put null terminator
    ld (HL), 0 

    call cmp_command

    ; Clear input buffer
    xor A
    ld (input_length), A
    ret

cmp_command:
    ld DE, cmd_map
_next_cmd:
    ld HL, input_buffer

_cmp_loop:
    ld A, (DE)
    cp (HL)
    jr nz, _next

    or A
    jr z, _dispatch

    inc HL
    inc DE
    
    ld A, (HL)
    cp KEY_SPACE
    jr z, _parse_arg
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
    jr z, _unknown
    jr _next_cmd

_parse_arg:
    ld BC, cmd_arg1
_p_loop:
    inc HL
    ; HL now points to the arg
    ld A, (HL)
    or A
    jr z, _args_done

    cp KEY_SPACE
    jr z, _p_2nd_arg
    
    ld (BC), A
    inc BC

    jr _p_loop
_p_2nd_arg:
    ; put null terminator for first arg
    xor A
    ld (BC), A

    ld BC, cmd_arg2
    jr _p_loop
_args_done:
    ld HL, cmd_arg1
    push DE
    call str_atoi
    pop DE
    
    ; HL now contains the first argument as a 16-bit integer
    push HL
    push DE
    ld HL, cmd_arg2
    call str_atoi
    
    ld B, H
    ld C, L
    
    pop DE
    pop HL

_dispatch:
    inc DE
    ld A, (DE)

    cp CMD_HELP
    jr z, _cmd_help

    cp CMD_CLS
    jr z, _cmd_cls

    cp CMD_PEEK
    jr z, _cmd_peek

    cp CMD_POKE
    jr z, _cmd_poke

    cp CMD_RAND
    jr z, _cmd_rand

    cp CMD_RAIN
    jr z, _cmd_rain

_cmd_help:
    ld BC, help_str
    call print_str
    ret
_cmd_cls:
    call clr_screen
    ret
_cmd_peek:
    ld A, 13
    call print_char
    call mem_peek
    call print_byte
    ret
_cmd_poke:
    call mem_poke
    ret
_cmd_rand:
    ld A, 13
    call print_char
    call rnd_byte
    call print_byte
    ret
_cmd_rain:
    call rain_run
    call clr_screen
    ret
_unknown:
    ld BC, unknown
    call print_str
    ret

cmd_map:
    db "HELP", 0, CMD_HELP
    db "CLS", 0, CMD_CLS
    db "PEEK", 0, CMD_PEEK
    db "POKE", 0, CMD_POKE
    db "RAND", 0, CMD_RAND
    db "RAIN", 0, CMD_RAIN, 0

help_str:
    defb 13, 13, "AVAILABLE COMMANDS:", 13, 13
    defb "HELP  CLS  RAND", 13
    defb "PEEK  POKE RAIN", 13, 0

unknown:
    defb 13, "UNKNOWN COMMAND", 13, 0

shell:
    defb 13, "MATRIZX>", 0

input_buffer:
    defs INPUT_SIZE, 0

input_length:
    db 0

cmd_arg1:
    defs ADDR_LENGTH, 0

cmd_arg2:
    defs ADDR_LENGTH, 0