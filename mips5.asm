 
     .data
		
		space:.asciiz  "\n "          # space to insert between numbers		
		str1: .asciiz "Y= "
		str2: .asciiz "Your wrote:   "
		
		Y: .word 0:32
		N: .word 32
		var1: .word 23
		A: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32
		B: .word 1,1,-1,-1,1,1,-1,-1,1,1,-1,-1,1,1,-1,-1,1,1,-1,-1,1,1,-1,-1,1,1,-1,-1,1,1,-1,-1
		
  .text
  .globl main
  main:  
  	la	$s0, A		# load contents of RAM location into register $t0:  $t0 = A
  	la 	$s4, B		#t1=B
  	la	$s6, Y		#load address of Y t2=Y
  	la	$t3, N		#load address of N
  	lw	$t3, 0($t3)	#load N size
  	addi	$t3, $t3, -1	#set counter to N-1
  	
  	#A[0] *B[0]
  	lw 	$t7, 0($s0)	#load value of A[n] to $t7
	lw	$t6, 0($s4)	#load value of B[n] to $t6
	mul	$s5,$t7,$t6	# s5= t7*t6
	la   $a0, str1       # load address of spacer for syscall
      	li   $v0, 4           # specify Print String service
      	syscall  
	li	$v0, 1		# Print integer
	move 	$a0, $s5	#store contents of register $s5 into a0
	syscall
	
	
	addi	$t3, $t3, -1	#decrease counter
	addi 	$s0, $s0, 4	# increment address of s0, A	
	addi	$s4, $s4, 4	# increment address of s4, B
	
	
	la   $a0, space       # load address of spacer for syscall
      	li   $v0, 4           # specify Print String service
      	syscall               # output string
  	jal loop
 loop:
 	blt 	$t3,0, exit	# if ( $t3>0)
 	lw 	$s1, 0($s0)	#load value of A[n] to $t7
	lw	$t6, 0($s4)	#load value of B[n] to $t6
	mul	$s5,$s1,$t6	# s5= t7*t6
	
	lw 	$s1, -4($s0)	#load value of A[i-1] to $t7
	mul	$s2,$s1,$t6	#A[i-1]*B[i]
	lw	$t6, -4($s4)	#load value of B[i-1] to $t6
	mul	$s3,$s1,$t6	#A[i]*B[i-1]	
		
	
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	bgt	$s5,$s2, fcond #if (t7<=t8)
	fcond:	add	$s6,$s2,0
	bgt	$s5,$s3, fcond2#if (t7<=t9)
	fcond2:	addi	$s6,$s3,0
	#lw	$ra, 0($sp)
	#addi	$sp, $sp, 4
	

	addi	$t3, $t3, -1	#decrease counter
	addi 	$s0, $s0, 4	# increment address of t0, A	
	addi	$s4, $s4, 4	# increment address of t1, B
	
	la   $a0, str1       # load address of spacer for syscall
      	li   $v0, 4           # specify Print String service
      	syscall  
      	
	li	$v0, 1		# Print integer
	move 	$a0, $s6	#store contents of register $t3 into a0
	syscall
	
	             # output string
	
	la   $a0, space       # load address of spacer for syscall
      	li   $v0, 4           # specify Print String service
      	syscall               # output string
      	
      	
	j loop
	
	#bgtz	$t4, loop

	#jr	$ra
		#set max $t7
	
done:
	#syscall         # print it
exit:      
          
          
       
