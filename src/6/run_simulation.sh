#!/bin/bash

rm work-obj93.cf
../../ghdl_install/bin/ghdl -a design.vhd 
../../ghdl_install/bin/ghdl -a testbench.vhd
../../ghdl_install/bin/ghdl -e LED_Blink_TB
../../ghdl_install/bin/ghdl -r LED_Blink_TB --vcd=testbench.vcd
gtkwave testbench.vhd
