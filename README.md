Joseph ("Joey") Lincoln @j0ey-code
Project from April, 2025
Northern Essex Community College, Microcontrollers / Assembly Programming

**There and Back: Reverse Engineering BASIC to ASM**
Code optimization at the lowest-level.
"addtl/" has video demo as file and documentation for the PIC18F microcontroller instruction set.
"LCDmsgs.asm" is the code itself — a single Assembly file intended for the PIC18F4XXX microcontroller.
And, for usage with a 128x64 LCD graphical display device. Similar to ones for road signs!

YouTube video showcase and demo here too (messages apppear at the end, first part is just scroll thru code!!)
https://www.youtube.com/shorts/gO_OGjyzrp4

That's what this program is. It just prints simple messages to the display.
The novelty is that the BASIC, which was disassembled from demo code files, actually did not assemble in the most optimal way.
This project was an attempt to re-write the code. 
By using "higher level" mechanisms not typically found in Assembly anyways (saving state variables for characters, looping for predicted behavior), I was able to cut down on over 100 lines of what was essentially frill and garbage.
Combined with the documentation for the PIC18F instruction set and the reverse engineered / dis-assembled BASIC, I put a thorough picture together of how the commands all worked together within the PIC's processor.
From there, I simply decided what could change about the code, design-wise, to be make it shorter / more efficient.
A first experiment in reverse engineering and low-level code optimization.



