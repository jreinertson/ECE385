/*********
 * 
 * Write the assembly function:
 *     printn ( char * , ... ) ;
 * Use the following C functions:
 *     printHex ( int ) ;
 *     printOct ( int ) ;
 *     printDec ( int ) ;
 * 
 * Note that 'a' is a valid integer, so movi r2, 'a' is valid, and you dont need to look up ASCII values.
 *********/

.global	printn
printn:
addi sp,sp, -16 #make space for arguments in registers in stack
stw ra, 0(sp) #store ra on top of stack
stw r5, 4(sp) #store r5 on stack
stw r6, 8(sp) # store r6....
stw r7, 12(sp)#store r7....
#///////////////
mov r16, r4 #character pointer
ldb r17, 0(r16) #load first character
movi r19, 'H'
movi r20, 'D'
movi r21, 'O'


MLOOP:
beq r17, r0, END #if character is null terminator, exit
ldw r4, 4(sp) #load next number off stack
ldw r18, 0(sp) #load ra of stack
stw r18, 4(sp) #put ra back on stack in new pos
addi sp, sp, 4 #increment sp


beq r17, r19, HEX #branches to go to the H, O, or D calls
beq r17, r20, DEC
beq r17, r21, OCT
br END
#//////////////////
HEX:
call printHex
addi r16, r16, 1 #increment character pointer
ldb r17, 0(r16) #load next character
br MLOOP

#//////////////////
DEC:
call printDec
addi r16, r16, 1 
ldb r17, 0(r16) #load next character
br MLOOP

#////////////////////
OCT:
call printOct
addi r16, r16, 1
ldb r17, 0(r16) #load next character
br MLOOP


#///////////////
END:
mov r2, r0
ldw ra, 4(sp) #load RA from stack
addi sp,sp,4 #increment sp
    ret


