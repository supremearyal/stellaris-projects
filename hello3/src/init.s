    .syntax unified
    .thumb

    .global _init

    .type _init, %function

    .section .init

    @ Initialization code that runs before main.
_init:
    
    @ Copy data section.
    ldr r0, =_etext
    ldr r1, =_bdata
    ldr r2, =_edata

copy_data:
    cmp r1, r2
    beq copy_data_done
    ldrb r3, [r0], #1
    strb r3, [r1], #1
    b copy_data
copy_data_done:

    @ Initialize bss section with zero.
    ldr r0, =_bbss
    ldr r1, =_ebss
    mov r2, #0

copy_bss:
    cmp r0, r1
    beq copy_bss_done
    strb r2, [r0], #1
    b copy_bss
copy_bss_done:

    @ Branch to main. Don't need to
    @ call as function since we don't
    @ expect to return from main.
    b main
    
    .end
