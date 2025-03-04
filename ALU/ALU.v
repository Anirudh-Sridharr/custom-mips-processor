module alu(
input wire [3:0]        Aluctrl, 
input wire [15:0]       din1,
input wire [15:0]       din2, 
output wire             done, 
output reg [15:0]      dout 
);

reg [31:0] mulreg;

`define add  4'b0001
`define sub  4'b0010
`define mul  4'b0011
`define islt 4'b0100
`define iseq 4'b0101
`define bor  4'b0110
`define band 4'b0111
`define mv   4'b1000
`define bxor 4'b1001
`define bnot 4'b1010
`define slli 4'b1011
`define srli 4'b1110
// `define slai 4'b1100;
// `define srai 4'b1101;
// below code is just for testing the alu alone, ALUtest.mem need not bear any relevance later
// reg [3:0]temp_mem[15:0]; 
// initial begin 
//     $readmemb("ALUtest.mem",temp_mem);
// end
//input reg clk;
// input wire [3:0]        Aluctrl; 
// input wire [15:0]       din1;
// input wire [15:0]       din2; 
// // output reg zeroflag; 
// output wire done; 
// output reg [15:0]      dout; 
always @(*) begin
case (Aluctrl)
        `add: dout = din1 + din2;
        `sub: dout = din1 - din2;
        `mul: begin 
                mulreg = din1 * din2;
                dout = [15:0] mulreg;
              end
        `islt: dout = (din1 > din2) ? 0 : 1;
        `iseq: dout = (din1 == din2) ? 1 : 0;
        `bor: dout = din1 | din2;
        `band: dout = din1 & din2;
        `bxor: dout = din1 ^ din2;
        `bnot: dout = ~din1; // Use ~ for bitwise NOT
        `slli: dout = din1 << din2;
        `srli: dout = din1 >> din2;
        `mv:   dout = din1; // Move input 1 to output
        default: dout = din1; // Default case to handle unspecified Aluctrl values
    endcase
// zeroflag = (|dout);
end 
endmodule