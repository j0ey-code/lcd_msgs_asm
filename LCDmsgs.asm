;Joseph Lincoln | Microcomputers / Assembly Programming
;Professor Kristen Sparrow
;April 21, 2025
;Show Me What You Know! Final Code Assignment
;Simple LCD Highway Messages in Assembly
;Reverse Engineered and Improved from Provided BASIC Demo Codefiles

;Written for the PIC18(F4520) microcontroller family,
;in a simulated development environment with peripherals / devices 
;provided as extension screens of integrated code editor

;NOTE:	This program was built using parts of a disassembled BASIC file (demo.bas)
;	which also writes / displays to the LCD module. Using the most necessary and
;	most crucial parts of that disassembled program, I was able to reverse-engineer,
;	add to, modify, optimize, and restructure it significantly (using knowledge gained this 
;	semester in class) to create a new program which would serve our purposes without a lot
;	of the extra, tedious spaghetti code spat out by the disassembler. 
;	The result is a cleaner, shorter, more optimized program written entirely
;	in assembly, which accomplishes the same exact thing - displaying / writing some 
;	simple messages to the LCD module, similar to messages on a road sign!!

CNTVAL1	EQU 0x00F	;necessary value and register variables set
CNTREG1 EQU 0x014
CNTVAL2	EQU 0x010
CNTREG2	EQU 0x015
;CNTVAL3 EQU 0x00F
CNTREG3	EQU 0x016
CNTVAL4 EQU 0x00E
CNTREG4	EQU 0x017
CNTVAL5	EQU 0x00E
CNTREG5	EQU 0x018
;CNTVAL6 EQU 0x00F
CNTREG6	EQU 0x019
CPYREG	EQU 0x01A
WRITREG	EQU 0x019

	BSF RCON, IPEN, A	;necessary directive here from the BASIC
	GOTO INIT		;immediately jump to initialization label INIT
	NOP
	RETFIE
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	RETFIE
INIT:	LFSR FSR0, CPYREG	;initializing file select registers
	LFSR FSR1, WRITREG	;to intended start values for data copy / write
	MOVLW 0x06
	MOVWF ADCON1, A
	BCF LATD, 3, A	;clearing bits 1-3 of LATD / TRISD / PORTD;
	BCF LATD, 1, A	;our RS, R/W, and E lines, respectively
	BCF LATD, 2, A
	BCF TRISD, 3, A	;this is all that is technically necessary to
	BCF TRISD, 1, A	;simply write to the LCD screen; I2C EEPROM SDA &
	BCF TRISD, 2, A	;SDL are explicitly for EEPROM memory actions
	CLRF TRISB, A	;finally, clear TRISB / PORTB entirely for our data lines!
	MOVLW 0x02
	MOVWF 0x000, A
	CLRF 0x001, A	;a series of highly specific assembly instruction calls
	RCALL BITMOV	;which seems to be readying the LCD module for display
	MOVLW 0x33
	RCALL PRELIM	;the BASIC program (demo.bas), when initially dissassembled, 
	MOVLW 0xCE	;required these instructions, calls, and labels to be executed
	MOVWF 0x008,A	;before anything would appear or happen on the LCD display
	MOVLW 0x07
	MOVWF 0x009,A
	RCALL RDYLP2
	MOVLW 0x33
	RCALL PRELIM
	MOVLW 0x83
	MOVWF 0x008,A
	RCALL RDYLP1
	MOVLW 0x38
	RCALL PRELIM
	MOVLW 0x0D
	RCALL PRELIM
	MOVLW 0x01
	RCALL PRELIM
	MOVLW 0xC6
	MOVWF 0x008,A
	MOVLW 0x00
	MOVWF 0x009,A
	RCALL RDYLP2
	CLRF 0x004,A
	CLRF 0x005,A
MSG1:	MOVF 0x004,W,A	;again, a seemingly necessary series of calls before each
	MOVWF 0x000,A	;message to ready the LCD module display, derived from /
	MOVF 0x005,W,A	;found scattered inside the dissassembled BASIC demo(s)
	MOVWF 0x001,A
	MOVLW 0x01
	MOVWF 0x002,A
	CLRF 0x003,A
	RCALL SETLP		;initialize the "abstract for loop" from the BASIC template
	;BTFSS STATUS, Z, A	;setlp = 0x002 / 2 means three different iterations / messages
	;BRA KILL 
	MOVLW 0x01
	RCALL PRELIM
SETUP1:	MOVLW CNTVAL1		;ready our first character sequence count
	MOVWF CNTREG1
	MOVLW HIGH SBRMS1	;load TABLPTR with the location
	MOVWF TBLPTRH		;of our first line of characters
	MOVLW LOW SBRMS1
	MOVWF TBLPTRL
RD1:	TBLRD*+			;read the character data from program memory
	MOVFF TABLAT, POSTINC0	;into closer general purpose register data 
	DECF CNTREG1, F		;memory using the table pointer and file select registers
	BNZ RD1
	MOVLW CNTVAL1		;ready the count again for writing to the LCD
	MOVWF CNTREG1
WR1:	MOVFF PREINC1, WREG	;load each character data value sequentially
	RCALL BITCLR		;call the label / sub-routine to clear the LCD display
	DECF CNTREG1, F		;for, and then to begin, the write process
	BNZ WR1			;loop until each character is written to line
JMPLN1:	MOVLW 0xCE	
	MOVWF 0x008,A		;another block of code reverse-engineered from the 
	MOVLW 0x07		;dissassembler which "line jumps" from one line in the LCD  
	MOVWF 0x009,A		;module down to the next line
	RCALL RDYLP2
	MOVLW 0xC0
	RCALL PRELIM
SETUP2:	NOP
	NOP			;brief hardcoded delay for the program execution's sake
	LFSR FSR0, CPYREG	;and re-initializing the file select registers
	LFSR FSR1, WRITREG	;for the next LCD message line
	NOP
	NOP
	MOVLW CNTVAL2		;new count set for new message length
	MOVWF CNTREG2
	MOVLW HIGH SBRMS2	;reload TBLPTR with new data byte message value location
	MOVWF TBLPTRH
	MOVLW LOW SBRMS2
	MOVWF TBLPTRL
RD2:	TBLRD*+			;again, we perform a table read of our ASCII character
	MOVFF TABLAT, POSTINC0	;data values from program memory to data memory,
	DECF CNTREG2, F		;using the table pointer and file select registers
	BNZ RD2
	MOVLW CNTVAL2		;reload the count
	MOVWF CNTREG2
WR2:	MOVFF PREINC1, WREG	;perform another write for the first message's second line
	RCALL BITCLR
	DECF CNTREG2, F
	BNZ WR2
	RCALL DELAY		;a shoddy attempt to delay the LCD reset a little longer,
	RCALL DELAY 		;so that the message(s) may be viewed for a bit longer as well
	RCALL DELAY
MSG2:	MOVF 0x004,W,A		;again, we will use the code block(s) reverse-engineered and taken 
	MOVWF 0x000,A		;from the BASIC to assembly dissassembler to reset our LCD
	MOVF 0x005,W,A		;display module for the second message to be written out
	MOVWF 0x001,A
	MOVLW 0x01
	MOVWF 0x002,A
	CLRF 0x003,A
	;RCALL SETLP
	;BTFSS STATUS,Z,A
	;BRA KILL
	MOVLW 0x01
	RCALL PRELIM
SETUP3:	NOP
	NOP
	LFSR FSR0, CPYREG	;re-initialize file select registers
	LFSR FSR1, WRITREG
	NOP
	NOP
	MOVLW CNTVAL1		;set the count equal to the message length
	MOVWF CNTREG3
	MOVLW HIGH WRKMS1	;load the message's location in program memory
	MOVWF TBLPTRH		;into the table pointer special function register
	MOVLW LOW WRKMS1
	MOVWF TBLPTRL
RD3:	TBLRD*+			;perform a read and write for the 
	MOVFF TABLAT, POSTINC0	;first line of our second message
	DECF CNTREG3, F
	BNZ RD3
	MOVLW CNTVAL1
	MOVWF CNTREG3
WR3:	MOVFF PREINC1, WREG
	RCALL BITCLR		;line for our call to jump down and begin clearing  
	DECF CNTREG3, F		;and writing to the LCD display module
	BNZ WR3
JMPLN2:	MOVLW 0xCE		;switch down to the second / next line for
	MOVWF 0x008,A		;the second line in our second message 
	MOVLW 0x07		;to be displayed / written out to the LCD module
	MOVWF 0x009,A
	RCALL RDYLP2
	MOVLW 0xC0
	RCALL PRELIM
SETUP4:	NOP
	NOP
	LFSR FSR0, CPYREG
	LFSR FSR1, WRITREG
	NOP
	NOP
	MOVLW CNTVAL4
	MOVWF CNTREG4
	MOVLW HIGH WRKMS2
	MOVWF TBLPTRH
	MOVLW LOW WRKMS2
	MOVWF TBLPTRL
RD4:	TBLRD*+ 
	MOVFF TABLAT, POSTINC0
	DECF CNTREG4, F
	BNZ RD4
	MOVLW CNTVAL4
	MOVWF CNTREG4
WR4:	MOVFF PREINC1, WREG
	RCALL BITCLR
	DECF CNTREG4, F
	BNZ WR4
	RCALL DELAY
	RCALL DELAY
	RCALL DELAY
MSG3:	MOVF 0x004,W,A
	MOVWF 0x000,A
	MOVF 0x005,W,A
	MOVWF 0x001,A
	MOVLW 0x01
	MOVWF 0x002,A
	CLRF 0x003,A
	;RCALL SETLP
	;BTFSS STATUS,Z,A
	;BRA KILL
	MOVLW 0x01
	RCALL PRELIM
SETUP5:	NOP
	NOP
	LFSR FSR0, CPYREG
	LFSR FSR1, WRITREG
	NOP
	NOP
	MOVLW CNTVAL5
	MOVWF CNTREG5
	MOVLW HIGH TIKMS1
	MOVWF TBLPTRH
	MOVLW LOW TIKMS1
	MOVWF TBLPTRL
RD5:	TBLRD*+
	MOVFF TABLAT, POSTINC0
	DECF CNTREG5, F
	BNZ RD5
	MOVLW CNTVAL5
	MOVWF CNTREG5
WR5:	MOVFF PREINC1, WREG
	RCALL BITCLR
	DECF CNTREG5, F
	BNZ WR5
JMPLN3:	MOVLW 0xCE
	MOVWF 0x008,A
	MOVLW 0x07
	MOVWF 0x009,A
	RCALL RDYLP2
	MOVLW 0xC0
	RCALL PRELIM
SETUP6:	NOP
	NOP
	LFSR FSR0, CPYREG
	LFSR FSR1, WRITREG
	NOP
	NOP
	MOVLW CNTVAL1
	MOVWF CNTREG6
	MOVLW HIGH TIKMS2
	MOVWF TBLPTRH
	MOVLW LOW TIKMS2
	MOVWF TBLPTRL
RD6:	TBLRD*+
	MOVFF TABLAT, POSTINC0
	DECF CNTREG6, F
	BNZ RD6
	MOVLW CNTVAL1
	MOVWF CNTREG6
WR6:	MOVFF PREINC1, WREG
	RCALL BITCLR
	DECF CNTREG6, F
	BNZ WR6
	RCALL DELAY
	RCALL DELAY
	RCALL DELAY
INF:	BRA MSG1		;creating an infinite loop to emulate a sign on the roadway
;KILL:	SLEEP
;	END			
RDYLP1:	DECFSZ 0x008, F, A	;RDYLP1: sub-routine to run through all the bits of one "cell" of the LCD module
	BRA RDYLP1		;to clear, ready, and intialize them for the message read / write process
	RETURN					
RDYLP2:	MOVLW 0x01		;here and below (with the exception of DELAY and the data bytes under
	SUBWF 0x008, F, A	;the ORG statements) we have labels / sub-routines initially created
	CLRF WREG, A		;by the dissassembler when breaking apart the BASIC demo program(s)
	BTFSS STATUS, C, A	
	ADDLW 0x01		;these labels / sub-routines are a little dense and hard to pick apart,
	SUBWF 0x009, F, A	;but I've renamed, restructed / reorganized, and even modified a couple of them	
	BTFSS STATUS, C, A	
	RETURN			;the crux of these function(s) seems to be clearing and readying the  
	BRA RDYLP2		;LCD module display for action and writing, and operating under this 
BITMOV:	MOVLW 0x01		;educated assumption (after examining the dissassembly thoroughly),
	SUBWF 0x000, F, A	;I was able to incorporate them into my final program effectively
	CLRF WREG, A
	SUBWFB 0x001, F, A	;bit movement logic to ready the LCD module
	BTFSS STATUS, C, A	;skip until carry flag is set from previous SUB instruction(s), then return
	RETURN
	MOVLW 0xC5
	MOVWF 0x008, A
	MOVLW 0x00
	MOVWF 0x009, A
	RCALL RDYLP2
	BRA BITMOV
BITLAG:	BSF LATD, 3, A		;LATD bit 3 set, clear, initialization and delays
	NOP
	NOP
	BCF LATD, 3, A
	NOP
	NOP
	RETURN
BITCLR:	BSF LATD, 1, A		;bit set and bit clear initialization
	BCF LATD, 2, A
	MOVWF LATB, A		;preparing values for RDYLP1 to clear / ready LCD module
	RCALL BITLAG		
	MOVLW 0x1F		;decimal value of 31 (lights / bits in a single LCD rectangle)
	MOVWF 0x008, A		;moved to general purpose register 0x008 
	RCALL RDYLP1		;to be used for looping through each LCD rectangle to clear and ready them
	RETURN
PRELIM:	BCF LATD, 1, A		;clear LATD bits 1-2 (RS and R/W)
	BCF LATD, 2, A
	MOVWF LATB, A
	RCALL BITLAG
	MOVLW 0x1E
	MOVWF 0x008,A
	MOVLW 0x03
	MOVWF 0x009,A
	RCALL RDYLP2
	RETURN
	MOVLW 0x05
	BRA RDYLCD
	MOVLW 0x02
	BRA RDYLCD
	MOVLW 0x06
	BRA RDYLCD
	MOVLW 0x03
	BRA RDYLCD
	MOVLW 0x04
	BRA RDYLCD
SETLP:	MOVLW 0x02	;set loop | initialized (abstract) for loop counter to 1, 2 messages will be written
RDYLCD:	MOVWF 0x008,A	;for loop RDYLCD decrememts until STATUS flag zero  
	MOVF 0x003, W,A	;is set to ready the LCD module for blinking and writing
	SUBWF 0x001, W,A
	BTFSS STATUS, Z,A
	BRA BLINK
	MOVF 0x002,W,A
	SUBWF 0x000,W,A
BLINK:	MOVLW 0x04			
	BTFSC STATUS, C, A
	MOVLW 0x01
	BTFSC STATUS, Z, A
	MOVLW 0x02
	ANDWF 0x008, W, A	 ;this code is intended to display the effect of
	BTFSS STATUS, Z, A 	 ;a single LCD rectangle blinking on / off   
	MOVLW 0xFF	 	 ;0xFF - the hex value of a fully lit up LCD
	RETURN
DELAY:	NOP		;custom sub-routine intended for manual delay
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	RETURN
	ORG 0x400	;program memory
SBRMS1: DB 0x44, 0x72, 0x69, 0x76, 0x65, 0x20, 0x53, 0x6F, 0x62, 0x65, 0x72, 0x20, 0x6F, 0x72, 0x20
	ORG 0x420
SBRMS2: DB 0x47, 0x65, 0x74, 0x20, 0x50, 0x75, 0x6C, 0x6C, 0x65, 0x64, 0x20, 0x4F, 0x76, 0x65, 0x72, 0x20
	ORG 0x440
WRKMS1: DB 0x20, 0x20, 0x43, 0x6F, 0x6E, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x69, 0x6F, 0x6E, 0x20
	ORG 0x460
WRKMS2: DB 0x20, 0x20, 0x20, 0x57, 0x6F, 0x72, 0x6B, 0x20, 0x41, 0x68, 0x65, 0x61, 0x64, 0x20
	ORG 0x480
TIKMS1: DB 0x20, 0x20, 0x43, 0x6C, 0x69, 0x63, 0x6B, 0x20, 0x69, 0x74, 0x20, 0x6F, 0x72, 0x20
	ORG 0x500
TIKMS2: DB 0x20, 0x20, 0x54, 0x69, 0x63, 0x6B, 0x65, 0x74, 0x20, 0x4D, 0x61, 0x73, 0x73, 0x21, 0x20
