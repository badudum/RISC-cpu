# RISC CPU 
This is a reduced instruction set CPU which aims to let us understand and master the ins and outs of a rudimentary CPU. 

# Overall Diagram
![cpu diagram upload](/images/cpu_diagram.png)
The above diagram shows the general layout of the cpu design. There are several components, which are described below.

## Datapath
The datapath contains various functionalities, starting from the ALU(arithmetic logic unit), a bit shifter, and several registers to store values.

### ALU 
  The ALU will support addition, subtraction, bitwise AND operation, and a bitwise negation with the opcodes below:

  | ALU_op | operation        | ALU_out       |
  | ------ | ---------------- | ------------- |
  | 00     | addition         | val_A + val_b | 
  | 01     | subtraction      | val_A - val_b |
  | 10     | bitwise AND      | val_A & val_b |
  | 11     | bitwise negation |    ~val_B     |
