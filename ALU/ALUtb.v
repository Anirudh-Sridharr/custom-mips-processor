module alutb;
reg [3:0]               PC; 
//reg [15:0]              temp_mem[3:0]; 
//reg                     clk; 
reg [3:0]        Aluctrl; 
reg [15:0]       din1;
reg [15:0]       din2; 
// wire             zeroflag; 
wire             done; 
wire [15:0]       dout; 
wire [31:0]       mulreg; 



reg [3:0]temp_mem[15:0]; 
// initial begin 
//     $readmemb("ALUtest.mem",temp_mem);
// end

initial begin
$dumpfile("ALUtb_sim.vcd");
$dumpvars(0,alutb);
din1 = 16'hFF03;
din2 = 16'h0001;
PC = 4'b0000;
$readmemb("ALUtest.mem",temp_mem);
#300 $finish;
end

alu uut(.Aluctrl(Aluctrl), .din1(din1), .din2(din2), .done(done), .dout(dout), .mulreg(mulreg));

always #20 PC <= PC+1;

always @(PC)
begin
Aluctrl <= temp_mem[PC];
#10; 
end

assign done=1'b1;
endmodule