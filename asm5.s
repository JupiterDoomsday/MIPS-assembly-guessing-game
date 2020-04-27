# AUTHOR: ISABELA HUTCHINGS
# PROJECT: ASM 5 -- GUESSING GAME
# GOAL: This project simulates an guessing game
.data 
TOP_BORDER: .asciiz "# ----------- round "
TOP_BORDER_PART2: .asciiz " ----------- #\n"
BOT_BORDER: .asciiz "# ----------------------------- #\n"
TAB: .asciiz "\t"
SPACE: .asciiz "  "
MSG_1: .asciiz "Set the min range of the random number\n"
MSG_2: .asciiz "Set the max range of the random number\n"
MSG_LOW: .asciiz "guess is too low\n"
MSG_HI: .asciiz "guess is too high\n"
MSG_OT: .asciiz "guess is out of range\n"
MSG: .asciiz "Guess a number\n"
MIN: .asciiz "  min: "
MAX: .asciiz "  max: "
QUIT_ROUND: .asciiz "QUITING THIS ROUND... \n"
PREV: .asciiz "  guesses:\n"
ANSWER: .asciiz "The random number is : "
ERROR_MSG_1: .asciiz "ERROR: input must be an int"
ERROR_MSG_2: .asciiz "  ERROR: input must be larger than "
HINT: .asciiz "Do you want to quit?"
NEWLINE: .asciiz "\n"
CONGRATS: .asciiz "  CONGRATS YOU HAVE SUCCESSFULLY GUESSED THE NUMBER :\n"
EPILOUGE_MSG: .asciiz  "  Number of guesses it took: "
QUESTION: .asciiz  "Play again?\n"
.text
.globl	main
main: # main()
    addi $t6, $zero,1                       # t5 = 1 t5 is the round counter
RESTART:    
                      
    addi $v0,$zero,4                        # print out the TOP_BORDER
    la $a0, TOP_BORDER
    syscall
    addi $v0,$zero,1                        # print out t5
    add $a0,$t6,$zero
    syscall
    addi $v0,$zero,4
    la $a0,TOP_BORDER_PART2                 # print out string TOP_BORDER_PART2
    syscall
    la $a0, NEWLINE                         # print "\n"
    syscall

INPUT_LOOP_1:  				# this is a while loop that will take an input form the user to set the minimum range
    addi $v0,$zero,51 						# set syscall to ask user input to read an integer
    la $a0,MSG_1      						# set text message for pop up
    syscall
    beq $a1,$zero,AFTER_LOOP_1  			# if input is not an int print out error message and ask for input again
    addi $v0,$zero,55                       # print out error message that input was not valid
    la $a0,ERROR_MSG_1
    syscall
    j INPUT_LOOP_1                          # loop back
AFTER_LOOP_1:
    add $s0, $zero,$a0   					# s0 = a0 = min
    addi $v0, $zero,4    					# set output to read string
    la $a0,MIN
    syscall              					# print out min
    addi $v0, $zero,1
    add $a0,$zero,$s0
    syscall
    addi $v0,$zero,4     					# print "\n"
    la $a0,NEWLINE
    syscall
    
INPUT_LOOP_2:  				    # this is a while loop that will take the second input form the user to set the maximum range
    addi $v0,$zero,51 			 			 	# set input to read integer from stdin
    la, $a0,MSG_2               			 	# set text box msg to MSG_2
    syscall 									# ask the user for input
    bne $a1,$zero,ERROR_1       				# if (a1 == 0) goto ERROR_1
    slt $t0,$s0,$a0                             # t0 = min < a0
    bne $t0,$zero,AFTER_LOOP_2 					# if (t0 != 0) exit INPUT_LOOP_2
ERROR_2:
    addi $v0,$zero,4                  			# Print out error
    la $a0,ERROR_MSG_2
    syscall
    addi $v0,$zero,1                            # set syscall to print out ints
    add $a0,$s0,$zero                           # print out the min values
    syscall
    addi $v0,$zero,4                            # set syscal to print out string
    la $a0,NEWLINE                              # print "\n"
    syscall
    j INPUT_LOOP_2                              # jump back to the beginging of the loop
ERROR_1:
    addi $v0,$zero,4                            # set syscall to print out string
    la $a0,ERROR_MSG_1 							# print ERROR_MSG_1
    syscall
    j INPUT_LOOP_2  							# jump back to loop
AFTER_LOOP_2:
    add $s1, $zero,$a0   						# s1 = max
    addi $v0, $zero,4							#sey syscall to print out string
    la $a0,MAX
    syscall
    addi $v0, $zero,1
    add $a0,$zero,$s1    						# print out max
    syscall
    addi $v0,$zero,4                         
    la $a0,NEWLINE                              # print "\n"
    syscall										# print "\n"
    syscall
    la $a0,PREV									# print out string "GUESS:""
    syscall
    addi $v0,$zero,42                           # set syscall to generate a random number
    add $a0,$s0,$zero 							# a0 = min
    add $a1,$s1,$zero                           # a1 = max
    syscall                                     # generate the random number
    add $s2,$a0,$zero							# s2 = Math.random(s0,s1)
    addi $t0,$zero,1                            # t0 = 0
    addi $t1,$zero,9                           	# t1 = 11
    add $t3,$zero,$zero                         # t3 = 0 

GUESS_LOOP:		# this is a while loop that continues to ask for player input until the right guess
    slt $t2, $t3,$t1                            # t2 = t3 < 11
    bne $t2,$zero,GUESS                         # (t2 == 0) goto GUESS
    add $t3,$zero,$zero							# t3 = 0
    addi $v0,$zero,50							# set syscall to ConfirmDialog pop-up
    la $a0,HINT									# set the pop-up message to HINT
    syscall										# trigger the ConfrimDialouge syscall
    beq $a0,$zero,SHOW_ANSWER					# if(a0 == 0) goto SHOW _ANSWER
    GUESS:
        addi $v0,$zero,51 						# set input to read integer from stdin
        la $a0,MSG         						# set text box message to MSG
        syscall                                 # ask the player for input
        bne $a1,$zero,GUESS_ERROR_1             #if (a1 != 0) goto GUESS_ERROR_1
        beq $a0,$s2,EXIT_GUESS_LOOP             # if (a0 == s2) exit the loop
        add $t4,$a0,$zero                       # t4 = a0          
        slt $t2,$a0,$s2                         # t2 = a0 < max
        beq $t2,$zero,GUESS_ERROR_3             # if (t2 == 0) goto GUESS_ERROR_3 
        
        GUESS_ERROR_2:                         # this branch prints out a message when the guess is too low
            addi $v0,$zero,55
            la $a0,MSG_LOW
            syscall
            j AFTER
        GUESS_ERROR_3:                         # this branch prints out a mesage when the guess is too high
            addi $v0,$zero,55
            la $a0,MSG_HI
            syscall
            j AFTER
        GUESS_ERROR_1:                         # this branch prints outa message if the input is not valid
            addi $v0,$zero,55
            la $a0,ERROR_MSG_1
            syscall
        AFTER:
            addi $v0,$zero,4                    # set syscall to print string
            la $a0,TAB                          # print "\t"
            syscall
            addi $v0,$zero,1                    # set syscall to print int
            add $a0,$zero,$t4                   # print t4 = users guess
            syscall
            addi $v0,$zero,4                    # set syscall to printout string
            la $a0,NEWLINE                      # print "\n"
            syscall
            addi $t0,$t0,1        				# t0++
            addi $t3,$t3,1                      # t3++
            j GUESS_LOOP
SHOW_ANSWER:			# this branch is triggered if the user quites guessing after every 10 guesses              
    addi $v0, $zero,4                           # set syscall to print out string
    la $a0,QUIT_ROUND                           # print out QUIT_ROUND
    syscall
    la $a0,ANSWER                               # print string ANSWER
    syscall
    addi $v0,$zero,1                            # set syscall to print int
    add $a0,$zero,$s2                           # print out s2
    syscall
    addi $v0, $zero,4                           # set syscall to print out string
    la $a0,NEWLINE                              # print "\n"
    syscall
    j TRY_AGAIN                                 # ask the player if they want to retry

EXIT_GUESS_LOOP: 		# this branch is triggered when you exit the loop after a correct guess
    addi $v0,$zero,4 					# set input to read an string
    la $a0,NEWLINE
    syscall 							# print "\n"
    la $a0, CONGRATS					# print out the CONRATS message
    syscall
    addi $v0,$zero,1					# set syscall to print out ints
    add $a0,$zero,$s2 					# print out the randomly generated number
    syscall
    addi $v0,$zero,4 					# set syscall to print out strings
    la $a0,NEWLINE 						# print out "\n"
    syscall
    syscall
    la $a0, EPILOUGE_MSG 				# print out
    syscall
    la $a0,SPACE                                        # print "  "
    syscall	
    addi $v0,$zero,1 					# set input to read an integer
    add $a0,$t0,$zero
    syscall
    addi $v0,$zero,4 					# set input to read an string
    la $a0,NEWLINE                                      # print "\n"
    syscall
TRY_AGAIN: 								# this branch asks the player they want to retry
    addi $t6,$t6,1               		# increment the round counter
    addi $v0,$zero,4					# set the border for the proper output
    la $a0, NEWLINE                     # print "\n"
    syscall
    la $a0, BOT_BORDER                  # print out the bottom border to stdout
    syscall
    la $a0,NEWLINE                      # print "\n"
    syscall
    addi $v0,$zero,50					# set the syscall to take a dialouge confirmation of YES or NO
    la $a0,QUESTION						# set the texxt message of the pop-up to QUESTION
    syscall								# syscall the confirmation Dialouge box
    beq $a0,$zero,RESTART				# if (output = 0) goto RESTART

EXIT:									# this branch exits the function
    addi    $v0, $zero,10 				# set to exit function
    syscall
