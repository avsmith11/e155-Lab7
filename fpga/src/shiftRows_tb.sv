module testbench_shiftRows();
    logic [0:3][31:0] arrayIn;
    logic [0:3][31:0] arrayOut;

    initial begin
    assign arrayIn = 128'h d4e0b81e27bfb44111985d52aef1e530;// Appendix B round 1 
    end

    shiftRows dut(arrayIn, arrayOut); // WHY DOESN'T THIS WORK?!?!?!?


endmodule