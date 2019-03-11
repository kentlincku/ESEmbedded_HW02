.syntax unified

.word 0x20000100
.word _start

.global _start
.type _start, %function
_start:
	mov r0, sp
	mov r1, #1
	mov r2, #2
	mov r3, #3
	mov r4, #0
	mov r5, #0
	mov r6, #0
	push {r1, r2, r3}
	pop {r4, r5, r6}
	mov r4, #0
	mov r5, #0
	mov r6, #0
	str r1, [r0, #-4]
	str r2, [r0, #-8]
	str r3, [r0, #-12]
	ldr r4, [r0, #-4]
	ldr r5, [r0, #-8]
	ldr r6, [r0, #-12]
sleep:
	b	sleep
