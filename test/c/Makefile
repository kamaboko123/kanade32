
SRC_DIR = src
TARGET_DIR = bin
MEMDATA_DIR = memdata

START_ASM = asm/crt0.asm
START_OBJ = $(TARGET_DIR)/crt0.o
START_ENTRY_SYMBLE = start

SRC = $(wildcard $(SRC_DIR)/*.c)
OBJ = $(addprefix $(TARGET_DIR)/, $(notdir $(SRC:.c=.o)))
BIN = $(addprefix $(TARGET_DIR)/, $(notdir $(SRC:.c=.bin)))
MEM = $(addprefix $(MEMDATA_DIR)/, $(notdir $(SRC:.c=.mem)))
CFLAGS = -O1 -mno-abicalls -fno-delayed-branch -march=mips32 -mfp32 -Iinclude
MEMFILE_LENGTH_WORD = 65536 # 128KB / 4 byte

.SECONDARY: $(BIN) $(OBJ)

all: $(MEM)

$(MEMDATA_DIR)/%.mem: $(TARGET_DIR)/%.bin
	mkdir -p $(MEMDATA_DIR)
	$(eval LENGTH := $(shell xxd -c 4 -ps $^ | wc -l))
	$(eval PADDING_LENGTH := $(shell expr $(MEMFILE_LENGTH_WORD) - $(LENGTH) ))
	xxd -c 4 -ps $^ > $@
	for i in `seq 1 $(PADDING_LENGTH)`; do echo "00000000" >> $@; done

$(TARGET_DIR)/%.bin: $(TARGET_DIR)/%.o $(START_OBJ)
	mips-linux-gnu-ld -e $(START_ENTRY_SYMBLE) -Ttext=0 -o $<.o $(START_OBJ) $<
	mips-linux-gnu-objcopy --only-section=.text -O binary $<.o $@

$(TARGET_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(TARGET_DIR)
	mips-linux-gnu-gcc -c $(CFLAGS) -o $@ $^

$(START_OBJ): $(START_ASM)
	mkdir -p $(TARGET_DIR)
	mips-linux-gnu-as $(ASFLAGS) -o $@ $^

clean:
	rm -rf $(TARGET_DIR)
	rm -rf $(MEMDATA_DIR)

