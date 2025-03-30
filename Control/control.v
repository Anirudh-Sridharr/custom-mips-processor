`include ALU.v
module control();
//instruction register and memory
reg [31:0] IR; 
reg [31:0] inst_mem [6:0];
reg [31:0] data_mem [31:0];
reg [31:0] GPR  [4:0];
reg [15:0] dtemp;
`define opcode  IR[31:26];
`define rdst    IR[25:21];
`define rsrc1   IR[20:16];
`define rsrc2   IR[15:11]; 
`define shamt   IR[10:7]; 
`define functR  IR[6:0]; //R-type ALU code function 

`define imm     IR[15:0];
`define br_addr  IR[15:0];
`define j_addr  IR[25:0];


always @(*)
begin 
    case(opcode)
        6'b000000: // 3-reg ALU instructions  
            begin 
                Aluctrl = functR[3:0];
                casex(Aluctrl)

                    4'b00xx: begin //ADD, SUB. MUL
                        assign din1 = GPR[`rsrc1];
                        assign din2 = GPR[`rsrc2];
                        GPR[`rdst] = dout;
                    end

                    4'b10xx: begin// BOR, BAND, BXOR, BNOT
                        assign din1 = GPR[`rsrc1];
                        assign din2 = GPR[`rsrc2];
                        GPR[`rdst] = dout;
                    end 

                    4'b010x: begin// ISEQ, ISLT
                        assign din1 = GPR[`rsrc1];
                        assign din2 = GPR[`rsrc2];
                        GPR[`rdst] = dout;
                    end 

                   /* 4'b111x: begin// SLLI, SRLI
                        assign din1 = GPR[`rsrc1];
                        assign din2 = `shamt;
                        GPR[`rdst] = dout;
                    end */

                    default: begin
                        assign din1 = 0;
                        assign din2 = 0;
                        GPR[`rdst] = 0;
                    end

        6'b01xxxx: // ALU-Immmediate instructions 
            begin
                    Aluctrl = [3:0] opcode; 
                    case(Aluctrl)
                    4'b00xx: begin //ADD, SUB. MUL
                        assign din1 = GPR[`rsrc1];
                        assign din2 = IR[15:0];
                        GPR[`rdst] = dout;
                    end

                    4'b10xx: begin // BOR, BAND, BXOR, BNOT
                        assign din1 = GPR[`rsrc1];
                        assign din2 = IR[15:0];
                        GPR[`rdst] = dout;
                    end

                    4'b010x: begin // ISEQ, ISLT
                        assign din1 = GPR[`rsrc1];
                        assign din2 = IR[15:0];
                        GPR[`rdst] = dout;
                    end

                    4'b111x: begin // SLLI, SRLI
                        assign din1 = GPR[`rsrc1];
                        assign din2 = IR[15:0];
                        GPR[`rdst] = dout;
                    end
                    endcase
            end 
        //6'b001xxx: //branch instructions, hardcoded in all 8 cases
        6'b001000:// beq
            begin
                Aluctrl = 4'b0101; 
                din1 =  GPR[`rsrc1];
                din2 = GPR[`rsrc2]; 
                PC = dout?(`br_addr):(PC+4);
            end
        6'b001001:// bneq
            begin
                Aluctrl = 4'b0101; 
                din1 =  GPR[`rsrc1];
                din2 = GPR[`rsrc2]; 
                PC = dout?(PC+4):(`br_addr);
            end
        6'b001010:// bez
            begin
                Aluctrl = 4'b0101; 
                din1 =  GPR[`rsrc1];
                din2 = 16'b0; 
                PC = dout?(`br_addr):(PC+4);
            end
        6'b001011:// bnez
            begin
                Aluctrl = 4'b0101; 
                din1 =  rsrc1;
                din2 = 16'b0; 
                PC = dout?(PC+4):(br_addr);
            end

        //for blt, bgt add isgt snd islt instructions. 
        6'b001100: //blt
            begin
                Aluctrl = 4'b1101;
                din1 = GPR[`rsrc1];
                din2 = GPR[`rsrc2];
                dout = GPR[`rdst];
                PC = dout?(`br_addr):(PC+4);
            end

        6'b001101: //bgt
            begin
                Aluctrl = 4'b1100;
                din1 = GPR[`rsrc1];
                din2 = GPR[`rsrc2];
                dout = GPR[`rdst];
                PC = dout?(`br_addr):(PC+4);
            end

        6'b001110: //bgez
            begin
                Aluctrl = 4'b1100;
                din1 = GPR[`rsrc1];
                din2 = 16'b0;
                dout = GPR[`rdst];
                PC = dout?(`br_addr):(PC+4);
            end

        6'b001111: //blez
            begin
                Aluctrl = 4'b1101;
                din1 = GPR[`rsrc1];
                din2 = 16'b0;
                dout = GPR[`rdst];
                PC = dout?(`br_addr):(PC+4);
            end


                endcase
            end

    endcase 
end 
endmodule 