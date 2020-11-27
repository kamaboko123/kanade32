
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
CFLAGS = -O1 -mno-abicalls -fno-delayed-branch

.SECONDARY: $(BIN) $(OBJ)

all: $(MEM)

$(MEMDATA_DIR)/%.mem: $(TARGET_DIR)/%.bin
	mkdir -p $(MEMDATA_DIR)
	xxd -c 4 -ps $^ > $@

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

