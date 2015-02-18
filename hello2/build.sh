#!/bin/bash
arm-none-eabi-as -mcpu=cortex-m4 hello.s -o hello.o
arm-none-eabi-ld -Ttext 0x0 -o hello.axf hello.o
arm-none-eabi-objcopy -O binary hello.axf hello.bin
lm4flash hello.bin
