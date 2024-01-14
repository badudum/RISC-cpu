module cpu(input clk, input rst_n, input [7:0] start_pc, output[15:0] out);
  logic [7:0] pc, next_pc;
  logic [15:0] ir, ram_r_data, ram_w_data;
  
  ram ram(.clk(clk), 
          .ram_w_en(), 
          .ram_r_addr(), 
          .ram_w_addr(), 
          .ram_w_data(), 
          .ram_r_data());
          
  controller controller(.clk(clk), 
                        .rst_n(rst_n),
                        .opcode(), 
                        .ALU_op(), 
                        .shift_op(), 
                        .Z(), 
                        .N(), 
                        .V(), 
                        .waiting(), 
                        .reg_sel(),
                        .wb_sel(),
                        .w_en(),
                        .en_A(),
                        .en_B(),
                        .en_C(),
                        .en_status(),
                        .sel_A(),
                        .sel_B(),
                        .load_pc(load_pc),
                        .clear_pc(clear_pc),
                        .load_ir(load_ir));

  idecoder instructiondecoder(.ir(),
                              .reg_sel(),
                              .opcode(),
                              .ALU_op(),
                              .shift_op(),
                              .sximm5(),
                              .sximm8(),
                              .r_addr(),
                              .w_addr());

  datapath datapath(.clk(clk), 
                    .mdata(), 
                    .pc(), 
                    .wb_sel(), 
                    .w_addr(), 
                    .w_en(), 
                    .r_addr(),
                    .en_A(),
                    .en_B(),
                    .shift_op(),
                    .sel_A(),
                    .sel_B(),
                    .ALU_op(),
                    .en_C(),
                    .en_status(),
                    .sximm8(),
                    .sximm5(),
                    .datapath_out(),
                    .Z_out(),
                    .N_out(),
                    .V_out());

  assign next_pc = clear_pc ? start_pc : pc + 1;

  always_ff @(posedge clk) begin
    if (load_pc) begin
      pc <= next_pc; 
    end
    else begin
      pc <= pc;
    end

    if(load_ir) begin
      ir <= ram_r_data;
    end
    else begin
      ir <= ir;
    end
  end
endmodule: cpu
