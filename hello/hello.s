	.equ STACK_TOP,     0x20008000
	.equ PORT_F_ENABLE, 0x400fe108
	.equ PORT_F_DIR,    0x40025400
	.equ PORT_F_DEN,    0x4002551c
	.equ PORT_F_DATA,   0x400253fc
	.equ DELAY_COUNT,   40000000
	.equ CLOCK_CONFIG2, 0x400fe070
	.equ CLOCK_CONF,    0xc1000010
	.text
	.syntax unified
	.thumb
	.global _start
	.type start, %function
_start:
	.word STACK_TOP, start
start:
	/* set clock to 80 mhz */
	/* SYSDIV2=0x02, SYSDIV2LSB=0, Divisor=5, DIV400=1, BYPASS2=0 */
	ldr r0, =CLOCK_CONFIG2
	ldr r1, =CLOCK_CONF
	str r1, [r0]

	/* enable port F */
	ldr r0, =PORT_F_ENABLE
	mov r1, #0x20
	str r1, [r0]

	/* wait for clock to be set */
	nop
	nop
	nop

	/* set port f, pins 1, 2, 3 to output */
	mov r1, #0x0e
	ldr r0, =PORT_F_DIR
	str r1, [r0]

	/* enable digital for port f, pin 1, 2, 3 */
	ldr r0, =PORT_F_DEN
	str r1, [r0]

	/* toggle port f, pin 1, 2, 3 output value */
blink:
	ldr r0, =PORT_F_DATA
	ldr r1, [r0]
	eor r1, r1, #0x0e
	str r1, [r0]

	/* delay for a bit and clear led
	 * each delay loop is 2 cycles */
	ldr r2, =DELAY_COUNT
loop:
	subs r2, r2, #1
	bne loop
	b blink

	/* never gets here, but loop forever */
done:
	b done
	.end
