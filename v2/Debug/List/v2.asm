
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _index=R4
	.DEF _index_msb=R5
	.DEF _state=R6
	.DEF _state_msb=R7
	.DEF _s=R8
	.DEF _s_msb=R9
	.DEF _c=R10
	.DEF _c_msb=R11
	.DEF _input=R13
	.DEF _rx_wr_index=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x1,0x0,0x0,0x0
	.DB  0x0

_0x3:
	.DB  0x66,0x66,0x56,0x41
_0x4:
	.DB  0x63,0x37,0x38,0x39,0x2A,0x2F,0x61,0x34
	.DB  0x35,0x36,0x2D,0x6D,0x28,0x31,0x32,0x33
	.DB  0x2B,0x70,0x29,0x30,0x2E,0x3D,0x2B,0x6E
_0x5C:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x0
_0x0:
	.DB  0x3D,0x0,0x20,0x25,0x36,0x2E,0x32,0x66
	.DB  0x0,0x25,0x66,0x0,0x25,0x31,0x2E,0x31
	.DB  0x66,0x0,0x6F,0x6B,0x0,0x45,0x52,0x52
	.DB  0x4F,0x52,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040003:
	.DB  0x80,0xC0
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x09
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x04
	.DW  _answer
	.DW  _0x3*2

	.DW  0x18
	.DW  _keys
	.DW  _0x4*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 1/15/2019
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdlib.h>
;#include <delay.h>
;#include <string.h>
;
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;char scankp();
;void showlcd();
;void clear();
;float cal();
;
;// Declare your global variables here
;float answer = 13.4;

	.DSEG
;float h_answer = 0; //saved answer from last process
;int index = 0;
;int state = 0; // 0 for input mode 1 for output mode
;int  s = 1,c = 0;
;char input ;
;char inarray[20] ;
;char str[16];
;int t = 0;
;char keys[4][6]={{'c','7','8','9','*','/'},{'a','4','5','6','-','m'},{'(','1','2','3','+','p'},{')','0','.','=','+','n'} ...
;// KEYPAD . OUTPUT ROWS AND INPUT COLS. INPUTS ARE PULLD UP INTERNALLY
;#define ROW1 PORTD.2
;#define ROW2 PORTD.3
;#define ROW3 PORTD.4
;#define ROW4 PORTD.5
;#define COL1 PINC.0
;#define COL2 PINC.1
;#define COL3 PINC.2
;#define COL4 PINC.3
;#define COL5 PINC.4
;#define COL6 PINC.5
;
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0059 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 005A char status,data;
; 0000 005B status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 005C data=UDR;
	IN   R16,12
; 0000 005D if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x5
; 0000 005E    {
; 0000 005F    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0060 #if RX_BUFFER_SIZE == 256
; 0000 0061    // special case for receiver buffer size=256
; 0000 0062    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 0063 #else
; 0000 0064    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R12
	BRNE _0x6
	CLR  R12
; 0000 0065    if (++rx_counter == RX_BUFFER_SIZE)
_0x6:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x8)
	BRNE _0x7
; 0000 0066       {
; 0000 0067       rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0000 0068       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0069       }
; 0000 006A #endif
; 0000 006B    }
_0x7:
; 0000 006C }
_0x5:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0073 {
; 0000 0074 char data;
; 0000 0075 while (rx_counter==0);
;	data -> R17
; 0000 0076 data=rx_buffer[rx_rd_index++];
; 0000 0077 #if RX_BUFFER_SIZE != 256
; 0000 0078 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0079 #endif
; 0000 007A #asm("cli")
; 0000 007B --rx_counter;
; 0000 007C #asm("sei")
; 0000 007D return data;
; 0000 007E }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0087 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0088 // Place your code here
; 0000 0089 t++;
	LDI  R26,LOW(_t)
	LDI  R27,HIGH(_t)
	CALL SUBOPT_0x0
; 0000 008A if(t>500){
	LDS  R26,_t
	LDS  R27,_t+1
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0xC
; 0000 008B     t=0;
	CALL SUBOPT_0x1
; 0000 008C }
; 0000 008D 
; 0000 008E }
_0xC:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 0091 {
_main:
; .FSTART _main
; 0000 0092 // Declare your local variables here
; 0000 0093 
; 0000 0094 // Input/Output Ports initialization
; 0000 0095 // Port A initialization
; 0000 0096 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0097 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0098 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0099 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 009A 
; 0000 009B // Port B initialization
; 0000 009C // Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 009D DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(60)
	OUT  0x17,R30
; 0000 009E // State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=T Bit0=T
; 0000 009F PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00A0 
; 0000 00A1 // Port C initialization
; 0000 00A2 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00A3 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 00A4 // State: Bit7=T Bit6=T Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 00A5 PORTC=(0<<PORTC7) | (0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	LDI  R30,LOW(63)
	OUT  0x15,R30
; 0000 00A6 
; 0000 00A7 // Port D initialization
; 0000 00A8 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00A9 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 00AA // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00AB PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00AC 
; 0000 00AD // Timer/Counter 0 initialization
; 0000 00AE // Clock source: System Clock
; 0000 00AF // Clock value: 125.000 kHz
; 0000 00B0 // Mode: CTC top=OCR0
; 0000 00B1 // OC0 output: Disconnected
; 0000 00B2 // Timer Period: 1 ms
; 0000 00B3 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(11)
	OUT  0x33,R30
; 0000 00B4 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00B5 OCR0=0x7C;
	LDI  R30,LOW(124)
	OUT  0x3C,R30
; 0000 00B6 
; 0000 00B7 // Timer/Counter 1 initialization
; 0000 00B8 // Clock source: System Clock
; 0000 00B9 // Clock value: Timer1 Stopped
; 0000 00BA // Mode: Normal top=0xFFFF
; 0000 00BB // OC1A output: Disconnected
; 0000 00BC // OC1B output: Disconnected
; 0000 00BD // Noise Canceler: Off
; 0000 00BE // Input Capture on Falling Edge
; 0000 00BF // Timer1 Overflow Interrupt: Off
; 0000 00C0 // Input Capture Interrupt: Off
; 0000 00C1 // Compare A Match Interrupt: Off
; 0000 00C2 // Compare B Match Interrupt: Off
; 0000 00C3 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00C4 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00C5 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00C6 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00C7 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00C8 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00C9 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00CA OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00CB OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00CC OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00CD 
; 0000 00CE // Timer/Counter 2 initialization
; 0000 00CF // Clock source: System Clock
; 0000 00D0 // Clock value: Timer2 Stopped
; 0000 00D1 // Mode: Normal top=0xFF
; 0000 00D2 // OC2 output: Disconnected
; 0000 00D3 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00D4 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00D5 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00D6 OCR2=0x00;
	OUT  0x23,R30
; 0000 00D7 
; 0000 00D8 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00D9 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00DA 
; 0000 00DB // External Interrupt(s) initialization
; 0000 00DC // INT0: Off
; 0000 00DD // INT1: Off
; 0000 00DE // INT2: Off
; 0000 00DF MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00E0 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00E1 
; 0000 00E2 // USART initialization
; 0000 00E3 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00E4 // USART Receiver: On
; 0000 00E5 // USART Transmitter: On
; 0000 00E6 // USART Mode: Asynchronous
; 0000 00E7 // USART Baud Rate: 9600
; 0000 00E8 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 00E9 UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 00EA UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00EB UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00EC UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 00ED 
; 0000 00EE // Analog Comparator initialization
; 0000 00EF // Analog Comparator: Off
; 0000 00F0 // The Analog Comparator's positive input is
; 0000 00F1 // connected to the AIN0 pin
; 0000 00F2 // The Analog Comparator's negative input is
; 0000 00F3 // connected to the AIN1 pin
; 0000 00F4 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00F5 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00F6 
; 0000 00F7 // ADC initialization
; 0000 00F8 // ADC disabled
; 0000 00F9 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00FA 
; 0000 00FB // SPI initialization
; 0000 00FC // SPI disabled
; 0000 00FD SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00FE 
; 0000 00FF // TWI initialization
; 0000 0100 // TWI disabled
; 0000 0101 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0102 
; 0000 0103 // Alphanumeric LCD initialization
; 0000 0104 // Connections are specified in the
; 0000 0105 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0106 // RS - PORTB Bit 0
; 0000 0107 // RD - PORTB Bit 1
; 0000 0108 // EN - PORTB Bit 2
; 0000 0109 // D4 - PORTB Bit 3
; 0000 010A // D5 - PORTB Bit 4
; 0000 010B // D6 - PORTB Bit 5
; 0000 010C // D7 - PORTB Bit 6
; 0000 010D // Characters/line: 16
; 0000 010E lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 010F 
; 0000 0110 // Global enable interrupts
; 0000 0111 #asm("sei")
	sei
; 0000 0112 
; 0000 0113 while (1)
_0xD:
; 0000 0114       {
; 0000 0115       // Place your code here
; 0000 0116         if(state == 0){ // input mode
	MOV  R0,R6
	OR   R0,R7
	BREQ PC+2
	RJMP _0x10
; 0000 0117             input = scankp();
	RCALL _scankp
	MOV  R13,R30
; 0000 0118             if((input != '=' && input != 'c' && input <= 58 && input >= 40) || input == 'a'){
	LDI  R30,LOW(61)
	CP   R30,R13
	BREQ _0x12
	LDI  R30,LOW(99)
	CP   R30,R13
	BREQ _0x12
	LDI  R30,LOW(58)
	CP   R30,R13
	BRLO _0x12
	LDI  R30,LOW(40)
	CP   R13,R30
	BRSH _0x14
_0x12:
	LDI  R30,LOW(97)
	CP   R30,R13
	BRNE _0x11
_0x14:
; 0000 0119                 inarray[index] = input;
	MOVW R30,R4
	SUBI R30,LOW(-_inarray)
	SBCI R31,HIGH(-_inarray)
	ST   Z,R13
; 0000 011A                 inarray[index+1] = 0;
	MOVW R30,R4
	__ADDW1MN _inarray,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 011B                 if(index < 19){
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x16
; 0000 011C                     index++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 011D                 }
; 0000 011E 
; 0000 011F             }
_0x16:
; 0000 0120 
; 0000 0121             if(input == 'c'){
_0x11:
	LDI  R30,LOW(99)
	CP   R30,R13
	BRNE _0x17
; 0000 0122                 clear();
	RCALL _clear
; 0000 0123             }
; 0000 0124 
; 0000 0125             if(input == '='){
_0x17:
	LDI  R30,LOW(61)
	CP   R30,R13
	BRNE _0x18
; 0000 0126                 state = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
; 0000 0127                 answer = cal();
	RCALL _cal
	STS  _answer,R30
	STS  _answer+1,R31
	STS  _answer+2,R22
	STS  _answer+3,R23
; 0000 0128                 h_answer = answer;
	CALL SUBOPT_0x2
	STS  _h_answer,R30
	STS  _h_answer+1,R31
	STS  _h_answer+2,R22
	STS  _h_answer+3,R23
; 0000 0129                 lcd_clear();
	CALL _lcd_clear
; 0000 012A             }
; 0000 012B             showlcd();
_0x18:
	RCALL _showlcd
; 0000 012C         }
; 0000 012D 
; 0000 012E         if(state == 1){
_0x10:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x19
; 0000 012F            if((input = scankp()) == 'c'){
	RCALL _scankp
	MOV  R13,R30
	CPI  R30,LOW(0x63)
	BRNE _0x1A
; 0000 0130                 clear();
	RCALL _clear
; 0000 0131                 state = 0;
	CLR  R6
	CLR  R7
; 0000 0132            }
; 0000 0133            showlcd();
_0x1A:
	RCALL _showlcd
; 0000 0134         }
; 0000 0135 
; 0000 0136 
; 0000 0137       }
_0x19:
	RJMP _0xD
; 0000 0138 }
_0x1B:
	RJMP _0x1B
; .FEND
;char scankp(){ //a function that scans the keypad and returns proper input
; 0000 0139 char scankp(){
_scankp:
; .FSTART _scankp
; 0000 013A     int i = 0, j = 0;
; 0000 013B if( c == 0){
	CALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	MOV  R0,R10
	OR   R0,R11
	BREQ PC+2
	RJMP _0x1C
; 0000 013C     if(s == 1){
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x1D
; 0000 013D           ROW1 = 0;
	CBI  0x12,2
; 0000 013E           ROW2 = 1;
	SBI  0x12,3
; 0000 013F           ROW3 = 1;
	SBI  0x12,4
; 0000 0140           ROW4 = 1;
	SBI  0x12,5
; 0000 0141           i = 0;
	__GETWRN 16,17,0
; 0000 0142           if(COL1 == 0){
	SBIC 0x13,0
	RJMP _0x26
; 0000 0143             j = 0;
	CALL SUBOPT_0x3
; 0000 0144             c = 1;
; 0000 0145             t = 0;
; 0000 0146             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 0147           }
; 0000 0148           if(COL2 == 0){
_0x26:
	SBIC 0x13,1
	RJMP _0x27
; 0000 0149             j = 1;
	CALL SUBOPT_0x5
; 0000 014A             c = 1;
; 0000 014B             t = 0;
; 0000 014C             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 014D           }
; 0000 014E           if(COL3 == 0){
_0x27:
	SBIC 0x13,2
	RJMP _0x28
; 0000 014F             j = 2;
	CALL SUBOPT_0x6
; 0000 0150             c = 1;
; 0000 0151             t = 0;
; 0000 0152             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 0153           }
; 0000 0154           if(COL4 == 0){
_0x28:
	SBIC 0x13,3
	RJMP _0x29
; 0000 0155             j = 3;
	CALL SUBOPT_0x7
; 0000 0156             c = 1;
; 0000 0157             t = 0;
; 0000 0158             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 0159           }
; 0000 015A           if(COL5 == 0){
_0x29:
	SBIC 0x13,4
	RJMP _0x2A
; 0000 015B             j = 4;
	CALL SUBOPT_0x8
; 0000 015C             c = 1;
; 0000 015D             t = 0;
; 0000 015E             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 015F           }
; 0000 0160           if(COL6 == 0){
_0x2A:
	SBIC 0x13,5
	RJMP _0x2B
; 0000 0161             j = 5;
	CALL SUBOPT_0x9
; 0000 0162             c = 1;
; 0000 0163             t = 0;
; 0000 0164             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 0165           }
; 0000 0166           s = 2;
_0x2B:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R8,R30
; 0000 0167           return -1;
	LDI  R30,LOW(255)
	RJMP _0x20C000A
; 0000 0168     }
; 0000 0169 
; 0000 016A     if(s == 2){
_0x1D:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x2C
; 0000 016B           ROW1 = 1;
	SBI  0x12,2
; 0000 016C           ROW2 = 0;
	CBI  0x12,3
; 0000 016D           ROW3 = 1;
	SBI  0x12,4
; 0000 016E           ROW4 = 1;
	SBI  0x12,5
; 0000 016F           i = 1;
	__GETWRN 16,17,1
; 0000 0170           if(COL1 == 0){
	SBIC 0x13,0
	RJMP _0x35
; 0000 0171             j = 0;
	CALL SUBOPT_0x3
; 0000 0172             c = 1;
; 0000 0173             t = 0;
; 0000 0174             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 0175           }
; 0000 0176           if(COL2 == 0){
_0x35:
	SBIC 0x13,1
	RJMP _0x36
; 0000 0177             j = 1;
	CALL SUBOPT_0x5
; 0000 0178             c = 1;
; 0000 0179             t = 0;
; 0000 017A             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 017B           }
; 0000 017C           if(COL3 == 0){
_0x36:
	SBIC 0x13,2
	RJMP _0x37
; 0000 017D             j = 2;
	CALL SUBOPT_0x6
; 0000 017E             c = 1;
; 0000 017F             t = 0;
; 0000 0180             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 0181           }
; 0000 0182           if(COL4 == 0){
_0x37:
	SBIC 0x13,3
	RJMP _0x38
; 0000 0183             j = 3;
	CALL SUBOPT_0x7
; 0000 0184             c = 1;
; 0000 0185             t = 0;
; 0000 0186             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 0187           }
; 0000 0188           if(COL5 == 0){
_0x38:
	SBIC 0x13,4
	RJMP _0x39
; 0000 0189             j = 4;
	CALL SUBOPT_0x8
; 0000 018A             c = 1;
; 0000 018B             t = 0;
; 0000 018C             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 018D           }
; 0000 018E           if(COL6 == 0){
_0x39:
	SBIC 0x13,5
	RJMP _0x3A
; 0000 018F             j = 5;
	CALL SUBOPT_0x9
; 0000 0190             c = 1;
; 0000 0191             t = 0;
; 0000 0192             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 0193           }
; 0000 0194           s = 3;
_0x3A:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R8,R30
; 0000 0195           return -1;
	LDI  R30,LOW(255)
	RJMP _0x20C000A
; 0000 0196 
; 0000 0197     }
; 0000 0198 
; 0000 0199      if(s == 3){
_0x2C:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x3B
; 0000 019A           ROW1 = 1;
	SBI  0x12,2
; 0000 019B           ROW2 = 1;
	SBI  0x12,3
; 0000 019C           ROW3 = 0;
	CBI  0x12,4
; 0000 019D           ROW4 = 1;
	SBI  0x12,5
; 0000 019E           i = 2;
	__GETWRN 16,17,2
; 0000 019F           if(COL1 == 0){
	SBIC 0x13,0
	RJMP _0x44
; 0000 01A0             j = 0;
	CALL SUBOPT_0x3
; 0000 01A1             c = 1;
; 0000 01A2             t = 0;
; 0000 01A3             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 01A4           }
; 0000 01A5           if(COL2 == 0){
_0x44:
	SBIC 0x13,1
	RJMP _0x45
; 0000 01A6             j = 1;
	CALL SUBOPT_0x5
; 0000 01A7             c = 1;
; 0000 01A8             t = 0;
; 0000 01A9             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 01AA           }
; 0000 01AB           if(COL3 == 0){
_0x45:
	SBIC 0x13,2
	RJMP _0x46
; 0000 01AC             j = 2;
	CALL SUBOPT_0x6
; 0000 01AD             c = 1;
; 0000 01AE             t = 0;
; 0000 01AF             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 01B0           }
; 0000 01B1           if(COL4 == 0){
_0x46:
	SBIC 0x13,3
	RJMP _0x47
; 0000 01B2             j = 3;
	CALL SUBOPT_0x7
; 0000 01B3             c = 1;
; 0000 01B4             t = 0;
; 0000 01B5             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 01B6           }
; 0000 01B7           if(COL5 == 0){
_0x47:
	SBIC 0x13,4
	RJMP _0x48
; 0000 01B8             j = 4;
	CALL SUBOPT_0x8
; 0000 01B9             c = 1;
; 0000 01BA             t = 0;
; 0000 01BB             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 01BC           }
; 0000 01BD           if(COL6 == 0){
_0x48:
	SBIC 0x13,5
	RJMP _0x49
; 0000 01BE             j = 5;
	CALL SUBOPT_0x9
; 0000 01BF             c = 1;
; 0000 01C0             t = 0;
; 0000 01C1             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 01C2           }
; 0000 01C3           s = 4;
_0x49:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R8,R30
; 0000 01C4           return -1;
	LDI  R30,LOW(255)
	RJMP _0x20C000A
; 0000 01C5 
; 0000 01C6     }
; 0000 01C7 
; 0000 01C8      if(s == 4){
_0x3B:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x4A
; 0000 01C9           ROW1 = 1;
	SBI  0x12,2
; 0000 01CA           ROW2 = 1;
	SBI  0x12,3
; 0000 01CB           ROW3 = 1;
	SBI  0x12,4
; 0000 01CC           ROW4 = 0;
	CBI  0x12,5
; 0000 01CD           i = 3;
	__GETWRN 16,17,3
; 0000 01CE           if(COL1 == 0){
	SBIC 0x13,0
	RJMP _0x53
; 0000 01CF             j = 0;
	CALL SUBOPT_0x3
; 0000 01D0             c = 1;
; 0000 01D1             t = 0;
; 0000 01D2             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 01D3           }
; 0000 01D4           if(COL2 == 0){
_0x53:
	SBIC 0x13,1
	RJMP _0x54
; 0000 01D5             j = 1;
	CALL SUBOPT_0x5
; 0000 01D6             c = 1;
; 0000 01D7             t = 0;
; 0000 01D8             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 01D9           }
; 0000 01DA           if(COL3 == 0){
_0x54:
	SBIC 0x13,2
	RJMP _0x55
; 0000 01DB             j = 2;
	CALL SUBOPT_0x6
; 0000 01DC             c = 1;
; 0000 01DD             t = 0;
; 0000 01DE             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 01DF           }
; 0000 01E0           if(COL4 == 0){
_0x55:
	SBIC 0x13,3
	RJMP _0x56
; 0000 01E1             j = 3;
	CALL SUBOPT_0x7
; 0000 01E2             c = 1;
; 0000 01E3             t = 0;
; 0000 01E4             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 01E5           }
; 0000 01E6           if(COL5 == 0){
_0x56:
	SBIC 0x13,4
	RJMP _0x57
; 0000 01E7             j = 4;
	CALL SUBOPT_0x8
; 0000 01E8             c = 1;
; 0000 01E9             t = 0;
; 0000 01EA             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 01EB           }
; 0000 01EC           if(COL6 == 0){
_0x57:
	SBIC 0x13,5
	RJMP _0x58
; 0000 01ED             j = 5;
	CALL SUBOPT_0x9
; 0000 01EE             c = 1;
; 0000 01EF             t = 0;
; 0000 01F0             return keys[i][j];
	CALL SUBOPT_0x4
	RJMP _0x20C000A
; 0000 01F1           }
; 0000 01F2           s = 1;
_0x58:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 01F3           return -1;
	LDI  R30,LOW(255)
	RJMP _0x20C000A
; 0000 01F4     }
; 0000 01F5 }
_0x4A:
; 0000 01F6 
; 0000 01F7 if(t > 250){
_0x1C:
	LDS  R26,_t
	LDS  R27,_t+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x59
; 0000 01F8     c = 0;
	CLR  R10
	CLR  R11
; 0000 01F9 }
; 0000 01FA 
; 0000 01FB }
_0x59:
_0x20C000A:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;void clear(){
; 0000 01FC void clear(){
_clear:
; .FSTART _clear
; 0000 01FD 
; 0000 01FE     inarray[0] = 0;
	LDI  R30,LOW(0)
	STS  _inarray,R30
; 0000 01FF     index = 0;
	CLR  R4
	CLR  R5
; 0000 0200     lcd_clear();
	CALL _lcd_clear
; 0000 0201 }
	RET
; .FEND
;void showlcd(){
; 0000 0202 void showlcd(){
_showlcd:
; .FSTART _showlcd
; 0000 0203     //int j = 0;
; 0000 0204 
; 0000 0205      if(state == 0){ //input mode
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x5A
; 0000 0206       lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0207     /*  for(j = 0; j <= index; j++){
; 0000 0208         if(inarray[j] != 0){
; 0000 0209             sprintf(str,"%c",inarray[j]);
; 0000 020A             lcd_puts(str);
; 0000 020B         }
; 0000 020C       }
; 0000 020D       */
; 0000 020E       lcd_puts(inarray);
	LDI  R26,LOW(_inarray)
	LDI  R27,HIGH(_inarray)
	CALL _lcd_puts
; 0000 020F      }
; 0000 0210 
; 0000 0211      if(state == 1){
_0x5A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x5B
; 0000 0212         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0213         lcd_putsf("=");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 0214         sprintf(str," %6.2f",answer);
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,2
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2
	CALL SUBOPT_0xA
; 0000 0215         lcd_puts(str);
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	CALL _lcd_puts
; 0000 0216      }
; 0000 0217 }
_0x5B:
	RET
; .FEND
;float cal(){
; 0000 0218 float cal(){
_cal:
; .FSTART _cal
; 0000 0219 
; 0000 021A     int paran = 1;// if it contains parans
; 0000 021B     int size = 0;
; 0000 021C     int muldive = 1; // if it contains mults and divisions
; 0000 021D     int subsum = 1; //if it contains subs and sums
; 0000 021E     int err = 0;
; 0000 021F     int i = 0;
; 0000 0220     int j = 0;
; 0000 0221     int k = 0;
; 0000 0222     int iop = 0; //opening paran index
; 0000 0223     int icp = 0; //closing paran index
; 0000 0224     char tempreschar[10]; //temp result of each part
; 0000 0225     float tempresint;
; 0000 0226     char chars[15][8]; // seperated nums and ops
; 0000 0227     char temp[15][8]; // temp char used for parans
; 0000 0228     int tempsize = 0; // size of temp char
; 0000 0229     float numbers[10]; // in order to sort ops and numbers in from left to right
; 0000 022A     for(i = 0; i < strlen(inarray); i++){
	SBIW R28,54
	SUBI R29,1
	__GETWRN 24,25,270
	LDI  R26,LOW(40)
	LDI  R27,HIGH(40)
	LDI  R30,LOW(_0x5C*2)
	LDI  R31,HIGH(_0x5C*2)
	CALL __INITLOCW
	CALL __SAVELOCR6
;	paran -> R16,R17
;	size -> R18,R19
;	muldive -> R20,R21
;	subsum -> Y+314
;	err -> Y+312
;	i -> Y+310
;	j -> Y+308
;	k -> Y+306
;	iop -> Y+304
;	icp -> Y+302
;	tempreschar -> Y+292
;	tempresint -> Y+288
;	chars -> Y+168
;	temp -> Y+48
;	tempsize -> Y+46
;	numbers -> Y+6
	__GETWRN 16,17,1
	__GETWRN 18,19,0
	__GETWRN 20,21,1
	CALL SUBOPT_0xB
_0x5E:
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	BRLO PC+2
	RJMP _0x5F
; 0000 022B         if(inarray[i] == '+' || inarray[i] == '-' || inarray[i] == '*' || inarray[i] == '/' || inarray[i] == '(' || inar ...
	CALL SUBOPT_0xE
	LD   R26,Z
	CPI  R26,LOW(0x2B)
	BREQ _0x61
	CPI  R26,LOW(0x2D)
	BREQ _0x61
	CPI  R26,LOW(0x2A)
	BREQ _0x61
	CPI  R26,LOW(0x2F)
	BREQ _0x61
	CPI  R26,LOW(0x28)
	BREQ _0x61
	CPI  R26,LOW(0x29)
	BRNE _0x60
_0x61:
; 0000 022C 
; 0000 022D             chars[j][0] = inarray[i];
	CALL SUBOPT_0xF
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0xE
	LD   R30,Z
	ST   X,R30
; 0000 022E             chars[j][1] = 0;
	CALL SUBOPT_0xF
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 022F             if(i < strlen(inarray)-1)
	CALL SUBOPT_0xC
	SBIW R30,1
	CALL SUBOPT_0xD
	BRSH _0x63
; 0000 0230             j++;
	CALL SUBOPT_0x10
; 0000 0231 
; 0000 0232         }
_0x63:
; 0000 0233         else if((inarray[i] < 58 && inarray[i] > 47) || inarray[i] == '.'){  //agar adad bood
	RJMP _0x64
_0x60:
	CALL SUBOPT_0xE
	LD   R26,Z
	CPI  R26,LOW(0x3A)
	BRSH _0x66
	CPI  R26,LOW(0x30)
	BRSH _0x68
_0x66:
	LD   R26,Z
	CPI  R26,LOW(0x2E)
	BRNE _0x65
_0x68:
; 0000 0234 
; 0000 0235             chars[j][k] = inarray[i];
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	CALL SUBOPT_0xE
	LD   R30,Z
	ST   X,R30
; 0000 0236             k++;
	MOVW R26,R28
	SUBI R26,LOW(-(306))
	SBCI R27,HIGH(-(306))
	CALL SUBOPT_0x0
; 0000 0237              if(i+1 < strlen(inarray)){
	CALL SUBOPT_0xC
	CALL SUBOPT_0x12
	ADIW R26,1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x6A
; 0000 0238                 if(!((inarray[i+1] < 58 && inarray[i+1] > 47) || inarray[i+1] == '.')){   //agar adad nabood
	CALL SUBOPT_0x13
	__ADDW1MN _inarray,1
	LD   R26,Z
	CPI  R26,LOW(0x3A)
	BRSH _0x6C
	CPI  R26,LOW(0x30)
	BRSH _0x6E
_0x6C:
	LD   R26,Z
	CPI  R26,LOW(0x2E)
	BRNE _0x6F
_0x6E:
	RJMP _0x6B
_0x6F:
; 0000 0239 
; 0000 023A                       chars[j][k] = 0;
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 023B                       if(i < strlen(inarray)-1)
	CALL SUBOPT_0xC
	SBIW R30,1
	CALL SUBOPT_0xD
	BRSH _0x70
; 0000 023C                       j++;
	CALL SUBOPT_0x10
; 0000 023D                       k = 0;
_0x70:
	LDI  R30,LOW(0)
	__CLRW1SX 306
; 0000 023E                 }
; 0000 023F             }
_0x6B:
; 0000 0240 
; 0000 0241         }
_0x6A:
; 0000 0242         else if(inarray[i] == 'a'){
	RJMP _0x71
_0x65:
	CALL SUBOPT_0xE
	LD   R26,Z
	CPI  R26,LOW(0x61)
	BRNE _0x72
; 0000 0243             sprintf(chars[j],"%f",h_answer);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	LDS  R30,_h_answer
	LDS  R31,_h_answer+1
	LDS  R22,_h_answer+2
	LDS  R23,_h_answer+3
	CALL SUBOPT_0xA
; 0000 0244             chars[j][strlen(chars[j])-1] = 0;
	CALL SUBOPT_0x16
	CALL __LSLW3
	MOVW R0,R30
	MOVW R26,R28
	SUBI R26,LOW(-(168))
	SBCI R27,HIGH(-(168))
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R30,R0
	CALL SUBOPT_0x17
	CALL _strlen
	SBIW R30,1
	POP  R26
	POP  R27
	CALL SUBOPT_0x18
; 0000 0245             if(i < strlen(inarray)-1)
	CALL SUBOPT_0xC
	SBIW R30,1
	CALL SUBOPT_0xD
	BRSH _0x73
; 0000 0246             j++;
	CALL SUBOPT_0x10
; 0000 0247         }
_0x73:
; 0000 0248     }
_0x72:
_0x71:
_0x64:
	CALL SUBOPT_0x19
	RJMP _0x5E
_0x5F:
; 0000 0249 
; 0000 024A     size = j;
	__GETWRSX 18,19,308
; 0000 024B     chars[size+1][0] = 0;
	MOVW R30,R18
	CALL SUBOPT_0x1A
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 024C 
; 0000 024D     while(paran == 1){
_0x74:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+2
	RJMP _0x76
; 0000 024E         paran = 0;
	__GETWRN 16,17,0
; 0000 024F         for(i = 0; i <= size; i++){
	CALL SUBOPT_0xB
_0x78:
	CALL SUBOPT_0x1B
	BRLT _0x79
; 0000 0250             if(chars[i][0] == ')'){
	CALL SUBOPT_0x1C
	LD   R26,X
	CPI  R26,LOW(0x29)
	BRNE _0x7A
; 0000 0251                 paran = 1;
	__GETWRN 16,17,1
; 0000 0252                 icp = i;
	CALL SUBOPT_0x13
	__PUTW1SX 302
; 0000 0253                 break;
	RJMP _0x79
; 0000 0254 
; 0000 0255             }
; 0000 0256         }
_0x7A:
	CALL SUBOPT_0x19
	RJMP _0x78
_0x79:
; 0000 0257         for(i = size; i >= 0; i--){
	__PUTWSRX 18,19,310
_0x7C:
	__GETB2SX 311
	TST  R26
	BRMI _0x7D
; 0000 0258             if(chars[i][0] == '(' && i < icp){
	CALL SUBOPT_0x1C
	LD   R26,X
	CPI  R26,LOW(0x28)
	BRNE _0x7F
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xD
	BRLT _0x80
_0x7F:
	RJMP _0x7E
_0x80:
; 0000 0259                 iop = i;
	CALL SUBOPT_0x13
	__PUTW1SX 304
; 0000 025A                 tempsize = icp - iop - 2;
	CALL SUBOPT_0x1E
	SBIW R30,2
	STD  Y+46,R30
	STD  Y+46+1,R31
; 0000 025B                 break;
	RJMP _0x7D
; 0000 025C             }
; 0000 025D         }
_0x7E:
	MOVW R26,R28
	SUBI R26,LOW(-(310))
	SBCI R27,HIGH(-(310))
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x7C
_0x7D:
; 0000 025E 
; 0000 025F         for(i = 0; i < icp - iop - 1; i++){    //extracting inside of the paran into temp
	CALL SUBOPT_0xB
_0x82:
	CALL SUBOPT_0x1E
	SBIW R30,1
	CALL SUBOPT_0xD
	BRGE _0x83
; 0000 0260             strncpy(temp[i],chars[iop+i+1],8);
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x14
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	CALL SUBOPT_0x22
	LDI  R26,LOW(8)
	CALL _strncpy
; 0000 0261 
; 0000 0262         }
	CALL SUBOPT_0x19
	RJMP _0x82
_0x83:
; 0000 0263 
; 0000 0264 
; 0000 0265         if(paran == 1){
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+2
	RJMP _0x84
; 0000 0266           //------------------------------------------------------ calculating paran
; 0000 0267              while(muldive == 1){
_0x85:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ PC+2
	RJMP _0x87
; 0000 0268                     muldive = 0;
	__GETWRN 20,21,0
; 0000 0269                     for(i = 0; i <= tempsize; i++){
	CALL SUBOPT_0xB
_0x89:
	CALL SUBOPT_0x23
	BRGE PC+2
	RJMP _0x8A
; 0000 026A 
; 0000 026B                         if(temp[i][0] == '*'){
	CALL SUBOPT_0x1F
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x2A)
	BRNE _0x8B
; 0000 026C 
; 0000 026D                             muldive = 1;
	CALL SUBOPT_0x24
; 0000 026E                             tempresint = atof(temp[i-1])*atof(temp[i+1]);
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x25
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x26
; 0000 026F                             sprintf(tempreschar,"%1.1f",tempresint);
	CALL SUBOPT_0x27
; 0000 0270                             strncpy(temp[i-1],tempreschar,8);
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
; 0000 0271                             for(j = i + 2 ; j <= tempsize; j++){
_0x8D:
	CALL SUBOPT_0x2B
	BRLT _0x8E
; 0000 0272                                 strncpy(temp[j-2],temp[j],8);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	LDI  R26,LOW(8)
	CALL _strncpy
; 0000 0273                             }
	CALL SUBOPT_0x10
	RJMP _0x8D
_0x8E:
; 0000 0274                             temp[tempsize-1][0] = 0;
	CALL SUBOPT_0x2E
; 0000 0275                             tempsize = tempsize - 2;
	CALL SUBOPT_0x2F
; 0000 0276                             break;
	RJMP _0x8A
; 0000 0277                         }
; 0000 0278 
; 0000 0279                          if(temp[i][0] == '/'){
_0x8B:
	CALL SUBOPT_0x1F
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x2F)
	BRNE _0x8F
; 0000 027A                             muldive = 1;
	CALL SUBOPT_0x24
; 0000 027B                             tempresint = atof(temp[i-1])/atof(temp[i+1]);
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x25
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x30
; 0000 027C                             if(atof(temp[i+1]) == 0){ //taghsim bar sefr
	CALL SUBOPT_0x25
	CALL __CPD10
	BRNE _0x90
; 0000 027D                                 err = 1;
	CALL SUBOPT_0x31
; 0000 027E                                 break;
	RJMP _0x8A
; 0000 027F                             }
; 0000 0280                             sprintf(tempreschar,"%1.1f",tempresint);
_0x90:
	CALL SUBOPT_0x32
; 0000 0281                             strncpy(temp[i-1],tempreschar,10);
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	CALL SUBOPT_0x33
; 0000 0282                             for(j = i + 2 ; j <= tempsize; j++){
_0x92:
	CALL SUBOPT_0x2B
	BRLT _0x93
; 0000 0283                                 strncpy(temp[j-2],temp[j],8);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	LDI  R26,LOW(8)
	CALL _strncpy
; 0000 0284                             }
	CALL SUBOPT_0x10
	RJMP _0x92
_0x93:
; 0000 0285                             temp[size-1][0] = 0;
	CALL SUBOPT_0x34
	MOVW R26,R28
	ADIW R26,48
	CALL SUBOPT_0x18
; 0000 0286                             tempsize = tempsize - 2;
	CALL SUBOPT_0x2F
; 0000 0287                             break;
	RJMP _0x8A
; 0000 0288                         }
; 0000 0289                         if(err == 1){
_0x8F:
	CALL SUBOPT_0x35
	BREQ _0x8A
; 0000 028A                             break;
; 0000 028B                         }
; 0000 028C                      }
	CALL SUBOPT_0x19
	RJMP _0x89
_0x8A:
; 0000 028D 
; 0000 028E              }
	RJMP _0x85
_0x87:
; 0000 028F                  while(subsum == 1){
_0x95:
	CALL SUBOPT_0x36
	BREQ PC+2
	RJMP _0x97
; 0000 0290                     subsum = 0;
	CALL SUBOPT_0x37
; 0000 0291                     for(i = 0; i <= tempsize; i++){
_0x99:
	CALL SUBOPT_0x23
	BRGE PC+2
	RJMP _0x9A
; 0000 0292 
; 0000 0293                         if(temp[i][0] == '+'){
	CALL SUBOPT_0x1F
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x2B)
	BRNE _0x9B
; 0000 0294 
; 0000 0295                             subsum = 1;
	CALL SUBOPT_0x38
; 0000 0296                             tempresint = atof(temp[i-1])+atof(temp[i+1]);
	CALL SUBOPT_0x39
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x25
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3A
; 0000 0297                             sprintf(tempreschar,"%1.1f",tempresint);
	CALL SUBOPT_0x32
; 0000 0298                             strncpy(temp[i-1],tempreschar,10);
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	CALL SUBOPT_0x33
; 0000 0299                             for(j = i + 2 ; j <= tempsize; j++){
_0x9D:
	CALL SUBOPT_0x2B
	BRLT _0x9E
; 0000 029A                                 strncpy(temp[j-2],temp[j],8);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	LDI  R26,LOW(8)
	CALL _strncpy
; 0000 029B                             }
	CALL SUBOPT_0x10
	RJMP _0x9D
_0x9E:
; 0000 029C                             temp[tempsize-1][0] = 0;
	CALL SUBOPT_0x2E
; 0000 029D                             tempsize = tempsize - 2;
	CALL SUBOPT_0x2F
; 0000 029E                             break;
	RJMP _0x9A
; 0000 029F                         }
; 0000 02A0 
; 0000 02A1                          if(temp[i][0] == '-' && temp[i][1] ==0){
_0x9B:
	CALL SUBOPT_0x1F
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x2D)
	BRNE _0xA0
	MOVW R26,R28
	ADIW R26,48
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Z+1
	CPI  R26,LOW(0x0)
	BREQ _0xA1
_0xA0:
	RJMP _0x9F
_0xA1:
; 0000 02A2                             subsum = 1;
	CALL SUBOPT_0x38
; 0000 02A3                             lcd_putsf("ok");
	__POINTW2FN _0x0,18
	CALL _lcd_putsf
; 0000 02A4                             tempresint = atof(temp[i-1])-atof(temp[i+1]);
	CALL SUBOPT_0x39
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x25
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3B
; 0000 02A5                             sprintf(tempreschar,"%1.1f",tempresint);
	CALL SUBOPT_0x32
; 0000 02A6                             strncpy(temp[i-1],tempreschar,10);
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	CALL SUBOPT_0x33
; 0000 02A7                             for(j = i + 2 ; j <= tempsize; j++){
_0xA3:
	CALL SUBOPT_0x2B
	BRLT _0xA4
; 0000 02A8                                 strncpy(temp[j-2],temp[j],8);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	LDI  R26,LOW(8)
	CALL _strncpy
; 0000 02A9                             }
	CALL SUBOPT_0x10
	RJMP _0xA3
_0xA4:
; 0000 02AA                             temp[tempsize-1][0] = 0;
	CALL SUBOPT_0x2E
; 0000 02AB                             tempsize = tempsize - 2;
	CALL SUBOPT_0x2F
; 0000 02AC                             break;
	RJMP _0x9A
; 0000 02AD                         }
; 0000 02AE                     }
_0x9F:
	CALL SUBOPT_0x19
	RJMP _0x99
_0x9A:
; 0000 02AF 
; 0000 02B0                 }
	RJMP _0x95
_0x97:
; 0000 02B1                 if(err == 1)
	CALL SUBOPT_0x35
	BRNE _0xA5
; 0000 02B2                 break;
	RJMP _0x76
; 0000 02B3                 //-------------------------------------------------- end of calculating paran
; 0000 02B4                 strncpy(chars[iop],temp[0],8);
_0xA5:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	MOVW R30,R28
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	CALL _strncpy
; 0000 02B5                 size = size - (icp - iop);           //replacing the paran with its value
	CALL SUBOPT_0x1E
	__SUBWRR 18,19,30,31
; 0000 02B6                 for( i = iop+1 ; i <= size; i++){
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3E
_0xA7:
	CALL SUBOPT_0x1B
	BRLT _0xA8
; 0000 02B7                     strncpy(chars[i],chars[i + (icp - iop)],8);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x21
	CALL SUBOPT_0x3C
	SUB  R30,R26
	SBC  R31,R27
	__GETW2SX 312
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x22
	LDI  R26,LOW(8)
	CALL _strncpy
; 0000 02B8                 }
	CALL SUBOPT_0x19
	RJMP _0xA7
_0xA8:
; 0000 02B9                 for(i = size+1; i < 15; i ++){
	MOVW R30,R18
	CALL SUBOPT_0x3E
_0xAA:
	CALL SUBOPT_0x12
	SBIW R26,15
	BRGE _0xAB
; 0000 02BA                     chars[i][0] = 0;
	CALL SUBOPT_0x1C
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 02BB                 }
	CALL SUBOPT_0x19
	RJMP _0xAA
_0xAB:
; 0000 02BC 
; 0000 02BD 
; 0000 02BE         }
; 0000 02BF 
; 0000 02C0         if(err == 1)
_0x84:
	CALL SUBOPT_0x35
	BREQ _0x76
; 0000 02C1         break;
; 0000 02C2         muldive = 1;
	__GETWRN 20,21,1
; 0000 02C3         subsum = 1;
	CALL SUBOPT_0x38
; 0000 02C4     }
	RJMP _0x74
_0x76:
; 0000 02C5 
; 0000 02C6 
; 0000 02C7 
; 0000 02C8 
; 0000 02C9 
; 0000 02CA 
; 0000 02CB     while(muldive == 1){
_0xAD:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ PC+2
	RJMP _0xAF
; 0000 02CC         muldive = 0;
	__GETWRN 20,21,0
; 0000 02CD         for(i = 0; i <= size; i++){
	CALL SUBOPT_0xB
_0xB1:
	CALL SUBOPT_0x1B
	BRGE PC+2
	RJMP _0xB2
; 0000 02CE 
; 0000 02CF             if(chars[i][0] == '*'){
	CALL SUBOPT_0x1C
	LD   R26,X
	CPI  R26,LOW(0x2A)
	BRNE _0xB3
; 0000 02D0 
; 0000 02D1                 muldive = 1;
	CALL SUBOPT_0x3F
; 0000 02D2                 tempresint = atof(chars[i-1])*atof(chars[i+1]);
	CALL _atof
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x40
	CALL _atof
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x26
; 0000 02D3                 sprintf(tempreschar,"%f",tempresint);
	CALL SUBOPT_0x15
	CALL SUBOPT_0x41
; 0000 02D4                 strncpy(chars[i-1],tempreschar,8);
	CALL SUBOPT_0x42
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
; 0000 02D5                 for(j = i + 2 ; j <= size; j++){
_0xB5:
	CALL SUBOPT_0x43
	BRLT _0xB6
; 0000 02D6                     strncpy(chars[j-2],chars[j],8);
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
	LDI  R26,LOW(8)
	CALL _strncpy
; 0000 02D7                 }
	CALL SUBOPT_0x10
	RJMP _0xB5
_0xB6:
; 0000 02D8                 chars[size-1][0] = 0;
	CALL SUBOPT_0x34
	CALL SUBOPT_0x17
	CALL SUBOPT_0x46
; 0000 02D9                 size = size - 2;
; 0000 02DA                 break;
	RJMP _0xB2
; 0000 02DB             }
; 0000 02DC 
; 0000 02DD              if(chars[i][0] == '/'){
_0xB3:
	CALL SUBOPT_0x1C
	LD   R26,X
	CPI  R26,LOW(0x2F)
	BRNE _0xB7
; 0000 02DE                 muldive = 1;
	CALL SUBOPT_0x3F
; 0000 02DF                 tempresint = atof(chars[i-1])/atof(chars[i+1]);
	CALL _atof
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x40
	CALL _atof
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x30
; 0000 02E0                 if(atof(chars[i+1]) == 0){ //taghsim bar sefr
	CALL SUBOPT_0x40
	CALL _atof
	CALL __CPD10
	BRNE _0xB8
; 0000 02E1                     err = 1;
	CALL SUBOPT_0x31
; 0000 02E2                     break;
	RJMP _0xB2
; 0000 02E3                 }
; 0000 02E4                 sprintf(tempreschar,"%f",tempresint);
_0xB8:
	CALL SUBOPT_0x47
	CALL SUBOPT_0x41
; 0000 02E5                 strncpy(chars[i-1],tempreschar,10);
	CALL SUBOPT_0x42
	CALL SUBOPT_0x29
	CALL SUBOPT_0x33
; 0000 02E6                 for(j = i + 2 ; j <= size; j++){
_0xBA:
	CALL SUBOPT_0x43
	BRLT _0xBB
; 0000 02E7                     strncpy(chars[j-2],chars[j],8);
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
	LDI  R26,LOW(8)
	CALL _strncpy
; 0000 02E8                 }
	CALL SUBOPT_0x10
	RJMP _0xBA
_0xBB:
; 0000 02E9                 chars[size-1][0] = 0;
	CALL SUBOPT_0x34
	CALL SUBOPT_0x17
	CALL SUBOPT_0x46
; 0000 02EA                 size = size - 2;
; 0000 02EB                 break;
	RJMP _0xB2
; 0000 02EC             }
; 0000 02ED             if(err == 1){
_0xB7:
	CALL SUBOPT_0x35
	BREQ _0xB2
; 0000 02EE                 break;
; 0000 02EF             }
; 0000 02F0         }
	CALL SUBOPT_0x19
	RJMP _0xB1
_0xB2:
; 0000 02F1 
; 0000 02F2     }
	RJMP _0xAD
_0xAF:
; 0000 02F3      while(subsum == 1){
_0xBD:
	CALL SUBOPT_0x36
	BREQ PC+2
	RJMP _0xBF
; 0000 02F4         subsum = 0;
	CALL SUBOPT_0x37
; 0000 02F5         for(i = 0; i <= size; i++){
_0xC1:
	CALL SUBOPT_0x1B
	BRGE PC+2
	RJMP _0xC2
; 0000 02F6 
; 0000 02F7             if(chars[i][0] == '+'){
	CALL SUBOPT_0x1C
	LD   R26,X
	CPI  R26,LOW(0x2B)
	BRNE _0xC3
; 0000 02F8 
; 0000 02F9                 subsum = 1;
	CALL SUBOPT_0x38
; 0000 02FA                 tempresint = atof(chars[i-1])+atof(chars[i+1]);
	CALL SUBOPT_0x48
	CALL _atof
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x40
	CALL _atof
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3A
; 0000 02FB                 sprintf(tempreschar,"%f",tempresint);
	CALL SUBOPT_0x47
	CALL SUBOPT_0x41
; 0000 02FC                 strncpy(chars[i-1],tempreschar,10);
	CALL SUBOPT_0x42
	CALL SUBOPT_0x29
	CALL SUBOPT_0x33
; 0000 02FD                 for(j = i + 2 ; j <= size; j++){
_0xC5:
	CALL SUBOPT_0x43
	BRLT _0xC6
; 0000 02FE                     strncpy(chars[j-2],chars[j],8);
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
	LDI  R26,LOW(8)
	CALL _strncpy
; 0000 02FF                 }
	CALL SUBOPT_0x10
	RJMP _0xC5
_0xC6:
; 0000 0300                 chars[size-1][0] = 0;
	CALL SUBOPT_0x34
	CALL SUBOPT_0x17
	CALL SUBOPT_0x46
; 0000 0301                 size = size - 2;
; 0000 0302                 break;
	RJMP _0xC2
; 0000 0303             }
; 0000 0304 
; 0000 0305              if(chars[i][0] == '-' && chars[i][1] ==0){
_0xC3:
	CALL SUBOPT_0x1C
	LD   R26,X
	CPI  R26,LOW(0x2D)
	BRNE _0xC8
	MOVW R26,R28
	SUBI R26,LOW(-(168))
	SBCI R27,HIGH(-(168))
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Z+1
	CPI  R26,LOW(0x0)
	BREQ _0xC9
_0xC8:
	RJMP _0xC7
_0xC9:
; 0000 0306                 subsum = 1;
	CALL SUBOPT_0x38
; 0000 0307                 tempresint = atof(chars[i-1])-atof(chars[i+1]);
	CALL SUBOPT_0x48
	CALL _atof
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x40
	CALL _atof
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3B
; 0000 0308                 sprintf(tempreschar,"%f",tempresint);
	CALL SUBOPT_0x47
	CALL SUBOPT_0x41
; 0000 0309                 strncpy(chars[i-1],tempreschar,10);
	CALL SUBOPT_0x42
	CALL SUBOPT_0x29
	CALL SUBOPT_0x33
; 0000 030A                 for(j = i + 2 ; j <= size; j++){
_0xCB:
	CALL SUBOPT_0x43
	BRLT _0xCC
; 0000 030B                     strncpy(chars[j-2],chars[j],8);
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
	LDI  R26,LOW(8)
	CALL _strncpy
; 0000 030C                 }
	CALL SUBOPT_0x10
	RJMP _0xCB
_0xCC:
; 0000 030D                 chars[size-1][0] = 0;
	CALL SUBOPT_0x34
	CALL SUBOPT_0x17
	CALL SUBOPT_0x46
; 0000 030E                 size = size - 2;
; 0000 030F                 break;
	RJMP _0xC2
; 0000 0310             }
; 0000 0311         }
_0xC7:
	CALL SUBOPT_0x19
	RJMP _0xC1
_0xC2:
; 0000 0312 
; 0000 0313     }
	RJMP _0xBD
_0xBF:
; 0000 0314     numbers[0] = atof(chars[0]);
	MOVW R26,R28
	SUBI R26,LOW(-(168))
	SBCI R27,HIGH(-(168))
	CALL _atof
	__PUTD1S 6
; 0000 0315     if(err == 0){
	CALL SUBOPT_0x20
	SBIW R30,0
	BRNE _0xCD
; 0000 0316         return numbers[0];
	__GETD1S 6
	RJMP _0x20C0009
; 0000 0317     }
; 0000 0318     else{
_0xCD:
; 0000 0319         clear();
	RCALL _clear
; 0000 031A         lcd_putsf("ERROR");
	__POINTW2FN _0x0,21
	CALL _lcd_putsf
; 0000 031B         delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 031C         clear();
	RCALL _clear
; 0000 031D         state = 0;
	CLR  R6
	CLR  R7
; 0000 031E     }
; 0000 031F 
; 0000 0320 
; 0000 0321 }
_0x20C0009:
	CALL __LOADLOCR6
	ADIW R28,60
	SUBI R29,-1
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	CALL SUBOPT_0x49
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200000D
	CALL SUBOPT_0x4A
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	RJMP _0x20C0008
_0x200000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200000C
	CALL SUBOPT_0x4A
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	RJMP _0x20C0008
_0x200000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x200000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4C
	LDI  R30,LOW(45)
	ST   X,R30
_0x200000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2000010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2000010:
	LDD  R17,Y+8
_0x2000011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000013
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4F
	RJMP _0x2000011
_0x2000013:
	CALL SUBOPT_0x50
	CALL __ADDF12
	CALL SUBOPT_0x4B
	LDI  R17,LOW(0)
	CALL SUBOPT_0x51
	CALL SUBOPT_0x4F
_0x2000014:
	CALL SUBOPT_0x50
	CALL __CMPF12
	BRLO _0x2000016
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x52
	CALL SUBOPT_0x4F
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2000017
	CALL SUBOPT_0x4A
	__POINTW2FN _0x2000000,5
	CALL _strcpyf
	RJMP _0x20C0008
_0x2000017:
	RJMP _0x2000014
_0x2000016:
	CPI  R17,0
	BRNE _0x2000018
	CALL SUBOPT_0x4C
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2000019
_0x2000018:
_0x200001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001C
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x53
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x4C
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x54
	CALL __MULF12
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
	RJMP _0x200001A
_0x200001C:
_0x2000019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0007
	CALL SUBOPT_0x4C
	LDI  R30,LOW(46)
	ST   X,R30
_0x200001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2000020
	CALL SUBOPT_0x55
	CALL SUBOPT_0x52
	CALL SUBOPT_0x4B
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x4C
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0x55
	CALL SUBOPT_0x54
	CALL SUBOPT_0x56
	RJMP _0x200001E
_0x2000020:
_0x20C0007:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0008:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND
_atof:
; .FSTART _atof
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,10
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	__CLRD1S 8
_0x200003C:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	MOV  R21,R30
	MOV  R26,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x200003E
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x200003C
_0x200003E:
	LDI  R30,LOW(0)
	STD  Y+7,R30
	CPI  R21,43
	BREQ _0x200006C
	CPI  R21,45
	BRNE _0x2000041
	LDI  R30,LOW(1)
	STD  Y+7,R30
_0x200006C:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x2000041:
	LDI  R30,LOW(0)
	MOV  R20,R30
	MOV  R21,R30
	__GETWRS 16,17,16
_0x2000042:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	CALL _isdigit
	CPI  R30,0
	BRNE _0x2000045
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	LDI  R30,LOW(46)
	CALL __EQB12
	MOV  R21,R30
	CPI  R30,0
	BREQ _0x2000044
_0x2000045:
	OR   R20,R21
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x2000042
_0x2000044:
	__GETWRS 18,19,16
	CPI  R20,0
	BREQ _0x2000047
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x2000048:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BREQ _0x200004A
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
	CALL SUBOPT_0x57
	CALL SUBOPT_0x54
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41200000
	CALL __DIVF21
	CALL SUBOPT_0x58
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	CALL SUBOPT_0x59
_0x200004B:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	SBIW R26,1
	STD  Y+16,R26
	STD  Y+16+1,R27
	CP   R26,R16
	CPC  R27,R17
	BRLO _0x200004D
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x54
	CALL __MULF12
	CALL SUBOPT_0x57
	CALL __ADDF12
	CALL SUBOPT_0x58
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	RJMP _0x200004B
_0x200004D:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R21,X
	CPI  R21,101
	BREQ _0x200004F
	CPI  R21,69
	BREQ _0x200004F
	RJMP _0x200004E
_0x200004F:
	LDI  R30,LOW(0)
	MOV  R20,R30
	STD  Y+6,R30
	MOVW R26,R18
	LD   R21,X
	CPI  R21,43
	BREQ _0x200006D
	CPI  R21,45
	BRNE _0x2000053
	LDI  R30,LOW(1)
	STD  Y+6,R30
_0x200006D:
	__ADDWRN 18,19,1
_0x2000053:
_0x2000054:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R21,R30
	MOV  R26,R30
	CALL _isdigit
	CPI  R30,0
	BREQ _0x2000056
	LDI  R26,LOW(10)
	MULS R20,R26
	MOVW R30,R0
	ADD  R30,R21
	SUBI R30,LOW(48)
	MOV  R20,R30
	RJMP _0x2000054
_0x2000056:
	CPI  R20,39
	BRLO _0x2000057
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x2000058
	__GETD1N 0xFF7FFFFF
	RJMP _0x20C0006
_0x2000058:
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0006
_0x2000057:
	LDI  R21,LOW(32)
	CALL SUBOPT_0x59
_0x2000059:
	CPI  R21,0
	BREQ _0x200005B
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x5A
	CALL __MULF12
	CALL SUBOPT_0x5C
	MOV  R30,R20
	AND  R30,R21
	BREQ _0x200005C
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
_0x200005C:
	LSR  R21
	RJMP _0x2000059
_0x200005B:
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0x200005D
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x57
	CALL __DIVF21
	RJMP _0x200006E
_0x200005D:
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x57
	CALL __MULF12
_0x200006E:
	__PUTD1S 8
_0x200004E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x200005F
	__GETD1S 8
	CALL __ANEGF1
	CALL SUBOPT_0x58
_0x200005F:
	__GETD1S 8
_0x20C0006:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
; .FEND

	.DSEG

	.CSEG

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
_strncpy:
; .FSTART _strncpy
	ST   -Y,R26
    ld   r23,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strncpy0:
    tst  r23
    breq strncpy1
    dec  r23
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strncpy0
strncpy2:
    tst  r23
    breq strncpy1
    dec  r23
    st   x+,r22
    rjmp strncpy2
strncpy1:
    movw r30,r24
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
; .FSTART __lcd_write_nibble_G102
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2040004
	SBI  0x18,3
	RJMP _0x2040005
_0x2040004:
	CBI  0x18,3
_0x2040005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2040006
	SBI  0x18,4
	RJMP _0x2040007
_0x2040006:
	CBI  0x18,4
_0x2040007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2040008
	SBI  0x18,5
	RJMP _0x2040009
_0x2040008:
	CBI  0x18,5
_0x2040009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x204000A
	SBI  0x18,6
	RJMP _0x204000B
_0x204000A:
	CBI  0x18,6
_0x204000B:
	__DELAY_USB 13
	SBI  0x18,2
	__DELAY_USB 13
	CBI  0x18,2
	__DELAY_USB 13
	RJMP _0x20C0004
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 133
	RJMP _0x20C0004
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x5E
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x5E
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2040010
_0x2040011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040013
	RJMP _0x20C0004
_0x2040013:
_0x2040010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x20C0004
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2040014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040014
_0x2040016:
	RJMP _0x20C0005
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2040017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040017
_0x2040019:
_0x20C0005:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x17,3
	SBI  0x17,4
	SBI  0x17,5
	SBI  0x17,6
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x5F
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0004:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G103:
; .FSTART _put_buff_G103
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2060010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2060012
	__CPWRN 16,17,2
	BRLO _0x2060013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2060012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x0
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2060013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2060014
	CALL SUBOPT_0x0
_0x2060014:
	RJMP _0x2060015
_0x2060010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2060015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__ftoe_G103:
; .FSTART __ftoe_G103
	CALL SUBOPT_0x49
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2060019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2060000,0
	CALL _strcpyf
	RJMP _0x20C0003
_0x2060019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2060018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2060000,1
	CALL _strcpyf
	RJMP _0x20C0003
_0x2060018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x206001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x206001B:
	LDD  R17,Y+11
_0x206001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x206001E
	CALL SUBOPT_0x60
	CALL SUBOPT_0x61
	RJMP _0x206001C
_0x206001E:
	CALL SUBOPT_0x5D
	CALL __CPD10
	BRNE _0x206001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x60
	CALL SUBOPT_0x61
	RJMP _0x2060020
_0x206001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x62
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2060021
	CALL SUBOPT_0x60
	CALL SUBOPT_0x61
_0x2060022:
	CALL SUBOPT_0x62
	BRLO _0x2060024
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x5C
	SUBI R19,-LOW(1)
	RJMP _0x2060022
_0x2060024:
	RJMP _0x2060025
_0x2060021:
_0x2060026:
	CALL SUBOPT_0x62
	BRSH _0x2060028
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	SUBI R19,LOW(1)
	RJMP _0x2060026
_0x2060028:
	CALL SUBOPT_0x60
	CALL SUBOPT_0x61
_0x2060025:
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x53
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x62
	BRLO _0x2060029
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x5C
	SUBI R19,-LOW(1)
_0x2060029:
_0x2060020:
	LDI  R17,LOW(0)
_0x206002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x206002C
	__GETD2S 4
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x53
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x61
	__GETD1S 4
	CALL SUBOPT_0x5A
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x63
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x5A
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x5C
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x206002A
	CALL SUBOPT_0x63
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x206002A
_0x206002C:
	CALL SUBOPT_0x64
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x206002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2060113
_0x206002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2060113:
	ST   X,R30
	CALL SUBOPT_0x64
	CALL SUBOPT_0x64
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x64
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0003:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G103:
; .FSTART __print_G103
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2060030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x0
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2060036
	CPI  R18,37
	BRNE _0x2060037
	LDI  R17,LOW(1)
	RJMP _0x2060038
_0x2060037:
	CALL SUBOPT_0x65
_0x2060038:
	RJMP _0x2060035
_0x2060036:
	CPI  R30,LOW(0x1)
	BRNE _0x2060039
	CPI  R18,37
	BRNE _0x206003A
	CALL SUBOPT_0x65
	RJMP _0x2060114
_0x206003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x206003B
	LDI  R16,LOW(1)
	RJMP _0x2060035
_0x206003B:
	CPI  R18,43
	BRNE _0x206003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2060035
_0x206003C:
	CPI  R18,32
	BRNE _0x206003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2060035
_0x206003D:
	RJMP _0x206003E
_0x2060039:
	CPI  R30,LOW(0x2)
	BRNE _0x206003F
_0x206003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060040
	ORI  R16,LOW(128)
	RJMP _0x2060035
_0x2060040:
	RJMP _0x2060041
_0x206003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2060042
_0x2060041:
	CPI  R18,48
	BRLO _0x2060044
	CPI  R18,58
	BRLO _0x2060045
_0x2060044:
	RJMP _0x2060043
_0x2060045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2060035
_0x2060043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2060046
	LDI  R17,LOW(4)
	RJMP _0x2060035
_0x2060046:
	RJMP _0x2060047
_0x2060042:
	CPI  R30,LOW(0x4)
	BRNE _0x2060049
	CPI  R18,48
	BRLO _0x206004B
	CPI  R18,58
	BRLO _0x206004C
_0x206004B:
	RJMP _0x206004A
_0x206004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2060035
_0x206004A:
_0x2060047:
	CPI  R18,108
	BRNE _0x206004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2060035
_0x206004D:
	RJMP _0x206004E
_0x2060049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2060035
_0x206004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2060053
	CALL SUBOPT_0x66
	CALL SUBOPT_0x67
	CALL SUBOPT_0x66
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x68
	RJMP _0x2060054
_0x2060053:
	CPI  R30,LOW(0x45)
	BREQ _0x2060057
	CPI  R30,LOW(0x65)
	BRNE _0x2060058
_0x2060057:
	RJMP _0x2060059
_0x2060058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x206005A
_0x2060059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x69
	CALL __GETD1P
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6B
	LDD  R26,Y+13
	TST  R26
	BRMI _0x206005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x206005D
	CPI  R26,LOW(0x20)
	BREQ _0x206005F
	RJMP _0x2060060
_0x206005B:
	CALL SUBOPT_0x6C
	CALL __ANEGF1
	CALL SUBOPT_0x6A
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x206005D:
	SBRS R16,7
	RJMP _0x2060061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x68
	RJMP _0x2060062
_0x2060061:
_0x206005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2060062:
_0x2060060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2060064
	CALL SUBOPT_0x6C
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2060065
_0x2060064:
	CALL SUBOPT_0x6C
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G103
_0x2060065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x6D
	RJMP _0x2060066
_0x206005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2060068
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x6D
	RJMP _0x2060069
_0x2060068:
	CPI  R30,LOW(0x70)
	BRNE _0x206006B
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x6E
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x206006D
	CP   R20,R17
	BRLO _0x206006E
_0x206006D:
	RJMP _0x206006C
_0x206006E:
	MOV  R17,R20
_0x206006C:
_0x2060066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x206006F
_0x206006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2060072
	CPI  R30,LOW(0x69)
	BRNE _0x2060073
_0x2060072:
	ORI  R16,LOW(4)
	RJMP _0x2060074
_0x2060073:
	CPI  R30,LOW(0x75)
	BRNE _0x2060075
_0x2060074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2060076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x6F
	LDI  R17,LOW(10)
	RJMP _0x2060077
_0x2060076:
	__GETD1N 0x2710
	CALL SUBOPT_0x6F
	LDI  R17,LOW(5)
	RJMP _0x2060077
_0x2060075:
	CPI  R30,LOW(0x58)
	BRNE _0x2060079
	ORI  R16,LOW(8)
	RJMP _0x206007A
_0x2060079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20600B8
_0x206007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x206007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x6F
	LDI  R17,LOW(8)
	RJMP _0x2060077
_0x206007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x6F
	LDI  R17,LOW(4)
_0x2060077:
	CPI  R20,0
	BREQ _0x206007D
	ANDI R16,LOW(127)
	RJMP _0x206007E
_0x206007D:
	LDI  R20,LOW(1)
_0x206007E:
	SBRS R16,1
	RJMP _0x206007F
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x69
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2060115
_0x206007F:
	SBRS R16,2
	RJMP _0x2060081
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x6E
	CALL __CWD1
	RJMP _0x2060115
_0x2060081:
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x6E
	CLR  R22
	CLR  R23
_0x2060115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2060083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2060084
	CALL SUBOPT_0x6C
	CALL __ANEGD1
	CALL SUBOPT_0x6A
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2060084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2060085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2060086
_0x2060085:
	ANDI R16,LOW(251)
_0x2060086:
_0x2060083:
	MOV  R19,R20
_0x206006F:
	SBRC R16,0
	RJMP _0x2060087
_0x2060088:
	CP   R17,R21
	BRSH _0x206008B
	CP   R19,R21
	BRLO _0x206008C
_0x206008B:
	RJMP _0x206008A
_0x206008C:
	SBRS R16,7
	RJMP _0x206008D
	SBRS R16,2
	RJMP _0x206008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x206008F
_0x206008E:
	LDI  R18,LOW(48)
_0x206008F:
	RJMP _0x2060090
_0x206008D:
	LDI  R18,LOW(32)
_0x2060090:
	CALL SUBOPT_0x65
	SUBI R21,LOW(1)
	RJMP _0x2060088
_0x206008A:
_0x2060087:
_0x2060091:
	CP   R17,R20
	BRSH _0x2060093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2060094
	CALL SUBOPT_0x70
	BREQ _0x2060095
	SUBI R21,LOW(1)
_0x2060095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2060094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x68
	CPI  R21,0
	BREQ _0x2060096
	SUBI R21,LOW(1)
_0x2060096:
	SUBI R20,LOW(1)
	RJMP _0x2060091
_0x2060093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2060097
_0x2060098:
	CPI  R19,0
	BREQ _0x206009A
	SBRS R16,3
	RJMP _0x206009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x206009C
_0x206009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x206009C:
	CALL SUBOPT_0x65
	CPI  R21,0
	BREQ _0x206009D
	SUBI R21,LOW(1)
_0x206009D:
	SUBI R19,LOW(1)
	RJMP _0x2060098
_0x206009A:
	RJMP _0x206009E
_0x2060097:
_0x20600A0:
	CALL SUBOPT_0x71
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20600A2
	SBRS R16,3
	RJMP _0x20600A3
	SUBI R18,-LOW(55)
	RJMP _0x20600A4
_0x20600A3:
	SUBI R18,-LOW(87)
_0x20600A4:
	RJMP _0x20600A5
_0x20600A2:
	SUBI R18,-LOW(48)
_0x20600A5:
	SBRC R16,4
	RJMP _0x20600A7
	CPI  R18,49
	BRSH _0x20600A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20600A8
_0x20600A9:
	RJMP _0x20600AB
_0x20600A8:
	CP   R20,R19
	BRSH _0x2060116
	CP   R21,R19
	BRLO _0x20600AE
	SBRS R16,0
	RJMP _0x20600AF
_0x20600AE:
	RJMP _0x20600AD
_0x20600AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20600B0
_0x2060116:
	LDI  R18,LOW(48)
_0x20600AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20600B1
	CALL SUBOPT_0x70
	BREQ _0x20600B2
	SUBI R21,LOW(1)
_0x20600B2:
_0x20600B1:
_0x20600B0:
_0x20600A7:
	CALL SUBOPT_0x65
	CPI  R21,0
	BREQ _0x20600B3
	SUBI R21,LOW(1)
_0x20600B3:
_0x20600AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x71
	CALL __MODD21U
	CALL SUBOPT_0x6A
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x6F
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20600A1
	RJMP _0x20600A0
_0x20600A1:
_0x206009E:
	SBRS R16,0
	RJMP _0x20600B4
_0x20600B5:
	CPI  R21,0
	BREQ _0x20600B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x68
	RJMP _0x20600B5
_0x20600B7:
_0x20600B4:
_0x20600B8:
_0x2060054:
_0x2060114:
	LDI  R17,LOW(0)
_0x2060035:
	RJMP _0x2060030
_0x2060032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x72
	SBIW R30,0
	BRNE _0x20600B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x20600B9:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x72
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G103)
	LDI  R31,HIGH(_put_buff_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G103
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0002:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x20C0001
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20C0001:
	ADIW R28,4
	RET
; .FEND

	.DSEG
_answer:
	.BYTE 0x4
_h_answer:
	.BYTE 0x4
_inarray:
	.BYTE 0x14
_str:
	.BYTE 0x10
_t:
	.BYTE 0x2
_keys:
	.BYTE 0x18
_rx_buffer:
	.BYTE 0x8
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
__seed_G100:
	.BYTE 0x4
__base_y_G102:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x0:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	STS  _t,R30
	STS  _t+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDS  R30,_answer
	LDS  R31,_answer+1
	LDS  R22,_answer+2
	LDS  R23,_answer+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	__GETWRN 18,19,0
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:181 WORDS
SUBOPT_0x4:
	__MULBNWRU 16,17,6
	SUBI R30,LOW(-_keys)
	SBCI R31,HIGH(-_keys)
	ADD  R30,R18
	ADC  R31,R19
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5:
	__GETWRN 18,19,1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x6:
	__GETWRN 18,19,2
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x7:
	__GETWRN 18,19,3
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	__GETWRN 18,19,4
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x9:
	__GETWRN 18,19,5
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xA:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	__CLRW1SX 310
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(_inarray)
	LDI  R27,HIGH(_inarray)
	JMP  _strlen

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xD:
	__GETW2SX 310
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xE:
	__GETW1SX 310
	SUBI R30,LOW(-_inarray)
	SBCI R31,HIGH(-_inarray)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xF:
	__GETW1SX 308
	CALL __LSLW3
	MOVW R26,R28
	SUBI R26,LOW(-(168))
	SBCI R27,HIGH(-(168))
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x10:
	MOVW R26,R28
	SUBI R26,LOW(-(308))
	SBCI R27,HIGH(-(308))
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	ADD  R30,R26
	ADC  R31,R27
	__GETW2SX 306
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x12:
	__GETW2SX 310
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 58 TIMES, CODE SIZE REDUCTION:225 WORDS
SUBOPT_0x13:
	__GETW1SX 310
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x14:
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	__POINTW1FN _0x0,9
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x16:
	__GETW1SX 308
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:60 WORDS
SUBOPT_0x17:
	MOVW R26,R28
	SUBI R26,LOW(-(168))
	SBCI R27,HIGH(-(168))
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x19:
	MOVW R26,R28
	SUBI R26,LOW(-(310))
	SBCI R27,HIGH(-(310))
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1A:
	ADIW R30,1
	CALL __LSLW3
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0x12
	CP   R18,R26
	CPC  R19,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1C:
	RCALL SUBOPT_0x13
	CALL __LSLW3
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	__GETW1SX 302
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1E:
	__GETW2SX 304
	RCALL SUBOPT_0x1D
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0x13
	CALL __LSLW3
	MOVW R26,R28
	ADIW R26,48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	__GETW1SX 312
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	__GETW2SX 306
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x22:
	CALL __LSLW3
	MOVW R26,R28
	SUBI R26,LOW(-(170))
	SBCI R27,HIGH(-(170))
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDD  R30,Y+46
	LDD  R31,Y+46+1
	RCALL SUBOPT_0x12
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x24:
	__GETWRN 20,21,1
	RCALL SUBOPT_0x13
	SBIW R30,1
	CALL __LSLW3
	MOVW R26,R28
	ADIW R26,48
	ADD  R26,R30
	ADC  R27,R31
	JMP  _atof

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0x13
	ADIW R30,1
	CALL __LSLW3
	MOVW R26,R28
	ADIW R26,48
	ADD  R26,R30
	ADC  R27,R31
	JMP  _atof

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x26:
	CALL __MULF12
	__PUTD1SX 288
	MOVW R30,R28
	SUBI R30,LOW(-(292))
	SBCI R31,HIGH(-(292))
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x27:
	__POINTW1FN _0x0,12
	ST   -Y,R31
	ST   -Y,R30
	__GETD1SX 292
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x13
	SBIW R30,1
	CALL __LSLW3
	MOVW R26,R28
	ADIW R26,48
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x29:
	MOVW R30,R28
	SUBI R30,LOW(-(294))
	SBCI R31,HIGH(-(294))
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(8)
	CALL _strncpy
	RCALL SUBOPT_0x13
	ADIW R30,2
	__PUTW1SX 308
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+46
	LDD  R31,Y+46+1
	__GETW2SX 308
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2C:
	RCALL SUBOPT_0x16
	SBIW R30,2
	CALL __LSLW3
	MOVW R26,R28
	ADIW R26,48
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2D:
	RCALL SUBOPT_0x13
	CALL __LSLW3
	MOVW R26,R28
	ADIW R26,50
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2E:
	LDD  R30,Y+46
	LDD  R31,Y+46+1
	SBIW R30,1
	CALL __LSLW3
	MOVW R26,R28
	ADIW R26,48
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2F:
	LDD  R30,Y+46
	LDD  R31,Y+46+1
	SBIW R30,2
	STD  Y+46,R30
	STD  Y+46+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x30:
	CALL __DIVF21
	__PUTD1SX 288
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1SX 312
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x32:
	MOVW R30,R28
	SUBI R30,LOW(-(292))
	SBCI R31,HIGH(-(292))
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x33:
	LDI  R26,LOW(10)
	CALL _strncpy
	RCALL SUBOPT_0x13
	ADIW R30,2
	__PUTW1SX 308
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x34:
	MOVW R30,R18
	SBIW R30,1
	CALL __LSLW3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x35:
	__GETW2SX 312
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x36:
	__GETW2SX 314
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(0)
	__CLRW1SX 314
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1SX 314
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	RCALL SUBOPT_0x13
	SBIW R30,1
	CALL __LSLW3
	MOVW R26,R28
	ADIW R26,48
	ADD  R26,R30
	ADC  R27,R31
	JMP  _atof

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3A:
	CALL __ADDF12
	__PUTD1SX 288
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3B:
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1SX 288
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	__GETW1SX 304
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x3D:
	CALL __LSLW3
	MOVW R26,R28
	SUBI R26,LOW(-(168))
	SBCI R27,HIGH(-(168))
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	ADIW R30,1
	__PUTW1SX 310
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3F:
	__GETWRN 20,21,1
	RCALL SUBOPT_0x13
	SBIW R30,1
	CALL __LSLW3
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x40:
	RCALL SUBOPT_0x13
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x41:
	__GETD1SX 292
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x42:
	RCALL SUBOPT_0x13
	SBIW R30,1
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x43:
	__GETW2SX 308
	CP   R18,R26
	CPC  R19,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x44:
	RCALL SUBOPT_0x16
	SBIW R30,2
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	RCALL SUBOPT_0x13
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	LDI  R30,LOW(0)
	ST   X,R30
	__SUBWRN 18,19,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x47:
	MOVW R30,R28
	SUBI R30,LOW(-(292))
	SBCI R31,HIGH(-(292))
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x48:
	RCALL SUBOPT_0x13
	SBIW R30,1
	CALL __LSLW3
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x49:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4C:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4E:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x50:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x52:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x53:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	CALL __SWAPD12
	CALL __SUBF12
	RJMP SUBOPT_0x4B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x57:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	RCALL SUBOPT_0x51
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5A:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5B:
	RCALL SUBOPT_0x5A
	RJMP SUBOPT_0x52

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5C:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5D:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5F:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G102
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x60:
	__GETD2S 4
	RJMP SUBOPT_0x52

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x61:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x62:
	__GETD1S 4
	RCALL SUBOPT_0x5A
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x64:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x65:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x66:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x67:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x68:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x69:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6A:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6B:
	RCALL SUBOPT_0x66
	RJMP SUBOPT_0x67

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6C:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6D:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6E:
	RCALL SUBOPT_0x69
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6F:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x70:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x71:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x72:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
