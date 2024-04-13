.psx
.create "fillmem.bin", 0x80010000

; Entry Point of Code
.org 0x80010000

; Constant declaration
BASE_ADDR equ 0x0000

Main:
    li $t0, 0xa000             ; $t0 = 0xa000
    li $t1, 0xa0ff             ; $t1 = 0xa0ff
    li $t2, 0x12345678         ; $t2 = 0x12345678

Loop:
    sw   $t2, BASE_ADDR($t0)   ; *(*byte)(0x0000 + t0) = t2
    addi $t0, $t0, 4           ; to += 1
    ble  $t0, $t1, Loop        ; while (t0<t1) goto Loop

.close

