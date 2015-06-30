	.inesprg 1	; 1 PRG bank
	.ineschr 0	; 0 CHR bank
	.inesmir 0	; �������� 0
	.inesmap 4	; mapper 4 (MMC3)
	.org $C000
	.bank 0

start:
	jsr vwait
	lda #$80
	sta $2000	; ��NMI�жϣ��ⲿ����������
	lda #$8
	sta $2001	; ��������ʾ��ʹMMC3�ܹ�����
	lda #$40
	sta $4017	; ����֡����IRQ
	cli		; ����IRQ����

gameloop:
	jmp gameloop
			;  NMI ����
nmi:
	lda #$3F	; -\
	sta $2006	;   > �豳��ɫΪ��ɫ
	lda #0		;  |
	sta $2006	;  |
	lda #$6		;  |
	sta $2007	; -/
	lda #1
	sta $E000
	lda #$78	; $78=120
	sta $C000	; ���� MMC3 ������
	lda #$78
	sta $C001	; 120 ɨ����
	lda #1
	sta $E000
	lda #1
	sta $E001
	lda #0
	sta $2006
	lda #0
	sta $2006
	lda #$8
	sta $2001	; ��������ʾ��ʹMMC3�ܹ�����
	rti
			; IRQ ����
irq:

	pha
	txa
	pha		; ����A,X and Y.  �����������������Ϊ
	tya		; IRQ �ж��������������̣���ı���Ĵ�����
	pha		; 
			; �Ǿͻ�����...
	lda #0
	sta $2001	; ����ǿ�ƹرգ����޴��ķ��������ܹ�ʵ���Ҹı䱳��ɫ
	lda #$3F	; -\
	sta $2006	;  |
	lda #0		;  |
	sta $2006	;   > �豳��ɫΪ��ɫ
	lda #$0A	;  |
	sta $2007	; -/
	lda #1
	sta $E000	; Ӧ��IRQ������ֹ��һ����IRQ���ⲿ��������
	lda #0
	sta $2006
	lda #0
	sta $2006

	pla
	tay		; ��ԭ��ļĴ���
	pla
	tax
	pla
	rti
			; �ȵ���Ļˢ��
vwait:
	lda $2002
	bpl vwait	; �ȵ�ˢ�¿�ʼ
vwait_1:
	lda $2002
	bmi vwait_1	; �ȵ�ˢ�½���
	rts
			; �ļ�β��
			; ��ת�� NMI, Reset, IRQ ����ָ��
	.bank 1
	.org $fffa
	.dw nmi, start, irq

