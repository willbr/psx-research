```asm
li $t0, 10 ; load immediate value into register
li $t1, 0xfe

Label:
    la $t2, Label ; load address

    lb $t3,0x8000($t0) ; $t3 = *(0x8000 + $t0)

    lbu $t3,0x8000($t0) ; $t3 = *(0x8000 + (uint32)$t0)
    ; load byte unsigned

    lui $t3, 0x8001 ; $t3 - 0x80010000
    ;                         ^^^^
    ; load upper immediate
```

                

# Size of MIPS Types

|instruction|name|size|bits|
|--|-------|---------|---------|
|lb|  BYTE | 1 byte  | 8 bits  |
|lh|  HALF | 2 bytes | 16 bits |
|lw|  WORD | 4 bytes | 32 bits |
|??| DWORD | 7 bytes | 64 bits |

```c
 int main() {
    char      var1; // 1 byte
    short     var2; // 2 byte
    int       var3; // 4 byte
    long      var4; // 4 byte
    long long var5; // 8 byte
 }

```



# Store Instructions

```asm
    lui $t0, 0x1f80

    li $t1, 0x12345678
    sw $t1, 0x1810($t0)
    ;store one word @0x1f801810
    ; *(*word)(0x1810+$t0) = 0x12345678

    li $t1, 0x1abc
    sh $t1, 0x1810($t0)
    ;store one word @0x1f801810
    ; *(*half)(0x1810+$t0) = 0x12345678

    li $t1, 0x1abc
    sh $t1, 0x1810($t0)
    ;store one word @0x1f801810
    ; *(*half)(0x1810+$t0) = 0x12345678

    li $t1, 0xf1
    sb $t1, 0x1810($t0)
    ;store one word @0x1f801810
    ; *(*byte)(0x1810+$t0) = 0x12345678
```


# Add & Substract Instructions

```asm

    add $t0, $t1, $t2
    ; signed addition
    ; t0 = t1 + t2


    sub $a0, $a0, $a2
    ; a0 -= a2

    addi $t0, $t1, 5
    ; t0 = t1 + 5

    addi $s0, $s1, -5
    ; s0 = s1 - 5
    ; There is no subi instruction!


    addu $s0, $s1, $s1
    ; s0 = s1 + s1
    ; unsigned

    addiu $s0, $s1, 7
    ; s0 = s1 + 7

```


# Jump Instructions

```asm
Loop:
    ; unconditional jump
    j Loop
    nop

    ; jump to register
    la $a3, 0x80010001
    jr $a3
    nop

    ; jump and link
    jal MySubroutine
    nop

```

# Branch Instructions

```asm
Loop:
    beq $t0, $t1, Loop ; Branch if equals
    nop

    bne $0, $1, Loop ; Branch if not equals
    nop

    ; blt / bltu Branch if less than         (signed/unsigned)
    ; bgt / bgtu Brach if greater than       (signed/unsigned)
    ; ble / bleu Branch if less or equals    (signed/unsigned)
    ; bge / bgeu Branch if greater or equals (signed/unsigned)
```
