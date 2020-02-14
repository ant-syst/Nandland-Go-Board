#!/bin/bash

set -u

if [[ "$#" == 1 ]]
then
    if [[ "$1" == "--gtkwave" ]]
    then
        run_gtkwave=1
    else
        echo "Usage $0 [--gtkwave]"
        exit 1
    fi
else
    run_gtkwave=0
fi

cd "$(dirname "$(readlink -f "$0")")"

rm -f work-obj93.cf

${GHDL_BIN} -a debounce.vhd
${GHDL_BIN} -a uart_transmitter.vhd
${GHDL_BIN} -a main.vhd
${GHDL_BIN} -a testbench.vhd
${GHDL_BIN} -e UART_TB
${GHDL_BIN} -r UART_TB --vcd=testbench.vcd

if [[ "${run_gtkwave}" == 1 ]]
then
    gtkwave testbench.vcd &
fi
