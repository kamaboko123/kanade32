
SRC_DIR = asm
TARGET_DIR = bin
MEMDATA_DIR = memdata
SRC = $(wildcard $(SRC_DIR)/*.asm)
OBJ = $(addprefix $(TARGET_DIR)/, $(notdir $(SRC:.asm=.o)))
BIN = $(addprefix $(TARGET_DIR)/, $(notdir $(SRC:.asm=.bin)))
MEM = $(addprefix $(MEMDATA_DIR)/, $(notdir $(SRC:.asm=.mem)))
ASFLAGS=-mips1

.SECONDARY: $(BIN) $(OBJ)

all: $(MEM)

$(MEMDATA_DIR)/%.mem: $(TARGET_DIR)/%.bin
	mkdir -p $(MEMDATA_DIR)
	xxd -c 4 -ps $^ > $@

$(TARGET_DIR)/%.bin: $(TARGET_DIR)/%.o
	mips-linux-gnu-objcopy --only-section=.text -O binary $^ $@

$(TARGET_DIR)/%.o: $(SRC_DIR)/%.asm
	mkdir -p $(TARGET_DIR)
	mips-linux-gnu-as $(ASFLAGS) -o $@ $^

clean:
	rm -rf $(TARGET_DIR)
	rm -rf $(MEMDATA_DIR)

