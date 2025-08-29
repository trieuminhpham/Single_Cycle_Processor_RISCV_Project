module register_file (
    input clk,
    input rst,                 
    input [4:0] A1, A2, A3,
    input [31:0] WD3,
    input RegWrite,
    output wire [31:0] RD1, RD2
);

    reg [31:0] register [0:31];
    integer i;
    
    // đọc async
    assign RD1 = (A1 != 0) ? register[A1] : 32'b0;
    assign RD2 = (A2 != 0) ? register[A2] : 32'b0;

    // ghi sync + reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i=0; i<32; i=i+1)
                register[i] <= 32'b0;
        end else begin
            if ((A3 != 0) && RegWrite) begin
                register[A3] <= WD3;
            end
        end
    end
endmodule
