 #Data stored in cache#
     .data
     		
     		B: .word 1,1,-1,-1,1,1,-1,-1,1,1,-1,-1,1,1,-1,-1,1,1,-1,-1,1,1,-1,-1,1,1,-1,-1,1,1,-1,-1	#Array B	
   		space:.asciiz  "          "          # space to insert between numbers	   								
		str1: .asciiz "Y= "		#
		Y: .word 0:32			# Array Y
		N: .word 32			#Size of array Y		   		
		A: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32 #Array A
		
		
#Main Program		
  .text
  .globl main
  main:  
  	la	$s0, A		# load contents of RAM location into register $s0:  $s0 = A
  	la 	$s4, B		#s4=B
  	la	$a3, Y		#load address of Y to $a3=Y
  	la	$a2, N		#load address of N to $a2
  	lw	$t3, 0($a2)	#load N size of $a2 to $t3
  	addi	$t3, $t3, -1	#set counter to N-1
  	#========#A[0] *B[0]=========#
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
  	jal loop		# jump and link address. go to function loop
 loop: 	
	lw 	$s1, 0($s0)	#load value of A[n] to $s1
	lw	$t6, 0($s4)	#load value of B[n] to $t6
	mul	$s5,$s1,$t6	# s5= t7*t6
	lw	$s6, 0($a3)	#load value of a3[i] to $s6
	
	
	lw 	$s1, -4($s0)	#load value of A[i-1] to $s1
	mul	$s2,$s1,$t6	#A[i-1]*B[i]
	lw 	$s1, ($s0)	#return value of A[i-1] to A[i], $s1
	lw	$t6, -4($s4)	#load value of B[i-1] to $t6
	mul	$s3,$s1,$t6	#A[i]*B[i-1]			
	
	
	sw	$s5, ($a3)	#set value of $s5 to $a3
	
	bge	$s5,$s2, CMP #if (t7<=t8)	
	sw $s2, ($a3)	#<-------	set value of $s2 to $a3, now $a3 contains max of s5 and s2
	j   CMP		#jump to function compare
		
CMP:	bge	$s5,$s3, CMP2#if (t7<=t9)
	sw $s3, ($a3)	#<------------ set value of $s3 to $a3, now $a3 contains the max value of s5, s2 and s3
	
	j CMP2	#jmp to function compare 2
	
CMP2:	lw $s6, ($a3)		#load the value of $a3 to the stored variable $s6
	addi	$t3, $t3, -1	#decrease counter
	addi 	$s0, $s0, 4	# increment address of s0, A	
	addi	$s4, $s4, 4	# increment address of s4, B
	addi	$a3, $a3, 4	# increment address of a3, Y
	
	la   $a0, str1       # load address of spacer for syscall
      	li   $v0, 4           # specify Print String service
      	syscall        	
	li	$v0, 1		# Print integer
	move 	$a0, $s6	#store contents of register $t3 into a0 <------------
	syscall	
	             # output string
	
	la   $a0, space       # load address of spacer for syscall
      	li   $v0, 4           # specify Print String service
      	syscall               # output string
       
      	bgez $t3,loop	#if t3 >=0  go to loop      	
      	li   $v0, 10          # system call for exit
      	syscall               # we are out of here.

          
       
