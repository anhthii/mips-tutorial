## This first must-do program when you learn a new language
.data # define variables that are stored in memory
  text: .asciiz "Hello world!" # define a string

.text # store things in registers and do all kind of instructions
  .globl main

main:
  li $v0, 4 # prepare to print the string
  la $a0, text # load address of string to be printed into argument register load address of string to be printed into $a0
  syscall
