module top (
    input clk, rst,
    output [31:0] WriteData, ALUResult,
    output MemWrite
);

wire [31:0] PC, Instr, ReadData;

riscvsingle rvsingle (
    .clk(clk), 
    .rst(rst), 
    .PC(PC), 
    .Instr(Instr), 
    .MemWrite(MemWrite), 
    .ALUResult(ALUResult), 
    .WriteData(WriteData), 
    .ReadData(ReadData)
);

imem imem (
    .a(PC), 
    .rd(Instr)
);

dmem dmem (
    .clk(clk), 
    .we(MemWrite), 
    .a(ALUResult), 
    .wd(WriteData), 
    .rd(ReadData)
);

endmodule
