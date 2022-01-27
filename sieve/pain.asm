.data

space: .asciiz " "

.globl main

.text

### Register Legend
#
# $a0 - Syscall
# $v0 - Opcodes
##
# $s0 - 0x00000000 (0)
# $s1 - 0x11111111 (286331153)
# $s2 - Bottom of stack
# $s3 - Numbers of integers (1000)
##
# $t0 - Counter
# $t1 - Prime squared
# $t2 - Temporary stack address storage
# $t3 - Storage length variable

## Load in values in register
main: 
  li    $v0,    5               # Get integer from user
  syscall       

  slti  $t0,    $v0,    1001
  beq   $t0,    $zero,  main
  nop

  slti  $t0,    $v0,    1
  beq   $t0,    $zero,  main
  nop

  li    $s0,    0x00000000
  li    $s1,    0x11111111
  add   $s2,    $sp,    0       # Store bottom stack address
  li    $s3,    1000    
  move  $t0,    $v0             # Set counter to 2
  
  jal		init
  
  li	$v0,	10				# Exit program (code 10)
  syscall						# Call system

## Initialize program loop, I think
init:
  sw    $s1,    ($sp)           # Store value in stack
  add   $t0,    $t0     1       # Increase counter with 1
  sub   $sp,    $sp,    4       # Move 4 bytes up in stack
  ble   $t0,    $s3     init    # Branch while counter is under 1000
  
  li    $t0,    1

outer:
  add   $t0,    $t0,    1		# Increase counter by 1
  mul   $t1,    $t0,    $t0
  bgt   $t1,    $s3,    reset   # Print primes if counter is larger than $s3 (1000)

check:
  move  $t2,    $s2				# Store bottom stack address to be modified
  mul   $t3,    $t0,    4		# Get already used up storage
  sub   $t2,    $t2,    $t3		# Move up in stack to free memory
  add   $t2,    $t2,    8		# Add 2 words
  lw    $t3,    ($t2)			# Store $t2 into register
  beq   $t3,    $s0,    outer	# If value is 0, jump back to outer

inner:
  move  $t2,    $s2				# Store bottom stack address to be modified
  mul   $t3,    $t1,    4		# Get already used up memory
  sub   $t2,    $t2,    $t3		# Move up in stack to available memory
  add   $t2,    $t2,    8		# Add 2 words
  sw    $s0,    ($t2)			# Store $t2 into register
  add   $t1,    $t1,    $t0		# Repeat for all multiples of number
  bgt   $t1,    $s3,    outer	# Jump to outer when all multiples have been done
  j     inner					# Else, repeat for rest of multiples

reset:
  li    $t0,    1				# Reset counter

count:	
  add	$t0, 	$t0, 	1		# Increase counter by 1
  bgt	$t0, 	$s3, 	exit	# When all numbers been checked, exit
  move	$t2, 	$s2				# Store bottom of stack to be modified
  mul	$t3, 	$t0, 	4		# Ge already used up memory
  sub	$t2, 	$t2, 	$t3		# Move up in stack to available memory
  add	$t2, 	$t2, 	8		# Add 2 words
  lw	$t3, 	($t2)			# Store $t2 into register
  
  beq	$t3, 	$s0, 	count	# Jump to count label if values is 0
  move	$t3, 	$s2				# Store bottom of stack to be modified
  sub	$t3, 	$t3, 	$t2		# Move up in stack to available memory
  div	$t3, 	$t3, 	4		# Get amount of primes
  add	$t3, 	$t3, 	2		# Add last prime
  li	$v0, 	1				# Print integer
  move	$a0, 	$t3				# Print prime
  syscall						# Call system function
  li	$v0, 	4				# Print prime as string
  la	$a0, 	space			# Print space between each prime
  syscall						# Call system function
  ble   $t0,    $s3,    count	# Do for all primes in 1000.

exit:  
  jr    $ra						# Return / exit

