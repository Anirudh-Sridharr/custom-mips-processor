// Main processor module implementing a non-pipelined MIPS-like architecture

`include "Control/control.v"
`include "ALU/ALU.v"
`include "decode.v"

module processor(
    input wire clk,
    input wire reset,
    output wire [31:0] debug_pc,
    output wire [31:0] debug_inst,
    output wire [15:0] debug_alu_out
);

// Internal registers
reg [31:0] PC;
reg [31:0] IR;
reg [31:0] inst_mem [255:0];
reg [31:0] data_mem [255:0];
reg [31:0] GPR [31:0];

// Decoded instruction fields
wire [4:0] rdst, rsrc1, rsrc2;
wire [15:0] imm;
wire [6:0] functR;
wire [5:0] opcode;

// Control signals
wire [3:0] Aluctrl;
wire RegWrite, MemWrite, Branch;
wire [1:0] ALUSrc;

// ALU inputs/outputs
reg [15:0] alu_in1, alu_in2;
wire [15:0] alu_out;
wire alu_done;

// Instantiate decode unit
decode_unit decoder(
    .IR(IR),
    .rdst(rdst),
    .rsrc1(rsrc1),
    .rsrc2(rsrc2),
    .imm(imm),
    .functR(functR),
    .opcode(opcode)
);

// Instantiate control unit
control_unit ctrl(
    .opcode(opcode),
    .functR(functR),
    .Aluctrl(Aluctrl),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .ALUSrc(ALUSrc)
);

// Instantiate ALU
alu alu_unit(
    .Aluctrl(Aluctrl),
    .din1(alu_in1),
    .din2(alu_in2),
    .done(alu_done),
    .dout(alu_out)
);

// Debug outputs
assign debug_pc = PC;
assign debug_inst = IR;
assign debug_alu_out = alu_out;

// Initialize memories and registers
initial begin
    PC = 32'b0;
    $readmemh("inst_mem.hex", inst_mem);
    for (integer i = 0; i < 256; i = i + 1)
        data_mem[i] = 32'b0;
    for (integer i = 0; i < 32; i = i + 1)
        GPR[i] = 32'b0;
end

// Main processor cycle
always @(posedge clk or posedge reset) begin
    if (reset) begin
        PC <= 32'b0;
        IR <= 32'b0;
    end else begin
        // Fetch
        IR <= inst_mem[PC[7:0]];

        // Decode and select ALU inputs
        case (ALUSrc)
            2'b00: begin // reg-reg
                alu_in1 <= GPR[rsrc1][15:0];
                alu_in2 <= GPR[rsrc2][15:0];
            end
            2'b01: begin // reg-imm
                alu_in1 <= GPR[rsrc1][15:0];
                alu_in2 <= imm;
            end
            2'b10: begin // branch (comparison)
                alu_in1 <= GPR[rsrc1][15:0];
                alu_in2 <= GPR[rsrc2][15:0];
            end
            default: begin
                alu_in1 <= 16'b0;
                alu_in2 <= 16'b0;
            end
        endcase

        // Writeback
        if (RegWrite)
            GPR[rdst] <= {16'b0, alu_out}; // Write ALU result to destination register
        if (MemWrite)
            data_mem[GPR[rdst]] <= GPR[rsrc1]; // Example: store operation

        // Branch/PC update
        if (Branch)
            PC <= alu_out[0] ? PC + {{16{imm[15]}}, imm} : PC + 4;
        else
            PC <= PC + 4;
    end
end

endmodule