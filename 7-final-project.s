.data
  title: .asciiz "============================== Menu ==============================\n"
  .align 10
  arr: .space 40 # khai bao mang toi da gom 10 phan tu
  n: .word 0 # khai bao so phan tu cua mang
  valid: .word 0 # khai bao bien kiem tra xem mang da duoc nhap hay chua
  newline: .asciiz "\n"
  debug: .asciiz "debug"

  cmd0: .asciiz "Nhap yeu cau: "
  cmd1: .asciiz "1. Nhap mang\n"
  cmd2: .asciiz "2. Xuat mang\n"
  cmd3: .asciiz "3. Liet ke so nguyen to trong mang\n"
  cmd4: .asciiz "4. Liet ke so hoan thien trong mang\n"
  cmd5: .asciiz "5. Tinh tong cac so chinh phuong trong mang\n"
  cmd6: .asciiz "6. Tinh trung binh cong cac so doi xung trong mang\n"
  cmd7: .asciiz "7. Tim gia tri lon nhat trong mang\n"
  cmd8: .asciiz "8. Sap xep mang tang dan theo Selection sort\n"
  cmd9: .asciiz "9. Sap xep mang giam dan theo Bubble sort\n"
  cmd10: .asciiz "10. Thoat\n"
  
  msg0: .asciiz "Ban phai nhap mang truoc khi thuc hien cac yeu cau khac!\n"
  msg1: .asciiz "Nhap so phan tu cua mang, toi da 10: "
  msg2: .asciiz "so phan tu khong duoc qua 10\n"
  msg3: .asciiz "nhap phan tu "
  msg4: .asciiz "arr["
  msg5: .asciiz "] = "
  msg6: .asciiz "mang vua nhap: \n"

.text
  .globl main
main:
  li $v0, 4
  la $a0, title 
  syscall

PRINT_COMMAND: # in yeu cau
  li $v0, 4
  la $a0, cmd1 
  syscall

  li $v0, 4
  la $a0, cmd2
  syscall

  li $v0, 4
  la $a0, cmd3 
  syscall

  li $v0, 4
  la $a0, cmd4 
  syscall

  li $v0, 4
  la $a0, cmd5 
  syscall

  li $v0, 4
  la $a0, cmd6 
  syscall

  li $v0, 4
  la $a0, cmd7 
  syscall

  li $v0, 4
  la $a0, cmd8 
  syscall

  li $v0, 4
  la $a0, cmd9
  syscall

  li $v0, 4
  la $a0, cmd10
  syscall

ENTER_COMMAND:
  li $v0, 4
  la $a0, cmd0
  syscall

  li $v0, 5
  syscall # nhap yeu cau

  beq $v0, 10, CMD10 # neu yeu cau = 10, ket thuc chuong trinh
  bne $v0, 1, CHECK_VALID # nếu yêu cầu không phải = 1 , kiểm tra xem mảng đã được nhập hay chưa
  j CMD1  # neu yeu cau = 1, nhay den buoc nhap mang 
CHECK_VALID:
  lw $t0, valid
  beq $t0, 0, REENTER_COMMAND # neu mang chua duoc nhap yeu cau nhap lai 
  # neu mang da duoc nhap roi, thuc hien switch case

  beq $v0, 1, CMD1
  beq $v0, 2, CMD2
  #beq $v0, 3, CMD3
  #beq $v0, 4, CMD4
  #beq $v0, 5, CMD5
  #beq $v0, 6, CMD6
  #beq $v0, 7, CMD7
  #beq $v0, 8, CMD8
  #beq $v0, 9, CMD9
  #beq $v0, 10, CMD10

REENTER_COMMAND:
  li $v0, 4
  la $a0, msg0
  syscall
  j ENTER_COMMAND

CMD1:  # nhap mang

    CMD1_ENTER_N: # nhap n phan tu cua mang
      li $v0, 4
      la $a0, msg1
      syscall

      li $v0, 5
      syscall
      sw $v0, n # gan' gia tri vua nhap cho n luu vao RAM
      lw $s0, n # lay gia tri n de thuc hien cac buoc khac

      li $t0, 10 # luu so 10 vao $t0
      slt $t1, $t0, $s0 # kiem tra xem n co vuot qua 10 khong, luu bien' boolean  vao trong $t1
      beq $t1, 1, CMD1_N_IS_INVALID # neu $t1 == 1, khong hop le, nhap lai
      # neu $t1 == 0
      la $s1, arr # load dia chi cua phan tu dau tien trong mang vao $s1
      li $t0, 0 # khai bao' bien' dem' i = 0

      # thuc hien vong lap de nhap mang
    CMD1_LOOP:
      beq $t0, $s0, CMD1_END_LOOP # kiem tra i == n chua
      li $v0, 4
      la $a0, msg3
      syscall 

      li $v0, 4
      la $a0, msg4
      syscall # in arr[

      li $v0, 1
      move $a0, $t0
      syscall # in (i)

      li $v0, 4
      la $a0, msg5
      syscall # in ]
      
      li $v0, 5
      syscall

      sw $v0, ($s1) # luu gia tri vua nhap vao dia chi

      addi $s1, $s1, 4			# tang offset
      addi $t0, $t0, 1 # tang ben dem i them 1
      j CMD1_LOOP

    CMD1_END_LOOP:
      beq $s0, 1, ENTER_COMMAND # neu mang vua nhap khong co phan tu nao, quay lai buoc chon yeu cau
      li $t0, 1
      sw $t0, valid # chuyen bien valid thanh TRUE = 1, luc nay mang da hop le  
      j ENTER_COMMAND # quay ve buoc chon yeu cau: 1, 2,3 , 4...

    CMD1_N_IS_INVALID: # in ra n khong hop le
      li $v0, 4
      la $a0, msg2
      syscall
      j CMD1_ENTER_N

CMD2: # xuat mang
  lw $s0, n # lay n
  la $s1, arr # load dia chi cua phan tu dau tien trong mang vao $s1
  li $t0, 0 # khai bao bien dem i = 0
  
  li $v0, 4
  la $a0, msg6 # in ra " mang vua nhap la: "
  syscall

    CMD2_LOOP: # thuc hien lap de in cac phan tu
      beq $t0, $s0, CMD2_END_LOOP # neu i == n , ket thuc vong lap

      li $v0, 4
      la $a0, msg4
      syscall # in "arr["

      li $v0, 1
      move $a0, $t0 # in "(i)"
      syscall

      li $v0, 4
      la $a0, msg5
      syscall # in "]="

      li $v0, 1
      lw $a0, ($s1)
      syscall

      addi $s1, $s1, 4
      addi $t0, $t0, 1

      li $v0, 4
      la $a0, newline
      syscall
      j CMD2_LOOP 

    CMD2_END_LOOP:
      j ENTER_COMMAND

CMD10:
  li $v0, 10
  syscall

