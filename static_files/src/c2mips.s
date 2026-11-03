.data
source:
    .word   3, 1, 4, 1, 5, 9, 0
dest:
    .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0   # alternatively, one could also put:   .space  40    # ( 10 x 4 bytes ) 

.text
fun:
    addi $t0, $a0, 1    # $t0 = x + 1
    sub  $t1, $0, $a0   # $t1 = -x
    mult $t0, $t1       # $LO = (x + 1) * (-x)
    mflo $v0            # $v0 = $LO
    jr $ra              # return to caller function

main:
    # BEGIN PROLOGUE
    addi $sp, $sp, -20
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $ra, 16($sp)
    # END PROLOGUE

    addi $t0, $0, 0     # $t0 <-> k   = 0
    addi $s0, $0, 0     # $s0 <-> sum = 0

    la $s1, source
    la $s2, dest

WHILE:
    sll $s3, $t0, 2         
    add $t1, $s1, $s3       
    lw  $t2, 0($t1)         
    beq $t2, $0, ELIHW      
 
    add $a0, $0, $t2    
     
    addi $sp, $sp, -4
    sw   $t0, 0($sp)
    jal fun
    lw   $t0, 0($sp)
    addi $sp, $sp, 4

     
    add $t3, $s2, $s3   
    sw  $v0, 0($t3)      
    add $s0, $s0, $v0   

    addi $t0, $t0, 1          
    j WHILE                 

ELIHW:
    addi $v0, $0,  1   # syscall service number, 1 = 'print an integer'
    addi $a0, $s0, 0   # argument to syscall, $a0 = integer to print
    syscall            # system call (prints an integer)

    # BEGIN EPILOGUE
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    # END EPILOGUE    

    addi $v0, $0, 10    # syscall service number, 10 = program exit 
    syscall             # system call (exit the program)


