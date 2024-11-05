// shiftRows.sv
// perform one round of the shift row operation for AES
// Avery Smith
// avsmith@hmc.edu
// 10/29/24

module shiftRows(input logic [127:0] arrayIn,
                 output logic [127:0] arrayOut);

    // this module performs the operation s'_{r,c} = s_{r,(c+r)%4}
    // the first 4 bytes are the same, the next 4 bytes are left-shifted one byte,
    // the next are left-shifted 2 bytes, and the last are left-shifted 3 bytes

//   The key and message are 128-bit values packed into an array of 16 bytes as
//   shown below
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3

    assign arrayOut = {arrayIn[127:120], arrayIn[87:80], arrayIn[47:40], arrayIn[7:0], 
                       arrayIn[95:88], arrayIn[55:48], arrayIn[15:8], arrayIn[103:96],
                       arrayIn[63:56], arrayIn[23:16], arrayIn[111:104], arrayIn[71:64],
                       arrayIn[31:24], arrayIn[119:112], arrayIn[79:72], arrayIn[39:32]};
    // logic [31:0] row0, row1, row2, row3;

    //     assign row0 = arrayIn[0][31:0];
    //     assign row1 = {arrayIn[1][23:0], arrayIn[1][31:24]};
    //     assign row2 = {arrayIn[2][15:0], arrayIn[3][31:16]};
    //     assign row3 = {arrayIn[3][7:0], arrayIn[3][31:8]};

    //     assign arrayOut = {row0[31:24], row1[31:24], row2[31:24], row3[31:24],
    //                        row0[23:16], row1[23:16], row2[23:16], row3[23:16],
    //                        row0[15:8],  row1[15:8],  row2[15:8],  row3[15:8],
    //                        row0[7:0],   row1[7:0],   row2[7:0],   row3[7:0]};
endmodule