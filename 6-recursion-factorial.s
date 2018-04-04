.data
  msg1: .asciiz "Enter a number: "
  msg2: .asciiz "Factorial of "
	msg3: .asciiz " is: "

.text
  .globl main

main:
  li $v0, 4
  la $a0, msg1
  syscall

  li $v0, 5
  syscall
  move $a0, $v0

	jal factorial

	move $t0, $a0 # move n parameter into $t0
	move $t1, $v0 # move result in $v0 into $t1

	li $v0, 4
	la $a0, msg2
	syscall

	li $v0, 1
	move $a0, $t0
	syscall

	li $v0, 4
	la $a0, msg3
	syscall

	li $v0, 1
	move $a0, $t1 
	syscall

	li $v0, 10
	syscall

factorial:
	# Push rest of stack frame.  Already contains argument
	# pushed by caller.
	addi    $sp, $sp, -8 
	sw      $ra, 4($sp)
	sw      $a0, 0($sp)
	# Initialize N! to 1 and then multiply by all values from N to 2
	li      $v0, 1

factorial_loop:
	blt     $a0, 2, factorial_done
	mul     $v0, $v0, $a0
	addi    $a0, $a0, -1
	j       factorial_loop
	
factorial_done:
	
	# Pop stack frame
	lw      $a0, 0($sp)
	lw      $ra, 4($sp)
	addi    $sp, $sp, 8    # Account for argument on stack
	jr      $ra




