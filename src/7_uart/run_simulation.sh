#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")"

rm -f work-obj93.cf

${GHDL_BIN} -a Binary_To_7Segment.vhd
${GHDL_BIN} -a uart_receiver.vhd
${GHDL_BIN} -a testbench.vhd
${GHDL_BIN} -e UART_TB
${GHDL_BIN} -r UART_TB --vcd=testbench.vcd

gtkwave testbench.vcd &
