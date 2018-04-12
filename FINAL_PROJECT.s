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
  msg7: .asciiz "cac so nguyen to trong mang: \n"
  msg8: .asciiz "tong cac so chinh phuong trong mang la: "
  msg9: .asciiz "so lon nhat trong mang la: "
  msg10: .asciiz "mang da duoc sap theo thu tu tang dan bang selection sort"
  msg11: .asciiz "mang da duoc sap theo thu tu giam dan bang bubble sort"

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
  la $a0, cmd5 
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
  beq $v0, 3, CMD3
  #beq $v0, 4, CMD4
  beq $v0, 5, CMD5
  #beq $v0, 6, CMD6
  beq $v0, 7, CMD7
  beq $v0, 8, CMD8
  beq $v0, 9, CMD9
  beq $v0, 10, CMD10

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
      # neu $t1 = 0
      # thuc hien vong lap de nhap mang
    # khởi tạo vòng lặp, cho chỉ số i = 0
    jal ARRAY_LOOP_INITIALIZE

    CMD1_LOOP:
      # thực hiện hàm kiểm tra i = n hay chưa
      jal ARRAY_LOOP_CHECK_LAST
      # kết quả của hàm ARRAY_LOOP_CHECK_LAST được trả về trong các register $v0, $v1
      # $v0 - 1|| 0 , $v1: chỉ số(i) của mảng
      # nếu $v0 = 1, đúng - đã ở cuối mảng, kết thúc vòng lặp
      beq $v0, 1, CMD1_END_LOOP
      # lưu chỉ số(i) từ $v1 vào register $a0
      move $a0, $v1
      # hàm in `arr[i] =`, yêu cầu tham số $a0 = (i) chỉ số của mảng 
      jal PRINT_ARRAY_ELEMENT_LABEL 

      li $v0, 5 # nhập giá trị cho phần tử
      syscall
      
      move $a0, $v0 # đưa giá trị phần tử vừa nhập vào register tham số $a0
      jal SET_ARRAY_ELEMENT_VALUE # thực hiện hàm thiết lập giá trị cho phần tử của mảng
      jal ARRAY_LOOP_INCREMENT # tăng biến đếm i
      j CMD1_LOOP # quay trở lại vòng lặp

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
    jal ARRAY_LOOP_INITIALIZE
    
    CMD2_LOOP: # thuc hien lap de in cac phan tu
      jal ARRAY_LOOP_CHECK_LAST
      beq $v0, 1, CMD2_END_LOOP # neu ket qua tra ve  cua ham ARRAY_LOOP_CHECK_LAST = 1, ket thuc vong lap 
      move $a0, $v1
      jal GET_ARRAY_ELEMENT_VALUE
      move $a1, $v1
      jal PRINT_ARRAY_ELEMENT
      jal ARRAY_LOOP_INCREMENT
      j CMD2_LOOP 

    CMD2_END_LOOP:
      jal ARRAY_LOOP_END
      j ENTER_COMMAND

CMD3: # in cac so nguyen to
    li $v0, 4
    la $a0, msg7
    syscall

    jal ARRAY_LOOP_INITIALIZE

    CMD3_LOOP:
      jal ARRAY_LOOP_CHECK_LAST
      beq $v0, 1, CMD3_END_LOOP
      addi $sp, $sp, -4
      sw $v1, 0($sp)
      jal GET_ARRAY_ELEMENT_VALUE
      move $a0, $v1
      jal IS_PRIME
      beq $v0, 0, CMD3_LOOP_CONTINUE # neu khong phai la so nguyen to tiep tuc
      lw $a0, 0($sp)
      addi $sp, $sp, 4
      move $a1, $v1
      jal PRINT_ARRAY_ELEMENT
      #syscall

    CMD3_LOOP_CONTINUE:
      jal ARRAY_LOOP_INCREMENT
      j CMD3_LOOP

    CMD3_END_LOOP:
      jal ARRAY_LOOP_END
      j ENTER_COMMAND
    
    # kiem tra xem x co phai la so ngyen to hay khong
    # arg: $a0 : x
    # return: $v0: 1 or 0
    IS_PRIME:
      addi $sp, $sp, -12
      sw $s0, 8($sp)
      sw $s1, 4($sp)
      sw $a0, 0($sp)

      li $s0, 1 # khoi tao bien dem i = 1
      li $s1, 0 # khoi tao bien count - dem so duoc chia het 
      IS_PRIME_LOOP:
        div $a0, $s0
        mfhi $t3 # luu phan du vao $t3
        beq $t3, 0, INCREASE_COUNT
        j INCREASE_I
      
      INCREASE_COUNT:
        addi $s1, $s1, 1

      INCREASE_I:
        addi $s0, $s0, 1
        lw $a0, 0($sp)
        slt $s2, $a0, $s0 # kiem tra i > x
        beq $s2, 0, IS_PRIME_LOOP

        # kiem tra count == 2
        beq $s1, 2, PRIME_YES
        li $v0, 0
        j PRIME_END

      PRIME_YES:
        li $v0, 1

      PRIME_END:
        lw $s1, 4($sp)
        lw $s0, 8($sp)
        addi $sp, $sp, 12
        jr $ra

CMD5: # tinh tong cac so chinh phuong
    li $t4, 0  # khai bao tong = 0

    # ham kiem tra so chinh phuong
    # arg:  $a0 : x
    # return: $v0: 1 or 0
    jal ARRAY_LOOP_INITIALIZE

    CMD5_LOOP:
      jal ARRAY_LOOP_CHECK_LAST
      beq $v0, 1, CMD5_END_LOOP 
      jal GET_ARRAY_ELEMENT_VALUE
      move $a0, $v1
      jal IS_SQUARE_NUMBER
      beq $v0, 0, CMD5_LOOP_CONTINUE # neu khong phai la so chinh phuong, tiep tuc vong lap
      add $t4, $t4, $v1 # tong = tong + so chinh phuong
 
    CMD5_LOOP_CONTINUE:
      jal ARRAY_LOOP_INCREMENT
      j CMD5_LOOP

    CMD5_END_LOOP:
      jal ARRAY_LOOP_END
      li $v0, 4
      la $a0, msg8
      syscall

      li $v0, 1
      move $a0, $t4
      syscall

      li $v0, 4
      la $a0, newline
      syscall 

      j ENTER_COMMAND

    IS_SQUARE_NUMBER:
      li $t1, 0 # khoi tao bien i

      IS_SQUARE_NUMBER_LOOP:
      mul $t2, $t1, $t1
      slt $t3, $t2, $a0
      beq $t3, 0, IS_SQUARE_NUMBER_LOOP_END
      addi $t1, $t1, 1
      j IS_SQUARE_NUMBER_LOOP
      
      IS_SQUARE_NUMBER_LOOP_END:
      beq $t2, $a0, IS_SQUARE_NUMBER_YES  
      li $v0, 0
      j IS_SQUARE_NUMBER_END
      
      IS_SQUARE_NUMBER_YES:
      li $v0, 1

      IS_SQUARE_NUMBER_END:
      jr $ra

CMD7: # Tìm giá trị lớn nhất trong mảng
    jal ARRAY_LOOP_INITIALIZE
    li $t1, 0 # khoi tao max = 0

    CMD7_LOOP:
      jal ARRAY_LOOP_CHECK_LAST
      beq $v0, 1, CMD7_END_LOOP
      jal GET_ARRAY_ELEMENT_VALUE
      slt $t2, $t1, $v1 # kiem tra neu max < a[i]
      beq $t2, 0, CMD7_LOOP_CONTINUE # neu sai tiep tuc vong lap
      # neu dung, gan max = a[i]
      move $t1, $v1

    CMD7_LOOP_CONTINUE:
      jal ARRAY_LOOP_INCREMENT
      j CMD7_LOOP

    CMD7_END_LOOP:
      jal ARRAY_LOOP_END
      li $v0, 4
      la $a0, msg9
      syscall
      li $v0, 1
      move $a0, $t1
      syscall
      li $v0, 4
      la $a0, newline
      syscall
      j ENTER_COMMAND

CMD8: # Sắp xếp mảng tăng dần theo Selection sort
    # thuật toán
    # void selectionSort(int arr[], int n) {
    #    int i, j, min_idx;
    #    for (i = 0; i < n-1; i++) {
    #        min_idx = i;
    #        for (j = i+1; j < n; j++) {
    #           if (arr[j] < arr[min_idx]) {
    #               min_idx = j;
    #            }
    #        }     
    #        swap(&arr[min_idx], &arr[i]);
    #    }
    # }

    SELECTION_SORT:
    lw $t0, n # lay so phan tu cua mang, n 
    li $t1, 0 # khoi tao i
    sub $t3, $t0, 1 # n - 1

    SELECTION_SORT_OUTER_LOOP:
    beq $t1, $t3, SELECTION_SORT_OUTER_LOOP_END   # kiem tra xem i = n - 1 hay chua, neu = nhau, dung vong lap
    addi $t2, $t1, 1 # cho j = i + 1
    move $t4, $t1 # gan min_idx = i
    
    SELECTION_SORT_INNER_LOOP:
    beq $t2, $t0, SELECTION_SORT_INNER_LOOP_END  # kiem tra j = n hay chua
    la $s0, arr # load địa chỉ của phần tử đầu tiên vào $s0
    mul $t5, $t2, 4 # j * 4
    add $s0, $s0, $t5 # địa chỉ của arr[j] = $s0 + j * 4
    lw $s1, ($s0) # lưu giá trị của arr[j] vào $s1
    mul $t6, $t4, 4 # min_idx * 4
    la $s0, arr
    add $s0, $s0, $t6 # địa chỉ của arr[min_idx] = $s0 + min_idx * 4 
    lw $s2, ($s0) # lưu giá trị của arr[min_idx] vào $s2
    slt $s3, $s1, $s2 # so sánh arr[j] < arr[min_idx]
    beq $s3, 0, SELECTION_SORT_INNER_LOOP_CONTINUE # nếu sai tiếp tục vòng lặp
    move $t4, $t2 #  nếu đúng gán min_idx = j

    SELECTION_SORT_INNER_LOOP_CONTINUE:
    addi $t2, $t2, 1 # tăng chỉ số j
    j SELECTION_SORT_INNER_LOOP # quay lại vòng lặp trong

    SELECTION_SORT_INNER_LOOP_END:
    la $s0, arr
    mul $t5, $t1, 4 # i * 4
    add $s0, $s0, $t5 # đia chỉ của arr[i] = $s0 + i * 4
    lw $s1, ($s0) # arr[i]
    mul $t6, $t4, 4 # min_idx * 4
    la $s0, arr
    add $s0, $s0, $t6  # địa chỉ của arr[min_idx] = $s0 + min_idx * 4 
    lw $s2, ($s0) # arr[min_idx]
    # swap arr[i] va arr[min_idx] 
    sw $s1, ($s0) # gan arr[i] = arr[min_idx]

    la $s0, arr
    add $s0, $s0, $t5 # $t5 đã được tính ở trên
    sw $s2, ($s0) # gan arr[min_idx] = arr[i]

    addi $t1, $t1, 1 # tăng chỉ số i
    j SELECTION_SORT_OUTER_LOOP # quay lại vòng lặp ngoài

    SELECTION_SORT_OUTER_LOOP_END:
    li $v0, 4
    la $a0, msg10
    syscall # in thong bao so 10

    j ENTER_COMMAND

CMD9: # Sắp xếp mảng giảm dần theo Bubble sort
    # thuật toán
    # void bubbleSort(int arr[], int n) {
    #  int i, j;
    #  for (i = 0; i < n-1; i++) {
    #    for (j = 0; j < n-i-1; j++) {
    #      if (arr[j] > arr[j+1]) {
    #        swap(&arr[j], &arr[j+1]);
    #      }
    #    }           
    #  }           
    # }
    BUBBLE_SORT:
    lw $t0, n # lưu số phần tử của mảng vào $t0
    li $t1, 0 # khởi tạo chỉ số i
    sub $t3, $t0, 1 # lưu n - 1 vào $t3 

    BUBBLE_SORT_OUTER_LOOP:
    beq $t1, $t3, BUBBLE_SORT_OUTER_LOOP_END # nếu i = n - 1 kết thúc vòng lặp ngoài
    la $s0, arr # lưu địa chỉ của mảng vào $s0
    li $t2, 0 # khởi tạo biến j 
    # lưu n - i - 1 vào $t4
    sub $t4, $t0, $t1 
    addi $t4, $t4, -1 

    BUBBLE_SORT_INNER_LOOP:
    beq $t2, $t4, BUBBLE_SORT_INNER_LOOP_END # nếu j = n - i -1 kết thúc vòng lặp trong
    lw $s1, ($s0) # arr[i]

    addi $s0, $s0, 4
    lw $s2, ($s0) # arr[j]

    slt $t5, $s1, $s2 # kiểm tra arr[i] < arr[j]
    beq $t5, 0, BUBBLE_SORT_INNER_LOOP_CONTINUE

    # swap arr[i] và arr[j]
    addi $s0, $s0, -4
    sw $s2, ($s0)
    addi $s0, $s0, 4
    sw $s1, ($s0)
    
    BUBBLE_SORT_INNER_LOOP_CONTINUE:
    addi $t2, $t2, 1
    j BUBBLE_SORT_INNER_LOOP 

    BUBBLE_SORT_INNER_LOOP_END:
    addi $t1, $t1, 1
    j BUBBLE_SORT_OUTER_LOOP 

    BUBBLE_SORT_OUTER_LOOP_END:
    li $v0, 4
    la $a0, msg11
    syscall # in thong bao so 11

    j ENTER_COMMAND

CMD10:
  li $v0, 10
  syscall

# ============================ Các hàm bổ trợ ==================================

# hàm khởi tạo để chuẩn bị thực hiện vòng lặp cho mảng
# no args
# return void
ARRAY_LOOP_INITIALIZE:
  addi $sp, $sp, -4
  # lưu $s0 vào stack để không bị rewrite dứ liệu, không lưu $s1 vì $s1 lưu địa chỉ của mảng, sẽ được dùng ở các hàm khác
  sw $s0, 0($sp)

  lw $s0, n # lưu số phần tử của mảng `n` vào $s0
  la $s1, arr # load địa chỉ của phần tử đầu tiên của mảng vào $s1
  li $t0, 0 # khai báo chỉ số i = 0
  jr $ra

# hàm kiểm tra chỉ số ở cuối mảng hay chưa (i == n)
# no args
# return $v0: 1 ||  0, $v1: i
ARRAY_LOOP_CHECK_LAST: 
  addi $sp, $sp, -4
  sw $ra, 0($sp)

  beq $t0, $s0, ARRAY_LOOP_CHECK_LAST_TRUE # nếu i = n, dừng vòng lặp
  # return $v0 = 0 nếu chưa ở cuối mảng
  li $v0, 0
  
  jal ARRAY_LOOP_CHECK_END

  ARRAY_LOOP_CHECK_LAST_TRUE:
  # return $v0 = 1 nếu đã ở cuối mảng
  li $v0, 1

  ARRAY_LOOP_CHECK_END:
  move $v1, $t0 # return $v1 = i (chỉ số)
  lw $ra, 0($sp) # pop địa chỉ gọi hàm từ stack
  addi $sp, $sp, 4
  jr $ra

ARRAY_LOOP_INCREMENT:
  addi $s1, $s1, 4 # tăng địa chỉ $s1 thêm 4
  addi $t0, $t0, 1 # tăng chỉ số i thêm 1
  jr $ra
  
ARRAY_LOOP_END:
  # pop dữ liệu của $s0 khỏi stack
  lw $s0, 0($sp)
  addi $sp, $sp, 4
  jr $ra

# hàm thiết lập giá trị phần tử của mảng
# arg: $a0 (value)
# return void
SET_ARRAY_ELEMENT_VALUE:
  # sử dụng địa chỉ của mảng được khởi tạo ở hàm ARRAY_LOOP_INITIALIZE
  sw $a0, ($s1)
  jr $ra

# hàm lấy giá trị phần tử của mảng
# no args
# return $v1 
GET_ARRAY_ELEMENT_VALUE:
 # sử dụng địa chỉ của mảng được khởi tạo ở hàm ARRAY_LOOP_INITIALIZE
  lw $v1, ($s1) # trả kết quả về register $v1
  jr $ra

# hàm in ra:  arr[`i`] =
# arg $a0 (i)
# return void
PRINT_ARRAY_ELEMENT_LABEL: 
  addi $sp, $sp, -4
  sw $a0, 0($sp)

  li $v0, 4
  la $a0, msg4
  syscall # in "arr["

  li $v0, 1
  lw $a0, 0($sp)
  syscall
  addi $sp, $sp, 4

  li $v0, 4
  la $a0, msg5
  syscall # in "]="
  jr $ra

# hàm in ra:  arr[`i`] = value
# arg $a0 (i), $a1 (value)
# return void
PRINT_ARRAY_ELEMENT:
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal PRINT_ARRAY_ELEMENT_LABEL
  li $v0, 1
  move $a0, $a1
  syscall

  li $v0, 4
  la $a0, newline
  syscall
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra



