
.psx
.create "image24.bin", 0x80010000

.org 0x80010000

numlines: .word 0
score:    .word 0

; IO Port
IO_BASE_ADDR equ 0x1f80

; GPU Registers
GP0 equ 0x1810  ; Rending data & VRAM access
GP1 equ 0x1814  ; Display Control & Enviroment setup

IMG_WIDTH      equ 640
IMG_HEIGHT     equ 480
IMG_SIZE_BYTES equ 921600   ; 640 * 480 * 3 ; 24bpp


Main:
    la $sp, 0x00103cf0 ; init stack pointer

    lui $a0, IO_BASE_ADDR

    ;; setup display control

    li $t1, 0x00000000 ; reset GPU
    sw $t1, GP1($a0)   ; write packet to GP1

    li $t1, 0x03000000 ; enable display
    sw $t1, GP1($a0)   ; write packet to GP1

    ;li $t1, 0x06c60260 ; Horz Display Range    (3168..608)
    li $t1, 0x06260c56
    ;li $t1, 0x06c56260
    sw $t1, GP1($a0)   ; write packet to GP1

    ;li $t1, 0x0707e018 ; Vert Display Range    (504..24)
    li $t1, 0x07100010
    sw $t1, GP1($a0)   ; write packet to GP1

    ;li $t1, 0x08000001 ; set display mode 320x240, 15bit, NTSC
    li $t1, 0x08000037 ;  set display mode 640x480, 24bit, NTSC, interlace
    sw $t1, GP1($a0)   ; write packet to GP1


    ;; setup vram access

    li $t1, 0xe1000400
    sw $t1, GP0($a0)   ; e1 draw mode

    li $t1, 0xe3000000
    sw $t1, GP0($a0)   ; drawing area top left

    li $t1, 0xe403bd3f ; 239 319
    sw $t1, GP0($a0)   ; drawing area bottom right

    li $t1, 0xe5000000
    sw $t1, GP0($a0)   ; drawing offset



    ; copy rect to VRAM
    li $t1, 0xa0000000
    sw $t1, GP0($a0)

    ; copy onscreen
    ;li $t1, 0x00640096 ; copy area top left
    ;sw $t1, GP0($a0)

    ; copy offscreen
    li $t1, 0x00000000 ; x, y = 0, 0
    sw $t1, GP0($a0)

    ;li $t1, 0x01e003c0 ; 0xhhhhwwww width & height
    li $t1, 0x01e00280 ; 0xhhhhwwww width & height
    sw $t1, GP0($a0)


    ;; send pixel data word by word
    ;; calculate the number of words
    li   $t0, IMG_SIZE_BYTES
    srl  $t0, 2           ; t0 >> 2 ; t0/4

    la $t2, Image
LoopWords:
    lw $t1, 0($t2)        ; t1 = *t2
    nop
    sw $t1, GP0($a0)
    addiu $t2, 4          ; t2 += 4
    addiu $t0, $t0, -1    ; t0 -= 1
    bnez  $t0, LoopWords  ; while (t0 != 0)
    nop


inf:
    j inf
    nop


Image:
    .incbin "logo.bin"

.close

