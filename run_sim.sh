# Compile and run Verilog files using Icarus Verilog
iverilog -o processor_sim processor.v processor_tb.v ALU/ALU.v Control/control.v
vvp processor_sim
# View waveforms using GTKWave
gtkwave processor_sim.vcd
