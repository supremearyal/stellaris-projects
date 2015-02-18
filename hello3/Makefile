TOOL_PREFIX := arm-none-eabi
AS := $(TOOL_PREFIX)-as
CC := $(TOOL_PREFIX)-gcc
LD := $(TOOL_PREFIX)-ld
OBJCOPY := $(TOOL_PREFIX)-objcopy
OBJDUMP := $(TOOL_PREFIX)-objdump
FLASH_TOOL = lm4flash

TARGET = hello

SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

LINKER_FILE := $(SRC_DIR)/linker.ld

BINARY_ELF := $(BIN_DIR)/$(TARGET).elf
BINARY := $(BIN_DIR)/$(TARGET).bin

SSRCS := $(wildcard $(SRC_DIR)/*.s)
CSRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(SSRCS:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.o)
OBJS += $(CSRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

AS_FLAGS := -mcpu=cortex-m4 -mthumb
CFLAGS := -mcpu=cortex-m4
CFLAGS += -mthumb
CFLAGS += -std=c99
CFLAGS += -g
CFLAGS += -Os
OBJCOPY_FLAGS := -O binary

all : $(BINARY)

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	$(AS) $(AS_FLAGS) $< -o $@

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BINARY_ELF) : $(OBJS)
	@mkdir -p $(dir $@)
	cd $(OBJ_DIR) && $(LD) -T ../$(LINKER_FILE) *.o -o ../$@

$(BINARY) : $(BINARY_ELF)
	@mkdir -p $(dir $@)
	$(OBJCOPY) $(OBJCOPY_FLAGS) $< $@

flash : $(BINARY)
	$(FLASH_TOOL) $(BINARY)

clean :
	rm -f $(OBJS) $(BINARY_ELF) $(BINARY)

distclean : clean
	rm -rf $(BIN_DIR) $(OBJ_DIR)

.PHONY : all flash clean distclean
