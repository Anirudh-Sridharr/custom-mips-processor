module alu(
input wire [3:0]        Aluctrl, 
input wire [15:0]       din1,
input wire [15:0]       din2, 
output wire             done, 
output reg [15:0]      dout 
);

reg [31:0] mulreg;
reg overflow;
reg zeroflag;
reg negativeflag;
reg signflag;



`define add  4'b0001
`define sub  4'b0010
`define mul  4'b0011
`define islt 4'b0100
`define isgt 4'b0101
`define iseq 4'b0110
`define isneq 4'b0111
`define bor  4'b1000
`define band 4'b1001
`define bxor 4'b1010
`define bnot 4'b1011
`define slli 4'b1100
`define srli 4'b1101



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
always @(Aluctrl) begin
case (Aluctrl)
        `add: 
        begin
          dout = din1 + din2;
          overflow = (din1[15] == din2[15]) && (dout[15] != din1[15]);
        end
        `sub: 
        begin
          dout = din1 - din2;
          overflow = (din1[15] != din2[15]) && (dout[15] != din1[15]);
        end
        `mul: 
        begin 
          mulreg = din1 * din2;
          dout = [15:0] mulreg;
          overflow = (mulreg[31:16] != 0); 
        end
        `islt: dout = (din1 < din2) ? 1 : 0;
        `iseq: dout = (din1 == din2) ? 1 : 0;
        `bor: dout = din1 | din2;
        `band: dout = din1 & din2;
        `bxor: dout = din1 ^ din2;
        `bnot: dout = ~din1; // Use ~ for bitwise NOT
        `slli: dout = din1 << din2;
        `srli: dout = din1 >> din2;
        // `mv:   dout = din1; // Move input 1 to output
        `isgt: dout = (din1 > din2) ? 1 : 0;
        `isneq: dout = (din1 != din2) ? 1 : 0;
        default: dout = din1; // Default case to handle unspecified Aluctrl values
    endcase
  zeroflag = (|dout);
end 
endmodule