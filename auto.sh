#!/bin/bash

make $@

# auto run make command when change verilog files
# reflex is needed for use this script
# https://github.com/cespare/reflex

reflex -r '\.(v|mem)$' make $@

