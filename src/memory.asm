;---------------;
; HL=addr       ;
;---------------;
mem_peek:
    ld A, (HL)
    ret

;---------------;
; HL=addr       ;
; BC=value      ;
;---------------;
mem_poke:
    ld (HL), C
    ret