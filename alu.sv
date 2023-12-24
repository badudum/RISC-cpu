module ALU(input logic [15:0] val_A, input logic [15:0] val_B, input logic [1:0] ALU_op, output logic [15:0] ALU_out, output logic Z);


  always @(*) begin
    case (ALU_op)
      2'b00: ALU_out = val_A + val_B;
      2'b01: ALU_out = val_A - val_B;
      2'b10: ALU_out = val_A & val_B;
      2'b11: ALU_out = val_A | val_B;
    endcase
    if (ALU_out == 0) begin
      Z = 1;
    end else begin
      Z = 0;
    end
  end
  
endmodule: ALU
