.data
  number: .word 5
  isOdd: .asciiz "This is an odd number"
  isEven: .asciiz "This is an even number"
.text
  .globl main
main:
  # write conditions that check number is odd or even
  lw $t0 2
  la $t1 number # load address of nubmer into register t1
  div $t1, $t0
  mflo $s0 # store quotient
  mfhi $s1 # store remainder
  li $v0, 4
  beq $s1, 1, ODD
	j EVEN
  
ODD:
	la $a0, isOdd
	j EXIT

EVEN:
	la $a0, isEven
  j EXIT

EXIT:
  syscall