# custom-mips-processor
A rudimentary 32 bit mips processor,being made just for practice.

>[!Note]
>this project is under progress. 


## 32-bit Instructions: 
All ALU operations supported for instructions involving 3 registers[rdst, rsrc1, rsrc2] and instructions having 2 registers and an immediate[rdst, rsrc1, imm]
Branch instructions are computed and executed by the control unit passing arguments to the ALU in one of the above mentioned formats and then updating PC accordingly

### instructions formats: 
