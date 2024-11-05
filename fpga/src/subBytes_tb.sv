// subBytes_tb.sv
// testbench for subBytes submodule for AES
// Avery Smith
// avsmith@hmc.edu
// 10/31/24
`timescale 1ns/1ns

module testbench_subBytes();
    logic [0:3][31:0] arrayIn, arrayOut;
    logic clk;
    subBytes dut(clk, arrayIn, arrayOut);
    
    initial begin
        arrayIn = 128'h 19_a0_9a_e9_3d_f4_c6_f8_e3_e2_8d_48_be_2b_2a_08;
        clk = 0;
        #5
        clk = 1;
        #5
        clk = 0;
        #5
        clk = 1;
        #5
        clk = 0;
        #5
        clk = 1;
        #5
        clk = 0;
        #5
        clk = 1;
        #5
        clk = 0;
    end
endmodule
