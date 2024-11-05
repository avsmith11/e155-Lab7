// subBytes.sv
// perform the byte substitution step of AES on a state array
// Avery Smith
// avsmith@hmc.edu
// 10/29/24

module subBytes(input logic clk,
                input logic [0:3][31:0]arrayIn,
                output logic [0:3][31:0]arrayOut);
    // apply the sbox_sync transform (lookup table) to each byte in arrayIn
    logic [7:0] sp00, sp01, sp02, sp03, sp10, sp11, sp12, sp13, sp20, sp21, sp22, sp23, sp30, sp31, sp32, sp33;

    sbox_sync sbox_sync00(arrayIn[0][31:24], clk, sp00);
    sbox_sync sbox_sync01(arrayIn[0][23:16], clk, sp01);
    sbox_sync sbox_sync02(arrayIn[0][15:8], clk, sp02);
    sbox_sync sbox_sync03(arrayIn[0][7:0], clk,  sp03);
    
    sbox_sync sbox_sync10(arrayIn[1][31:24], clk, sp10);
    sbox_sync sbox_sync11(arrayIn[1][23:16], clk, sp11);
    sbox_sync sbox_sync12(arrayIn[1][15:8], clk, sp12);
    sbox_sync sbox_sync13(arrayIn[1][7:0], clk, sp13);

    sbox_sync sbox_sync20(arrayIn[2][31:24], clk, sp20);
    sbox_sync sbox_sync21(arrayIn[2][23:16], clk, sp21);
    sbox_sync sbox_sync22(arrayIn[2][15:8], clk, sp22);
    sbox_sync sbox_sync23(arrayIn[2][7:0], clk, sp23);

    sbox_sync sbox_sync30(arrayIn[3][31:24], clk, sp30);
    sbox_sync sbox_sync31(arrayIn[3][23:16], clk, sp31);
    sbox_sync sbox_sync32(arrayIn[3][15:8], clk, sp32);
    sbox_sync sbox_sync33(arrayIn[3][7:0], clk, sp33);

    assign arrayOut = {sp00, sp01, sp02, sp03, 
                       sp10, sp11, sp12, sp13,
                       sp20, sp21, sp22, sp23,
                       sp30, sp31, sp32, sp33};
endmodule