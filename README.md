# README #

Contains VHDL code :
* From https://www.nandland.com/ tutorial
* From homemade work to learn VHDL by doing nandland exercises

## 1) ##

Subject :
* Create a program to light up a LED when a button is pushed.

Links :
* https://www.nandland.com/goboard/your-first-go-board-project.html

Folders :
* `src/1/solutions`: Nandland source code solution

## 2) ##

Subject :
* This project should illuminate LED D1 when both Switch 1 and Switch 2 are
pushed at the same time

Links :
* https://www.nandland.com/goboard/look-up-tables-luts-boolean-logic.html

Folders :
* `src/2/solutions`: Nandland source code solution

## 3) ##

Subject :
* This project should toggle the state of LED 1, only when Switch 1 is released.

Links :
* https://www.nandland.com/goboard/registers-and-clocks-project.html

Folders :
* `src/3/solutions`: Nandland source code solution

## 4) ##

Subject :
* This project should add a debounce filter to the code from the previous
project to ensure that a single press of the button toggles the LED

Links :
* https://www.nandland.com/goboard/debounce-switch-project.html

Folders :
* `src/4/solutions`: Nandland source code solution

## 5) ##

Subject : Increment a Binary Counter to Drive One Digit of the 7-Segment
Display Each Time a Switch is Released.

Links :
* https://www.nandland.com/goboard/seven-segment-display-intro.html

Folders :
* `src/5/seven_segment_displays`: Homemade source code
* `src/5/count_down`: A variation of the project that displays a cout down
* `src/5/solutions`: Nandland source code solution

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
* `src/7/uart_receiver/`: Homemade source code
    * `src/7/uart_receiver/run_simulation.sh` Script to run GHDL simulation.
* `src/7/solutions/`: Nandland source code solution

Test program on board :

1. Run a terminal
```bash
sudo picocom --baud=115200 --databits=8 --parity=none --stopbits=1 --flow=none /dev/ttyUSB1
```
2. Type `Ctrl+A Ctrl+W 1F` to send the `1F` ascii code to the board
2. The code `1F` is displayed on the board.

## 8) ##

Subject :
* Create a loopback of data sent by the computer. The Go Board should receive
data from the computer and then transmit the received data back to the computer.
The UART receiver should operate at 115200 baud, 8 data bits, no parity, 1 stop
bit, no flow control.

Links :
* https://www.nandland.com/goboard/uart-go-board-project-part2.html

Folders :
* `src/8/uart_transmitter/`: Homemade source code
