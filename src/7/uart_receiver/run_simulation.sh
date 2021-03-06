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

${GHDL_BIN} -a Binary_To_7Segment.vhd
${GHDL_BIN} -a uart_receiver.vhd
${GHDL_BIN} -a test_bench.vhd
${GHDL_BIN} -e UART_TB
${GHDL_BIN} -r UART_TB --vcd=test_bench.vcd

if [[ "${run_gtkwave}" == 1 ]]
then
    gtkwave test_bench.vcd &
fi
