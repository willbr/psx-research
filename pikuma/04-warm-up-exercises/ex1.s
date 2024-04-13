.psx
.create "exercise1.bin", 0x80010000
.org 0x80010000
Main:
    li $t0, 0x01  ; t0 = 1
    li $t1, 0x100 ; t1 = 256
    li $t2, 0x11  ; t2 = 17
End:
.close

