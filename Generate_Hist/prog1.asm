;
; The code given to you here implements the histogram calculation that 
; we developed in class.  In programming lab, we will add code that
; prints a number in hexadecimal to the monitor.
;
; Your assignment for this program is to combine these two pieces of 
; code to print the histogram to the monitor.
;
; If you finish your program, 
;    ** commit a working version to your repository  **
;    ** (and make a note of the repository version)! **


	.ORIG	x3000		; starting address is x3000


;
; Count the occurrences of each letter (A to Z) in an ASCII string 
; terminated by a NUL character.  Lower case and upper case should 
; be counted together, and a count also kept of all non-alphabetic 
; characters (not counting the terminal NUL).
;
; The string starts at x4000.
;
; The resulting histogram (which will NOT be initialized in advance) 
; should be stored starting at x3F00, with the non-alphabetic count 
; at x3F00, and the count for each letter in x3F01 (A) through x3F1A (Z).
;
; table of register use in this part of the code
;    R0 holds a pointer to the histogram (x3F00)
;    R1 holds a pointer to the current position in the string
;       and as the loop count during histogram initialization
;    R2 holds the current character being counted
;       and is also used to point to the histogram entry
;    R3 holds the additive inverse of ASCII '@' (xFFC0)
;    R4 holds the difference between ASCII '@' and 'Z' (xFFE6)
;    R5 holds the difference between ASCII '@' and '`' (xFFE0)
;    R6 is used as a temporary register
;

	LD R0,HIST_ADDR      	; point R0 to the start of the histogram
	
	; fill the histogram with zeroes 
	AND R6,R6,#0		; put a zero into R6
	LD R1,NUM_BINS		; initialize loop count to 27
	ADD R2,R0,#0		; copy start of histogram into R2

	; loop to fill histogram starts here
HFLOOP	STR R6,R2,#0		; write a zero into histogram
	ADD R2,R2,#1		; point to next histogram entry
	ADD R1,R1,#-1		; decrement loop count
	BRp HFLOOP		; continue until loop count reaches zero

	; initialize R1, R3, R4, and R5 from memory
	LD R3,NEG_AT		; set R3 to additive inverse of ASCII '@'
	LD R4,AT_MIN_Z		; set R4 to difference between ASCII '@' and 'Z'
	LD R5,AT_MIN_BQ		; set R5 to difference between ASCII '@' and '`'
	LD R1,STR_START		; point R1 to start of string

	; the counting loop starts here
COUNTLOOP
	LDR R2,R1,#0		; read the next character from the string
	BRz PRINT_HIST		; found the end of the string

	ADD R2,R2,R3		; subtract '@' from the character
	BRp AT_LEAST_A		; branch if > '@', i.e., >= 'A'
NON_ALPHA
	LDR R6,R0,#0		; load the non-alpha count
	ADD R6,R6,#1		; add one to it
	STR R6,R0,#0		; store the new non-alpha count
	BRnzp GET_NEXT		; branch to end of conditional structure
AT_LEAST_A
	ADD R6,R2,R4		; compare with 'Z'
	BRp MORE_THAN_Z         ; branch if > 'Z'

; note that we no longer need the current character
; so we can reuse R2 for the pointer to the correct
; histogram entry for incrementing
ALPHA	ADD R2,R2,R0		; point to correct histogram entry
	LDR R6,R2,#0		; load the count
	ADD R6,R6,#1		; add one to it
	STR R6,R2,#0		; store the new count
	BRnzp GET_NEXT		; branch to end of conditional structure

; subtracting as below yields the original character minus '`'
MORE_THAN_Z
	ADD R2,R2,R5		; subtract '`' - '@' from the character
	BRnz NON_ALPHA		; if <= '`', i.e., < 'a', go increment non-alpha
	ADD R6,R2,R4		; compare with 'z'
	BRnz ALPHA		; if <= 'z', go increment alpha count
	BRnzp NON_ALPHA		; otherwise, go increment non-alpha

GET_NEXT
	ADD R1,R1,#1		; point to next character in string
	BRnzp COUNTLOOP		; go to start of counting loop



PRINT_HIST

; you will need to insert your code to print the histogram here

; The code follows the flowchart that was gives
; Once that part of the code is implemented, we print the ASCII character,
; a space, and then the histogram that displays the count of the number of 
; occurences of each character in a particular string
;  partners: ssgarg2, ssrana4, mustafa6


; R0 contains the character to be printed to the screen
; R1 digit counter
; R2 digit
; R3 hex to be printed
; R4 bit counter
; R5 line counter
; R6 holds character to print at start of line
; R7 temporary register

		AND R5, R5, #0 ; Initialise R5	
		AND R6, R6, #0 ; Initialise R6
		AND R0, R0, #0 ; Initialise R0
		ADD R5, R5, #15 ; Iterate over 
		ADD R5, R5, #12 ; 27 lines

		LD R6, AT ; Load the hex value for @ into R6
		
		LD R3, START_ADDR ; Load x3F00 into R6

LINE_LOOP

		AND R0, R0, #0 ; Initialise R0 
		ADD R0, R6, #0	; Load @ into R0 to print to the screen
		OUT
		
		LD R0, SPACE ; Print space between character and count
		OUT 		
	
		ST R3, CURR_ADDR ; Store R3 in .FILL x0000 temporarily
		LDR R3, R3, #0 ; Load contents of x3F00 into R3

		AND R1, R1, #0 ; Clear R1
		ADD R1, R1, #4 ; Put 4 in R1 as number of digits

DIGIT_L

		AND R0, R0, #0 ; Clear R0
		ADD R1, R1, #0 ; 
		BRz DIGIT_END ; When R1 is 0, all 4 digits have been read, so we can move to the part of the code that prints the output 

		AND R2, R2, #0 ; Clear R2
		AND R4, R4, #0 ; Clear R4
		ADD R4, R4, #4 ; Set up bit counter 

BIT_L

		ADD R4, R4, #0 ; Empty command (to loop back to the branch)
		BRz DIGIT_CONDITION ; When R4 is 0, 4 bits have been read, so we check what the value of the digit is and print the output accordingly

		ADD R2, R2, R2 ; Left shift R2 to accomodate the next incoming bit from R3

		ADD R3, R3, #0 ; Empty command (to loop back to the branch)
		BRn NEG ; If R3 has a 1 in the most significant bit, the code moves to NEG

		ADD R2, R2, #0 ; Empty command 
		ADD R3, R3, R3 ; Left shift R3 to check the next bit 
		ADD R4, R4, #-1 ; Decrement bit counter
		BRnzp BIT_L ; Loop back to BIT_L to repeat the process 

NEG

		ADD R2, R2, #1 ; Add 1 to R2
		ADD R3, R3, R3 ; Left shift R3 to check the next bit 
		ADD R4, R4, #-1 ; Decrement bit counter
		BRnzp BIT_L ; Loop back to BIT_L to repeat the process 


DIGIT_CONDITION ; to check whether the value of the digit is >9 or <=9

		ADD R2, R2, #-9 ; Subtract 9 from R2 to check if it's >9
		ADD R2, R2, #0 ; Empty command 
		BRp LARGE ; If R2 is positive, the digit is more than 9

		LD R7, ZERO ; Load ASCII 0 into R7
		ADD R2, R2, R7 ; Add '0' to R2
		ADD R2, R2, #9 ; Add back the 9 that was subtracted earlier

		ADD R0, R2, #0 ; Put the value stored in R2 into R0
		OUT ; Print
		ADD R1, R1, #-1 ; Decrement digit counter
		BRnzp DIGIT_L ; Loop back to BIT_L to repeat the process 

LARGE

		ADD R2, R2, #9 ; Add back 9 that was subtracted earlier
		LD R7, A ; Load 'A'(ASCII A) into R7
		ADD R2, R2, R7 ; Add 'A' to R2
		ADD R2, R2, #-10 ; Subtract 10 to bring it to the correct ASCII character
		ADD R0, R2, #0 ; Empty command
		OUT ; Print
		ADD R1, R1, #-1 ; Decrement digit counter
		BRnzp DIGIT_L ; Loop back to BIT_L to repeat the process


DIGIT_END 

		LD R0, NL ; Load new line ASCII character into R0
		OUT ; Print new line 
		ADD R6, R6, #1 ; Increment R6 to print the next ASCII character in the new line 
		LD R3, CURR_ADDR ; Restore the original R3 by loading in the CURR_ADDR
		ADD R3, R3, #1 ; Increment the address of R3
		ADD R5, R5, #-1 ; Decrement line counter to tell the computer to stop at 'Z'
		BRp LINE_LOOP ; Loop back to the beginning until the line counter reaches 0 


ZERO .FILL x30
A .FILL x41
AT .FILL x40
NL .FILL x0A
SPACE .FILL x20
START_ADDR .FILL x3F00
CURR_ADDR .FILL x0000

; do not forget to write a brief description of the approach/algorithm
; for your implementation, list registers used in this part of the code,
; and provide sufficient comments



DONE	HALT			; done


; the data needed by the program
NUM_BINS	.FILL #27	; 27 loop iterations
NEG_AT		.FILL xFFC0	; the additive inverse of ASCII '@'
AT_MIN_Z	.FILL xFFE6	; the difference between ASCII '@' and 'Z'
AT_MIN_BQ	.FILL xFFE0	; the difference between ASCII '@' and '`'
HIST_ADDR	.FILL x3F00     ; histogram starting address
STR_START	.FILL x4000	; string starting address

; for testing, you can use the lines below to include the string in this
; program...
; STR_START	.FILL STRING	; string starting address
; STRING		.STRINGZ "This is a test of the counting frequency code.  AbCd...WxYz."



	; the directive below tells the assembler that the program is done
	; (so do not write any code below it!)

	.END
