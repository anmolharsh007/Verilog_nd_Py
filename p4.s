### Assignment : 7                           
### Problem No : 3                                   
### Semester : Autumn 2020                   
### Group No : G10                           
### Members : Ayudh Saxena & Anmol Harsh     

####################### Data segment ######################################
.data

array : 
	.align 2
	.space 36 # array of 9 integers
nl:				.asciiz "\n"
enter_num9:		.asciiz "Enter the 9 numbers: "
enter_key:		.asciiz "Enter the number to be searched for: "
not_found:		.asciiz "The number was not found :("
num_found:		.asciiz "The number was found at index (0-based indexing): "
output_msg : 	.asciiz "\nThe numbers sorted in ascending order are : "


####################### Data segment ######################################

####################### Text segment ######################################
.globl main
.text
	main:
		la $a0, enter_num9 							# enter 9 numbers
		li $v0, 4									# loading the function code for print_string system function
		syscall 									# calling the system to execute the function

		la $t0, array 								# loading the base address of the array in the register
		li $t1, 9 									# loop variable from i = 9 to 1
		  
		INPUT_LOOP :
			# reading input integer
			li $v0, 5 								# loading the function code for read_int system function
			syscall

			sw $v0, 0($t0) 							# storing the input integer into the array

			# updating the loop variables
			addi $t0, $t0, 4 						# &array[i+1]
			addi $t1, $t1, -1

			bgt $t1, $zero, INPUT_LOOP 				# continue looping if i > 0
	 
		la $a0, array 								# prepare the argument for the SORT subroutine
		  
		jal SORT 									# call the SORT subroutine

		la $a0, output_msg 							# message string in $a0
		li $v0, 4 									# loading the function code for print_string system function
		syscall

		la $t0, array 								# loading the base address of the array in the register
		li $t1, 9 									# loop variable from i = 9 to 1

		OUTPUT_LOOP :

			# print number
			lw $a0, 0($t0)
			li $v0, 1 								# loading the function code for print_int system function
			syscall

			# print space
			li $a0, 32 								# ASCII value of space = 32
			li $v0, 11 								# loading the function code for print_char system function
			syscall

			# updating the loop variables
			addi $t0, $t0, 4
			addi $t1, $t1, -1
							  
			bgt $t1, $zero, OUTPUT_LOOP 			# continue looping while i > 0

		  	# system EXIT i.e end of the program
			la $a0, nl 								# print newline
			li $v0, 4 								# loading the function code for print_string system function
			syscall
			la $a0, enter_key
			li $v0, 4  								# enter key to be searched
			syscall

			li $v0, 5  								#reads integer
			syscall
			move $s1, $v0
		

			li $t1, 0
			la $a0, array
			
			# move $t0, $a0
						
			la $a1, 0
			la $a2, 8
			move $a3, $s1		
			jal bin_search
			move $s5, $v0
			beq $s5, -1, print_fail
			j print_found



			j EXIT

			bin_search:
			move $t0, $a0							# array argument
			move $t1, $a1							# leftmost end
			move $t2, $a2							# rightmost end
			move $t3, $a3							# key
						
			recurse:
			addi $sp, $sp, -4
			sw $ra, ($sp) 							# Storing return address

			# calculate mid -> t4
			add $t4, $t1, $t2
			li $s2, 2
			div $t4, $s2
			mflo $t4

			move $t5, $t4
			li $s4, 4
			mult $t4, $s4
			mflo $t4
			add $t4, $t4, $t0

			# exit if l>r --> notfound
			bgt $t1, $t2, out_of_bounds
			
			lw $t6, 0($t4)
			beq $t6, $t3, found 					# if key is foundd

			bgt $t3, $t6, go_right 					# if key > mid_val goto right_half
			blt $t3, $t6, go_left 					# if key < mid_val goto left_half

			jr $ra


			go_right:
				addi $t1, $t5, 1					# update left_end as mid+1
				la $a0, array
				move $a1, $t1
				move $a2, $t2
				move $a3, $s1
				# recurse to the right half
				jal bin_search
				# jr $ra
				j clear_stack						# to clear the stacks


			go_left:
				addi $t2, $t5, -1					# update right_end as mid-1
				la $a0, array
				move $a1, $t1
				move $a2, $t2
				move $a3, $s1
				# recurse to the left half
				jal bin_search
				# jr $ra
				j clear_stack						# to clear the stack


			out_of_bounds:
				la $a0, nl 
				li $v0, 4							#print newline
				syscall

				li $v0, -1
				# jr $ra
				j clear_stack						# to clear the stack



			found:

				move $v0, $t5
				# jr $ra
				j clear_stack						# to clear the stack
				# j EXIT


			clear_stack:
				# Clean up the stack and return the value in v0
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra



			print_found:
				la $a0, num_found 
				li $v0, 4								#print found
				syscall

				move $a0, $s5							# print the index(0-based) 
				li $v0, 1 								# loading the function code for print_int system function
				syscall

				la $a0, nl 
				li $v0, 4								#prints the message string
				syscall		

				j EXIT

			print_fail:
				la $a0, not_found 
				li $v0, 4							#print not_found
				syscall

				la $a0, nl 
				li $v0, 4							#prints newline
				syscall

				j EXIT

	 
	SORT :
		move $t0, $a0
		addi $t0, $t0, 4 									# outer loop variable -> &array[i]
		li $t1, 1 											# outer loop variable -> i
		li $t2, 9 											# upper bound of i
		  
		OUTER_LOOP :
			lw $t3, 0($t0) 									# number at the ith position of array -> array[i]

			addi $t4, $t1, -1 								# inner loop variable -> j = i-1
			addi $t5, $t0, -4 								# inner loop variable -> &array[j] = &array[i-1]

		INNER_LOOP :
			lw $t6, 0($t5) 									# number at the jth position of array -> array[j]
			blt $t4, $zero, ASSIGN 							# if j < 0, break out of inner loop
			ble $t6, $t3, ASSIGN 							# if array[j] <= array[i], break out of inner loop
				
			move $t7, $t5
			addi $t7, $t7, 4 								# &array[j+1]

			sw $t6, 0($t7) 									# array[j+1] = array[j]
			addi $t4, $t4, -1 								# j = j-1
			addi $t5, $t5, -4 								# &array[j]
				   
			j INNER_LOOP
	
	ASSIGN :
		addi $t5, $t5, 4  									# &array[j+1]
		sw $t3, 0($t5) 										# array[j+1] = array[i]

		addi $t1, $t1, 1 									# i = i+1                
		addi $t0, $t0, 4 									# &array[i] 

		ble $t1, $t2, OUTER_LOOP 							# continue looping while i < 9
		  
		# return to the caller
		jr $ra 
	 
	EXIT:
		li $v0, 10
		syscall # EXIT
		   
####################### Text segment ######################################
