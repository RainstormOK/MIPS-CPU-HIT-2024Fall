/*
 * instruction memory
 *
 * Given a 32-bit address the data is latched and driven 
 * on the rising edge of the clock.
 *
 * The lowest two bits are assumed to be byte indexes and ignored. 
 */

module im (
    input wire [31:0]   addr,
    output wire [31:0]  data,

    output wire         inst_sram_en,
    output wire [31:0]  inst_sram_addr,
    input wire [31:0]   inst_sram_rdata);

    assign inst_sram_en = 1'b1;
    assign inst_sram_addr = addr;
    assign data = inst_sram_rdata;

endmodule