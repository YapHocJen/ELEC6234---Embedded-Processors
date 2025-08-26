# ELEC6234---Embedded-Processors
Design an application-specific processor that computes a one-dimensional Gaussian-smoothed sample of a noisy waveform. Implementation in SystemVerilog, and validated by synthesizing and testing on a Cyclone V FPGA.

**Design Details Form**

Total Cost: 95
ALMs: 95
Memory bits: 0
Multipliers: 1

# Instruction Set

## Five instructions are implemented to perform one-dimensional Gaussian smoothing.

**ADD**:      Adds the values stored in two source registers and stores the result in the destination register.

**MULI**:      Multiplies the value of a source register by an immediate value and stores the result in the destination register.

**LW**:        Loads a word from ROM and writes it to the destination register.

**BEQ**:       Branches to a specific address if the value in register 1 is equal to the value in register 2. 

**BNE**:       Branches to a specified address if the value in register 1 is not equal to the value in register 2. 


## Instruction Format

Databus width = 8 bits, Instruction size = 16 bits

R-format (add): 3b opcode, 3b %s1, 3b %d, 3b %s2, 4b padding

I-format (muli, lw): 3b opcode, 3b %s, 3b %d, 7b immediate/(1b padding, 6b address)

BEQ: 3b opcode, 3b %s1, 3b %s2, 1b padding, 6b address

BNE: 3b opcode, 3b padding, 3b %s2, [[3b %s1], 4b address]

|Instruction|Format|Operation|
|---|---|---|
|ADD|	ADD %d, %s1, %s2|	%d = %s1 + %s2|
|MULI|	MULI %d, %s, imm|	%d = %s x imm|
|LW|	LW %d, imm(%s)	|%d = Memory[%s + imm]|
|BEQ|	BEQ %s1, %s2, addr|	(%s1==%s2) ? PC = addr : PC += 1|
|BNE|	BNE %s1, %s2, addr|	(%s1!=%s2) ? PC = addr : PC += 1|

# Custom assembly program
```
add   %5, %0, %0        clear reg 5
add   %4, %0, %0        clear reg 4
BEQ   %1, %0, 1         Only proceed with SW8 is 1
lw    %3,  0(%2)        reg 3 <- W[i]
muli  %4,  %3, 35       reg 4 <- W[i]*35
lw    %3, -1(%2)        reg 3 <- W[i-1]
muli  %3,  %3, 29       reg 3 <- W[i-1]*29
add   %4, %3, %4        reg 4 <- W[i]*35 + W[i-1]*29
lw    %3, -2(%2)        reg 3 <- W[i-2]
muli  %3,  %3, 17       reg 3 <- W[i-2]*17
add   %4, %3, %4        reg 4 <- W[i]*35 + W[i-1]*29 + W[i-2]*17
lw    %3,  1(%2)        reg 3 <- W[i+1]
muli  %3,  %3, 29       reg 3 <- W[i+1]*29
add   %4, %3, %4        reg 4 <- W[i]*35 + W[i-1]*29 + W[i-2]*17 + W[i+1]*29
lw    %3,  2(%2)        reg 3 <- W[i+2]
muli  %3,  %3, 17       reg 3 <- W[i+2]*17
add   %4, %3, %4        reg 4 <- W[i]*35 + W[i-1]*29 + W[i-2]*17 + W[i+1]*29 + W[i+2]*17
add   %5, %4, %5        reg 5 connected to LEDs
BEQ   %1, %0, 0         Only proceeed when SW8 is 0
BNE   %1, %0, 18        Jump back to inst 17 if SW8 is not 0
```


# Design Block Diagram
![cpuArchitecture](https://github.com/user-attachments/assets/c467258d-b237-4359-aaa1-11e1ee9a0399)


