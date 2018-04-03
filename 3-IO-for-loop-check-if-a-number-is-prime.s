# write a program that check if an entered number is prime or not
.data
  command: .asciiz "Enter a number: "
  yes: .asciiz "This is a prime number!"
  no: .asciiz "This is not a prime number!"
  
.text
  .globl main
main:
  li $v0, 4
  la $a0, command
  syscall
  
  li $v0, 5
  syscall

  move $t0, $v0
# An easy ALGORITHM
# for (int i = 1; i <= number; i++) { 
#   if (number % i == 0) count++ 
# }
# return count == 2
IS_PRIME:
  li $t1, 0 # create count variable
  li $t2, 1 # i : 
IS_PRIME_LOOP:
  div $t0, $t2
  mfhi $t3 # store the ramainder into $t3

  beq $t3, 0, INCREASE_COUNT
  j INCREASE_I
 
INCREASE_COUNT:
  addi $t1, $t1, 1

INCREASE_I:
  addi $t2, $t2, 1
  slt $t4, $t0, $t2 # check if i > number, store boolean value in $t4
  beq $t4, 0, IS_PRIME_LOOP

  # loop end
  li $v0, 4
  beq $t1, 2, YES
  j NO

YES:
  la $a0, yes
  j EXIT

NO:
  la $a0, no

EXIT:
  syscall  