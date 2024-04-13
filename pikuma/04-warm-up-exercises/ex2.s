.psx
.create "exercise2.bin", 0x80010000
.org 0x80010000

Main:
    li $t0, 0x01
    li $t1, 0x00

    j Test
    nop

    Loop:
        add  $t1, $t1, $t0  ; t1 += t0
        addi $t0, $t0, 0x01 ; t0 += 1

    Test:
        ble $t0, 0x0a, Loop
        nop

End:
.close
