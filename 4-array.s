.data
  cmd1: .asciiz "Enter size of array: "
  end: .asciiz "Max size 10"
  text0: .asciiz "Enter "
  text1: .asciiz "arr["
  text2: .asciiz "] = "
  newline: .asciiz "\n"
  .align 10
  arr: .space 40 # an array of maximum 10 elements
.text
  .globl main
main:
  li $v0, 4
  la $a0, cmd1
  syscall # print cmd1

  li $v0, 5
  syscall

  li $t0, 10
  slt $t1, $t0, $v0 # check if entered size is greater than 10, if true exit
  beq $t1, 1, INVALID  

  move $s0, $v0 # store size in $s0

  la $s1, arr # load address of the first element in array into $s1
  li $t1, 0 # initialize array with i = 0

LOOP:
  beq $t1, $s0, OUTPUT
  li $v0, 4
  la $a0, text0
  syscall 

  li $v0, 4
  la $a0, text1
  syscall # print Enter arr[nth]

  li $v0, 1
  move $a0, $t1
  syscall

  li $v0, 4
  la $a0, text2
  syscall
  li $v0, 5

  syscall
  sw $v0, ($s1)

  addi	$s1, $s1, 4			# increase offset
  addi $t1, $t1, 1
  j LOOP

INVALID:
  li $v0, 4
  la $a0, end
  syscall
  j END

OUTPUT:
  li $t1 0
  la $s1, arr # load address of the first element in array into $s1

OUTPUT.LOOP:
  beq $t1, $s0, END
  li $v0, 4
  la $a0, text1
  syscall # print Enter arr[nth]

  li $v0, 1
  move $a0, $t1
  syscall

  li $v0, 4
  la $a0, text2
  syscall

  li $v0, 1
  lw $a0, ($s1)
  syscall

  addi $s1, $s1, 4
  addi $t1, $t1, 1

  li $v0, 4
  la $a0, newline
  syscall

  j OUTPUT.LOOP
END:
  li	$v0, 10		# system call code for exit = 10
	syscall		
