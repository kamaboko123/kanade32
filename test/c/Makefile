
SRC_DIR = src
TARGET_DIR = bin
MEMDATA_DIR = memdata

LIB_SRC_DIR = src/lib
LIB_TARGET_DIR = lib

START_ASM = asm/crt0.asm
START_OBJ = $(TARGET_DIR)/crt0.o
START_ENTRY_SYMBLE = start

SRC = $(wildcard $(SRC_DIR)/*.c)
OBJ = $(addprefix $(TARGET_DIR)/, $(notdir $(SRC:.c=.o)))
BIN = $(addprefix $(TARGET_DIR)/, $(notdir $(SRC:.c=.bin)))
MEM = $(addprefix $(MEMDATA_DIR)/, $(notdir $(SRC:.c=.mem)))
CFLAGS = -O1 -mno-abicalls -fno-delayed-branch -march=mips32 -mfp32 -Iinclude
MEMFILE_LENGTH_WORD = 65536 # 128KB / 4 byte

LIB_SRC = $(wildcard $(LIB_SRC_DIR)/*.c)
LIB_OBJ = $(addprefix $(LIB_TARGET_DIR)/, $(notdir $(LIB_SRC:.c=.o)))

.SECONDARY: $(BIN) $(OBJ)

all: lib $(MEM)

$(MEMDATA_DIR)/%.mem: $(TARGET_DIR)/%.bin
	mkdir -p $(MEMDATA_DIR)
	$(eval LENGTH := $(shell xxd -c 4 -ps $^ | wc -l))
	$(eval PADDING_LENGTH := $(shell expr $(MEMFILE_LENGTH_WORD) - $(LENGTH) ))
	xxd -c 4 -ps $^ > $@
	#for i in `seq 1 $(PADDING_LENGTH)`; do echo "00000000" >> $@; done

$(TARGET_DIR)/%.bin: $(TARGET_DIR)/%.o $(START_OBJ) lib
	mips-linux-gnu-ld -e $(START_ENTRY_SYMBLE) -Tkanade32.lds2 -o $<.o $(START_OBJ) $(LIB_OBJ) $<
	mips-linux-gnu-objcopy --only-section=.text -O binary $<.o $@

$(TARGET_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(TARGET_DIR)
	mips-linux-gnu-gcc -c $(CFLAGS) -o $@ $^

$(START_OBJ): $(START_ASM)
	mkdir -p $(TARGET_DIR)
	mips-linux-gnu-as $(ASFLAGS) -o $@ $^


lib: $(LIB_OBJ)

$(LIB_TARGET_DIR)/%.o: $(LIB_SRC_DIR)/%.c
	mkdir -p $(LIB_TARGET_DIR)
	mips-linux-gnu-gcc -c $(CFLAGS) -o $@ $^

clean:
	rm -rf $(TARGET_DIR)
	rm -rf $(LIB_TARGET_DIR)
	rm -rf $(MEMDATA_DIR)

