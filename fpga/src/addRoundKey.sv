// addRoundKey.sv
// perform the AddRoundKey operation on the state array for AES given a round key
// Avery Smith
// avsmith@hmc.edu
// 11/1/24

module addRoundKey(input [127:0] arrayIn,
                   input [127:0] roundKey,
                   output [127:0]arrayOut);
    // the round key is applied to each column of the state with an XOR with the corresponding word of the round key
    
    assign arrayOut[127:96] = arrayIn[127:96] ^ roundKey[127:96];
    assign arrayOut[95:64] = arrayIn[95:64] ^ roundKey[95:64];
    assign arrayOut[63:32] = arrayIn[63:32] ^ roundKey[63:32];
    assign arrayOut[31:0] = arrayIn[31:0] ^ roundKey[31:0];

    // // map columns of the arrayIn to variables
    // logic [31:0] c0, c1, c2, c3;
    // assign c0 = arrayIn[0];
    // assign c1 = arrayIn[1];
    // assign c2 = arrayIn[2];
    // assign c3 = arrayIn[3];

    // // XOR columns with words of round key
    // logic [31:0] cp0, cp1, cp2, cp3; // cp for c'
    // assign cp0 = c0 ^ roundKey[0];
    // assign cp1 = c1 ^ roundKey[1];
    // assign cp2 = c2 ^ roundKey[2];
    // assign cp3 = c3 ^ roundKey[3];

    // // map columns to arrayOut
    // assign arrayOut[0] = cp0;
    // assign arrayOut[1] = cp1;
    // assign arrayOut[2] = cp2;
    // assign arrayOut[3] = cp3;
endmodule