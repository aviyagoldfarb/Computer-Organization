	#201509635 aviya goldfarb
	#this is a program  that scans two pstrings and one number, and sends them as parameters to some function 
	.section		.rodata
int_format:		.string	"%d"	#int format for  scanf function
str_format:		.string	"%s"	#string format for scanf function

	.text						#the beginnig of the code
.globl	main					#the label "main" is used to state the initial point of this program
	.type	main, @function		# the label "main" representing the beginning of a function
main:							# the main function:
								#preparing for first calling to scanf- scanning the size of the first pstring
	pushq	%rbp				#save the old frame pointer
	movq	%rsp, %rbp			#create the new frame pointer
	leaq 	-4(%rsp), %rsp 		#allocating memory on the stack for  user`s  size (integer) input
	movq 	$int_format, %rdi 	#the int_format is the first paramter passed to the scanf function
	movq 	%rsp, %rsi 			#passing the address pointed by %rsp as the second parameter of scanf
	movq	$0, %rax
	call	scanf				#calling scanf. scanning the size of the first pstring
								#preparing for second calling to scanf- scanning the  first string
	movq	$0, %rbx
	movb	(%rsp),  %bl 			#assigning the scaned size of the first pstring to one byte register %bl
	leaq 	4(%rsp), %rsp 		#assigning to %rsp its original address
	subq	%rbx, %rsp 			#allocating memory on the stack for  user`s first string input
	subq	$2, %rsp 			#allocating another two bytes for the string`s size and for '\0' 
	
	movb	%bl, (%rsp)			#assigning to the first address (pointed by %rsp) in the stack, the first pstring`s size

	movq 	$str_format, %rdi 	#the str_format is the first paramter passed to the scanf function
	movq 	%rsp, %rsi 			#passing the address pointed by %rsp as the second parameter of scanf
	leaq 	1(%rsi), %rsi 		#promoting %rsi one byte in order to leave one byte for the  string`s size
	movq	$0, %rax
	call	scanf				#calling scanf. scanning the string of the first pstring

	movq	%rsp, %r14			#assigning to %r14 the first pointed address of the first pstring
								#preparing for third calling to scanf- scanning the size of the second pstring
	leaq 	-4(%rsp), %rsp 		#allocating memory on the stack for  user`s  size (integer) input
	movq 	$int_format, %rdi 	#the int_format is the first paramter passed to the scanf function
	movq 	%rsp, %rsi 			#passing the address pointed by %rsp as the second parameter of scanf
	movq	$0, %rax
	call	scanf				#calling scanf. scanning the size of the first pstring

	movq	$0, %r12
	movb	(%rsp),  %r12b 		#assigning the scaned size of the first pstring to one byte register %r12b
	leaq 	4(%rsp), %rsp 		#assigning to %rsp its previous address
	subq	%r12, %rsp 			#allocating memory on the stack for  user`s string input
	subq	$2, %rsp 			#allocating another two bytes for the string`s size and for '\0' 
	
	movb	%r12b, (%rsp)		#assigning to the first address (pointed by %rsp) in the stack, the second pstring`s size

	movq 	$str_format, %rdi 	#the str_format is the first paramter passed to the scanf function
	movq 	%rsp, %rsi 			#passing the address pointed by %rsp as the second parameter of scanf
	leaq 	1(%rsi), %rsi 		#promoting %rsi one byte in order to leave one byte for the  string`s size
	movq	$0, %rax
	call	scanf				#calling scanf. scanning the string of the second pstring

	movq	%rsp, %r15			#assigning to %r15 the first pointed address of the second pstring

	leaq 	-4(%rsp), %rsp 		#allocating memory on the stack for  user`s  option input
	movq 	$int_format, %rdi 	#the int_format is the first paramter passed to the scanf function
	movq 	%rsp, %rsi 			#passing the address pointed by %rsp as the second parameter of scanf
	movq	$0, %rax
	call	scanf				#calling scanf. scanning the number of the wanted option

	movl	(%rsp), %edi 			#the 'option' integer (which is pointed by %rsp) is the first parameter for run_func
	movq	%r14, %rsi 			#the first pstring (which is pointed by %r14) is the second parameter for run_func
	movq	%r15, %rdx 			#the second pstring (which is pointed by %r15) is the third parameter for run_func
	call 	run_func 			#run_func responsible for calling to the appropriate function according to the user`s 'option' input  

	movq	$0, %rax
	movq	%rbp, %rsp			#restore the old stack pointer - release all used memory
	popq	%rbp				#restore old frame pointer (the caller function frame)
	ret							#return to caller function (OS).
