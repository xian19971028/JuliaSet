	.data

	.globl team		
	.globl student11
	.globl student22
	.globl student33	
	.globl lastline	


	team:		.asciz"Team 01\n"
	firstline:	.asciz"*****Student Name*****\n"
	student11:	.asciz"Sam Yeh     \n"
	student22:	.asciz"Kevin Hsieh \n"
	student33:	.asciz"Eugene Lu   \n"
	lastline:	.asciz"*****End Print*****\n"
	
	.text
	.globl name
name:	stmfd sp!,{lr}			@back up
		ldr r0, = firstline		
		bl printf				@print *****Student Name*****
		ldr r0, = team			
		bl printf				@print Team 01
		ldr r0, = student11
		bl printf				@print Sam Yeh
		ldr r0, = student22
		bl printf				@print Kevin Hsieh
		ldr r0, = student33
		bl printf				@print Eugene Lu
		ldr r0, = lastline
		bl printf				@print *****End Print*****
		mov r0,#0				
		ldmfd sp!,{lr}			@return
		mov pc,lr
