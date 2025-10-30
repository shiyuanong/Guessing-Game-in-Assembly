.data
initial_prompt:  .asciiz "Guess a number between 1 and 20: "
error_prompt:    .asciiz "Invalid guess. Please enter a number between 1 and 20: "
wrong_prompt:    .asciiz "Wrong guess. Try again: "
success_msg:     .asciiz "Correct! You guessed the number.\n"

.text
main:
    # Generate random number 1-20
    li $v0, 42        # Syscall 42: Random integer range
    li $a1, 20        # Upper bound (exclusive)
    syscall           # Result in $a0 (0-19)
    addi $s0, $a0, 1  # Store target number (1-20) in $s0

    # Print initial prompt
    li $v0, 4
    la $a0, initial_prompt
    syscall

game_loop:
    # Read integer input
    li $v0, 5
    syscall
    move $t0, $v0     # Store guess in $t0

    # Validate input range
    li $t1, 1          # Load lower bound
    li $t2, 20         # Load upper bound
    blt $t0, $t1, invalid_input  # Compare with register
    bgt $t0, $t2, invalid_input  # Compare with register


    # Check guess
    beq $t0, $s0, correct_guess

    # Handle wrong guess
    li $v0, 4
    la $a0, wrong_prompt
    syscall
    j game_loop

invalid_input:
    li $v0, 4
    la $a0, error_prompt
    syscall
    j game_loop

correct_guess:
    li $v0, 4
    la $a0, success_msg
    syscall

    # Exit program
    li $v0, 10
    syscall
