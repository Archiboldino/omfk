include user_vars.mk

CC                      := $(CROSS_TOOL)gcc
LD                      := $(CROSS_TOOL)ld
OC                      := $(CROSS_TOOL)objcopy
OD                      := $(CROSS_TOOL)objdump

SCRIPT_DIR              := scripts
BUILD_DIR               := build

TARGET                  := omfk
TARGET_BINARY           := $(BUILD_DIR)/$(TARGET).bin
TARGET_MAP              := $(BUILD_DIR)/$(TARGET).map
TARGET_DUMP             := $(BUILD_DIR)/$(TARGET).dump

SERIAL_COMMUNICATION    := minicom -o -D

FLASH_TOOL              := st-flash

CORE_INC_DIR            := arch/$(ARCH)/$(CORE)

PLATFORM_DIR            := platform/$(PLATFORM)
PLATFORM_INC_DIR        := $(PLATFORM_DIR)/inc
PLATFORM_EXTRA_INC_DIR  := $(PLATFORM_DIR)/$(PLATFORM_SERIES)

KERNEL_DIR              := kernel
KERNEL_INC_DIR          := $(KERNEL_DIR)/inc

COMMON_DIR              := common
COMMON_INC_DIR          := $(COMMON_DIR)/inc

LIB_DIR                 := lib
LIB_INC_DIR             := $(LIB_DIR)/inc

DRIVER_DIR              := driver
DRIVER_INC_DIR          := $(DRIVER_DIR)/inc

ALL_DIR                 := $(KERNEL_DIR) $(COMMON_DIR) $(PLATFORM_DIR) \
                           $(DRIVER_DIR) $(LIB_DIR)
ALL_INC                 := -I $(KERNEL_INC_DIR) -I $(CORE_INC_DIR) \
                           -I $(COMMON_INC_DIR) -I $(LIB_INC_DIR) \
                           -I $(DRIVER_INC_DIR) -I $(PLATFORM_INC_DIR) \
                           -I $(PLATFORM_EXTRA_INC_DIR)

BUILD_SCRIPT            := $(SCRIPT_DIR)/sh/build.sh
LD_SCRIPT               := $(SCRIPT_DIR)/ld/$(PLATFORM)$(PLATFORM_SERIES).ld

CC_FLAGS                := -mcpu=cortex-$(CORE) -mthumb -g -ffreestanding \
                           -std=gnu99 $(ALL_INC) -fomit-frame-pointer -Werror
LD_FLAGS                := -T $(LD_SCRIPT) --cref \
                           -Map $(TARGET_MAP) -nostartfiles -nostdlib

SRCS                    := $(shell find $(ALL_DIR) -name '*.c')
OBJS                    := $(foreach obj, $(shell find \
                           $(ALL_DIR) -name '*.c' \
                           | grep -o '[a-z+_]*\.c' \
                           | sed -e 's/.c/.o/g'), $(BUILD_DIR)/$(obj))