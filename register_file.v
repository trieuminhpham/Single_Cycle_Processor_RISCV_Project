module register_file (
    input clk,
    input [4:0] A1, A2, A3,
    input [31:0] WD3,
    input RegWrite,
    output wire [31:0] RD1, RD2
);

    reg [31:0] register [31:0];
    
// Xuat giu lieu ra dua vao dia chi vao
    assign RD1 = (A1 != 0) ? register[A1] : 32'b0;
    assign RD2 = (A2 != 0) ? register[A2] : 32'b0;

// Ghi du lieu vao registor file
    always @ (posedge clk) begin
        if ((A3 != 0) && RegWrite) begin
            register[A3] <= WD3;
        end
    end
endmodule
