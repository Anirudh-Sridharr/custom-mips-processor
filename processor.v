`include control.v 
`include ALU.v

module processor(
//input ports 
input wire din1,
input wire din2,
input wire Aluctrl, 

    
    
    
    
     );
reg clk;
reg reset;
// instantiate control unit
//instantiate ALU 


reg mulreg[31:0];
reg [15:0] din1, din2;
reg [3:0] Aluctrl;

//ALU variables 
reg [31:0] mulreg;
reg overflow;
reg zeroflag;
reg negativeflag;
reg signflag;
reg carryflag;
reg parityflag;

//control unit variables 
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


always @(posedge clk or posedge reset) 
begin
    if(reset) begin 
        PC = 0; 
        IR = 32'b0; 
    end 
    else begin
    data_mem[PC] = IR;   
    end 
end 

endmodule 