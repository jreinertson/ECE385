# Include nios_macros.s to workaround a bug in the movia pseudo-instruction.
.include "nios_macros.s"

.equ SWITCHES, 0xFF200040
.equ RED_LEDS, 0xFF200000 
# (Hint: See DESL website for documentation on LEDs/Switches)

.data                  # "data" section for input and output lists

IN_LIST:               # List of 10 words starting at location IN_LIST
    .word 1
    .word -1
    .word -2
    .word 2
    .word -3
    .word 0
    .word 100
    .word 0xffffff9c
    .word 0x100
    .word 0b1111
    
OUT_NEGATIVE:
    .skip 80            # Reserve space for 20 output words
    
OUT_POSITIVE:
    .skip 80           # Reserve space for 20 output words

#-----------------------------------------

.text                  # "text" section for (read-only) code

    # Register allocation:
    #   r0 is zero, and r1 is "assembler temporary". Not used here.
    #   r2  Holds the number of negative numbers in the list
    #   r3  Holds the number of non-negative numbers in the list
    #   r_  A pointer to ___
    #   r_  loop counter for ___
    #   r16 Register for short-lived temporary values.
    #   etc...

.global _start
_start:

    # Your program here. Pseudocode and some code done for you:
    
    # Begin loop to process each number
    
        # Process a number here:
        #    if (number is negative) { 
        #        insert number in OUT_NEGATIVE list
        #        increment count of negative values (r2)
        #    } else {
        #        insert number in OUT_POSITIVE list
        #        increment count of non-negative values (r3)
        #    }
        # Done processing.
        
    # End loop
	movia r6, IN_LIST #load first list element into r6
	movia r7, OUT_NEGATIVE #r7 is the list
	movia r8, OUT_POSITIVE
	addi r2, r0, 0
	addi r3, r0, 0
	addi r5, r0, 0 #et all these to 0
	addi r9, r0, 20
	LOOP:

		beq r5, r9, LOOP_FOREVER
		ldw r16, 0(r6)
		beq r16, r0, LOOP_FOREVER
		bge r16, r0, POSITIVES
		
		NEGATIVES:
			stwio r6, 0(r7)
			addi r7, r7, 4 
			addi r2, r2, 1
			addi r6, r6, 4
			addi r5, r5, 1 
			br LOOP
		
		POSITIVES:
			stwio r6, 0(r8)
			addi r3, r3, 1
			addi r6, r6, 4 
			addi r5, r5, 1
			addi r8, r8, 4 
			br LOOP

LOOP_FOREVER:

        # (You'll learn more about I/O in Lab 4.)
        movia  r16, RED_LEDS          # r16 is a temporary value
		movia r4, SWITCHES
		#stwio r2, 0(r16) # Send r2 out to the red LEDs device
		ldwio r11, 0(r4)
		
		beq r0, r11, POS
		
		NEG:
			stwio r2, 0(r16)
			br LOOP_FOREVER
		
		POS:
			stwio r3, 0(r16)
			br LOOP_FOREVER
	# Add a switching logic that uses any switch on the board to mux the values of r2 and r3 on the RED LEDs and hold them.
        # Finished output to LEDs.
        
	
    br LOOP_FOREVER                   # Loop forever.
