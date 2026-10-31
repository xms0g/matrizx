init_rnd:
    ; get ROM SEED variable
    ld A, ($5C76)
    or A
    jr nz, _save_seed
    inc A
 _save_seed:
    ld (random_seed), A
    ret

rnd_byte:
    ld A,(random_seed)
    srl A
    jr nc, _save
    xor 0B8h
_save:
    ld (random_seed), A
    ret

random_seed:
    db 0