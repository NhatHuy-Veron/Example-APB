# Makefile for APB UVM VIP Exercise
# Supports QuestaSim/ModelSim

# Variables
TESTNAME ?= apb_test
RTL_DIR = ../rtl
TB_DIR = ../tb
WORK_LIB = work

# Source files
RTL_FILES = $(RTL_DIR)/apb_slave.sv
TB_FILES = $(TB_DIR)/apb_interface.sv \
           $(TB_DIR)/apb_transaction.sv \
           $(TB_DIR)/apb_sequence.sv \
           $(TB_DIR)/apb_sequencer.sv \
           $(TB_DIR)/apb_driver.sv \
           $(TB_DIR)/apb_monitor.sv \
           $(TB_DIR)/apb_agent.sv \
           $(TB_DIR)/apb_environment.sv \
           $(TB_DIR)/apb_test.sv \
           $(TB_DIR)/testbench.sv

# Compilation options
VLOG_OPTS = -sv +incdir+$(TB_DIR) +define+UVM_NO_DPI
VSIM_OPTS = -c -voptargs="+acc" -L uvm

# Default target
all: compile simulate

# Create work library
$(WORK_LIB):
	vlib $(WORK_LIB)

# Compile RTL and TB files
compile: $(WORK_LIB)
	vlog $(VLOG_OPTS) $(RTL_FILES) $(TB_FILES)

# Simulate
simulate: compile
	vsim $(VSIM_OPTS) -do "run -all; quit" $(TESTNAME)

# Run with GUI
gui: compile
	vsim $(VSIM_OPTS) -do "add wave -r /*; run -all" $(TESTNAME)

# Clean
clean:
	vdel -lib $(WORK_LIB) -all
	rm -rf $(WORK_LIB)

.PHONY: all compile simulate gui clean