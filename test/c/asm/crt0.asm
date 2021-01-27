.extern mips_main
.global start

start:
    nop
main:
    lui  $sp, 0x1 #$sp = 0x00010000
    nop
    jal mips_main
    add $v1, $zero, $v0
    nop
    j end
    
end:
    nop
    j end
    nop
