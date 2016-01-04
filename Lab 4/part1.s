# Include nios_macros.s to workaround a bug in the movia pseudo-instruction.
.include "nios_macros.s"
.equ CONTROLLER, 0xFF200070
.equ DIRECTION_CONFIG, 0x07f557ff 

# (Hint: See DESL website for documentation on LEDs/Switches)

# .data                  # "data" section for input and output lists



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

movia r8, CONTROLLER
movia r9, DIRECTION_CONFIG
stwio r9, 4(r8) #initialize direction reg
movi32 r9, 0xffffffff
stwio r9, 0(r8)
movi r10, 0b1000 #is balanced at 8
movia r11,  ~(0x1 << 10)
movia r15, ~(0x1 << 12)
movia r13, 0b01111


LOAD_VALUES:
ldwio r17, 0(r8) #sensor 1
ldwio r12, 0(r8) #sensor 0
and r12, r12, r11
stwio r12, 0(r8) #enable sensor 0
#ldwio r12, 0(r8)
#movia r14, 0b1111111111111111111101111111111
#stwio r14, 0(r8) #enable sensor 0


timeout1:

		ldwio r16, 0(r8)
		srli r16, r16,11
		slli r16, r16, 31
		bne r16, r0, timeout1

ldwio r12, 0(r8)

and r17, r17, r15
stwio r17, 0(r8)

timeout2:
		ldwio r16, 0(r8)
		srli r16, r16,13
		slli r16, r16, 31
		bne r16, r0, timeout2
ldwio r17, 0(r8)
		

srli r12, r12, 27 #shift bits right so the sensor value is last (first?) 4 bits
srli r17, r17, 27
#beq r12,r10, LOAD_VALUES #if r12 is 8/0b11000 is balanced
#bge r12, r13, LOAD_VALUES #if r12 is 0b11111 it's an invalid read
ble r12, r17, TILT_RIGHT 
bge r12, r17, TILT_LEFT

TILT_RIGHT:
movia r14, 0xfffffffe   
stwio r14, 0(r8)
#br LOAD_VALUES
br TILT_RIGHT

TILT_LEFT:
movia r14, 0xfffffffc   
stwio r14, 0(r8)
br LOAD_VALUES