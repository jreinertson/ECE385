# Include nios_macros.s to workaround a bug in the movia pseudo-instruction.
.include "nios_macros.s"
.equ ADDR_TIMR, 0xFF202000
.equ ADDR_AUDIO, 0xFF203040 #primary audio address, there are 4 32 bit registers
.equ ADDR_VGA_CHAR, 0x09000000
.equ ADDR_TIMR, 0xFF202000
.equ PS2_PORT, 0xFF200100

# CHARACTERS
.equ LETTER_A, 0x41
.equ LETTER_B, 0x42
.equ LETTER_M, 0x4D
.equ LASER, 0x7C

#constants
.equ delay_value, 5 #delay value for laser


.data

#OBJECTS
.align 1
UFO: #when a UFO is destroyed, set it to 0
.word 0x09000000
.word 2
.word 3
.word 4
.word 5
.word 6 
.word 7 
.word 8 
.word 9 
.word 10 
.word 11 
.word 12 
.word 13 
.word 14 
.word 15 
.word 16 
.word 17 
.word 18 
.word 19 
.word 20 
.word 21 
.word 22 
.word 23 
.word 24 
.word 25 
.word 26 
.word 27 

.align 1
UFO_count:
.word 27

.align 1
LASER_loc:
.word 0

.align 1

Guy_loc:
.word 0x09000001 #old loc
.word 0x09000001 #new loc

.align 1

Stack_loop:
.word 0

.align 1
 
Stack_game:
.word 0

.align 1

laser_Delay:
.word 0

.align 1

UFO_RL: #will ufo move right or move left
.word 0 #flag for yes/no
.word 0 #counter for how many times it was moved over
.word 0 #counter for how many loops before it moves over
.word 0 #value of delay

.align 1
WIN_FLAG:
.word 0

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
#
movia r8, ADDR_VGA_CHAR
addi r8, r8, 68
movia r12, WIN_FLAG
ldw r11, 0(r12)

#
beq r11, r0, set_to_zero
ldb r9, 0(r8)
ldb r12, 1(r8)
br after_setting

#
set_to_zero:
addi r9, r0, 0x30
addi r12, r0, 0x30

after_setting:
#store address values in r9, r10

addi r1, r0, 8191
addi r2, r0, 0
RefreshLoop:
	movia r8, ADDR_VGA_CHAR
	add r8, r8, r2
	stb r0, 0(r8)
	addi r2, r2, 1
	blt r2, r1, RefreshLoop 

	#
movia r8, ADDR_VGA_CHAR
addi r8, r8, 68
stb r9, 0(r8)
stb r12, 1(r8)
	
addi r1, r0, 80
addi r2, r0, 0	
movia r3, LASER
movia r8, ADDR_VGA_CHAR
addi r8, r8, 61
Draw_Boarder:
	stb r3, 0(r8)
	addi r8, r8, 0b0000010000000
	addi r2, r2, 1
	blt r2, r1, Draw_Boarder
	
	
	
#this sets up the initial laser values
movia r8, ADDR_VGA_CHAR
movia r7, LETTER_A

#init laser
movia r9, LASER
movia r10, LASER_loc
addi r9, r0, 0
stw r9, 0(r10)

#init UFO_RL
movia r10, UFO_RL
addi r9, r0, 0
stw r9, 0(r10)
addi r9, r0, 0
stw r9, 4(r10)
stw r9, 8(r10)
addi r9, r9, 10
stw r9, 12(r10) #inital delay value

#this sets up the initial ufo array values
movia r10, UFO
#addi r11, r8, 0b0000010000000
addi r11, r8, 0b1010010000000 
addi r11, r11, 4 #1
stw r11, 0(r10)
addi r11, r11, 3 #2
stw r11, 4(r10)
addi r11, r11, 3 #3 
stw r11, 8(r10)
addi r11, r11, 3 #4 
stw r11, 12(r10)
addi r11, r11, 3 #5 
stw r11, 16(r10)
addi r11, r11, 3 #6 
stw r11, 20(r10) 
addi r11, r11, 3 #7 
stw r11, 24(r10)
addi r11, r11, 3 #8 
stw r11, 28(r10) 
addi r11, r11, 3 #9 
stw r11, 32(r10)
addi r11, r11, 0b0000010000000
subi r11, r11, 2 #10
stw r11, 36(r10)
subi r11, r11, 3 #11
stw r11, 40(r10)
subi r11, r11, 3 #12 
stw r11, 44(r10) 
subi r11, r11, 3 #13 
stw r11, 48(r10)
subi r11, r11, 3 #14 
stw r11, 52(r10)
subi r11, r11, 3 #15 
stw r11, 56(r10)
subi r11, r11, 3 #16 
stw r11, 60(r10) 
subi r11, r11, 3 #17 
stw r11, 64(r10)
addi r11, r11, 0b0000010000000
subi r11, r11, 3 #18 
stw r11, 68(r10)
addi r11, r11, 28 #19 
stw r11, 72(r10)
addi r11, r11, 0b0000010000000
addi r11, r11, 2 #20 
stw r11, 76(r10)
subi r11, r11, 32 #21 
stw r11, 80(r10)
subi r11, r11, 0b0010000000000
addi r11, r11, 11 #22 
stw r11, 84(r10)
addi r11, r11, 10 #23 
stw r11, 88(r10)
subi r11, r11, 0b0000110000000
subi r11, r11, 3 #24
stw r11, 92(r10)
subi r11, r11, 4 #25 
stw r11, 96(r10)
subi r11, r11, 0b0000010000000
addi r11, r11, 2 #26
stw r11, 100(r10)
addi r11, r11, 0b0100010000000
stw r11, 104(r10) #27

#sets up num of ufo
movia r10, UFO_count
addi r9, r0, 27
stw r9, 0(r10)

#stb r7, 0(r11)

movia r15, 0x53 #displays the string SCORE
stb r15, 62(r8)
movia r15, 0x43
stb r15, 63(r8)
movia r15, 0x4F
stb r15, 64(r8)
movia r15, 0x52
stb r15, 65(r8)
movia r15, 0x45
stb r15, 66(r8)
movia r15, 0x3A
stb r15, 67(r8)
movia r15, 0x30
#stb r15, 68(r8)
#stb r15, 69(r8)





add r15, sp, r0 #we're gonna push the return address onto the stack
subi r15, r15, 200 #this is stack location for uhhhh gameloop
movia r20, Stack_game
stw r15, 0(r20)

subi r15, r15, 200 #this is stack location for main loop
movia r20, Stack_game
stw r15, 0(r20) 
subi r16, r15, 100 #this is gonna be where the stack starts for GameLoop
stw r16, 0(r15)


movia r17, 0b1 #IRQ 1
rdctl r18, ienable
or r18, r18, r17  #enable interrupts for IRQ1
wrctl ienable, r18 
movi r18, 1
wrctl status, r18 #enable NIOSII interrupt handling
#all registers free again
#////////////////////////////
#movia r16, 10000000 #loads n into r16
movia r16, 5000000
movia r17, ADDR_TIMR #load timer's address
stwio r0, 0(r17)
andi r16, r16, 0x0000ffff
stwio r16, 8(r17) 
#movia r16, 11111111
movia r16, 5000000
srli r16, r16, 16
stwio r16, 12(r17) #set the N into there

movui r16, 0b101
stwio r16, 4(r17)



LOOP:
	#r8 is the PS2 address
	#r10 is temp or laser
	#r21 is the entire value read from the Ps/2 port
	#r22 is modified versions of r9, used to checking if we have values to read
	movia r9, PS2_PORT
	ldwio r21, 0(r9) #read in data
	movia r22, ~(0x1 << 15)
	and r22, r22, r21 #check if bit 15 is true
	beq r22, r0, LOOP #go back to start if data is not valid
	addi r22, r21, 0
	srli r22, r22, 16
	beq r22, r0, LOOP #go back to start if there is nothing to read
	#now there is valid data and data to read...
	mov r22, r21
	slli r22, r22, 17
	srli r22, r22, 17
	#r10 now contains a valid command, with a 1 at the front
	#1C is left
	#23 is right
	#1D is up
	#1B is down
	#if we get an F0 read value, we should consume the next read 
	movia r21, 0xF0
	beq r22, r21, CONSUME_NEXT #consume the key release buffered
	
	movia r21, 0x1C
	beq r21, r22, MOVE_LEFT
	
	movia r21, 0x23
	beq r21, r22, MOVE_RIGHT
	
	#movia r21, 0x1D
	#beq r21, r22, MOVE_UP
	
	movia r21, 0x1B
	#beq r21, r22, MOVE_DOWN	
	beq r21, r22, FIRE_LASER

br LOOP

CONSUME_NEXT:
ldwio r9, 0(r9)
br LOOP

FIRE_LASER:
	movia r20, Guy_loc
	movia r8, LASER_loc
	
	movia r11, laser_Delay
	ldw r11, 0(r11)

	beq r11, r0, let_laser_fire
	br no_laser_fire 
	
	let_laser_fire:
	ldw r10, 0(r8)
	stb r0, 0(r10)
	ldw r20, 0(r20)
	stw r20, 0(r8)
	
	movia r11, laser_Delay
	movia r12, delay_value
	stw r12, 0(r11)
	
		makesound1: #make sound for when the player fires
		movia r11, 300
		movia r20, ADDR_AUDIO
		sound1:
		movia r3, 0xeeeeeeee
		stwio r3, 8(r20)      /*write to left buffer AKA left fifo*/
		stwio r3, 12(r20)     /*write to right buffer AKA right fifo*/
		subi r11, r11, 1
		beq r11, r0, makesound2
		br sound1

		makesound2:
		movia r11, 300
		sound2:
		movia r3, 0x00000000
		stwio r3, 8(r20)      /*write to left buffer AKA left fifo*/
		stwio r3, 12(r20)     /*write to right buffer AKA right fifo*/
		subi r11, r11, 1
		beq r11, r0, LOOP
		br sound2
		br LOOP
	
	no_laser_fire:
	br LOOP
	
MOVE_RIGHT:
movia r20, Guy_loc
ldw r23, 4(r20)
movia r10, ADDR_VGA_CHAR
addi r10, r10, 60
beq r23, r10, LOOP

addi r23, r23, 1
stwio r23, 4(r20)
br LOOP

MOVE_UP:
movia r20, Guy_loc
ldw r23, 4(r20)
subi r23, r23, 0b0000010000000
stwio r23, 4(r20)
br LOOP

MOVE_DOWN:
movia r20, Guy_loc
ldw r23, 4(r20)
addi r23, r23, 0b0000010000000
stwio r23, 4(r20)
br LOOP

MOVE_LEFT:
movia r20, Guy_loc
ldw r23, 4(r20)
movia r10, ADDR_VGA_CHAR
beq r23, r10, LOOP
subi r23, r23, 1
stwio r23, 4(r20)
br LOOP

GameLoop:
	#r15 handles sp location

	#r16 is the ufo stuff r8
	#r17 is the Laser stuff r9
	#r18 is the ufo counter r10 

	movia r16, UFO
	movia r17, LASER_loc
	movia r18, UFO_count 
	movia r19, Guy_loc
	
	
	add r15, sp, r0 #we're gonna push the return address onto the stack
	subi sp, sp, 8 #it's 8 because we're also going to save the previous sp location
	stw r15, 0(sp)
	stw ra, 4(sp)

	
	#call stuff here

	call User_lasers
	call UFO_handle #handles ufos
	
	ldw ra, 4(sp)
	ldw r15, 0(sp) #load sp back into the potentially modified r15(since it's caller saved)
	add sp, r15, r0 #now put the original sp value back as the sp
	
	#render dude here, super quick 'n dirty for demo
	#Guy_Loc has two values, it's current position to render and it's last position rendered at
	ldwio r2, 0(r19) #load old position of guy
	stb r0, 0(r2) #erase it
	ldwio r2, 4(r19) #load current position
	movia r14, LETTER_B
	stb r14, 0(r2) #render A to new pos
	stwio r2, 0(r19)  #update old position
	
	
	ret
	

UFO_handle:
	#r8 handles loading UFO_RL flag
	#r9 handles loading movement counter
	#r10 is the loop counter
	#r11 is the hardcoded number of ufos in the array, 4atm
	#r12 is the loop variable
	#r13 is the A letter
	
	#r14 handles delay loop counter
	#r15 handles delay value
	
	#r16 is the ufo stuff r8
	#r17 is the Laser stuff r9
	#r18 is the ufo counter r10 
	
	#r19 is

	movia r13, LETTER_A
	movia r16, UFO
	movia r8, UFO_RL #address of array
	ldw r9, 4(r8) #load movement counter first
	ldw r14, 8(r8) #load counter for delay
	ldw r15, 12(r8) #load delay value, which changes and decreases as game goes on

	
	addi r10, r0, 0
	addi r11, r0, 27
	Move_ufo:
		
		beq r14, r15, can_move #this means the counter has maxed output
		
		addi r14, r14, 1 
		stw r14, 8(r8)
		br end_it
		
		can_move:
				
		addi r14, r0, 0#reset the value of delay counter
		stw r14, 8(r8)
		
		#we're gonna use r14 for something different here now
		
		movia r14, 28 #hardcoded value of how many move overs the ufo goes
		beq r9, r14, change_direction
		
		continue_load_move:
		addi r9, r9, 1 #increase movement counter by 1
		stw r9, 4(r8)
		
		ldw r8, 0(r8) #then finally load the the flag to check if we move left or move right
		
		
		beq r8, r0, move_rightz #the flag being 0 means move_right happens
		#the flag being 1 will mean move_left happens
		
		move_start:
		
		subi r16, r16, 4
		move_left:
			beq r10, r11, end_it
			addi r16, r16, 4 
			
			ldw r12, 0(r16) #load current ufo 
			beq r12, r0, skip_ufol #if ufo is 0, it means it is dead
			
			stb r0, 0(r12)#clear current ufo location 
			
			subi r12, r12, 1
			stw r12, 0(r16)
			stb r13, 0(r12)
			
			skip_ufol:
			addi r10, r10, 1
			br move_left
			
		move_rightz:
		addi r16, r16, 108
		move_right:
			beq r10, r11, end_it
			subi r16, r16, 4 
			
			ldw r12, 0(r16) #load current ufo 
			beq r12, r0, skip_ufor #if ufo is 0, it means it is dead
			
			stb r0, 0(r12)#clear current ufo location 
			
			addi r12, r12, 1
			stw r12, 0(r16)
			stb r13, 0(r12)
			
			skip_ufor:
			addi r10, r10, 1
			br move_right
			
		move_down: 
		subi r16, r16, 4
		
		movia r8, UFO_RL #speeds up ufos
		ldw r10, 12(r8)
		beq r10, r0, move_down2 
		subi r10, r10, 1 
		stw r10, 12(r8)
		stw r0, 8(r8)
		addi r10, r0, 0
		
		move_down2:
			beq r10, r11, end_it
			addi r16, r16, 4 
			
			ldw r12, 0(r16) #load current ufo 
			beq r12, r0, skip_ufod #if ufo is 0, it means it is dead
			
			stb r0, 0(r12)#clear current ufo location 
			
			subi r12, r12, 0b0000010000000
			stw r12, 0(r16)
			stb r13, 0(r12)
			
			andi r12, r12, 0b1111110000000
			beq r12, r0, gameover
			skip_ufod:
			addi r10, r10, 1
			br move_down2
			
	end_it:
		#redraw mothership as M
		movia r16, UFO
		ldw r16, 104(r16)
		movia r13, LETTER_M
		stb r13, 0(r16)
		ret
		
		gameover:
			movia r8, ADDR_VGA_CHAR
			addi r8, r8, 0b0000010000000
			movia r15, 0x454D4147 #string for GAME
			stwio r15, 64(r8)
			movia r15, 0x5245564F #string for OVER
			stwio r15, 69(r8)
			#movia r9, LASER
			#stb r9, 0(r8)
			movia r9, 0xFFFFFFF
			lop:
			subi r9, r9, 1
			bne r9, r0, lop
			movia r9, WIN_FLAG
			movia r10, 0
			stb r10, 0(r9)
			movia r8, ADDR_VGA_CHAR
			br _start
			
		
	change_direction:
		addi r9, r0, 0
		stw r9, 4(r8)#reste movement counter
		
		ldw r8, 0(r8) #then finally load the the flag to check if we move left or move right
		beq r8, r0, change_to_left
		
		#otherwise it's r8=1 atm
		movia r8, UFO_RL
		addi r14, r0, 0
		stw r14, 0(r8)
		
		br move_down
		
		change_to_left:
			#we're gonna set it to 1
			movia r8, UFO_RL
			addi r14, r0, 1
			stw r14, 0(r8)
			br move_down

User_lasers:
	#code for checking user's lasers
	
	#r8 is the updated laser address
	#r9 is the laser counter loop
	#r10 is the hardcoded number of ufos in the array, 4atm
	#r11 is the loop variable
	#r12 is the temp load value
	#r13 is the laser Laser char
	
	#r15 handles sp location
	
	#r16 is the ufo stuff r8
	#r17 is the Laser stuff r9
	#r18 is the ufo counter r10 

	
	movia r16, UFO

	
	#clears current laser location
	movia r17, LASER_loc
	ldw r8, 0(r17)
	beq r8, r0, skip # his is used to ignroe the initial non existance of the laser
	stb r0, 0(r8) 
	
	#moves laser location up 1
	addi r8, r8, 0b0000010000000
	
	movia r13, LASER
	stb r13, 0(r8)
	stwio r8, 0(r17)
	
	#check if collision
	addi r10, r0, 27
	addi r9, r0, 0
	
	subi r16, r16, 4
	Check_collision:
		#loop through num items in ufo array
		#use r12 as temp load value
		
		addi r16, r16, 4
		
		ldw r12, 0(r16)
		#push ra
		beq r12, r8, time_to_call #it will skip the next few lines if theres no collision #change to call Check_collision
		
		addi r9, r9, 1
		bne r9, r10, Check_collision 
		
	br UL_ret #no collision
		
	time_to_call:
		add r15, sp, r0 #we're gonna push the return address onto the stack
		subi sp, sp, 32 #it's 32 because we're also going to save the previous sp location
		stw r15, 0(sp)
		stw ra, 4(sp)
		stw r8, 8(sp)
		stw r9, 12(sp)
		stw r10, 16(sp)
		stw r11, 20(sp)
		stw r12, 24(sp)
		stw r13, 28(sp)
		
		add r4, r0, r9 #ufo number
		call Handle_collision_user
		
		ldw r13, 32(sp)
		ldw r12, 24(sp)
		ldw r11, 20(sp)
		ldw r10, 16(sp)
		ldw r9, 12(sp)
		ldw r8, 8(sp)
		ldw ra, 4(sp)
		ldw r15, 0(sp) #load sp back into the potentially modified r15(since it's caller saved)
		add sp, r15, r0 #now put the original sp value back as the sp
		#pop ra
	
	br UL_ret 
	
	UL_ret:
	

	
	skip:
	ret
	
	

Handle_collision_user:
	#code for handling a user's laser hitting a ufo
	#r4 is the ufo number in the array
	#r8 has the VGA address
	#r9 has the LASER address
	
	#r16 is the ufo stuff r8
	#r17 is the Laser stuff r9
	#r18 is the ufo counter r10 


	#for now if a collision occurs, draw a laser at the top right of screen
	
	movia r16, UFO 
	addi r5, r0, 26
	beq r4, r5, game_win
	muli r4, r4, 4
	add r16, r16, r4
	
	stw r0, 0(r16) #done with that ufo
	
	movia r4, UFO_count
	ldw r5, 0(r4) 
	subi r5, r5, 1 
	stw r5, 0(r4) #reduced count
	
	movia r8, LASER_loc
	ldw r8, 0(r8)
	addi r9, r0, 0
	stb r9, 0(r8) #disable laser's visual
	movia r8, LASER_loc
	stwio r9, 0(r8) #disables actual laser
	
	makesound11: #make sound for when the player hits an enemy
		movia r11, 500
		movia r20, ADDR_AUDIO
		sound11:
		movia r3, 0xdddddddd
		stwio r3, 8(r20)      /*write to left buffer AKA left fifo*/
		stwio r3, 12(r20)     /*write to right buffer AKA right fifo*/
		subi r11, r11, 1
		beq r11, r0, makesound22
		br sound11

		makesound22:
		movia r11, 500
		sound22:
		movia r3, 0x00000000
		stwio r3, 8(r20)      /*write to left buffer AKA left fifo*/
		stwio r3, 12(r20)     /*write to right buffer AKA right fifo*/
		subi r11, r11, 1
		bne r11, r0, sound22
		
		movia r8, ADDR_VGA_CHAR
		ldb r11, 69(r8)
		movia r20, 0x39
		beq r20, r11, ADD_TENS:
		addi r11, r11, 1
		stb r11, 69(r8)
		br DONE_SCORE
		ADD_TENS:
		movia r20, 0x30
		stb r20, 69(r8)
		ldb r11, 68(r8)
		addi r11, r11, 1
		stb r11, 68(r8)
		DONE_SCORE:
	
	bne r5, r0, HCU_end
	
	game_win:
	movia r8, ADDR_VGA_CHAR
	movia r9, LASER
	#stb r9, 0(r8) #just to indicate the game is over
	addi r8, r8, 0b0000010000000
	
	movia r15, 0x554F59 #string for YOU_
	stwio r15, 64(r8)
	movia r15, 0x214E4957 #string for WIN!
	stwio r15, 68(r8)
	movia r9, 0xFFFFFFF
	lop2:
	subi r9, r9, 1
	bne r9, r0, lop2
	
	movia r9, WIN_FLAG
	movia r10, 1
	stb r10, 0(r9)
	
	br _start
	HCU_end:
	ret
	
.section .exceptions, "ax"

IHANDLER:
	#r18 is the temp variable for holding stack location
	
	rdctl et, ipending
	#andi r9, et, 0b1 #whatever amount of zeros for timer interrupt
	#addi r9, r9, 1
	
	movia r3, laser_Delay
	ldw r4, 0(r3)
	
	beq r4, r0, Continue_IH
	#br Continue_IH
	
	dec_delay:
	subi r4, r4, 1
	stw r4, 0(r3)
	
	Continue_IH:
	
	movia r18, Stack_loop
	ldw r18, 0(r18)
	stw sp, 0(r18)
	stw ea, 4(r18)
	stw r8, 8(r18)
	stw r9, 12(r18)
	stw r10, 16(r18)
	stw r11, 20(r18)
	stw r12, 24(r18)
	stw r13, 28(r18)
	stw r14, 32(r18)
	stw r15, 36(r18)
	stw r16, 40(r18)
	stw r17, 44(r18)
	stw r18, 48(r18)
	stw r19, 52(r18)
	stw r20, 56(r18)
	stw r21, 60(r18)
	stw r22, 64(r18)
	stw r23, 68(r18)
	
	movia r18, Stack_game
	ldw r18, 0(r18)
	ldw sp, 0(r18)
	ldw ea, 4(r18)
	ldw r8, 8(r18)
	ldw r9, 12(r18)
	ldw r10, 16(r18)
	ldw r11, 20(r18)
	ldw r12, 24(r18)
	ldw r13, 28(r18)
	ldw r14, 32(r18)
	ldw r15, 36(r18)
	ldw r16, 40(r18)
	ldw r17, 44(r18)
	ldw r18, 48(r18)
	ldw r19, 52(r18)
	ldw r20, 56(r18)
	ldw r21, 60(r18)
	ldw r22, 64(r18)
	ldw r23, 68(r18)
		
	

	call GameLoop
	
	movia r18, Stack_game
	ldw r18, 0(r18)
	stw sp, 0(r18)
	stw ea, 4(r18)
	stw r8, 8(r18)
	stw r9, 12(r18)
	stw r10, 16(r18)
	stw r11, 20(r18)
	stw r12, 24(r18)
	stw r13, 28(r18)
	stw r14, 32(r18)
	stw r15, 36(r18)
	stw r16, 40(r18)
	stw r17, 44(r18)
	stw r18, 48(r18)
	stw r19, 52(r18)
	stw r20, 56(r18)
	stw r21, 60(r18)
	stw r22, 64(r18)
	stw r23, 68(r18)
	
	movia r18, Stack_loop
	ldw r18, 0(r18)
	ldw sp, 0(r18)
	ldw ea, 4(r18)
	ldw r8, 8(r18)
	ldw r9, 12(r18)
	ldw r10, 16(r18)
	ldw r11, 20(r18)
	ldw r12, 24(r18)
	ldw r13, 28(r18)
	ldw r14, 32(r18)
	ldw r15, 36(r18)
	ldw r16, 40(r18)
	ldw r17, 44(r18)
	ldw r18, 48(r18)
	ldw r19, 52(r18)
	ldw r20, 56(r18)
	ldw r21, 60(r18)
	ldw r22, 64(r18)
	ldw r23, 68(r18)
	
	#stb r0, 0(r8)
	#addi r8, r8, 0b0000010000000
	#movia LETTER_A, 
	
	#ldb r10, 0(r8) #checking if colission
	
	#stb r9, 0(r8)
	
	movia r17, ADDR_TIMR #load timer's address
	stwio r0, 0(r17)
	movui r16, 0b101
	stwio r16, 4(r17)	
	
	subi ea, ea, 4
	eret #return to sensor location
