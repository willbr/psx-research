.psx
.create "factorial.bin", 0x80010000

.org 0x80010000

Main:

    li $t0, 5

    li $t1, 1
    li $t2, 1
    li $t3, 1

    WhileOuter:
        bgt $t1, $t0, EndWhileOuter
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

.close
