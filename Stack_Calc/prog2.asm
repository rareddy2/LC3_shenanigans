


;
;
;
.ORIG x3000

;your code goes here

; The program acts as a calculator
; The program takes postfix expressions as inputs and calculates their corresponding outputs
; It does basic arithmetic operations on positive integers
; It uses subroutines to do the arithmetic operations
; The inputs and outputs are stored in a stack
; They are pushed and popped whenever necessary
; The output is printed onto the screen whenever the program sees an '=' as an input from the user


NEW_CHAR
	IN

	ADD R0, R0, #0 ; R0 stores the initial input from the user
	ST R0, EVAL_CHECK_EQUAL_TO ; Stores R0 value so that it can be retrieved later
	LD R1, EQUAL_TO ;
	NOT R1, R1 ;
	ADD R1, R1, #1 ;
	ADD R0, R0, R1 ;
	BRz CHECK_STACK ; If the character is equal to, the program gives the final output
	LD R0, EVAL_CHECK_EQUAL_TO ; Retrieve value of R0
	AND R1, R1, #0 ;
	LD R1, SPACE ;
	NOT R1, R1 ;
	ADD R1, R1, #1 ;
	ADD R0, R0, R1 ;
	LD R0, EVAL_CHECK_EQUAL_TO ;
	BRz NEW_CHAR ; If the input is a space, the program goes back to asking the user to enter another input

	JSR EVALUATE ; Calls the evaluate function
	BRnzp NEW_CHAR ; goes back to get a new input from the user

DECREMENT .FILL x30
READ2_SAVER4 .BLKW #1

CHECK_STACK
  	LD R1, STACK_TOP ;
		ADD R1, R1, #1 ;
		LD R2, STACK_START ; Checks if there's only 1 value in the stack
		NOT R2, R2
		ADD R2, R2, #1
		ADD R1, R1, R2 ;
		BRnp GOTOEND ; If the stack does not have only 1 value, it prints invalid expression
		JSR POP ; If the program sees an equal to, it pops the value from the stack and outputs the value
		AND R5, R5, #0 ;
		ADD R5, R0, #0 ;
		JSR PRINT_HEX ; PRINT_HEX is the code that prints the final answer
		BRnzp END

	GOTOEND
			ST R0, GOTOEND_SAVER0 ;
			LEA R0, INVALID_EXPRESSION ;
			PUTS ; Loads and prints "Invalid expression"
			LD R0, GOTOEND_SAVER0 ;
			BRnzp END ; Ends the program

GOTOEND_SAVER0 .BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R3- value to print in hexadecimal
PRINT_HEX

		ST R7, PRINT_HEX_SAVER7

		; R0 contains the character to be printed to the screen
; R1 digit counter
; R2 digit
; R3 hex to be printed
; R4 bit counter
; R5 line counter
; R6 holds character to print at start of line
; R7 temporary register

		AND R3, R3, #0 ; initialise R5
		AND R6, R6, #0 ; initialise R6
		AND R0, R0, #0 ; initialise R0



;code to load R3 comes here


		AND R1, R1, #0 ;clear R1
		ADD R1, R1, #4 ;put 4 in R1 as number of digits

DIGIT_L

		AND R0, R0, #0 ;clear R0
		ADD R1, R1, #0
		BRz DIGIT_END ;if R0 is 0, 4 digits have been read

		AND R2, R2, #0 ;clear R2
		AND R4, R4, #0 ;clear R4
		ADD R4, R4, #4 ;put 4 in R4 as bit counter

BIT_L

		ADD R4, R4, #0
		BRz DIGIT_CONDITION ;if R4 is 0, 4 bits have been read

		ADD R2, R2, R2 ;left shift R2 to enter the next bit

		ADD R5, R5, #0
		BRn NEG ;if R3 has a 1 in the MSB go to NEG

		ADD R2, R2, #0
		ADD R5, R5, R5 ;left shift R3
		ADD R4, R4, #-1 ;decrement bit counter
		BRnzp BIT_L ;restart BIT_L

NEG

		ADD R2, R2, #1 ;add 1 to R2
		ADD R5, R5, R5 ;left shift R3
		ADD R4, R4, #-1 ;decrement bit counter
		BRnzp BIT_L ;restart BIT_L


DIGIT_CONDITION ;for checking if the digit is larger than 9 and printing the appropriate character

		ADD R2, R2, #-9 ;subtract 9 from R2 to check if it's >9
		ADD R2, R2, #0
		BRp LARGE ;if R2 is positive, the digit is more than 9

		LD R7, ZERO ;load zero character into R7
		ADD R2, R2, R7 ;add '0' to R2
		ADD R2, R2, #9 ;add back the 9 that was subtracted earlier

		ADD R0, R2, #0 ;put the value stored in R2 into R0
		OUT ;print
		ADD R1, R1, #-1 ;decrement digit counter
		BRnzp DIGIT_L ;restart digit loop

LARGE

		ADD R2, R2, #9 ;add back 9 that was subtracted earlier
		LD R7, A ;load 'A' into R7
		ADD R2, R2, R7 ;add 'A' to R2
		ADD R2, R2, #-10 ;subtract 10 to bring it to the correct ASCII character
		ADD R0, R2, #0
		OUT ;print
		ADD R1, R1, #-1 ;decrement digit counter
		BRnzp DIGIT_L ;restart digit loop


DIGIT_END
		LD R0, NL
		OUT
		ADD R6, R6, #1
		ADD R3, R3, #-1



		ZERO .FILL x0030
		A .FILL x41
		AT .FILL x40
		NL .FILL x0A
		NULL .FILL x00
		START_ADDR .FILL x3F00
		CURR_ADDR .FILL x0000
		EVAL_CHECK_EQUAL_TO .BLKW #1
		EQUAL_TO .FILL x003D
		SPACE .FILL x0020
		PRINT_HEX_SAVER7 .BLKW #1


		LD R7, PRINT_HEX_SAVER7

RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 - character input from keyboard
;R6 - current numerical output
;
;
END
	HALT

INVALID_EXPRESSION .STRINGZ "invalid expression"

EVALUATE

	ST R7, EVAL_SAVER7 ;

CHECK_PLUS
	ST R0, CHECK_PLUS_SAVER0
	ADD R0, R0, #0 ;
	LD R1, PLUS ; Loads '+'
	NOT R1, R1 ;
	ADD R1, R1, #1 ;
	ADD R0, R0, R1 ; Checking if char is '+'
	BRnp CHECK_MINUS ; If the character is not +, program moves to check for -
	ADD R0, R0, #0 ;
	ST R7,CHECK_PLUS_SAVER7
	JSR ADDITION ;
	LD R7, CHECK_PLUS_SAVER7
	RET

CHECK_PLUS_SAVER7 .BLKW #1
CHECK_PLUS_SAVER0 .BLKW #1

CHECK_MINUS
	LD R0, CHECK_PLUS_SAVER0
	ADD R0, R0, #0 ;
	LD R1, MINUS ; Loads '-'
	NOT R1, R1 ;
	ADD R1, R1, #1 ;
	ADD R0, R0, R1 ; Checking if char is '-'
	BRnp CHECK_MULTIPLY ; If the character is not -, program moves to check for *
	ADD R0, R0, #0 ;
	ST R7, CHECK_MINUS_SAVER7
	JSR SUBTRACT ;
	LD R7, CHECK_MINUS_SAVER7
	RET

CHECK_MINUS_SAVER7 .BLKW #1

CHECK_MULTIPLY
	LD R0, CHECK_PLUS_SAVER0
	ADD R0, R0, #0 ;
	LD R1, MULTIPLY_CHAR ; Loads '*'
	NOT R1, R1 ;
	ADD R1, R1, #1 ;
	ADD R0, R0, R1 ; Checking if char is '*'
	BRnp CHECK_DIVIDE ;  If the character is not *, program moves to check for /
	ADD R0, R0, #0 ;
	ST R7, CHECK_MULTIPLY_SAVER7
	JSR MULTIPLY ;
	LD R7, CHECK_MULTIPLY_SAVER7
	RET

CHECK_MULTIPLY_SAVER7 .BLKW #1


CHECK_DIVIDE
	LD R0, CHECK_PLUS_SAVER0
	ADD R0, R0, #0 ;
	LD R1, DIVIDE_CHAR ; Loads '/'
	NOT R1, R1 ;
	ADD R1, R1, #1 ;
	ADD R0, R0, R1 ; Checking if char is '/'
	BRnp CHECK_EXP ; If the character is not /, program moves to check for ^
	ADD R0, R0, #0 ;
	ST R7, CHECK_DIVIDE_SAVER7
	JSR DIVIDE ;
	LD R7, CHECK_DIVIDE_SAVER7
	RET

CHECK_DIVIDE_SAVER7 .BLKW #1

CHECK_EXP
	LD R0, CHECK_PLUS_SAVER0
	ADD R0, R0, #0 ;
	LD R1, EXP ; Loads '^'
	NOT R1, R1 ;
	ADD R1, R1, #1 ;
	ADD R0, R0, R1 ; Checking if char is '^'
	BRnp CHECK_NUMBER ;  If the character is not ^, program moves to check if the input is a number
	ADD R0, R0, #0 ;
	ST R7, CHECK_EXP_SAVER7
	JSR EXPONENT ;
	LD R7, CHECK_EXP_SAVER7
	RET

CHECK_EXP_SAVER7 .BLKW #1
PLUS .FILL x2B
MINUS .FILL x2D
EXP .FILL x5E
MULTIPLY_CHAR .FILL x2A
DIVIDE_CHAR .FILL x2F

CHECK_NUMBER
	LD R0, CHECK_PLUS_SAVER0 ;
	ADD R0, R0, #0 ;
	ST R0, CHECK_NUMBER_SAVER0 ;
	ST R7, CHECK_NUMBER_SAVER7 ;
	JSR CHECK_RANGE_NUMBER ; Checks the range of the number
	LD R0, CHECK_NUMBER_SAVER0 ;
	LD R7, CHECK_NUMBER_SAVER7 ;

	ST R4, READ2_SAVER4
	LD R4, DECREMENT
	NOT R4, R4
	ADD R4, R4, #1
	ADD R0, R4, R0 ; Adjusting the offset to change the value of the input from its ascii value of its decimal value
	JSR PUSH ; Push the number to stack
	LD R4, READ2_SAVER4
	BRnzp NEW_CHAR ; Go to NEW_CHAR to read the next character
	RET ; Return to the part of the code that calls JSR EVALUATE

CHECK_RANGE_NUMBER
		ST R1, CHECK_SAVE_R1 ; Store R1 in CHECK_SAVE_R1
    AND R5, R5, #0 ; Initialise R5
    LD R1, NINE ; Load decimal x39 into R1
		NOT R1, R1 ;
		ADD R1, R1, #1 ;
    ADD R2, R1, R0 ; Add R0 to x39
    BRp GOTOEND ; If R1 is negative, the sum is out of range
		AND R2, R2, #0
    LD R1, ZERO ; Load decimal x30 into R1
		NOT R1, R1 ;
		ADD R1, R1, #1 ;
    ADD R2, R1, R0 ; Add R0 to x30
    BRn GOTOEND ; If R1 is positive, the sum is out of range
		RET



STACK_START    .FILL x4000    ;
STACK_TOP    .FILL x4000    ;


	LD R7, EVAL_SAVER7
EVAL_SAVER7 .BLKW #1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
GOTOEND2
		ST R0, GOTOEND2_SAVER0 ;
		LEA R0, INVALID_EXPRESSION ;
		PUTS ;
		LD R0, GOTOEND2_SAVER0 ;
		BRnzp FINISH ;

GOTOEND2_SAVER0 .BLKW #1

ADDITION ; Storing registers
    ST R7, ADD_SAVE_R7 ; Store R7 in ADD_SAVE_R7
    ST R6, ADD_SAVE_R6 ; Store R6 in ADD_SAVE_R7
    ST R0, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R0
    ST R3, ADD_SAVE_R3 ; Store R3 in ADD_SAVE_R3
    ST R4, ADD_SAVE_R4 ; Store R4 in ADD_SAVE_R4
		ST R2, ADD_SAVE_R2 ; Store R0 in ADD_SAVE_R2
		ST R1, ADD_SAVE_R1 ; Store R0 in ADD_SAVE_R1

		AND R0, R0, #0
	  AND R5, R5, #0 ;
    JSR POP ; Pop 1 value
		ADD R3, R0, #0 ;
    ADD R5, R5, #0 ; To check if underflow is occuring
    BRp GOTOEND2 ; If underflow occurs, "Invalid expression" will be printed to the screen
    JSR POP ; Pop second value
		ADD R4, R0, #0 ;
		ADD R5, R5, #0 ;
    BRp GOTOEND2 ; Checking for underflow again
		AND R0, R0, #0
    ADD R0, R3, R4 ;
    JSR CHECK_RANGE ; Chck the range of the final output
    JSR PUSH ; Pushing the output to stack
    BRnzp EXIT ; Going to EXIT, where all the stored registers are restored

EXIT ; Restoing registers
    LD R7, ADD_SAVE_R7 ; Store R7 in ADD_SAVE_R7
    LD R6, ADD_SAVE_R6 ; Store R6 in ADD_SAVE_R6
    LD R0, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R0
    LD R3, ADD_SAVE_R3 ; Store R3 in ADD_SAVE_R3
    LD R4, ADD_SAVE_R4 ; Store R4 in ADD_SAVE_R4
		LD R1, ADD_SAVE_R1 ; Store R3 in ADD_SAVE_R1
		LD R2, ADD_SAVE_R2 ; Store R3 in ADD_SAVE_R2
    RET

CHECK_RANGE
    ST R1, CHECK_SAVE_R1 ; Store R1 in CHECK_SAVE_R1
    AND R5, R5, #0 ; Initialise R5
    LD R1, RANGE_POSITIVE ; Load decimal 100 into R1
    ADD R1, R1, R0 ; Add R0 to decimal 100
    BRn OUT_OF_RANGE ; If R1 is negative, the sum is out of range
    LD R1, RANGE_NEGATIVE ; Load decimal -100 into R1
    ADD R1, R1, R0 ; Add R0 to decimal -100
    BRp OUT_OF_RANGE ; If R1 is positive, the sum is out of range
    RET

OUT_OF_RANGE ; If the value is out of range, programs prints "Invalid expression"
    ADD R5, R5, #1
    RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
SUBTRACT
		ST R7, ADD_SAVE_R7 ; Store R7 in ADD_SAVE_R7
    ST R6, ADD_SAVE_R6 ; Store R6 in ADD_SAVE_R6
    ST R0, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R0
    ST R3, ADD_SAVE_R3 ; Store R3 in ADD_SAVE_R3
    ST R4, ADD_SAVE_R4 ; Store R4 in ADD_SAVE_R4
		ST R2, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R2
		ST R1, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R1


    AND R5, R5, #0 ;
		JSR POP ; Pop first value
		ADD R4, R0, #0 ;
    NOT R4, R4 ; Changing R4 into a negative value
    ADD R4, R4, #1 ; to subtract it from R3
		ADD R5, R5, #0 ;
    JSR POP ; Pop second value
		ADD R3, R0, #0 ;
		ADD R5, R5, #0 ;
    BRp GOTOEND2 ;
    BRp GOTOEND2 ;
    ADD R0, R3, R4 ;
    JSR CHECK_RANGE ;
    JSR PUSH ;
    BRnzp EXIT ;


;your code goes here

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MULTIPLY
		ST R7, ADD_SAVE_R7 ; Store R7 in ADD_SAVE_R7
    ST R6, ADD_SAVE_R6 ; Store R6 in ADD_SAVE_R6
    ST R0, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R0
    ST R3, ADD_SAVE_R3 ; Store R3 in ADD_SAVE_R3
    ST R4, ADD_SAVE_R4 ; Store R4 in ADD_SAVE_R4
		ST R2, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R2
		ST R1, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R1

    AND R5, R5, #0 ;
    JSR POP ;
		AND R3, R3, #0
		ADD R3, R0, #0 ;
		ADD R5, R5, #0 ;
    BRp GOTOEND2 ;
    JSR POP ;
		ADD R5, R5, #0 ;
    BRp GOTOEND2 ;
		AND R6, R6, #0
		ADD R6, R3, #0
		ADD R4, R0, #0 ;
		ADD R2, R4, #0 ; R2 is the multiplication counter
START_MULT
		ADD R2, R2, #-1
		BRp MULT_LOOP
		ADD R2, R2, #0
		BRnzp MULT_LOOP_END
MULT_LOOP
		;AND R0, R0, #0
    ADD R3, R3, R6 ; R3 stores the final output
		BRnzp START_MULT
MULT_LOOP_END
		AND R0, R0, #0
		ADD R0, R3, #0 ; R3 is loaded into R0 so that it can be printed to screen
    ADD R0, R0, #0 ;
    JSR CHECK_RANGE ;
    JSR PUSH ;
    BRnzp EXIT ;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
DIVIDE
		ST R7, ADD_SAVE_R7 ; Store R7 in ADD_SAVE_R7
    ST R6, ADD_SAVE_R6 ; Store R6 in ADD_SAVE_R6
    ST R0, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R0
    ST R3, ADD_SAVE_R3 ; Store R3 in ADD_SAVE_R3
    ST R4, ADD_SAVE_R4 ; Store R4 in ADD_SAVE_R4
		ST R2, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R2
		ST R1, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R1

    AND R5, R5, #0 ;
    JSR POP ;
		ADD R4, R0, #0 ;
		ADD R5, R5, #0 ;
    BRp GOTOEND2 ;
    JSR POP ;
		ADD R5, R5, #0 ;
    BRp GOTOEND2 ;
		ADD R3, R0, #0 ;
		ADD R2, R3, #0 ;
		AND R0, R0, #0 ;
		NOT R4, R4 ; Changing R3 into a negative value
		ADD R4, R4, #1 ; to subtract it from R4
DIV_LOOP
    ADD R0, R0, #1
		ADD R3, R3, R4
    BRzp DIV_LOOP
    ADD R0, R0, #-1 ; R0 is the quotient
    ADD R1, R4, R3 ; R1 holds the remainder
    ADD R0, R0, #0 ;
    JSR CHECK_RANGE ;
    JSR PUSH ;
    BRnzp EXIT ;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
EXPONENT
		ST R7, ADD_SAVE_R7 ; Store R7 in ADD_SAVE_R7
    ST R6, ADD_SAVE_R6 ; Store R6 in ADD_SAVE_R6
    ST R0, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R0
    ST R3, ADD_SAVE_R3 ; Store R3 in ADD_SAVE_R3
    ST R4, ADD_SAVE_R4 ; Store R4 in ADD_SAVE_R4
		ST R2, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R2
		ST R1, ADD_SAVE_R0 ; Store R0 in ADD_SAVE_R1

    AND R5, R5, #0 ;
    JSR POP ;
		ADD R4, R0, #0 ;
		ADD R5, R5, #0 ;
    BRp GOTOEND2 ;
    JSR POP ;
		ADD R5, R5, #0 ;
    BRp GOTOEND2 ;
		ADD R3, R0, #0 ;
		AND R6, R6, #0
		ADD R5, R3, #0
    ADD R1, R4, #0 ;R1 is the exponent counter (repeated multiplication R4 times)
		ADD R1, R1, #-1 ; Decrementing R1 because the number is multiplied by itself (n-1) times
EXP_LOOP

		ADD R6, R3, #0
    ADD R2, R5, #0 ; R2 is the multiplication counter (repeated addition)

		START_MULT_EXP; Same as multiplication but it is changed so that a is multiplied by a and not by b, where a and b are the inputs
				ADD R2, R2, #-1
				BRp MULT_LOOP_EXP
				;ADD R3, R3, R6
				ADD R1, R1, #-1
				BRp EXP_LOOP
				ADD R2, R2, #0
				BRnzp MULT_LOOP_END_EXP
		MULT_LOOP_EXP
				AND R0, R0, #0
		    ADD R3, R3, R6 ;
				BRnzp START_MULT_EXP
		MULT_LOOP_END_EXP
				AND R0, R0, #0
				ADD R0, R3, #0
		    ADD R0, R0, #0 ;
		    JSR CHECK_RANGE ;
		    JSR PUSH ;
		    BRnzp EXIT ;


;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH
    ST R3, PUSH_SaveR3    ;save R3
    ST R4, PUSH_SaveR4    ;save R4
    AND R5, R5, #0        ;
    LD R3, STACK_END    ;
    LD R4, STACK_TOP    ;
    ADD R3, R3, #-1        ;
    NOT R3, R3        ;
    ADD R3, R3, #1        ;
    ADD R3, R3, R4        ;
    BRz OVERFLOW        ;stack is full
    STR R0, R4, #0        ;no overflow, store value in the stack
    ADD R4, R4, #-1        ;move top of the stack
    ST R4, STACK_TOP    ;store top of stack pointer
    BRnzp DONE_PUSH        ;
OVERFLOW
    ADD R5, R5, #1        ;
DONE_PUSH
    LD R3, PUSH_SaveR3    ;
    LD R4, PUSH_SaveR4    ;
    RET


PUSH_SaveR3    .BLKW #1    ;
PUSH_SaveR4    .BLKW #1    ;


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP
    ST R3, POP_SaveR3    ;save R3
    ST R4, POP_SaveR4    ;save R3
    AND R5, R5, #0        ;clear R5
    LD R3, STACK_START    ;
    LD R4, STACK_TOP    ;
    NOT R3, R3        ;
    ADD R3, R3, #1        ;
    ADD R3, R3, R4        ;
    BRz UNDERFLOW        ;
    ADD R4, R4, #1        ;
    LDR R0, R4, #0        ;
    ST R4, STACK_TOP    ;
    BRnzp DONE_POP        ;
UNDERFLOW
    ADD R5, R5, #1        ;
DONE_POP
    LD R3, POP_SaveR3    ;
    LD R4, POP_SaveR4    ;
    RET


POP_SaveR3    .BLKW #1    ;
POP_SaveR4    .BLKW #1    ;
STACK_END    .FILL x3FF0    ;


ADD_SAVE_R6 .BLKW #1 ;
ADD_SAVE_R7 .BLKW #1 ;
ADD_SAVE_R0 .BLKW #1 ;
ADD_SAVE_R3 .BLKW #1 ;
ADD_SAVE_R4 .BLKW #1 ;
ADD_SAVE_R1 .BLKW #1 ;
ADD_SAVE_R2 .BLKW #1 ;


CHECK_SAVE_R1 .BLKW #1 ; Storing R1 here for check_range
RANGE_POSITIVE .FILL X0064 ; Decimal 100
RANGE_NEGATIVE .FILL XFF9C ; Decimal -100

;Evaluate .fills


;ZERO .FILL x30
NINE .FILL x0039
CHECK_NUMBER_SAVER7 .BLKW #1
CHECK_NUMBER_SAVER0 .BLKW #1



FINISH
  HALT

.END
