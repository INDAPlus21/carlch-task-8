# int multiply(int a, int b) {
# 		int i, sum = 0;
# 		for (i = 0; i < a; i++)
#       	sum += b;
#	 	return sum;
#	}


.macro PUSH(%reg)
	addi 	$sp,$sp,-4
	sw 		%reg,0($sp)
.end_macro

.macro POP(%reg)
	lw 		%reg,0($sp)
	addi 	$sp,$sp,4
.end_macro

.text
main:
	li $a0, 3
	li $a1, 7
	jal multiply
	move $s7,$v0
	
	li $a0, 5
	jal faculty
	move $s6,$v0
	
	li $v0,10
	syscall
	
	
multiply:
	PUSH($s0)
	PUSH($s1)
	move	$s0,$a0
	move 	$s1,$a1
	li 		$t0,0
	li		$v0,0
	
	m_loop:
		beq		$t0,$s0,m_end
		add 	$v0,$v0,$s1
		addi	$t0,$t0,1
		j		m_loop
	
	m_end:
		POP($s1)
		POP($s0)
		jr $ra	
		
faculty:
	PUSH($ra)
	PUSH($s0)
	PUSH($s1)s
	move	$s0,$a0
	li		$s1,1
	
	f_loop:
		beq		$s0,$zero,f_end
		move	$a0,$s0
		move	$a1,$s1
		jal 	multiply
		move	$s1,$v0
		addi	$s0,$s0,-1
		j		f_loop
		
	f_end:
		POP($s1)
		POP($s0)
		POP($ra)
		jr $ra
