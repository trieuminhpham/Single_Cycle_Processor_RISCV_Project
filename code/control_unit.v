module control_unit (
    input [6:0] Op,
    input [2:0] Funct3,
    input Funct7b5,
    input Zero,
    output wire PCSrc,
    output wire [1:0] ResultSrc,
    output reg [2:0] ALUControl,
    output wire ALUSrc,
    output wire [1:0] ImmSrc,
    output wire MemWrite, RegWrite,
    output wire Jump
);

wire [1:0] ALUOp;
reg [10:0] control;
wire Branch;
wire RTypeSub;

assign RTypeSub = Funct7b5 & Op[5];
assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = control;

// main decoder
always @(*) begin
    case (Op)
        7'b0000011: control = 11'b1_00_1_0_01_0_00_0; // lw 
        7'b0100011: control = 11'b0_01_1_1_00_0_00_0; // sw
        7'b0110011: control = 11'b1_xx_0_0_00_0_10_0; // R-Type
        7'b1100011: control = 11'b0_10_0_0_00_1_01_0; // beq
        7'b0010011: control = 11'b1_00_1_0_00_0_10_0; // I-type ALU
        7'b1101111: control = 11'b1_11_0_0_10_0_00_1; // jal
        default:    control = 11'bx_xx_x_x_xx_x_xx_x; // default safe
    endcase
end

assign PCSrc = (Zero & Branch) | Jump;

// ALU Decoder
always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 3'b000; // addition (add, lw, sw)
        2'b01: ALUControl = 3'b001; // subtraction (beq)
        default: begin
            case (Funct3)
                3'b000: ALUControl = (RTypeSub) ? 3'b001 : 3'b000; // sub or add
                3'b010: ALUControl = 3'b101; // slt/slti
                3'b110: ALUControl = 3'b011; // or/ori
                3'b111: ALUControl = 3'b010; // and/andi
                default: ALUControl = 3'bxxx;
            endcase
        end
    endcase
end

endmodule
