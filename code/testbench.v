`timescale 1ns/1ps
`define CYCLE 10.0       // 10ns => 100MHz
`define MAX_SIM_TIME 10000 // 10us

module tb_riscvsingle;

    // Tín hiệu đồng hồ và reset
    reg         clk;
    reg         rst; 

    // Outputs của DUT top (được kết nối với testbench)
    wire [31:0] WriteData;
    wire [31:0] ALUResult;
    wire        MemWrite;

    // Biến nội bộ để kiểm tra
    integer error_count = 0;
    
    // Khởi tạo và kết nối DUT (Device Under Test)
    top dut (
        .clk(clk), 
        .rst(rst),
        .WriteData(WriteData),
        .ALUResult(ALUResult), 
        .MemWrite(MemWrite)
    );
    
    // -------------------------------------
    // Generate clock
    // -------------------------------------
    always begin
        #(`CYCLE/2) clk = ~clk;
    end

    // Task reset CPU
    task reset_cpu;
        begin
            $display("INFO: Resetting CPU...");
            rst = 1;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);
            $display("INFO: CPU reset complete.");
        end
    endtask

    // -------------------------------------
    // So sánh toàn bộ register file
    // -------------------------------------
    task compare_registers;
        reg [31:0] regfile [0:31];
        reg [31:0] expected [0:31];
        integer i;
        begin
            // dump từ RTL ra file
            $writememh("regdump.hex", dut.rvsingle.dp.res.register);
            // đọc lại file dump và file expected
            $readmemh("regdump.hex", regfile);
            $readmemh("expected.hex", expected);

            for (i=0; i<32; i=i+1) begin
                if (^regfile[i] === 1'bx) begin
                    $display("INFO: Register x%0d not written -> skip", i);
                end
                else if (regfile[i] !== expected[i]) begin
                    $display(">> ERROR: Register x%0d mismatch! Expected=%h Got=%h",
                              i, expected[i], regfile[i]);
                    error_count = error_count + 1;
                end
                else begin
                    $display("INFO: Register x%0d OK = %h", i, regfile[i]);
                end
            end
        end
    endtask

    // -------------------------------------
    // Test sequence
    // -------------------------------------
    initial begin
        $display("*************************************************");
        $display("** Khởi chạy Testbench RISC-V Single-Cycle **");
        $display("*************************************************");

        // Khởi tạo tín hiệu
        clk = 0;
        rst = 0;

        // Reset hệ thống
        reset_cpu();

        // CHỜ vài chu kỳ clock sau reset để các thanh ghi chắc chắn về 0
        repeat(5) @(posedge clk);

        $display("\n-------------------------------------------------");
        $display("TEST: Thực thi chương trình từ file hex được cung cấp");
        $display("-------------------------------------------------");
        
        // cho CPU chạy thêm
        repeat(50) @(posedge clk); 
        
        // Kiểm tra kết quả
        $display("\n-------------------------------------------------");
        $display("Kiểm tra giá trị thanh ghi sau khi thực thi");
        $display("-------------------------------------------------");
        
        compare_registers();
      
        // --- KẾT THÚC VÀ BÁO CÁO ---
        if(error_count  === 0)begin
            $display("        *****************************");
            $display("        ** RISC-V Singlecycle Verify **");
            $display("        *****************************");
            `ifdef SYN
                $display("        ** part1 - SYN         **");
            `else
                $display("        ** part1 - RTL         **");
            `endif
            $display("        ****************************               ");
            $display("        **                        **       |\\__||  ");
            $display("        **  Congratulations !!    **      / O.O  | ");
            $display("        **                        **    /_____   | ");
            $display("        **  SIMULATION PASS !!    **   /^ ^ ^ \\  |");
            $display("        **                        **  |^ ^ ^ ^ |w| ");
            $display("        ****************************   \\m___m__|_|");
            $display("\n");
        end
        else begin
            `ifdef SYN
                $display("        ** part1 - SYN         **");
            `else
                $display("        ** part1 - RTL         **");
            `endif
            $display("        ****************************               ");
            $display("        **                        **       |\\__||  ");
            $display("        **  OOPS!!                **      / X,X  | ");
            $display("        **                        **    /_____   | ");
            $display("        **  SIMULATION Failed!!   **   /^ ^ ^ \\  |");
            $display("        **                        **  |^ ^ ^ ^ |w| ");
            $display("        ****************************   \\m___m__|_|");
            $display("         Totally has %d errors                     ", error_count); 
            $display("\n");
        end
        $finish;
    end
    
    // Timeout
    initial begin
        #(`MAX_SIM_TIME);
        $display("\n>> ERROR: Simulation timed out after %0t ns.", $time);
        $finish;
    end

endmodule
