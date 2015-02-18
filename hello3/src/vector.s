    .syntax unified
    .thumb

    .global _init
    .equ STACK_TOP, 0x20008000

    @ Entries in vector table need to be marked
    @ as thumb function. This sets the last bit
    @ of the function address to 1 which is needed
    @ for a processor running Thumb mode.
    .type nmi, %function
    .type hard_fault, %function
    .type mem_fault, %function
    .type bus_fault, %function
    .type usage_fault, %function

    @ Vector table.
    .section .vector
    .word STACK_TOP
    .word _init
    .word nmi
    .word hard_fault
    .word mem_fault
    .word bus_fault
    .word usage_fault
    
    .word usage_fault
    .word usage_fault
    .word usage_fault
    .word usage_fault
    .word usage_fault
    .word usage_fault
    .word usage_fault
    .word usage_fault
    .word usage_fault
    .word usage_fault
    .word usage_fault
    .word usage_fault
    .word usage_fault
    .word usage_fault
    .word usage_fault

    .text

    @ Vector table entries. Infinite loop
    @ for debugging.
nmi:
    b nmi
hard_fault:
    b hard_fault
mem_fault:
    b mem_fault
bus_fault:
    b bus_fault
usage_fault:
    b usage_fault
    
    .end
