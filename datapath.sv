module datapath(input logic clk, input logic [15:0] mdata, input logic [7:0] pc, input logic [1:0] wb_sel,
                input logic [2:0] w_addr, input logic w_en, input logic [2:0] r_addr, input logic en_A,
                input logic en_B, input logic [1:0] shift_op, input logic sel_A, input logic sel_B,
                input logic [1:0] ALU_op, input logic en_C, input logic en_status,
                input logic [15:0] sximm8, input logic [15:0] sximm5,
                output logic [15:0] datapath_out, output logic Z_out, output logic N_out, output logic V_out);
    
    logic [15:0] A, B, C, ALU_out, r_data, val_A, val_B, shift_B;
    logic Z, N, V;
    assign val_A = sel_A ? A : 16'b0;
    assign val_B = sel_B ? sximm5 : shift_B;
    assign datapath_out = C;
    assign w_data = wb_sel[1] ? (wb_sel[0] ? mdata : sximm8) : (wb_sel[0] ? {8'b0, pc} : datapath_out);
    
    regfile register(.clk(clk), .w_data(w_data), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .r_data(r_data));
    ALU alu(.val_A(val_A), .val_B(val_B), .ALU_out(ALU_out), .Z(Z), .N(N), .V(V));
    shifter shifter(.shift_in(B), .shift_op(shift_op), .shift_out(shift_B));

    always_ff @(posedge clk) begin
        if (en_A) begin
            A <= r_data;
        end else begin
            A <= A;
        end

        if (en_B) begin
            B <= r_data;
        end else begin
            B <= B;
        end

        if (en_C) begin
            C <= ALU_out;
        end else begin
            C <= C;
        end

        if (en_status) begin
            Z_out <= Z;
        end else begin
           Z <= Z; 
        end
    end

endmodule: datapath;