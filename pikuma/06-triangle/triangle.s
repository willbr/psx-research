.psx
.create "triangle.bin", 0x80010000

.org 0x80010000

numlines: .word 0
score:    .word 0

; IO Port
IO_BASE_ADDR equ 0x1f80

; GPU Registers
GP0 equ 0x1810  ; Rending data & VRAM access
GP1 equ 0x1814  ; Display Control & Enviroment setup

Main:
    la $t0, score
    li $t1, 0xbeefcafe
    sw $t1, 0($t0)

    lui $a0, IO_BASE_ADDR

    ;; setup display control

    li $t1, 0x00000000 ; reset GPU
    sw $t1, GP1($a0)   ; write packet to GP1

    li $t1, 0x03000000 ; enable display
    sw $t1, GP1($a0)   ; write packet to GP1

    li $t1, 0x08000001 ; set display mode 320x240, 15bit, NTSC
    sw $t1, GP1($a0)   ; write packet to GP1

    li $t1, 0x06c60260 ; Horz Display Range
    sw $t1, GP1($a0)   ; write packet to GP1

    li $t1, 0x07042018 ; Vert Display Range
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

    ;; clear screen

    li $t1, 0x02422e1b
    sw $t1, GP0($a0) ; fill rectangle with colour 00ff00

    li $t1, 0x00000000
    sw $t1, GP0($a0) ; top left corner

    li $t1, 0x00f00140
    ;li $t1, 0x00ef013f
    sw $t1, GP0($a0) ; width+height

    ;; draw triangle

    li $t1, 0x2000d7ff
    sw $t1, GP0($a0) ; top left corner

    li $t1, 0x003200a0
    sw $t1, GP0($a0) ; top left corner

    li $t1, 0x00c80050
    sw $t1, GP0($a0) ; top left corner

    li $t1, 0x00c800f0
    sw $t1, GP0($a0) ; top left corner



    ; gourand shaded triangle
    li $t1, 0x30ff31ff ; cmd and colour 1
    sw $t1, GP0($a0)

    li $t1, 0x00b40014 ; vertex 1
    sw $t1, GP0($a0)

    li $t1, 0x00a88332 ; colour 2
    sw $t1, GP0($a0)

    li $t1, 0x006400a0 ; vertex 2
    sw $t1, GP0($a0)

    li $t1, 0x0000ff00 ; colour 3
    sw $t1, GP0($a0)

    li $t1, 0x00e6004b ; vertex 3
    sw $t1, GP0($a0)


    li  $s0, 0xffff00
    li  $s1, 200
    li  $s2, 40
    li  $s3, 288
    li  $s4, 56
    li  $s5, 224
    li  $s6, 200
    jal DrawFlatTriangle
    nop



    la $sp, 0x00103cf0 ; init stack pointer

    addiu $sp, -(4 * 7)

    li $t0, 0xff4472
    sw $t0, 0($sp)

    li $t0, 0
    sw $t0, 4($sp)

    li $t0, 40
    sw $t0, 8($sp)

    li $t0, 200
    sw $t0, 12($sp)

    li $t0, 50
    sw $t0, 16($sp)

    li $t0, 200
    sw $t0, 20($sp)

    li $t0, 200
    sw $t0, 24($sp)


    jal DrawFlatTriangle2
    nop


inf:
    j inf
    nop



    ; Args:
    ; $a0 = IO_BASE_ADDR
    ; $s0 = colour 0xbbggrr
    ; $s1 = x1
    ; $s2 = y1
    ; $s3 = x2
    ; $s4 = y2
    ; $s5 = x3
    ; $s6 = y3
DrawFlatTriangle:
    lui  $t0, 0x2000        ; Command 0x20 flat triangle
    or   $t1, $t0, $s0      ; Command | Colour
    sw   $t1, GP0($a0)      ; Write to GP0 command and colour

    sll  $s2, $s2, 16       ; y1 <<= 16
    andi $s1, $s1, 0xffff   ; x1 &= 0xffff
    or   $t1, $s1, $s2      ; x1 | y1
    sw   $t1, GP0($a0)      ; Write to GP0

    sll  $s4, $s4, 16
    andi $s3, $s3, 0xffff
    or   $t1, $s3, $s4
    sw   $t1, GP0($a0)

    sll  $s6, $s6, 16
    andi $s5, $s5, 0xffff
    or   $t1, $s5, $s6
    sw   $t1, GP0($a0)

    jr $ra
    nop

DrawFlatTriangle2:
    lui  $t0, 0x2000        ; Command 0x20 flat triangle
    lw   $t1, 0($sp)
    nop
    or   $t8, $t0, $t1
    sw   $t8, GP0($a0)      ; Write to GP0 command and colour

    lw   $t1, 4($sp)
    lw   $t2, 8($sp)
    nop
    sll  $t2, $t2, 16       ; y1 <<= 16
    andi $t1, $t1, 0xffff   ; x1 &= 0xffff
    or   $t8, $t1, $t2      ; x1 | y1
    sw   $t8, GP0($a0)      ; Write to GP0

    lw   $t1, 12($sp)
    lw   $t2, 16($sp)
    nop
    sll  $t2, $t2, 16
    andi $t1, $t1, 0xffff
    or   $t8, $t1, $t2
    sw   $t8, GP0($a0)

    lw   $t1, 20($sp)
    lw   $t2, 24($sp)
    nop
    sll  $t2, $t2, 16
    andi $t1, $t1, 0xffff
    or   $t8, $t1, $t2
    sw   $t8, GP0($a0)

    addiu $sp, $sp, (4 * 7)

    jr $ra
    nop



.close
