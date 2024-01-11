module shifter(input logic [15:0] shift_in, input logic [1:0] shift_op, output logic [15:0] shift_out);
  always @(*) begin
    case (shift_op)
      2'b00: shift_out = shift_in;
      2'b01: shift_out = shift_in << 1;
      2'b10: shift_out = shift_in >> 1;
      2'b11: shift_out = shift_in >>> 1;
    endcase
  end
endmodule: shifter
