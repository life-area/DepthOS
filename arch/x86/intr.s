// .intel_syntax noprefix
.text

.global idt_flush

.extern intr_handler
.extern irq_handler

.macro INTR_NOERRCODE num
	.global intr\num
	intr\num:
		cli
		pushl $0
		pushl $\num
		jmp intr_cstub
.endm

.macro INTR_ERRCODE num
	.global intr\num
	intr\num:
		cli
		pushl $\num
		jmp intr_cstub
.endm

.macro IRQ_NOERRCODE num
	.global intr\num
	intr\num:
		// push 0 in place of the error code
		pushl	$0
		pushl	$\num
		jmp	irq_cstub
.endm


INTR_NOERRCODE 0
INTR_NOERRCODE 1
INTR_NOERRCODE 2
INTR_NOERRCODE 3
INTR_NOERRCODE 4
INTR_NOERRCODE 5
INTR_NOERRCODE 6
INTR_NOERRCODE 7
INTR_ERRCODE   8
INTR_NOERRCODE 9
INTR_ERRCODE   10
INTR_ERRCODE   11
INTR_ERRCODE   12
INTR_ERRCODE   13
INTR_ERRCODE   14
INTR_NOERRCODE 15
INTR_NOERRCODE 16
INTR_NOERRCODE 17
INTR_NOERRCODE 18
INTR_NOERRCODE 19
INTR_NOERRCODE 20
INTR_NOERRCODE 21
INTR_NOERRCODE 22
INTR_NOERRCODE 23
INTR_NOERRCODE 24
INTR_NOERRCODE 25
INTR_NOERRCODE 26
INTR_NOERRCODE 27
INTR_NOERRCODE 28
INTR_NOERRCODE 29
INTR_NOERRCODE 30
INTR_NOERRCODE 31
# IRQ HANDLERS
IRQ_NOERRCODE 32
IRQ_NOERRCODE 33
IRQ_NOERRCODE 34
IRQ_NOERRCODE 35
IRQ_NOERRCODE 36
IRQ_NOERRCODE 37
IRQ_NOERRCODE 38
IRQ_NOERRCODE 39
IRQ_NOERRCODE 40
IRQ_NOERRCODE 41
IRQ_NOERRCODE 42
IRQ_NOERRCODE 43
IRQ_NOERRCODE 44
IRQ_NOERRCODE 45
IRQ_NOERRCODE 46
IRQ_NOERRCODE 47
# END IRQ HANDLERS
INTR_NOERRCODE	48
INTR_NOERRCODE	49
INTR_NOERRCODE	50
INTR_NOERRCODE	51
INTR_NOERRCODE	52
INTR_NOERRCODE	53
INTR_NOERRCODE	54
INTR_NOERRCODE	55
INTR_NOERRCODE	56
INTR_NOERRCODE	57
INTR_NOERRCODE	58
INTR_NOERRCODE	59
INTR_NOERRCODE	60
INTR_NOERRCODE	61
INTR_NOERRCODE	62
INTR_NOERRCODE	63
INTR_NOERRCODE	64
INTR_NOERRCODE	65
INTR_NOERRCODE	66
INTR_NOERRCODE	67
INTR_NOERRCODE	68
INTR_NOERRCODE	69
INTR_NOERRCODE	70
INTR_NOERRCODE	71
INTR_NOERRCODE	72
INTR_NOERRCODE	73
INTR_NOERRCODE	74
INTR_NOERRCODE	75
INTR_NOERRCODE	76
INTR_NOERRCODE	77
INTR_NOERRCODE	78
INTR_NOERRCODE	79
INTR_NOERRCODE	80
INTR_NOERRCODE	81
INTR_NOERRCODE	82
INTR_NOERRCODE	83
INTR_NOERRCODE	84
INTR_NOERRCODE	85
INTR_NOERRCODE	86
INTR_NOERRCODE	87
INTR_NOERRCODE	88
INTR_NOERRCODE	89
INTR_NOERRCODE	90
INTR_NOERRCODE	91
INTR_NOERRCODE	92
INTR_NOERRCODE	93
INTR_NOERRCODE	94
INTR_NOERRCODE	95
INTR_NOERRCODE	96
INTR_NOERRCODE	97
INTR_NOERRCODE	98
INTR_NOERRCODE	99
INTR_NOERRCODE	100
INTR_NOERRCODE	101
INTR_NOERRCODE	102
INTR_NOERRCODE	103
INTR_NOERRCODE	104
INTR_NOERRCODE	105
INTR_NOERRCODE	106
INTR_NOERRCODE	107
INTR_NOERRCODE	108
INTR_NOERRCODE	109
INTR_NOERRCODE	110
INTR_NOERRCODE	111
INTR_NOERRCODE	112
INTR_NOERRCODE	113
INTR_NOERRCODE	114
INTR_NOERRCODE	115
INTR_NOERRCODE	116
INTR_NOERRCODE	117
INTR_NOERRCODE	118
INTR_NOERRCODE	119
INTR_NOERRCODE	120
INTR_NOERRCODE	121
INTR_NOERRCODE	122
INTR_NOERRCODE	123
INTR_NOERRCODE	124
INTR_NOERRCODE	125
INTR_NOERRCODE	126
INTR_NOERRCODE	127
INTR_NOERRCODE 128


intr_cstub:
	pusha
	push	%ds
	push	%es
	push	%gs
	push	%fs
	mov	$0x10, %ax
	mov	%ax, %ds
	mov	%ax, %es
	mov	%ax, %fs
	mov	%ax, %gs
	// Call the kernel IRQ handler
	call	intr_handler

	pop	%fs
	pop	%gs
	pop	%es
	pop	%ds
	popa
	add	$8, %esp
	sti
	iret

irq_cstub:
	pusha
	push	%ds
	push	%es
	push	%gs
	push	%fs
	mov	$0x10, %ax
	mov	%ax, %ds
	mov	%ax, %es
	mov	%ax, %fs
	mov	%ax, %gs
	// Call the kernel IRQ handler
	call	irq_handler

	pop	%fs
	pop	%gs
	pop	%es
	pop	%ds
	popa
	// pop error code and IRQ number
	add	$8, %esp
	iret

.extern idt_ptr

idt_flush:
	lidt idt_ptr
	ret
