# README #

Contains VHDL code :
* From https://www.nandland.com/ tutorial
* Or created by me to learn VHDL by doing nandland exercises

## 7) ##

Subject :
* Create a UART Receiver that receives a byte from the computer and
displays it in hexadecimal on the 7-Segment Displays. The UART receiver
should operate at 115200 baud, 8 data bits, no parity, 1 stop bit, no
flow control.

Links :
* https://www.nandland.com/goboard/uart-go-board-project-part1.html
* https://www.nandland.com/articles/what-is-a-uart-rs232-serial.html
* https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html

Folders :
* `7_uart`: Personnal solution
    * `7_uart/run_simulation.sh` Script to run GHDL simulation.
* `7_uart_nandland`: Nandland source code solution

Test program on board :

1. Run a terminal
```bash
sudo picocom --baud=115200 --databits=8 --parity=none --stopbits=1 --flow=none /dev/ttyUSB1
```
2. Type `Ctrl+A Ctrl+W 1F` to send the `1F` ascii code to the board
2. The code `1F` is displayed on the board.
