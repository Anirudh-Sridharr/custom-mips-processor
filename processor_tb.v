// Testbench for the main processor
module processor_tb;

// Testbench signals
reg clk;
reg reset;
wire [31:0] debug_pc;
wire [31:0] debug_inst;
wire [15:0] debug_alu_out;

// Instantiate the processor
processor uut(
    .clk(clk),
    .reset(reset),
    .debug_pc(debug_pc),
    .debug_inst(debug_inst),
    .debug_alu_out(debug_alu_out)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    // Set up waveform dumping
    $dumpfile("processor_sim.vcd");
    $dumpvars(0, processor_tb);
    
    // Initialize inputs
    reset = 1;
    
    // Wait 100 ns for global reset
    #100;
    reset = 0;
    
    // Run for some cycles
    #1000;
    
    // End simulation
    $finish;
end

// Monitor changes
always @(posedge clk) begin
    $display("Time=%0t PC=%0h Inst=%0h ALU_out=%0h", 
             $time, debug_pc, debug_inst, debug_alu_out);
end

endmodule
