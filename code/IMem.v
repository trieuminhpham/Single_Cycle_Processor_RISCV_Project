module imem (
    input  wire [31:0] a,
    output wire [31:0] rd
);

    // Bộ nhớ 64 từ, mỗi từ 32-bit
    reg [31:0] RAM [0:63];

    // Load dữ liệu từ file hex vào RAM
    initial begin
        $readmemh("D:/EDABK/Trainning/RISC-V/Single_Cycle_Processor_Last_Version/riscvtest.txt", RAM);
    end

    // Đọc dữ liệu theo địa chỉ word-aligned
    assign rd = RAM[a[31:2]];

endmodule