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

main: 
	move	$s0,	$0				# 
	move	$s1,	$sp				# Save bottom stack position
	li		$t0,	2				# Start at 2
	li		$a0,	1000			# Get prime nubmers smaller than 1000
	
	jal		loop					# Jump to init and link value
	
	li 		$v0,	10
	syscall
	
loop:
	add		$t0,	$t0,	1		# Increase counter with 1
	sub		$sp,	$sp,	4		# Move up in stack by 4 bytes
	ble		$t0,	$a0,	exit
	
	li		$t0,	0
	
outer:
	
exit:
	jr		$ra