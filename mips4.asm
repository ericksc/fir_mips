# Valores previamente almacenados en registros
# r1 Valor de numtaps
# r2 Valor de sampleidx
# r3 Dirección base de in
# r4 Dirección base de out
# r5 Dirección base de firtaps

fir:
	  .data
in:	  .space  48			# suponer arreglo de 10 + 2 condiciones iniciales = 12. 12 * 4 = 48
out:	  .space  40			# suponer arreglo de 10  condiciones iniciales = 10. 10 * 4 = 40
firtaps:  .space  12			# suponer arreglo de 3  firtaps 3 * 4 = 12

	.text
__start:
					# inicializando arreglo in
	la	$t0,	in		# "r3" Dirección base de in
	li	$s2, 	1
	sw 	$s2, 	4($t0)		#  inicializando algunos valores del arreglo IN
	sw 	$s2, 	8($t0)		
	sw 	$s2, 	12($t0)
					# inicializando arreglo out
	la	$t2, 	out		# "r4" Dirección base de out

					# inicializando arreglo firtaps
	la	$t1, 	firtaps		# "r5" Dirección base de firtaps
	li 	$s2, 	1
	sw 	$s2, 	($t1)
	li 	$s2, 	-2
	sw 	$s2, 	4($t1)
	li 	$s2, 	-3
	sw 	$s2, 	8($t1)
					# inicializando numtaps
	li 	$s0, 	3	        # "r1" numtaps

	li 	$s1, 	0	        # "r2" sampleidx					
	li 	$t4, 	0            	# $t3 sea outval = 0. inicialmente
	li 	$t3, 	0            	# $t4 sea tapidx = 0. inicialmente
	li 	$t5, 	6            	# $t5 sea size = 6.	

############################################################################################################
# Terminando inicialización de
# Arreglos en Memoria
# Nombre			MIPS (simulador)	Supuesto procesador (set de instrucciones propuesto)		
# Valor de numtaps		$s0			r1
# Valor de sampleidx		r2
# Dirección base de in		r3
# Dirección base de out		r4 
# Dirección base de firtaps	r5 
						
#############################################################################################################
	
$L4:
        # tapidx<numtaps
        slt     $s2,	$t3,	$s0  	# $s2 <- cmpgt($t2,$s0)
        beq     $s2,	$0,	$L3	# bcond($s2, $L3)
        
        # sampleidx + tapidx      
        addu 	$s2, 	$s1 , 	$t3	# $s1 <- add($s1 , $t3)
        
        li 	$s4, 	4		# $s4 <- movi(4)
        mul 	$s2, 	$s2, 	$s4	# $s2 <- mul($s2, $s4)

        addu    $s2,	$t0,	$s2     # $s2 <- add($t0 , $s2)
        lw      $s3,	0($s2)		# $s3 <- idi($s2)
        
        li 	$s4, 	4		# $s4 <- movi(4)
        mul 	$s2, 	$t3, 	$s4	# $s2 <- mul($t3, $s4)

        addu    $s4,	$t1,	$s2	# $s2 <- add($t0 , $s2)
        lw      $s2,	0($s4)		# $s2 <- idi($s4)
        
        mul  	$s2,  	$s2, 	$s3	# $s2 <- mul($s2, $s3)
        add 	$t4, 	$t4, 	$s2	# $t4 <- add($t4 , $s2)

	li 	$s4, 	1		# $s4 <- movi(1)
	add 	$t3, 	$t3 ,	$s4	# $t3 <- add($t3 , $s4)
        b       $L4			# branch ($L4)

$L3:
        li 	$s4, 	4		# $s4 <- movi(4)
        mul 	$s2, 	$s1, 	$s4	# $s2 <- mul($s1, $s4)

        addu    $s2,	$t2,	$s2	# $s2 <- add($t2 , $s2)
        sw      $t4,	0($s2)		# sti($s2, $t4)
