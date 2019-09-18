
	.data
	.globl student1
	.globl student2
	.globl student3
	.globl sum 
	
	
line1:		.asciz "*****Input ID*****\n"
line2:		.asciz "** Please Enter Member 1 ID: **\n"
line3:		.asciz "** Please Enter Member 2 ID: **\n"
line4:		.asciz "** Please Enter Member 3 ID: **\n"
line5:		.asciz "** Please Enter Command **\n"
line6:		.asciz "*****Print Team Member ID and ID Summation*****\n"
line7:		.asciz "\nID Summation = %d \n"
line8:		.asciz "*****End Print*****\n"
student1:	.word 0
student2: 	.word 0
student3: 	.word 0	
sum:		.word 0
out: 		.asciz "p"
int:		.asciz "%d"
intenter:	.asciz "%d\n"
total:		.asciz "%d"
charp:		.asciz "%s"
p:			.asciz ""






	.text
	.globl id
id:		stmfd sp!,{lr}			@back up
		ldr r0, =line1		
		bl printf				@print *****Input ID*****

		ldr r0, =line2
		bl printf				@print ** Please Enter Member 1 ID: **
		
		ldr r0, =int		
		ldr r1, =student1
		bl scanf				@enter student1 ID

		ldr r0, = line3
		bl printf				@print ** Please Enter Member 2 ID: **
		
		ldr r0, =int		
		ldr r1, =student2
		bl scanf				@enter student2 ID

		ldr r0, = line4
		bl printf				@print ** Please Enter Member 3 ID: **
		
		ldr r0, =int		
		ldr r1, =student3
		bl scanf				@enter student2 ID
		

		ldr r1, =student1		@put student1's adress to r1
		ldr r1,[r1]				@convert it into value
		ldr r2, =student2		@put student2's adress to r2
		ldr r2,[r2]				@convert it into value
		ldr r3, =student3		@put student3's adress to r3
		ldr r3,[r3]				@convert it into value

		add r1, r1, r2
		add r1, r1, r3			@add r1 r2 r3 
		mov r4, r1				@let r4 = r1 + r2 + r3
		ldr r0, = sum			
		str r4,[r0] 			@put summation into memory of sum
		


		ldr r0, =line5
		bl printf				@print ** Please Enter Command **

		ldr r0, =charp
		ldr r1, =p
		bl scanf				@enter command

		ldr r1, =p
		ldrb r1, [r1]			@let r1 = command

		ldr r3, = out
		ldrb r3,[r3]			@let r3 = p


		cmp r1, r3				@compare r1 and r3
		bne end					@if r1 != r3  go to end
		ldreq r1, =p		
		ldrb r1, [r1,#1]		@take the value of second byte	
		ldr r3, =out
		ldrb r3, [r3,#1]		@take the value of second byte
		cmp r1, r3				@compare them(they all should be '\0')
		movne r0, #0
		bne end					@if r1 != r3  go to end

		ldr r0, =line6
		bl printf				@print *****Print Team Member ID and ID Summation*****

		ldr r0, =intenter
		ldr r1, =student1
		ldr r1, [r1]
		bl printf				@print student1's value

		
		ldr r0, =intenter
		ldr r1, =student2
		ldr r1, [r1]
		bl printf				@print student2's value

		
		ldr r0, =intenter
		ldr r1, =student3
		ldr r1, [r1]
		bl printf				@print student3's value

		ldr r1, = sum
		ldr r1, [r1]
		ldr r0, = line7	
		bl printf				@print sum

		ldr r0,= line8
		bl printf				@print *****End Print*****

end:	
		ldmfd sp!,{lr}
		mov pc,lr
		
