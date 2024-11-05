// addRoundKey_tb.sv
// testbench for addRoundKey module using round 0 example from apendix B of AES standard
// Avery Smith
// avsmith@hmc.edu
// 11/2/24

module testbench_addRoundKey();
    logic [127:0] arrayIn, roundKey, arrayOut;
    addRoundKey addRoundKey(arrayIn, roundKey, arrayOut);
    initial begin
        arrayIn = 128'h 3243f6a8_885a308d_313198a2_e0370734;
        roundKey = 128'h 2b7e1516_28aed2a6_abf71588_09cf4f3c;
    end
endmodule