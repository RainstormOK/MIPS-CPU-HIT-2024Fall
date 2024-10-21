module cpu (input           clk,
            input           resetn,
            output              inst_sram_en,
            output  [31:0]      inst_sram_addr,
            input   [31:0]      inst_sram_rdata,
            output                  data_sram_en,
            output  [3:0]           data_sram_wen,
            output  [31:0]          data_sram_addr,
            output  [31:0]          data_sram_wdata,
            input   [31:0]          data_sram_rdata,
            output  [31:0]  debug_wb_pc,
            output          debug_wb_rf_wen,
            output  [4:0]   debug_wb_rf_wnum,
            output  [31:0]  debug_wb_rf_wdata);
    
    wire stall;
    reg cnt;
    
    mips mips ( clk, ~resetn,
                inst_sram_addr,
                inst_sram_rdata,
                data_sram_wen,
                data_sram_addr, data_sram_wdata,
                data_sram_rdata,
                    debug_wb_pc,
                    debug_wb_rf_wen_p,
                    debug_wb_rf_wnum,
                    debug_wb_rf_wdata);
    
    assign {inst_sram_en, data_sram_en} = 2'b11;
    assign debug_wb_rf_wen = debug_wb_rf_wen_p & (debug_wb_rf_wnum != 0);

endmodule