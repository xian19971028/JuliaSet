

	.data

a: 			.word 4000000
b:			.word 1500
c:			.word 1000
d:			.word 65535
e:			.word 1280
	.text
	.globl draw
	.globl __aeabi_idiv

draw:			stmfd sp!,{r4-r12,lr}		@back up
				stral r0,[sp ,#-4] 			@sp-4 = cX
				stral r1,[sp ,#-8]			@sp-8 = cY
				stral r2,[sp ,#-12]			@sp-12 = width
				stral r3,[sp ,#-16] 			@sp-16 = height

				moval r4, #0					@color = 0
				moval r5, #255				@maxIter = 255
				moval r6, #0					@zx = 0
				moval r7, #0					@zy = 0
				moval r8, #0					@i = 0
				moval r9, #0					@x = 0
				moval r10, #0					@y = 0
				moval r11, #0					@tmp = 0


.for1:			ldr r0, [sp ,#-12]			    @get width value


				cmp r0,r9					@compare x,width
				ble .done					@if X >= width, call done

				movgt r10, #0				@let y = 0

.for2:			ldr r2, [sp, #-16]        	@load height value
				cmp r10,r2
				bge .for2done				@if y >= height


				ldrlt r0, [sp ,#-12]                @ width
				mov r1, r0, ASR#1			@r1 = width>>1
				sub r0,r9,r1				@r0 = x - ( width >> 1 )
				
				ldr r2, =b				    @r2 = 1500
				ldr r2, [r2]
				mul r0,r0,r2				@r0 = 1500 * x - (width >> 1)
				
				sub sp, sp, #20
				bl __aeabi_idiv				@r0 = x - ( width >> 1 ) / ( width >> 1 )
				add sp, sp, #20
				
				mov r6,r0					@store r0 to zx




				ldr r0, [sp, #-16]			@r0 = height
				mov r1,r0, ASR#1            @r1 = height >> 1
				sub r0,r10,r1				@r0 = y - ( height >> 1 )
				
				ldr r2, =c					@r1 = 1000
				ldr r2, [r2]
				mul r0,r0,r2				@r0 = 1000 * y - (height >> 1)/(height >> 1)
				
				sub sp, sp, #20
				bl __aeabi_idiv				@r0 = y - ( height >> 1 )/ ( height >> 1 )
				add sp, sp, #20
				
				mov r7,r0					@store r0 to zy
				mov r8,r5	                @ i = maxIter
				b .wh

.wh:			ldr r1, =a					@r1 = 4000000
				ldr r1, [r1]
				mov r3,r6					@r3 = zx
				mov r2,r7					@r2 = zy
				mul r3,r3,r3				@r3 = zx * zx
				mul r2,r2,r2				@r2 = zy * zy
				add r0,r2,r3				@r0 = ( zx * zx + zy * zy )
				cmp r0, r1
				bge .whdone					@if ( zx * zx + zy * zy ) >= 4000000
				cmp r8,#0
				ble .whdone					@if i <= 0

				ldr r1,=c
				ldr r1,[r1]                 @r1=1000
				sub r0,r3,r2				@r0 = ( zx * zx - zy * zy )
				sub sp, sp, #20
				bl __aeabi_idiv				@r0 = ( zx * zx - zy * zy ) / 1000
				add sp, sp, #20
				ldr r1,[sp, #-4]			@r1 = cX
				add r0,r0,r1				@r0 = ( zx * zx - zy * zy ) / 1000 + cX
				mov r11,r0					@store r0 to tmp


				mov	r1,#2
				mul r0,r6,r7				@r0 = zx * zy
				mul r0,r0,r1				@r0 = zx * zy * 2
				ldr r1,=c					@r1 = 1000
				ldr r1,[r1]
				sub sp, sp, #20
				bl __aeabi_idiv				@r0 = ( x * y * 2 ) / 1000
				add sp, sp, #20
				ldr r1,[sp, #-8]			@r1 = cY
				add r0,r0,r1				@r0 = ( x * y * 2 ) / 1000 +cY
				mov r7,r0					@store r0 to zy

				mov r6,r11					@zx = tmp

				sub r8,r8,#1				@i--

				b .wh						@loop




.whdone:		AND r1,r8,#0xff				@r1 = i&0xff
				mov r2,r1 					@r2 = r1 = i&0xff
				lsl r1 ,#8					@r1 = (i&0xff)<<8
				orr r4,r1,r2				@r4(color) = r1 or r2
				mvn r4,r4					@r4=~color
				ldr r1,=d
				ldr r1,[r1]					@r1 = 65535
				AND r4,r4,r1				@r4 = (~color)&r1



				ldr r3,[sp, #40]
				ldr r1, =e					@r1 =1280
				ldr r1, [r1]
				mul r0, r10, r1				@r0 = 1280y
				mov r2, #2
				mul r1, r9, r2				@r1 = 2x
				add r0, r0, r1 				@r0 = 1280y + 2x
				add r0, r0, r3				@color = 1280y + 2x + frame
				strh r4,[r0]

				mov r1,r10					@r1 = y
				add r1,r1,#1				@y++
				mov r10,r1					@store y back
				b .for2						@loop

.for2done:		mov r1,r9					@r1 = x
				add r1,r1,#1				@x++
				mov r9,r1					@store x back
				b .for1 						@loop

.done:			mov r0,#0
				ldmfd sp!,{r4-r12,lr}
				mov pc,lr					@return

