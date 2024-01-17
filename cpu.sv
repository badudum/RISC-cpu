module cpu(input clk, input rst_n, input [7:0] start_pc, output[15:0] out);
  logic [7:0] pc, next_pc. data_arr_reg;
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
                        .load_ir(load_ir),
                        .pc_sel(pc_sel),
                        .sel_addr(sel_addr),
                        .load_addr(load_addr));

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

  assign next_pc = clear_pc ? start_pc : pc_sel ? branch_sel ? pc + datapath_out[7:0] + 1  : pc + sximm8 + 1 : pc + 1; //this will select the next program counter
  // if pc_sel is 1, just add one, and if pc_sel == 0 then use the datpath's output
  
  assign ram_r_addr = sel_addr ? pc : data_arr_reg;
  assign ram_w_addr = ram_r_addr;
  assign out = datapath_out;

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
      ir <= i;
    end

    if(load_addr) begin
      data_arr_reg <= datapath_out[7:0];
    end
    else begin
      data_arr_reg <= data_arr_reg;
    end
  end
endmodule: cpu
