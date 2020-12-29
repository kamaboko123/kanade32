#Makefile

IVERILOGR = iverilog
VVP = vvp
TARGET_DIR = bin
OBJ = $(TARGET_DIR)/sim.vvp
TOP = TEST_KANADE32
SRC_DIR = src
V_FILES = $(shell find $(SRC_DIR) -type f -and -name "*.v")
MEM_FILES = $(shell find ./ -type f -and -name "*.mem")
VCD_FILE = dump.vcd

MEM_FILE ?= test/c/memdata/fibonacci.mem
SIM_CLK ?= 10000000

$(VCD_FILE): $(OBJ)
	$(VVP) $(OBJ) -v

$(OBJ): $(V_FILES) $(MEM_FILES)
	@echo $(V_FILES)
	@echo $(MEM_FILES)
	mkdir -p $(TARGET_DIR)
	$(IVERILOGR) -o $(OBJ) -s $(TOP) -DTEST_MEM_FILE=\"$(MEM_FILE)\" -DSIM_CLK=$(SIM_CLK) $(V_FILES)

run: $(VCD_FILE)
	gtkwave dump.vcd

clean:
	rm -rf $(TARGET_DIR)
	rm -f $(VCD_FILE)
