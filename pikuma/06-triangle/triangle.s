.psx
.create "triangle.bin", 0x80010000

.org 0x80010000

; IO Port
IO_BASE_ADDR equ 0x1f80

; GPU Registers
GP0 equ 0x1810  ; Rending data & VRAM access
GP1 equ 0x1814  ; Display Control & Enviroment setup

Main:
    lui $t0, IO_BASE_ADDR

    ;; setup display control

    li $t1, 0x00000000 ; reset GPU
    sw $t1, GP1($t0)   ; write packet to GP1

    li $t1, 0x03000000 ; enable display
    sw $t1, GP1($t0)   ; write packet to GP1

    li $t1, 0x08000001 ; set display mode 320x240, 15bit, NTSC
    sw $t1, GP1($t0)   ; write packet to GP1

    li $t1, 0x06c60260 ; Horz Display Range
    sw $t1, GP1($t0)   ; write packet to GP1

    li $t1, 0x07042018 ; Vert Display Range
    sw $t1, GP1($t0)   ; write packet to GP1

    ;; setup vram access

    li $t1, 0xe1000400
    sw $t1, GP0($t0)   ; e1 draw mode

    li $t1, 0xe3000000
    sw $t1, GP0($t0)   ; drawing area top left

    li $t1, 0xe403bd3f ; 239 319
    sw $t1, GP0($t0)   ; drawing area bottom right

    li $t1, 0xe5000000
    sw $t1, GP0($t0)   ; drawing offset

    ;; clear screen

    li $t1, 0x02422e1b
    sw $t1, GP0($t0) ; fill rectangle with colour 00ff00

    li $t1, 0x00000000
    sw $t1, GP0($t0) ; top left corner

    li $t1, 0x00f00140
    ;li $t1, 0x00ef013f
    sw $t1, GP0($t0) ; width+height

    ;; draw triangle

    li $t1, 0x2000d7ff
    sw $t1, GP0($t0) ; top left corner

    li $t1, 0x003200a0
    sw $t1, GP0($t0) ; top left corner

    li $t1, 0x00c80050
    sw $t1, GP0($t0) ; top left corner

    li $t1, 0x00c800f0
    sw $t1, GP0($t0) ; top left corner


inf:
    j inf
    nop

.close

