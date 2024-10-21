module aludec ( input       [5:0] FunctD,
                input       [1:0] ALUOpD,
                output reg  [2:0] ALUControlD);

    always @(*) begin
        case (ALUOpD)
            2'b00: ALUControlD <= 3'b010;   // add
            2'b01: ALUControlD <= 3'b110;   // sub
            2'b11: ALUControlD <= 3'b011;   // cmp
            default: case(FunctD)
                6'b100000:  ALUControlD <= 3'b010;  // ADD
                6'b100010:  ALUControlD <= 3'b110;  // SUB
                6'b100100:  ALUControlD <= 3'b000;  // AND
                6'b100101:  ALUControlD <= 3'b001;  // OR
                6'b101010:  ALUControlD <= 3'b111;  // SLT
                default:    ALUControlD <= 3'bxxx;  // ???
            endcase
        endcase
    end
endmodule