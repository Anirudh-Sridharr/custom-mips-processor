begin 

// Control Unit for RISC Processor
// Only generates control signals based on opcode and funct fields
module control_unit(
    input wire [5:0] opcode,
    input wire [6:0] functR,
    output reg [3:0] Aluctrl,
    output reg RegWrite,
    output reg MemWrite,
    output reg Branch,
    output reg [1:0] ALUSrc // 0: reg-reg, 1: reg-imm, 2: branch
);

always @(*) begin
    // Default values
    Aluctrl = 4'b0000;
    RegWrite = 0;
    MemWrite = 0;
    Branch = 0;
    ALUSrc = 2'b00;

    case (opcode)
        6'b000000: begin // R-type ALU instructions
            Aluctrl = functR[3:0];
            RegWrite = 1;
            ALUSrc = 2'b00;
        end
        6'b010000, 6'b010001, 6'b010010, 6'b010011, 6'b010100, 6'b010101: begin // I-type ALU instructions
            Aluctrl = opcode[3:0];
            RegWrite = 1;
            ALUSrc = 2'b01;
        end
        6'b100000: begin // Memory write
            MemWrite = 1;
            ALUSrc = 2'b01;
        end
        6'b001000, 6'b001001, 6'b001010, 6'b001011, 6'b001100, 6'b001101, 6'b001110, 6'b001111: begin // Branches
            Branch = 1;
            ALUSrc = 2'b10;
            // Aluctrl can be set for comparison
            Aluctrl = 4'b0110; // Example: ISEQ for beq/bneq
        end
        default: begin
            // NOP or undefined
            Aluctrl = 4'b0000;
            RegWrite = 0;
            MemWrite = 0;
            Branch = 0;
            ALUSrc = 2'b00;
        end
    endcase
end
endmodule