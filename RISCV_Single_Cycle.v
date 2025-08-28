module riscvsingle (
    input  wire        clk, rst,
    output wire [31:0] PC,
    input  wire [31:0] Instr,
    output wire        MemWrite,
    output wire [31:0] ALUResult, WriteData,
    input  wire [31:0] ReadData
);

    // Tín hiệu nội bộ
    wire        ALUSrc, RegWrite, Jump, Zero, PCSrc;
    wire [1:0]  ResultSrc, ImmSrc;
    wire [2:0]  ALUControl;

    // Controller
    control_unit c(
        .Op        (Instr[6:0]),
        .Funct3    (Instr[14:12]),
        .Funct7b5  (Instr[30]),
        .Zero      (Zero),
        .ResultSrc (ResultSrc),
        .MemWrite  (MemWrite),
        .PCSrc     (PCSrc),
        .ALUSrc    (ALUSrc),
        .RegWrite  (RegWrite),
        .Jump      (Jump),
        .ImmSrc    (ImmSrc),
        .ALUControl(ALUControl)
    );

    // Datapath
    datapath dp(
        .clk       (clk),
        .rst     (rst),
        .ResultSrc (ResultSrc),
        .PCSrc     (PCSrc),
        .ALUSrc    (ALUSrc),
        .RegWrite  (RegWrite),
        .ImmSrc    (ImmSrc),
        .ALUControl(ALUControl),
        .Zero      (Zero),
        .PC        (PC),
        .Instr(Instr),
        .ALUResult (ALUResult),
        .WriteData (WriteData),
        .ReadData  (ReadData)
    );

endmodule
