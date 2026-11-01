TRAIL_LENGTH equ 10

init_rain:
    ld HL, heads
    ld DE, delays
    ld B, COLUMNS

_loop:
    call rnd_byte
    and $1F
    ld (HL), A
    inc HL

    call rnd_byte
    and $03
    ld (DE), A
    inc DE

    djnz _loop
    ret

rain_run:
_loop:
    halt                    ; Wait for frame interrupt
    call animate
    call kb_poll
    jr z, _loop
    
    call kb_read
    cp 'Q'
    jr z, _done
    jr _loop
_done:
    ret
    
animate:
    push IX
    push IY
    ld IX, heads
    ld IY, delays
    xor A
    ld (column), A

column_loop:
    ; Decrease delay if it is nonzero
    ld A, (IY+0)
    or A
    jr z, update_column

    dec (IY+0)
    jp advance_column

update_column:
    ; New delay: 1..4
    call rnd_byte
    and $03
    inc A
    ld (IY+0), A

    ; Current head position
    ld A, (IX+0)
    ld (head_row), A

    ; Erase the old tail:
    ; row = head - TRAIL_LENGTH - 1
    cp TRAIL_LENGTH+1
    jr c, draw_head

    sub TRAIL_LENGTH+1
    cp ROWS
    jr nc, draw_head
	ld (draw_row), A
	ld A, (column)
	ld (draw_col), A
    ld A, 32
    ld (draw_char), A
    xor A
    ld (draw_attr), A
    call draw_cell

draw_head:
    ld A, (head_row)
    cp ROWS
    jr nc, draw_trail

    ld (draw_row), A
    ld A, (column)
    ld (draw_col), A

    ; Character code: 33..96
    call rnd_byte
    and $3F
    add A, $21
    ld (draw_char), A

    ; Bright white ink on black paper
    ld A, $47
    ld (draw_attr), A
    call draw_cell

draw_trail:
    ld A, 1
    ld (trail_step), A

trail_loop:
    ld A, (trail_step)
    ld B, A
    ld A, (head_row)
    cp B
    jr c, next_trail

    sub B
    ld (draw_row), A

    ld A, (column)
    ld (draw_col), A

    ; Random character
    call rnd_byte
    and $3F
	add A, 21h
    ld (draw_char), A

    ; Green ink on black paper
    ld A, $04
    ld (draw_attr), A
    call draw_cell

next_trail:
    ld A, (trail_step)
    inc A
    ld (trail_step), A
    cp TRAIL_LENGTH+1
    jr c, trail_loop

    ; Advance the head
    ld A, (IX+0)
    inc A
    cp ROWS+TRAIL_LENGTH+1
    jr c, save_head

    ; Restart near the top: row 0..7
    call rnd_byte
    and $07

save_head:
    ld (IX+0), A

advance_column:
    inc IX
    inc IY

    ld A, (column)
    inc A
    ld (column), A
    cp COLUMNS
    jp c, column_loop

    pop IX
    pop IY
    ret

; --------------------------------------------------
; Draw one character cell
;
; Inputs:
;   draw_char = ROM character code
;   draw_row  = character row, 0..23
;   draw_col  = character column, 0..31
;   draw_attr = Spectrum color attribute
;
; --------------------------------------------------

draw_cell:
    ld A, (draw_row)
    cp ROWS
    ret nc

    ; Find the 8x8 glyph in the ROM font.
    ld A, (draw_char)
    sub 32
	ld L, A
    ld H, 0
    add HL, HL
    add HL, HL
    add HL, HL

    ld DE, ROM_FONT
    add HL, DE
    ex DE, HL               ; DE = glyph address

    ; bitmap address:
    ; 4000h + (row & 7)*32 + (row & 18h)*256 + column

    ld A, (draw_row)
    and $07
    add A, A
    add A, A
    add A, A
    add A, A
    add A, A
    ld L, A
    ld H, $40

    ld A, (draw_row)
    and $18
    add A, H
    ld H, A

    ld A, (draw_col)
    add A, L
    ld L, A

    ; Copy 8 scanlines.
    ; Spectrum scanlines are 256 bytes apart.
    ld B, 8

glyph_loop:
    ld A, (DE)
    ld (HL), A
    inc DE
    inc H
    djnz glyph_loop

    ; Attribute address = 5800h + row*32 + column
    ld A, (draw_row)
    ld L, A
    ld H, 0

    add HL, HL
    add HL, HL
    add HL, HL
    add HL, HL
    add HL, HL

    ld DE, ATTRIBUTES
    add HL, DE

    ld A, (draw_col)
    add A, L
    ld L, A
    jr nc, attribute_ready
    inc H

attribute_ready:
    ld A, (draw_attr)
    ld (HL), A

    ret

column:
    db 0

head_row:
    db 0

trail_step:
	db 0

draw_char:
    db 32

draw_row:
    db 0

draw_col:
    db 0

draw_attr:
    db 0

heads:
    defs COLUMNS,0

delays:
    defs COLUMNS,0
