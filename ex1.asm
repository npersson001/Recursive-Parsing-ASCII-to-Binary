.data 0x0
	newline:	.asciiz "\n"
	LEN:		.word 22
	terminator:	.asciiz "\0"
	string: 	.space 22

.text 0x3000
.globl main

main:
	ori     $sp, $0, 0x2ffc     # Initialize stack pointer to the top word below 
	addi    $fp, $sp, -4        # Set $fp to the start of main's stack frame

Loop:
	la $a0, string		#set string location in memeory
	addiu $a1, $0, 22	#set max length
	addiu $v0, $0, 8	#take in string
	syscall
	
	jal a_to_i		#call procedure ($a0 should be argument passed)
	
	addu $a0, $0, $v0	#print number
	ori $v0, $0, 1
	syscall
	
	la $a0, newline		#print newLine
	ori $v0, $0, 4
	syscall
	
	beq $t0, $0, exit_from_main	#if loop = false exit
	beq $0, $0, Loop		#loop back up if loop was true
	
a_to_i:
	addiu $t0, $0, 0	#set number as 0
	la $t1, string		#use $t1 for string pointer
	#la $t4, newline		#put newline in $t4
	ori $t4, $0, 10
	
Loop2:
	lbu $t2, 0($t1)		#get wanted character from the array of char
	beq $t2, $t4, a_to_i_exit	#exit procedure if character is the null terminator
	subiu $t2, $t2, 48	#sub 48 from our char
	
	addiu $t3, $0, 10	#get int 10 to use in mult
	multu $t0, $t3		#multiply number by 10
	mflo $t0		#set value mult back in number
	
	addu $t0, $t0, $t2	#add char value and number value * ten
	
	addiu $v0, $t0, 0	#put number into return variable
	addiu $t1, $t1, 1	#increase the char being looked at
	beq $0, $0, Loop2	#loop back to Loop2
	
a_to_i_exit: 
	jr $ra			#return to the main method

exit_from_main:
ori     $v0, $0, 10     # System call code 10 for exit
syscall                 # Exit the program
end_of_main:
