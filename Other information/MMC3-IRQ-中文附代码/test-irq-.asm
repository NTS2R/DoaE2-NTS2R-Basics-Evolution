	.inesprg 1	; 1 PRG bank
	.ineschr 0	; 0 CHR bank
	.inesmir 0	; 镜像类型 0
	.inesmap 4	; mapper 4 (MMC3)
	.org $C000
	.bank 0

start:
	jsr vwait
	lda #$80
	sta $2000	; 开NMI中断（外部）发生器。
	lda #$8
	sta $2001	; 开背景显示，使MMC3能够计数
	lda #$40
	sta $4017	; 禁用帧计数IRQ
	cli		; 启动IRQ过程

gameloop:
	jmp gameloop
			;  NMI 例程
nmi:
	lda #$3F	; -\
	sta $2006	;   > 设背景色为红色
	lda #0		;  |
	sta $2006	;  |
	lda #$6		;  |
	sta $2007	; -/
	lda #1
	sta $E000
	lda #$78	; $78=120
	sta $C000	; 设置 MMC3 发生器
	lda #$78
	sta $C001	; 120 扫描线
	lda #1
	sta $E000
	lda #1
	sta $E001
	lda #0
	sta $2006
	lda #0
	sta $2006
	lda #$8
	sta $2001	; 开背景显示，使MMC3能够计数
	rti
			; IRQ 例程
irq:

	pha
	txa
	pha		; 保存A,X and Y.  你必须这样做，是因为
	tya		; IRQ 中断了你的主代码进程，会改变你寄存器。
	pha		; 
			; 那就坏事了...
	lda #0
	sta $2001	; 背景强制关闭，叫愚蠢的仿真器，能够实现我改变背景色
	lda #$3F	; -\
	sta $2006	;  |
	lda #0		;  |
	sta $2006	;   > 设背景色为绿色
	lda #$0A	;  |
	sta $2007	; -/
	lda #1
	sta $E000	; 应答IRQ，并禁止进一步的IRQ（外部）发生器
	lda #0
	sta $2006
	lda #0
	sta $2006

	pla
	tay		; 还原你的寄存器
	pla
	tax
	pla
	rti
			; 等到屏幕刷新
vwait:
	lda $2002
	bpl vwait	; 等到刷新开始
vwait_1:
	lda $2002
	bmi vwait_1	; 等到刷新结束
	rts
			; 文件尾部
			; 跳转表 NMI, Reset, IRQ 开端指针
	.bank 1
	.org $fffa
	.dw nmi, start, irq

