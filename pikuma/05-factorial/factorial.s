.psx
.create "factorial.bin", 0x80010000

.org 0x80010000

Main:

    li $a0, 5
    jal Factorial
    nop

LoopForever:
    j LoopForever
    nop


;; Compute Factorial
;; Argument: num ($a0)
;; $v0 = Factorial($a0)
Factorial:
    li $t1, 1
    li $t2, 1
    li $t3, 1

    WhileOuter:
        bgt $t1, $a0, EndWhileOuter
        nop

        li $t4, 0
        li $t2, 0

        WhileInner:
            bge $t2, $t1, EndWhileInner
            nop

            add  $t4, $t4, $t3
            addi $t2, $t2, 1

            j WhileInner
            nop

        EndWhileInner:

        move $t3, $t4
        addi $t1, $t1, 1

        j WhileOuter
        nop

    EndWhileOuter:

    move $v0, $t4

    jr $ra            ; return to caller $ra is return address


.close
