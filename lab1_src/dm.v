/*
 * Data Memory
 *
 * 32-bit data with a 32-bit address
 * 
 * The read and write operations operate somewhat independently.
 *
 * Any time the read signal (rd) is high the data stored at the 
 * given address (addr) will be placed on 'rdata'.
 *
 * Any time the write signal (wr) is high the data on 'wdata' will
 * be stored at the given address (addr).
 *
 * If a simultaneous read/write is performed the data written
 * can be immediately read out.
 */

module dm (
    input wire [6:0]   addr,
    input wire          rd, wr,
    input wire [31:0]   wdata,
    output wire [31:0]  rdata,

    output wire         data_sram_en,
    output reg          data_sram_wen,
    output wire [31:0]  data_sram_addr,
    output wire [31:0]  data_sram_wdata,
    input wire [31:0]   data_sram_rdata);

    assign data_sram_addr = {23'b0, addr, 2'b0};
    assign data_sram_wdata = wdata;
    assign data_sram_en = 1'b1;

    always @(*) begin
        if (wr) begin
            data_sram_wen <= 1'b1;
        end else begin
            data_sram_wen <= 1'b0;
        end
    end

    assign rdata = wr ? wdata : data_sram_rdata;
    // During a write, avoid the one cycle delay by reading from 'wdata'.

endmodule