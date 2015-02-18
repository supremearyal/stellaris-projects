    @ addresses
    .equ STACK_TOP, 0x20008000
    .equ BB_RCGCGPIO_PORTF, 0x43fCC114
    .equ BB_PORT_F_PIN_1_DIR, 0x424A8004
    .equ BB_PORT_F_PIN_1_DEN, 0x424AA384
    .equ BB_PORT_F_PIN_1_DATA, 0x424A7f84

    @ code
    .text
    .syntax unified
    .thumb
    .global _start
    .type start, %function

    @ vector table
_start:
    .word STACK_TOP, start
start:
    mov r1, #1
    ldr r0, =BB_RCGCGPIO_PORTF
    str r1, [r0]
    ldr r0, =BB_PORT_F_PIN_1_DIR
    str r1, [r0]
    ldr r0, =BB_PORT_F_PIN_1_DEN
    str r1, [r0]
    ldr r0, =BB_PORT_F_PIN_1_DATA
    str r1, [r0]

    @ loop forever
done:
    b done
    .end
