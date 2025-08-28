module testbench;

    // Signals
    reg clk;
    reg rst;
    wire [31:0] WriteData, ALUResult;
    wire MemWrite;

    // Instantiate device to be tested
    top dut (
        .clk(clk),
        .rst(rst),
        .WriteData(WriteData),
        .ALUResult(ALUResult),
        .MemWrite(MemWrite)
    );

    // Initialize test
    initial begin
        rst = 1;
        #22 rst = 0;
    end

    // Generate clock to sequence tests
    always begin
        clk = 1;
        #5;
        clk = 0;
        #5;
    end

    // Check results
    always @(negedge clk) begin
        if (MemWrite) begin
            if (ALUResult === 100 && WriteData === 25) begin
                $display("Simulation succeeded");
                $stop;
            end else if (ALUResult !== 96) begin
                $display("Simulation failed");
                $stop;
            end
        end
    end

endmodule