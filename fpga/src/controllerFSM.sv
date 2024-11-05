// controllerFSM.sv
// controller module for multi-cyclce AES module
// Avery Smith
// avsmith@hmc.edu
// 10/31/24

module controllerFSM(input logic clk, load,
                    output logic addRoundKey_keyMux, genRoundKey_mux, reg_en,
                    output logic [1:0] addRoundKey_stateMux,
                    output logic [3:0] round,
                    output logic done);

    logic nextRound;
    // logic [3:0] counter; // use this if round takes more than one clock cycle
    typedef enum logic [3:0] {waiting, round0, round1, round2, round3, round4, round5, round6, round7, round8, round9, round10, doneState} statetype;
    statetype state, nextstate;

    always_ff @(posedge clk) begin
        // generate nextRound signal
        if (state == waiting) nextRound <= 0;
        else nextRound <= ~nextRound;
        // if (counter == 3'b111) nextRound <= ~nextRound;
    end

    always_ff @(posedge clk) begin
        // state register
        state <= nextstate;
    end

    always_ff @(posedge clk) begin
        // set done high on donestate. reset if 
        if (state == doneState) done <= 1;
        else if (load) done <= 0;
    end
    // nextstate logic
    always_comb
        case (state)
            waiting: if (load) nextstate = round0; // wait for load to go high to start encryption
                    else nextstate = waiting;
            round0: if (nextRound) nextstate = round1;
                    else nextstate = round0;
            round1: if (nextRound) nextstate = round2;
                    else nextstate = round1;
            round2: if (nextRound) nextstate = round3;
                    else nextstate = round2;
            round3: if (nextRound) nextstate = round4;
                    else nextstate = round3;
            round4: if (nextRound) nextstate = round5;
                    else nextstate = round4;
            round5: if (nextRound) nextstate = round6;
                    else nextstate = round5;
            round6: if (nextRound) nextstate = round7;
                    else nextstate = round6;
            round7: if (nextRound) nextstate = round8;
                    else nextstate = round7;
            round8: if (nextRound) nextstate = round9;
                    else nextstate = round8;
            round9: if (nextRound) nextstate = round10;
                    else nextstate = round9;
            round10: if (nextRound) nextstate = doneState;
                    else nextstate = round10;
            doneState: if (nextRound) nextstate = waiting;
                    else nextstate = doneState;
            default: nextstate = waiting;
        endcase
    //output logic
    always_comb begin
        if (state == doneState) reg_en = 0; // freeze outtput when in doneState
        else reg_en = nextRound; // when in AES process, reg_en goes high whenever we move to the next state
        
        case (state) // set round
            round1: round = 4'd1;
            round2: round = 4'd2;
            round3: round = 4'd3;
            round4: round = 4'd4;
            round5: round = 4'd5;
            round6: round = 4'd6;
            round7: round = 4'd7;
            round8: round = 4'd8;
            round9: round = 4'd9;
            round10: round = 4'd10;
            default: round = 4'd0;
        endcase
        
        if (state == round0) begin
            genRoundKey_mux = 0;
            addRoundKey_stateMux = 2'b00;
            addRoundKey_keyMux = 0;
        end

        else if (state == round1) begin 
            genRoundKey_mux = 0;
            addRoundKey_stateMux = 2'b10;
            addRoundKey_keyMux = 1;
        end

        else if (state == round10) begin
            genRoundKey_mux = 1;
            addRoundKey_stateMux = 2'b01;
            addRoundKey_keyMux = 1;
        end
        else if (state == doneState) begin
            genRoundKey_mux = 0;
            addRoundKey_stateMux = 2'b00;
            addRoundKey_keyMux = 0;
        end

        else begin
            genRoundKey_mux = 1;
            addRoundKey_stateMux = 2'b10;
            addRoundKey_keyMux = 1;
        end
    end
endmodule