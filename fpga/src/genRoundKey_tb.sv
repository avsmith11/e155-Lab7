// genRoundKey_tb.sv
// testbench for the single-round key-expansion module
// Avery Smith
// avsmith@hmc.edu
// 11/1/24
`timescale 1ns/1ns
module testbench_genRoundKey();
    logic [0:3][31:0] previousKey, roundKey;
    logic [3:0] round;
    logic clk;
    logic div;

    genRoundKey genRoundKey(clk, previousKey, round, roundKey);

    always begin
    // generate clk signal
        #10
        clk = 0;
        #10
        clk = 1;
    end

    always @(posedge clk) begin
        // go to next round
        div <= div + 1;
        if (div == 1) begin
            previousKey <= roundKey;
            round <= round + 1;
        end
    end

    initial begin
        // set initial round and previous key
        previousKey = 128'h 2b7e151628aed2a6abf7158809cf4f3c;
        round = 'd1;
        div = 0;
    end
endmodule