// genRoundKey
// perform a signle round of the key expansion algorithm for AES given the previous key
// Avery Smith
// avsmith@hmc.edu
// 10/30/24

module genRoundKey(input logic clk,
                   input logic [0:3][31:0] previousKey,
                   input logic [3:0] round,
                   output logic [0:3][31:0] nextRoundKey);
    // generate the next round key from previous round key

    //generate first word of round key
    logic [31:0] t0, t1, t2;
    logic [127:0] rCon;
    roundConstant roundConstant(round, rCon); // get round constant

    rotWord rotWord(previousKey[3][31:0], t0); // t0 = rotword(w[i-1])
    subWord subWord(clk, t0, t1); // t1 = subWord(t0)
    assign t2 = t1 ^ rCon; // t2 = t1 ^ Rcon(i/4)
    assign nextRoundKey[0][31:0] = t2 ^ previousKey[0][31:0]; // w[i] = t2 ^ w[i-4]

    // generate second word
    assign nextRoundKey[1][31:0] = nextRoundKey[0][31:0] ^ previousKey[1][31:0]; // w[i] = w[i-1] ^ w[i-4]

    //generate third word
    assign nextRoundKey[2][31:0] = nextRoundKey[1][31:0] ^ previousKey[2][31:0]; // w[i] = w[i-1] ^ w[i-4]

    //generate fourth word
    assign nextRoundKey[3][31:0] = nextRoundKey[2][31:0] ^ previousKey[3][31:0]; // w[i] = w[i-1] ^ w[i-4]
endmodule

module rotWord(input logic [31:0]  wordIn,
               output logic [31:0] wordOut);
    // rotate wordIn left 1 byte
    assign wordOut = {wordIn[23:0], wordIn[31:24]};
endmodule

module subWord(input logic clk,
               input logic [31:0] wordIn,
               output logic [31:0] wordOut);
    // substitute bytes of a word using sbox substitution
    sbox_sync sub0(wordIn[31:24], clk, wordOut[31:24]);
    sbox_sync sub1(wordIn[23:16], clk, wordOut[23:16]);
    sbox_sync sub2(wordIn[15:8], clk, wordOut[15:8]);
    sbox_sync sub3(wordIn[7:0], clk, wordOut[7:0]);
endmodule

module roundConstant(input logic [3:0] round,
                     output logic [127:0] rCon);
    // get the round constant (could implement this with galois multiplication with initial key)
    always_comb begin
        case (round)
        4'd0: rCon = 128'h00000000;
        4'd1: rCon = 128'h01000000;
        4'd2: rCon = 128'h02000000;
        4'd3: rCon = 128'h04000000;
        4'd4: rCon = 128'h08000000;
        4'd5: rCon = 128'h10000000;
        4'd6: rCon = 188'h20000000;
        4'd7: rCon = 128'h40000000;
        4'd8: rCon = 128'h80000000;
        4'd9: rCon = 128'h1b000000;
        4'd10: rCon = 128'h36000000;
        default: rCon = 128'h00000000;
        endcase
    end
endmodule