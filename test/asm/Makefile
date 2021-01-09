
SRC_DIR = asm
TARGET_DIR = bin
MEMDATA_DIR = memdata
SRC = $(wildcard $(SRC_DIR)/*.asm)
OBJ = $(addprefix $(TARGET_DIR)/, $(notdir $(SRC:.asm=.o)))
BIN = $(addprefix $(TARGET_DIR)/, $(notdir $(SRC:.asm=.bin)))
MEM = $(addprefix $(MEMDATA_DIR)/, $(notdir $(SRC:.asm=.mem)))
ASFLAGS = -mips1 -O0 --no-break --no-trap
MEMFILE_LENGTH_WORD = 32768 # 128KB / 4 byte

.SECONDARY: $(BIN) $(OBJ)

all: $(MEM)

$(MEMDATA_DIR)/%.mem: $(TARGET_DIR)/%.bin
	mkdir -p $(MEMDATA_DIR)
	$(eval LENGTH := $(shell xxd -c 4 -ps $^ | wc -l))
	$(eval PADDING_LENGTH := $(shell expr $(MEMFILE_LENGTH_WORD) - $(LENGTH) ))
	@echo $(PADDING_LENGTH)
	xxd -c 4 -ps $^ > $@
	for i in `seq 1 $(PADDING_LENGTH)`; do echo "00000000" >> $@; done

$(TARGET_DIR)/%.bin: $(TARGET_DIR)/%.o
	mips-linux-gnu-objcopy --only-section=.text -O binary $^ $@

$(TARGET_DIR)/%.o: $(SRC_DIR)/%.asm
	mkdir -p $(TARGET_DIR)
	mips-linux-gnu-as $(ASFLAGS) -o $@ $^

clean:
	rm -rf $(TARGET_DIR)
	rm -rf $(MEMDATA_DIR)

