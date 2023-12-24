module idecoder(input logic [15:0] ir, input logic [1:0] reg_sel,
                output logic [2:0] opcode, output logic [1:0] ALU_op, output logic [1:0] shift_op,
		output logic [15:0] sximm5, output logic [15:0] sximm8,
                output logic [2:0] r_addr, output logic [2:0] w_addr);
        
        logic [2:0] Rn, Rd, Rm;

        assign Rn = ir[10:8];
        assign Rd = ir[7:5];
        assign Rm = ir[2:0];

        always @(*) begin
                opcode = ir[15:13];
                ALU_op = ir[12:11];
                sximm5 = {{11{ir[4]}}, ir[4:0]};
                sximm8 = {{8{ir[7]}}, ir[7:0]};
                shift_op = ir[4:3];
                r_addr = reg_sel[1] ? Rn : reg_sel[0] ? Rd : Rm;
                w_addr = r_addr; 
        end
        
endmodule: idecoder
 