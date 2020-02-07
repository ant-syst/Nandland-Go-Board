#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")"

set -x

rm -f work-obj93.cf

${GHDL_BIN} -a Binary_To_7Segment.vhd
${GHDL_BIN} -a UART_RX.vhd
${GHDL_BIN} -a UART_RX_TB.vhd
${GHDL_BIN} -e UART_RX_TB
${GHDL_BIN} -r UART_RX_TB --vcd=testbench.vcd

gtkwave testbench.vcd &
