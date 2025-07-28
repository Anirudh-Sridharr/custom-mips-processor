// Instruction Decode Unit for RISC Processor
// Extracts register indices and immediate values from instruction
module decode_unit(
    input wire [31:0] IR,
    output wire [4:0] rdst,
    output wire [4:0] rsrc1,
    output wire [4:0] rsrc2,
    output wire [15:0] imm,
    output wire [6:0] functR,
    output wire [5:0] opcode
);
    assign opcode  = IR[31:26];
    assign rdst    = IR[25:21];
    assign rsrc1   = IR[20:16];
    assign rsrc2   = IR[15:11];
    assign imm     = IR[15:0];
    assign functR  = IR[6:0];
endmodule

// This module should be instantiated in processor.v and used to select registers and immediates for ALU and control.
