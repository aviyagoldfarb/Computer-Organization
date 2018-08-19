	#201509635 aviya goldfarb
	#this is a program  with pstring`s library functions
	.section		.rodata
invalid_message: 	.string 	"invalid input!\n"		
	.text
.globl	pstrlen					#the label "pstrlen" is used to state the initial point of this program
	#this function gets `pointer` (address) to pstring, and returns the pstring`s length
	.type	pstrlen, @function	#the label "pstrlen" representing the beginning of a function
pstrlen:							#the pstrlen function:
	movq	$0, %rax
	movb	(%rdi), %al 			#%rdi points to the address of the pstring, assigning into %rax the first byte of the pstring (it`s size)
	ret 							#return to caller function (run_func).

.globl	replaceChar	
	#this function gets `pointer` (address) to pstring and two chars- old char and new char, and replaces any appearance of old char with new char 
	.type	replaceChar, @function	#the label "pstrlen" representing the beginning of a function
replaceChar:						#the replaceChar function:
	movq	%rdi, %r11 			#assigning the address of %rdi (first parameter) to %r11 in order to walk over the pstring
	movq 	$0, %rcx
	movq 	$1, %rcx
.check_match:	 					#label that checks if there is a match between  the current pointed byte of the pstring and the old char  
	cmpb 	$0 , (%r11) 			#checks if we already walked over the whole string 
	je		.end_func 			#if we did, jump to .end_func label
	leaq	(%rcx, %r11), %r11 	#promote the pointed pstring`s address one byte 
	cmpb 	(%r11), %sil 			#check if there is a match between  the current pointed byte of the pstring and the old char
	jne		.check_match 			#if not, jump back to .check_match in order to check the next pstring`s byte
	movb	%dl, (%r11) 			#if there is a match, replace the pointed old char with the new char 
	jmp 		.check_match 			#jump back to .check_match in order to check the next pstring`s byte
.end_func:						#in this label we prepare for returning back to caller function
	movq	$0, %rax
	movq	%rdi, %rax 			#assigning the address of %rdi (the pointed pstring) to %rax as return value
	ret  						#return to caller function (run_func).

.globl	pstrijcpy	
	#this function gets two `pointers` (addresses) to pstring- dst (first pstring) and src (second pstring), and two char indexes i and j
	#and copies the substring (between i and j indexes) from src to dst, and returns pointer (address) to dst 
	.type	pstrijcpy, @function	#the label "pstrijcpy" representing the beginning of a function
pstrijcpy: 						#the pstrijcpy function:
	movq	%rdi, %r11 			#assigning the address of %rdi (first parameter) to %r11 in order to save its address
								#checking the validation of the indexes i and j 
	cmpb 	(%rsi), %dl 			#(%rsi) holds the size of the first pstring. we compare it to index i
	jg 		.invalid 			#if i is greater, jump to .invalid 
	cmpb 	(%rsi), %cl 			#(%rsi) holds the size of the first pstring. we compare it to index j
	jg 		.invalid 			#if j is greater, jump to .invalid 
	cmpb 	(%rdi), %dl 			#(%rdi) holds the size of the second pstring. we compare it to index i
	jg 		.invalid 			#if i is greater, jump to .invalid 
	cmpb 	(%rdi), %cl 			#(%rdi) holds the size of the second pstring. we compare it to index j
	jg 		.invalid 			#if j is greater, jump to .invalid 
	
	leaq 	1(%rdi), %rdi 		#%rdi holds the address of the first pstring. we promote %rdi to hold the address of the pstring`s string
	leaq 	1(%rsi), %rsi 		#%rsi holds the address of the second pstring. we promote %rsi to hold the address of the pstring`s string
	leaq 	(%rdx, %rdi), %rdi 	#promote %rdi to hold the address of the i index of the string
	leaq 	(%rdx, %rsi), %rsi 	#promote %rsi to hold the address of the i index of the string

	subq 	%rdx, %rcx 			#compute j - i and store the answer in %rcx in order to use it for stop condition  
	incq 	%rcx 				#increase  %rcx in 1. we have now the number of iterations we need to do over the src and dst strings
	movq 	$0, %r8 				#%r8 will be our counter of iterations
.copy: 							#in this label we copy one byte from src and assign it into dst. we then prepare for the next byte copy. 
	movb 	(%rsi), %r9b 			#copy one byte from src to %r9b
	movb 	%r9b, (%rdi)   		#copy the same byte from %r9b to dst
	incq 	%r8 				#increase our counter in 1, in order to count the number of iterations
	leaq 	1(%rdi), %rdi 		#promote dst to next byte 
	leaq 	1(%rsi), %rsi 		#promote src to next byte
	cmpq 	%rcx, %r8 			#this is the stop condition. compare between the number of the done iterations 
 								#and the number of iterations needs to be done
 	jne 		.copy 				#if not equal, copy another byte
 	jmp 		.func_end 			#if equal jump to .func_end 
.invalid:
	movq	$invalid_message, %rdi 	#the string invalid_message is the only paramter passed to the printf function
	movq	$0,%rax
	call	printf				#calling to printf in order to print the default message	
	jmp 		.func_end
.func_end:						#in this label we prepare for returning back to caller function
	movq	$0, %rax
	movq	%r11, %rax 			#assigning the address of %rdi (the dst pstring) to %rax as return value
	ret  						#return to caller function (run_func).	

.globl	swapCase	
	#this function gets `pointer` (address) to pstring, and returns the pstring after swapping between upper case and lower case	
	.type	swapCase, @function	#the label "swapCase" representing the beginning of a function
swapCase: 						#the swapCase function:
	movq	%rdi, %r11 			#assigning the address of %rdi (first parameter, pstring`s address) to %r11 in order to `walk over` it
	movq 	$0, %rcx
	movq 	$1, %rcx 			
.check_byte:	 					#label that checks if the current byte is upper case or lower case and promotes %r11 to next byte   
	cmpb 	$0 , (%r11) 			#checks if we already walked over the whole string 
	je		.return				#if we did, jump to .return label
	leaq	(%rcx, %r11), %r11 	#promote the pointed pstring`s address (%r11) one byte 
	cmpb 	$90, (%r11) 			#check if the current pointed byte of the pstring is less or equal to 90 - the ascii value of Z (upper case)  
	jle		.check_upper			#if it is, jump to .check_upper	
	cmpb 	$97, (%r11) 			#check if the current pointed byte of the pstring is greater or equal to 97 - the ascii value of a (lower case) 
	jge		.check_lower			#if it is, jump to .check_lower

.check_upper: 					#in this label we check if the current byte value is greater or equal to 65. if it is, that means that the 
								#current byte is an upper case letter between A and Z
	cmpb 	$65, (%r11) 			#check if the current byte value is greater or equal to 65	
	jl		.check_byte 			#if not, jump back to .check_byte in order to check the next pstring`s byte
	movb 	(%r11), %r9b 			#copy the current byte from %r11 to %r9b
	addb 	$32, %r9b 			#add 32 to the byte`s value in order to swap it to lower case
	movb 	%r9b, (%r11)   		#copy the swapped byte from %r9b to %r11	 
	jmp 		.check_byte 			#jump back to .check_byte in order to check the next pstring`s byte

.check_lower: 					#in this label we check if the current byte value is less or equal to 122. if it is, that means that the 
								#current byte is a lower case letter between a and z
	cmpb 	$122, (%r11) 			#check if the current byte value is less or equal to 122
	jg		.check_byte 			#if not, jump back to .check_byte in order to check the next pstring`s byte
	movb 	(%r11), %r9b 			#copy the current byte from %r11 to %r9b
	subb 	$32, %r9b 			#sub 32 from the byte`s value in order to swap it to upper case
	movb 	%r9b, (%r11)   		#copy the swapped byte from %r9b to %r11	 
	jmp 		.check_byte 			#jump back to .check_byte in order to check the next pstring`s byte

.return:							#in this label we prepare for returning back to caller function
	movq	$0, %rax
	movq	%r11, %rax 			#assigning the address of %rdi (the swapped pstring) to %rax as return value
	ret  						#return to caller function (run_func).	

.globl	pstrijcmp	
	#this function gets two `pointers` (addresses) to pstring- first pstring and second pstring, and two char indexes i and j
	#and compares between the substring (between i and j indexes) of the first pstring and the second pstring , and returns the result	
	.type	pstrijcmp, @function	#the label "pstrijcmp" representing the beginning of a function
pstrijcmp: 						#the pstrijcmp function:
	cmpb 	(%rsi), %dl 			#(%rsi) holds the size of the first pstring. we compare it to index i
	jg 		.not_valid 			#if i is greater, jump to .not_valid 
	cmpb 	(%rsi), %cl 			#(%rsi) holds the size of the first pstring. we compare it to index j
	jg 		.not_valid 			#if j is greater, jump to .not_valid 
	cmpb 	(%rdi), %dl 			#(%rdi) holds the size of the second pstring. we compare it to index i
	jg 		.not_valid 			#if i is greater, jump to .not_valid 
	cmpb 	(%rdi), %cl 			#(%rdi) holds the size of the second pstring. we compare it to index j
	jg 		.not_valid 			#if j is greater, jump to .not_valid 
	
	leaq 	1(%rdi), %rdi 		#%rdi holds the address of the first pstring. we promote %rdi to hold the address of the pstring`s string
	leaq 	1(%rsi), %rsi 		#%rsi holds the address of the second pstring. we promote %rsi to hold the address of the pstring`s string
	leaq 	(%rdx, %rdi), %rdi 	#promote %rdi to hold the address of the i index of the string
	leaq 	(%rdx, %rsi), %rsi 	#promote %rsi to hold the address of the i index of the string

	subq 	%rdx, %rcx 			#compute j - i and store the answer in %rcx in order to use it for stop condition  
	incq 	%rcx 				#increase  %rcx in 1. we have now the number of iterations we need to do over the src and dst strings
	movq 	$0, %r8 				#%r8 will be our counter of iterations
.compare: 						#in this label we compare one byte from the first substring and the second substring.  
	 							#we then prepare for the next byte compare.
	movb 	(%rsi), %r9b 			#copy the current byte from first substring to %r9b
	cmpb 	%r9b, (%rdi)   		#compare between the current byte of first substring and second substring  
	jne 		.find_greater 		#if they are not equal, jump to .find_greater
	incq 	%r8 				#increase our counter in 1, in order to count the number of iterations
	leaq 	1(%rdi), %rdi 		#promote first substring to next byte 
	leaq 	1(%rsi), %rsi 		#promote second substring to next byte
	cmpq 	%rcx, %r8 			#this is the stop condition. compare between the number of the done iterations 
 								#and the number of iterations needs to be done
 	jne 		.compare 			#if not equal, copy another byte
 	movq	$0, %rax 			#if we got here it means that the two substrings are equal, return value is 0
	ret  						#return to caller function (run_func).
.find_greater: 					#in this label we find the byte that holds the greater value
	cmpb 	%r9b, (%rdi)   		#compare between the current byte of first substring and second substring 
	jg 		.first_greater 		#if (%rdi) is greater, jump to .first_greater
	movq	$0, %rax 			#if not, it means that the second substring is greater 
	movq	$-1, %rax 			#return value is -1
	ret  						#return to caller function (run_func).
.first_greater: 					#in this label we return 1, because if we got here it means that the first substring is greater
	movq	$0, %rax
	movq	$1, %rax 			#return value is 1
	ret  						#return to caller function (run_func).
.not_valid:
	movq	$invalid_message, %rdi 	#the string invalid_message is the only paramter passed to the printf function
	movq	$0,%rax
	call	printf				#calling to printf in order to print the default message	
	movq	$0, %rax
	movq	$-2, %rax 			#return value is -2
	ret  						#return to caller function (run_func).
