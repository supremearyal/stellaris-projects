#!/bin/bash
arm-none-eabi-as -mcpu=cortex-m4 -mthumb hello.s -o hello.o
arm-none-eabi-ld -Ttext 0x0 -o hello.out hello.o
arm-none-eabi-objcopy -Obinary hello.out hello.bin
lm4flash hello.bin
