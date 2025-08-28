module top (
    input clk, rst,
    output [31:0] WriteData, ALUResult,
    output MemWrite
);

wire [31:0] PC, Instr, ReadData;

riscvsingle rvsingle (clk, rst, PC, Instr, MemWrite, ALUResult, WriteData, ReadData);
imem imem (PC, Instr);
dmem dmem (clk, MemWrite, ALUResult, WriteData, ReadData);
endmodule