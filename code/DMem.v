module dmem (
    input  wire        clk,       // Clock
    input  wire        we,        // Write enable
    input  wire [31:0] a,         // Address
    input  wire [31:0] wd,        // Write data
    output wire [31:0] rd         // Read data
);

    // Bộ nhớ 64 từ, mỗi từ 32-bit
    reg [31:0] RAM [0:63];

    // Đọc dữ liệu (asynchronous read)
    assign rd = RAM[a[31:2]];  // word aligned

    // Ghi dữ liệu (synchronous write)
    always @(posedge clk) begin
        if (we) begin
            RAM[a[31:2]] <= wd;
        end
    end

endmodule