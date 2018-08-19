	#201509635 aviya goldfarb
	#this is a program  with function that gets three parameters, swhiching on the first and calling to the right function respectively
	.section		.rodata
chr_format:		.string	"\n%c"	#char format for scanf function
int_format:		.string	"%d"	#int format for  scanf function
def_message:		.string	"invalid option!\n"
message50a:		.string	"first pstring length: %d, "
message50b:		.string	"second pstring length: %d\n"
message51: 		.string 	"old char: %c, new char: %c, first string: %s, second string: %s\n"
message52:		.string	"length: %d, string: %s\n"
message53:		.string	"length: %d, string: %s\n"
message54:		.string	"compare result: %d\n"
.align 8 							# Align address to multiple of 8
.swhich:
				.quad .case50		# Case 50: call pstrlen
				.quad .case51 	# Case 51: call replaceChar
				.quad .case52 	# Case 52: call pstrijcpy
				.quad .case53 	# Case 53: call swapCase
				.quad .case54 	# Case 54: call pstrijcmp
				.quad .default 	# default: print message 

	.text						#the beginnig of the code
.globl	run_func					#the label "run_func" is used to state the initial point of this program
	.type	run_func, @function	#the label "run_func" representing the beginning of a function
run_func:						#the run_func function:	  
	movq	%rsi, %r14  			#assigning the first pstring (which is the second parameter for run_func) into %r14
	movq	%rdx, %r15  			#assigning the second pstring (which is the third parameter for run_func) into %r15
								#Set up the jump table access
	leaq -50(%rdi),%r8			#Compute `option` - 50 (%rdi contains the `option` parameter)
	cmpq $4,%r8					#Compare (`option` - 50):4
	ja .default 					#if >, goto default-case
	jmp *.swhich(, %r8, 8) 			#Goto jt[xi]

.case50:							#Case 50: call pstrlen
	movq	%r14, %rdi 			#the first pstring address is the first (and only) parameter to  pstrlen function
	call 	pstrlen 				#returns the length of the first pstring

	movq 	$message50a, %rdi 	#the message50a is the first paramter passed to the printf function
	movq 	%rax, %rsi 			#the return value of `pstrlen` (pstring`s length) is the second parameter of printf
	movq	$0, %rax	
	call 	printf 				#printing the length of the first pstring

	movq	%r15, %rdi 			#the second pstring address is the first (and only) parameter to  pstrlen function
	call 	pstrlen 				#returns the length of the second pstring

	movq 	$message50b, %rdi 	#the message50b is the first paramter passed to the printf function
	movq 	%rax, %rsi 			#the return value of `pstrlen` (pstring`s length) is the second parameter of printf
	movq	$0, %rax	
	call 	printf 				#printing the length of the second pstring

	jmp 		.return 				
.case51: 							#Case 51: call replaceChar
	leaq 	-1(%rsp), %rsp 		#allocating memory on the stack for  user`s  old char input
	movq 	$chr_format, %rdi 	#the chr_format is the first paramter passed to the scanf function
	movq 	%rsp, %rsi 			#passing the address pointed by %rsp as the second parameter of scanf
	movq	$0, %rax
	call	scanf				#calling scanf. scanning the old char 
	
	leaq 	-1(%rsp), %rsp 		#allocating memory on the stack for  user`s  new char input
	movq 	$chr_format, %rdi 	#the chr_format is the first paramter passed to the scanf function
	movq 	%rsp, %rsi 			#passing the address pointed by %rsp as the second parameter of scanf
	movq	$0, %rax
	call	scanf				#calling scanf. scanning the new char 

	movq 	%r14, %rdi 			#the address of the first pstring is the first paramter passed to the replaceChar function  
	movq 	%rsp, %r13 			#assigning %rsp into %r13 in order to `walk over` the stack
	leaq 	1(%r13), %r13 		#assigning into %r13 the address of the old char
	movq	$0, %rsi
	movb 	(%r13), %sil 			#assigning into %rsi the old char
	movq 	$0, %rdx
	movb 	(%rsp), %dl 			#assigning into %rdx the new char
	call 	replaceChar

	movq 	%r15, %rdi 			#the address of the second pstring is the first paramter passed to the replaceChar function
	movq 	%rsp, %r13 			#assigning %rsp into %r13 in order to `walk over` the stack
	leaq 	1(%r13), %r13 		#assigning into %r13 the address of the old char
	movq	$0, %rsi
	movb 	(%r13), %sil 			#assigning into %rsi the old char
	movq 	$0, %rdx
	movb 	(%rsp), %dl 			#assigning into %rdx the new char
	call 	replaceChar
								
	movq 	$message51, %rdi 	#the message51 is the first paramter passed to the printf function
	movq	%rsp, %r9 			#assigning into %r9 the address of the new char in order to walk over the stack
	leaq	1(%r9), %r9 			#promoting %r9 to point to the address of the old char
	movq	$0, %rsi
	movb 	(%r9), %sil 			#the old char is the second paramter passed to the printf function	
	movq	$0, %rdx
	movb 	(%rsp), %dl 			#the new char is the third paramter passed to the printf function
	leaq 	1(%r14),%r14 		#%r14 holds the address of the first pstring, now it holds the address to the string itself
	movq	%r14, %rcx 			#the address of the first pstring`s string is the fourth paramter passed to the printf function
	leaq 	1(%r15),%r15 		#%r15 holds the address of the second pstring, now it holds the address to the string itself
	movq	%r15, %r8 			#the address of the second pstring`s string is the fifth paramter passed to the printf function
	movq	$0, %rax	
	call 	printf 				#printing the old char, new char, first string and second string

	leaq 	2(%rsp), %rsp  		#moving %rsp back to its original address (before we allocated the two bytes for old and new char)

	jmp 		.return
.case52: 							#Case 52: call pstrijcpy
	leaq 	-4(%rsp), %rsp 		#allocating memory on the stack for user`s integer first index i input
	movq 	$int_format, %rdi 	#the int_format is the first paramter passed to the scanf function
	movq 	%rsp, %rsi 			#passing the address pointed by %rsp as the second parameter of scanf
	movq	$0, %rax
	call	scanf				#calling scanf. scanning the first index i
	
	leaq 	-4(%rsp), %rsp 		#allocating memory on the stack for  user`s integer second index j input
	movq 	$int_format, %rdi 	#the int_format is the first paramter passed to the scanf function
	movq 	%rsp, %rsi 			#passing the address pointed by %rsp as the second parameter of scanf
	movq	$0, %rax
	call	scanf				#calling scanf. scanning the second index j

	movq 	%r14, %rdi 			#the address of the first pstring is the first paramter passed to the pstrijcpy function  
	movq 	%r15, %rsi 			#the address of the second pstring is the second paramter passed to the pstrijcpy function  
	movq 	%rsp, %r13 			#assigning %rsp into %r13 in order to `walk over` the stack
	leaq 	4(%r13), %r13 		#assigning into %r13 the address of the frst index i
	movq	$0, %rdx
	movb 	(%r13), %dl 			#assigning into %rsi the first index i
	movq 	$0, %rcx
	movb 	(%rsp), %cl 			#assigning into %rdx the second index j
	call 	pstrijcpy

	movq	%r14, %rdi 			#the first pstring address is the first (and only) parameter to  pstrlen function
	call 	pstrlen 				#returns the length of the first pstring

	movq 	$message52, %rdi 	#the message52 is the first paramter passed to the printf function
	movq 	%rax, %rsi 			#the return value of `pstrlen` (pstring`s length) is the second parameter of printf
	leaq 	1(%r14),%r14 		#%r14 holds the address of the first pstring, now it holds the address to the string itself
	movq	%r14, %rdx 			#the address of the first pstring`s string is the third paramter passed to the printf function
	movq	$0, %rax	
	call 	printf 				#printing the two fields of the pstring- length and string.

	movq	%r15, %rdi 			#the second pstring address is the first (and only) parameter to  pstrlen function
	call 	pstrlen 				#returns the length of the second pstring

	movq 	$message52, %rdi 	#the message52 is the first paramter passed to the printf function
	movq 	%rax, %rsi 			#the return value of `pstrlen` (pstring`s length) is the second parameter of printf
	leaq 	1(%r15),%r15 		#%r15 holds the address of the second pstring, now it holds the address to the string itself
	movq	%r15, %rdx			#the address of the second pstring`s string is the third paramter passed to the printf function
	movq	$0, %rax	
	call 	printf 				#printing the two fields of the pstring- length and string.

	leaq 	8(%rsp), %rsp  		#moving %rsp back to its original address (before we allocated the 8 bytes for i and j)

	jmp 		.return
.case53: 							#Case 53: call swapCase
	movq	%r14, %rdi 			#the first pstring address is the first (and only) parameter to  swapCase function
	call 	swapCase 			#returns the pstring after awapping between upper and lower case

	movq	%r15, %rdi 			#the first pstring address is the first (and only) parameter to  swapCase function
	call 	swapCase 			#returns the pstring after awapping between upper and lower case

	movq	%r14, %rdi 			#the first pstring address is the first (and only) parameter to  pstrlen function
	call 	pstrlen 				#returns the length of the first pstring

	movq 	$message53, %rdi 	#the message53 is the first paramter passed to the printf function
	movq 	%rax, %rsi 			#the return value of `pstrlen` (pstring`s length) is the second parameter of printf
	leaq 	1(%r14),%r14 		#%r14 holds the address of the first pstring, now it holds the address to the string itself
	movq	%r14, %rdx 			#the address of the first pstring`s string is the third paramter passed to the printf function
	movq	$0, %rax	
	call 	printf 				#printing the two fields of the pstring- length and string.

	movq	%r15, %rdi 			#the second pstring address is the first (and only) parameter to  pstrlen function
	call 	pstrlen 				#returns the length of the second pstring

	movq 	$message53, %rdi 	#the message53 is the first paramter passed to the printf function
	movq 	%rax, %rsi 			#the return value of `pstrlen` (pstring`s length) is the second parameter of printf
	leaq 	1(%r15),%r15 		#%r15 holds the address of the second pstring, now it holds the address to the string itself
	movq	%r15, %rdx			#the address of the second pstring`s string is the third paramter passed to the printf function
	movq	$0, %rax	
	call 	printf 				#printing the two fields of the pstring- length and string.
	
	jmp 		.return
.case54: 							#Case 54: call pstrijcmp
	leaq 	-4(%rsp), %rsp 		#allocating memory on the stack for user`s integer first index i input
	movq 	$int_format, %rdi 	#the int_format is the first paramter passed to the scanf function
	movq 	%rsp, %rsi 			#passing the address pointed by %rsp as the second parameter of scanf
	movq	$0, %rax
	call	scanf				#calling scanf. scanning the first index i
	
	leaq 	-4(%rsp), %rsp 		#allocating memory on the stack for  user`s integer second index j input
	movq 	$int_format, %rdi 	#the int_format is the first paramter passed to the scanf function
	movq 	%rsp, %rsi 			#passing the address pointed by %rsp as the second parameter of scanf
	movq	$0, %rax
	call	scanf				#calling scanf. scanning the second index j

	movq 	%r14, %rdi 			#the address of the first pstring is the first paramter passed to the pstrijcmp function  
	movq 	%r15, %rsi 			#the address of the second pstring is the second paramter passed to the pstrijcmp function  
	movq 	%rsp, %r13 			#assigning %rsp into %r13 in order to `walk over` the stack
	leaq 	4(%r13), %r13 		#assigning into %r13 the address of the frst index i
	movq	$0, %rdx
	movb 	(%r13), %dl 			#assigning into %rsi the first index i
	movq 	$0, %rcx
	movb 	(%rsp), %cl 			#assigning into %rdx the second index j
	call 	pstrijcmp

	movq 	$message54, %rdi 	#the message54 is the first paramter passed to the printf function
	movq 	%rax, %rsi 			#the return value of `pstrijcmp` is the second parameter of printf
	movq	$0, %rax	
	call 	printf 				#printing the result of the compare- the return value of pstrijcmp function.

	leaq 	8(%rsp), %rsp  		#moving %rsp back to its original address (before we allocated the 8 bytes for i and j)

	jmp 		.return
.default: 						#default: print message 
	movq	$def_message, %rdi 	#the string is the only paramter passed to the printf function
	movq	$0,%rax
	call	printf				#calling to printf in order to print the default message	
	jmp 		.return
.return:
	movq	$0, %rax
	ret 							#return to caller function (main).

