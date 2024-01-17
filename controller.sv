module controller(input logic clk, input logic rst_n,
                  input logic [2:0] opcode, input logic [1:0] op,
                  input logic Z, input logic N, input logic V,
                  
                  output logic [1:0] reg_sel, output logic [1:0] wb_sel, output logic w_en,
                  output logic en_A, output logic en_B, output logic en_C, output logic en_status,
                  output logic sel_A, output logic sel_B, output logic load_pc, output logic clear_pc,
                  output logic load_ir, output logic pc_sel, output logic sel_addr, output logic load_addr
                  output logic ram_w_en);
  // your implementation here
  logic [7:0] state;
  `define START 8'b001_00000;
  `define FETCH 8'b000_00001;
  `define LOAD 8'b000_00010;
  `define MOVE 8'b000_00011;
  
  `define ALU  8'b000_00100;
  `define MEMORY 8'b000_00101;
  `define BRANCH 8'b000_00110;
  
  `define MOVEIM8 8'b000_00111;
  
  `define MOVEB 8'b000_01000;
  `define MOVEC 8'b000_01001;
  `define MOVERD 8'b000_01010;

  assign clear_pc = state[5];


  `define Rn 2'b10;
  `define Rm 2'b01;
  `define Rd 2'b00;
  
  assign clear_pc = 
  always_ff @(posedge clk) begin
    if(!rst_n) begin
      reg_sel <= 2'b11; wb_sel <= 2'b00; sel_A <= 1'b0; sel_B <= 1'b1;
      w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
      load_pc <= 1'b0; load_ir <= 1'b1;
      pc_sel <= 1'b1; sel_addr <= 1'b0; load_addr <= 1'b0;
      ram_w_en <= 1'b0;
      branch_sel <= 1'b0;
    end
    else begin
      case(state)    
        `START : begin
          reg_sel <= 2'b11; wb_sel <= 2'b00;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          sel_A <= 1'b0; sel_B <= 1'b1;
          load_pc <= 1'b0; load_ir <= 1'b1;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        `FETCH : begin
          reg_sel <= 2'b11; wb_sel <= 2'b00; sel_A <= 1'b0; sel_B <= 1'b1; 
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          load_pc <= 1'b1; load_ir <= 1'b1;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        `LOAD : begin
          reg_sel <= 2'b11; wb_sel <= 2'b00; sel_A <= 1'b0; sel_B <= 1'b1;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end
        
        // MOVE STATES 
        // MOV immediate 
        `MOVEIM8 : begin
          reg_sel <= `Rn; wb_sel <= 2'b10; sel_A <= 1'b0; sel_B <= 1'b1;
          w_en <= 1'b1; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end
        // MOV, MVN
        `MOVEB : begin
          reg_sel <= `Rm; wb_sel <= 2'b10; sel_A <= 1'b1; sel_B <= 1'b0;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b1; en_C <= 1'b0; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        `MOVEC : begin
          reg_sel <= `Rm; wb_sel <= 2'b10; sel_A <= 1'b1; sel_B <= 1'b0;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b1; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end
        
        `MOVERD : begin
          reg_sel <= `Rd; wb_sel <= 2'b00; sel_A <= 1'b1; sel_B <= 1'b0;
          w_en <= 1'b1; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b1; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end


        // ALU STATES
        
        `STOREB : begin
          reg_sel <= `Rm; wb_sel <= 2'b00; sel_A <= 1'b0; sel_B <= 1'b0;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b1; en_C <= 1'b0; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        `STOREA : begin
          reg_sel <= `Rn; wb_sel <= 2'b00; sel_A <= 1'b0; sel_B <= 1'b0;
          w_en <= 1'b0; en_A <= 1'b1; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        //ADD, AND
        `STOREC : begin
          reg_sel <= `Rn; wb_sel <= 2'b00; sel_A <= 1'b0; sel_B <= 1'b0;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b1; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        `STORERD : begin
          reg_sel <= `Rd; wb_sel <= 2'b00; sel_A <= 1'b0; sel_B <= 1'b0;
          w_en <= 1'b1; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        // CMP
        `ENSTATUS : begin
          reg_sel <= `Rn; wb_sel <= 2'b00; sel_A <= 1'b0; sel_B <= 1'b0;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b1;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end


        //LDR

        `LOADRN_TO_A : begin
          reg_sel <= `Rn; wb_sel <= 2'b00; sel_A <= 1'b0; sel_B <= 1'b1;
          w_en <= 1'b0; en_A <= 1'b1; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        `LOAD_TO_C : begin
          reg_sel <= `Rn; wb_sel <= 2'b00; sel_A <= 1'b0; sel_B <= 1'b1;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b1; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        `LOAD_TO_RAM_REG : begin
          reg_sel <= `Rd; wb_sel <= 2'b00; sel_A <= 1'b0; sel_B <= 1'b1;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          sel_addr <= 1'b1; load_addr <= 1'b1;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        `LOAD_TO_RD : begin
          reg_sel <= `Rd; wb_sel <= 2'b11; sel_A <= 1'b0; sel_B <= 1'b1;
          w_en <= 1'b1; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          sel_addr <= 1'b0; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        //STR
        //Since we need the value of register rd to put it into the memeory using
        //the value of Rn + im5, we can just store the rd value into register b,
        //and rn to register A, and then we can just switch using the mux to get imm5.
        //The cycles are ,
        //1. Store the value of rd into register B 
        //2. Store the value of rn into register A
        //3. Store the value of memory address to register C (rn + im5)
        //4. Store the value of memory address to memory register
        //5. Store the value in B into C
        //6. Store the value in C into memory address
    
        `STORERD_TO_B : begin
          reg_sel <= 2'b01; wb_sel <= 2'b00;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b1; en_C <= 1'b0; en_status <= 1'b0;
          sel_A <= 1'b0; sel_B <= 1'b1;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        `STORERN_TO_A :begin
          reg_sel <= 2'b10; wb_sel <= 2'b00;
          w_en <= 1'b0; en_A <= 1'b1; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          sel_A <= 1'b0; sel_B <= 1'b1;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        `STORE_MEMADRR_C : begin
          reg_sel <= 2'b10; wb_sel <= 2'b00;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b1; en_status <= 1'b0;
          sel_A <= 1'b0; sel_B <= 1'b1;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end 
        
        `STORE_C_TO_MEMREG : begin
          reg_sel <= 2'b11; wb_sel <= 2'b00;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          sel_A <= 1'b1; sel_B <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b1; load_addr <= 1'b1;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end
        
        `STORE_B_TO_C : begin
          reg_sel <= 2'b11; wb_sel <= 2'b00;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b1; en_status <= 1'b0;
          sel_A <= 1'b1; sel_B <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b0; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end

        `STORE_B_TO_MEM : begin
          reg_sel <= 2'b11; wb_sel <= 2'b00;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          sel_A <= 1'b0; sel_B <= 1'b1;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b0; sel_addr <= 1'b0; load_addr <= 1'b0;
          ram_w_en <= 1'b1;
          branch_sel <= 1'b0;
        end


        //BRANCH
        
        `BRANCH : begin
          reg_sel <= 2'b11; wb_sel <= 2'b00;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          sel_A <= 1'b0; sel_B <= 1'b1;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b1; sel_addr <= 1'b0; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end
        

        //BRANCH LINK
        `BRANCHLINK : begin
          reg_sel <= 2'b10; wb_sel <= 2'b01;
          w_en <= 1'b1; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0; 
          sel_A <= 1'b0; sel_B <= 1'b1;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b1; sel_addr <= 1'b0; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b0;
        end
        
        //RETURN
        `RETURN : begin
          reg_sel <= 2'b11; wb_sel <= 2'b00;
          w_en <= 1'b0; en_A <= 1'b1; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0; 
          sel_A <= 1'b0; sel_B <= 1'b1;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b1; sel_addr <= 1'b0; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
          branch_sel <= 1'b1;
        end


        //HALT
        `HALT : begin
          reg_sel <= 2'b11; wb_sel <= 2'b00; sel_A <= 1'b0; sel_B <= 1'b1;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          pc_sel <= 1'b1; sel_addr <= 1'b0; load_addr <= 1'b0;
          ram_w_en <= 1'b0;
        end

        
        default : begin
          reg_sel <= `Rd; wb_sel <= 2'b00; sel_A <= 1'b0; sel_B <= 1'b1;
          w_en <= 1'b0; en_A <= 1'b0; en_B <= 1'b0; en_C <= 1'b0; en_status <= 1'b0;
          load_pc <= 1'b0; load_ir <= 1'b0;
          sel_addr <= 1'b0; load_addr <= 1'b0;
        end
      endcase
    end
  end

  always_comb begin
    case(state)
      `START : begin
        state = `FETCH;
      end
      `FETCH : begin
        state = `LOAD;        
      end 
      `LOAD : begin
        if ({opcode, op} == 5'b110_10) begin
          state = `MOVEIM8;
        end else if ({opcode, op} == 5'b110_00) begin
          state = `START;
        end else begin
          state = `START;
        end
      end
      `MOVE : begin
        if (op == 2'b10) begin
          state = `MOVEIM8;
        end else begin
          state = `MOVEB;
        end
      end
      `MOVEIM8 : state = `START;
      `MOVEB : state = `MOVEC;
      `MOVEC : state = `MOVERD;
      default : state = `START;
    endcase
  end
endmodule: controller
