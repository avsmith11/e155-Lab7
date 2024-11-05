onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_aes_core/clk
add wave -noupdate /testbench_aes_core/load
add wave -noupdate /testbench_aes_core/done
add wave -noupdate /testbench_aes_core/key
add wave -noupdate /testbench_aes_core/plaintext
add wave -noupdate /testbench_aes_core/cyphertext
add wave -noupdate /testbench_aes_core/expected
add wave -noupdate /testbench_aes_core/dut/controllerFSM/addRoundKey_keyMux
add wave -noupdate /testbench_aes_core/dut/controllerFSM/genRoundKey_mux
add wave -noupdate /testbench_aes_core/dut/controllerFSM/reg_en
add wave -noupdate /testbench_aes_core/dut/controllerFSM/addRoundKey_stateMux
add wave -noupdate /testbench_aes_core/dut/controllerFSM/round
add wave -noupdate /testbench_aes_core/dut/controllerFSM/done
add wave -noupdate /testbench_aes_core/dut/controllerFSM/nextRound
add wave -noupdate /testbench_aes_core/dut/controllerFSM/state
add wave -noupdate /testbench_aes_core/dut/controllerFSM/nextstate
add wave -noupdate /testbench_aes_core/dut/bufferedPlaintext
add wave -noupdate /testbench_aes_core/dut/bufferedKey
add wave -noupdate /testbench_aes_core/dut/previousKey
add wave -noupdate /testbench_aes_core/dut/nextRoundKey
add wave -noupdate -itemcolor Yellow /testbench_aes_core/dut/roundKey
add wave -noupdate -itemcolor Yellow /testbench_aes_core/dut/shiftRowsIn
add wave -noupdate -itemcolor Yellow /testbench_aes_core/dut/shiftRowsOut
add wave -noupdate /testbench_aes_core/dut/mixColumnsOut
add wave -noupdate -itemcolor Yellow /testbench_aes_core/dut/addRoundKeyIn
add wave -noupdate /testbench_aes_core/dut/addRoundKeyOut
add wave -noupdate -color Magenta -itemcolor Magenta /testbench_aes_core/dut/roundOut
add wave -noupdate /testbench_aes_core/dut/round
add wave -noupdate -radix binary /testbench_aes_core/dut/addRoundKey_stateMux
add wave -noupdate /testbench_aes_core/dut/addRoundKey_keyMux
add wave -noupdate /testbench_aes_core/dut/genRoundKey_mux
add wave -noupdate /testbench_aes_core/dut/reg_en
add wave -noupdate /testbench_aes_core/dut/nextRound
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {239 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 373
configure wave -valuecolwidth 238
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {116 ns} {1047 ns}
