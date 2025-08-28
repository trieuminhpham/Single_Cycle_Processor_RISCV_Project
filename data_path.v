module datapath (
    input clk, rst, PCSrc, ALUSrc, RegWrite,
    input [1:0] ResultSrc, ImmSrc,
    input [2:0] ALUControl,
    input [31:0] ReadData, Instr,
    output [31:0] WriteData,
	 output reg [31:0] ALUResult,
    output reg [31:0] PC,
    output Zero
);

wire [31:0] PCNext, PCPlus4, PCTarget, Result;
reg [31:0] ImmExt;
wire [31:0] SrcA, SrcB;

assign Zero = (ALUResult == 0);
assign PCTarget = PC + ImmExt;
assign PCPlus4 = PC + 4;

// Instance register file
register_file res (.clk(clk), .A1(Instr[19:15]), .A2(Instr[24:20]), .A3(Instr[11:7]), .WD3(Result), .RegWrite(RegWrite), .RD1(SrcA), .RD2(WriteData));

// Extend
always @(ImmSrc or Instr) begin
    case (ImmSrc)
        2'b00: ImmExt = {{20{Instr[31]}}, Instr[31:20]}; // I-Type: Imm[11:0] = Instr[31:20]
        2'b01: ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]}; // S-Type: Imm = {Instr[31:25], Instr[11:7]}
        2'b10: ImmExt = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0}; // B-Type: Imm = {Instr[31], Instr[7], Instr[30:25], Instr[11:8], 0}
        2'b11: ImmExt = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0}; // J-type: Imm = {Instr[31], Instr[19:12], Instr[20], Instr[30:21], 0}
        default: ImmExt = 32'b0;
    endcase
end

// ALU
always @(ALUControl or SrcA or SrcB) begin
    case (ALUControl)
        3'b000: ALUResult = SrcA + SrcB;
        3'b001: ALUResult = SrcA - SrcB;
        3'b101: ALUResult = (SrcA < SrcB) ? 32'b1 : 32'b0; 
        3'b011: ALUResult = SrcA | SrcB;
        3'b010: ALUResult = SrcA & SrcB;
        default: ALUResult = 32'b0;
    endcase
end

// Mux 2:1 cho RD2 va Imm
assign SrcB = (ALUSrc) ? ImmExt : WriteData;

//Mux 2:1 cho PCNext
assign PCNext = (PCSrc) ? PCPlus4 : PCTarget;

// Mux 3:1 cho Result
assign Result = (ResultSrc == 2'b00) ? ALUResult : (ResultSrc == 2'b01) ? ReadData : (ResultSrc == 2'b10) ? PCPlus4 : 32'bx;

// Tinh PC ke tiep
always @(posedge clk or posedge rst) begin
    if (rst)
        PC <= 32'b0;
    else
        PC <= PCNext;
end
endmodule