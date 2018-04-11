.data
  command: .asciiz "Enter a number: "
  yes: .asciiz "This is a square number!"
  no: .asciiz "This is not a square number!"
  
.text
  .globl main
main:
  li $v0, 4
  la $a0, command
  syscall
  
  li $v0, 5
  syscall

  move $t0, $v0

IS_SQUARE_NUMBER:
  li $t1, 0 # create count variable 
IS_SQUARE_NUMBER_LOOP:
  mul $t2, $t1, $t1
  slt $t3, $t2, $t0
  beq $t3, 0, END
  addi $t1, $t1, 1
  j IS_SQUARE_NUMBER_LOOP

END:
  beq $t2, $t0, YES  
  li $v0, 0
  j SQUARE_END

YES:
  li $v0, 1

SQUARE_END:
  move $a0, $v0
  li $v0, 1
  syscall