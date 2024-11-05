
/////////////////////////////////////////////
// aes
//   Top level module with SPI interface and SPI core
/////////////////////////////////////////////

module aes(input  logic sck, 
           input  logic sdi,
           output logic sdo,
           input  logic load,
           output logic done);
           
    HSOSC #(.CLKHF_DIV(2'b10)) 
        hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));
                    
    logic [127:0] key, plaintext, cyphertext;
            
    aes_spi spi(sck, sdi, sdo, done, key, plaintext, cyphertext);   
    aes_core core(clk, load, key, plaintext, done, cyphertext);
endmodule

/////////////////////////////////////////////
// aes_spi
//   SPI interface.  Shifts in key and plaintext
//   Captures ciphertext when done, then shifts it out
//   Tricky cases to properly change sdo on negedge clk
/////////////////////////////////////////////

module aes_spi(input  logic sck, 
               input  logic sdi,
               output logic sdo,
               input  logic done,
               output logic [127:0] key, plaintext,
               input  logic [127:0] cyphertext);

    logic         sdodelayed, wasdone;
    logic [127:0] cyphertextcaptured;
               
    // assert load
    // apply 256 sclks to shift in key and plaintext, starting with plaintext[127]
    // then deassert load, wait until done
    // then apply 128 sclks to shift out cyphertext, starting with cyphertext[127]
    // SPI mode is equivalent to cpol = 0, cpha = 0 since data is sampled on first edge and the first
    // edge is a rising edge (clock going from low in the idle state to high).
    
    always_ff @(posedge sck)
        if (!wasdone)  {cyphertextcaptured, plaintext, key} = {cyphertext, plaintext[126:0], key, sdi};
        else           {cyphertextcaptured, plaintext, key} = {cyphertextcaptured[126:0], plaintext, key, sdi}; 
    
    // sdo should change on the negative edge of sck
    always_ff @(negedge sck) begin
        wasdone = done;
        sdodelayed = cyphertextcaptured[126];
    end
    
    // when done is first asserted, shift out msb before clock edge
    assign sdo = (done & !wasdone) ? cyphertext[127] : sdodelayed;
endmodule

/////////////////////////////////////////////
// aes_core
//   top level AES encryption module
//   when load is asserted, takes the current key and plaintext
//   generates cyphertext and asserts done when complete 11 cycles later
// 
//   See FIPS-197 with Nk = 4, Nb = 4, Nr = 10
//
//   The key and message are 128-bit values packed into an array of 16 bytes as
//   shown below
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3
//
//   Equivalently, the values are packed into four words as given
//        [127:96]  [95:64] [63:32] [31:0]      w[0]    w[1]    w[2]    w[3]
/////////////////////////////////////////////


module aes_core(input  logic         clk, 
                input  logic         load,
                input  logic [127:0] key, 
                input  logic [127:0] plaintext, 
                output logic         done, 
                output logic [127:0] cyphertext);
    // the order here roughly follows left -> right in the block diagram

    // declare all signals
    logic [0:3][31:0] bufferedPlaintext, bufferedKey;
    logic [0:3][31:0] previousKey, nextRoundKey, roundKey, keyFeedback;
    logic [0:3][31:0] shiftRowsIn, shiftRowsOut, mixColumnsOut, addRoundKeyIn, addRoundKeyOut, roundOut;
    logic [3:0] round;
    logic [1:0] addRoundKey_stateMux;
    logic addRoundKey_keyMux, genRoundKey_mux, reg_en;

    // buffer and lock plaintext and key
    always_ff @ (posedge clk) begin
        if (load) begin
            bufferedPlaintext <= plaintext;
            bufferedKey <= key;
        end
    end

    // instantiate modules and muxes
    always_comb begin
        // select previousKey signal for genRoundKey
        if (genRoundKey_mux) previousKey = keyFeedback;
        else                 previousKey = bufferedKey;
    end

    always_ff @(posedge clk) begin
        // register for key feedback
        if (reg_en) keyFeedback <= nextRoundKey;
    end

    genRoundKey genRoundKey(clk, previousKey, round, nextRoundKey);

    subBytes subBytes(clk, roundOut, shiftRowsIn);

    shiftRows shiftRows(shiftRowsIn, shiftRowsOut);

    mixcolumns mixcolumns(shiftRowsOut, mixColumnsOut);

    always_comb begin
        // select arrayIn signal for addRoundKey
        if (addRoundKey_stateMux == 2'b00)      addRoundKeyIn = bufferedPlaintext;
        else if (addRoundKey_stateMux == 2'b01) addRoundKeyIn = shiftRowsOut;
        else                                    addRoundKeyIn = mixColumnsOut;

        // select roundKey signal for addRoundKey
        if (addRoundKey_keyMux) roundKey = nextRoundKey;
        else                    roundKey = bufferedKey;
    end
    
    addRoundKey addRoundKey(addRoundKeyIn, roundKey, addRoundKeyOut);

    controllerFSM controllerFSM(clk, load, addRoundKey_keyMux, genRoundKey_mux, reg_en, addRoundKey_stateMux, round, done);

    // roundOut register
    always_ff @(posedge clk) begin
        if (reg_en) roundOut <= addRoundKeyOut;
    end

    assign cyphertext = roundOut;

endmodule

// /////////////////////////////////////////////
// // sbox
// //   Infamous AES byte substitutions with magic numbers
// //   Combinational version which is mapped to LUTs (logic cells)
// //   Section 5.1.1, Figure 7
// /////////////////////////////////////////////

// module sbox(input  logic [7:0] a,
//             output logic [7:0] y);
            
//   // sbox implemented as a ROM
//   // This module is combinational and will be inferred using LUTs (logic cells)
//   logic [7:0] sbox[0:255];

//   initial   $readmemh("sbox.txt", sbox);
//   assign y = sbox[a];
// endmodule

/////////////////////////////////////////////
// sbox
//   Infamous AES byte substitutions with magic numbers
//   Synchronous version which is mapped to embedded block RAMs (EBR)
//   Section 5.1.1, Figure 7
/////////////////////////////////////////////
module sbox_sync(
	input		logic [7:0] a,
	input	 	logic 			clk,
	output 	logic [7:0] y);
            
  // sbox implemented as a ROM
  // This module is synchronous and will be inferred using BRAMs (Block RAMs)
  logic [7:0] sbox [0:255];

  initial   $readmemh("sbox.txt", sbox);
	
	// Synchronous version
	always_ff @(posedge clk) begin
		y <= sbox[a];
	end
endmodule

/////////////////////////////////////////////
// mixcolumns
//   Even funkier action on columns
//   Section 5.1.3, Figure 9
//   Same operation performed on each of four columns
/////////////////////////////////////////////

module mixcolumns(input  logic [127:0] a,
                  output logic [127:0] y);

  mixcolumn mc0(a[127:96], y[127:96]);
  mixcolumn mc1(a[95:64],  y[95:64]);
  mixcolumn mc2(a[63:32],  y[63:32]);
  mixcolumn mc3(a[31:0],   y[31:0]);
endmodule

/////////////////////////////////////////////
// mixcolumn
//   Perform Galois field operations on bytes in a column
//   See EQ(4) from E. Ahmed et al, Lightweight Mix Columns Implementation for AES, AIC09
//   for this hardware implementation
/////////////////////////////////////////////

module mixcolumn(input  logic [31:0] a,
                 output logic [31:0] y);
                      
        logic [7:0] a0, a1, a2, a3, y0, y1, y2, y3, t0, t1, t2, t3, tmp;
        
        assign {a0, a1, a2, a3} = a;
        assign tmp = a0 ^ a1 ^ a2 ^ a3;
    
        galoismult gm0(a0^a1, t0);
        galoismult gm1(a1^a2, t1);
        galoismult gm2(a2^a3, t2);
        galoismult gm3(a3^a0, t3);
        
        assign y0 = a0 ^ tmp ^ t0;
        assign y1 = a1 ^ tmp ^ t1;
        assign y2 = a2 ^ tmp ^ t2;
        assign y3 = a3 ^ tmp ^ t3;
        assign y = {y0, y1, y2, y3};    
endmodule

/////////////////////////////////////////////
// galoismult
//   Multiply by x in GF(2^8) is a left shift
//   followed by an XOR if the result overflows
//   Uses irreducible polynomial x^8+x^4+x^3+x+1 = 00011011
/////////////////////////////////////////////

module galoismult(input  logic [7:0] a,
                  output logic [7:0] y);

    logic [7:0] ashift;
    
    assign ashift = {a[6:0], 1'b0};
    assign y = a[7] ? (ashift ^ 8'b00011011) : ashift;
endmodule