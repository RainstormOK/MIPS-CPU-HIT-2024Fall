module alumod (input       [31:0]  a, b,
            input       [2:0]   alucontrol,
            output reg  [31:0]  result);
    
    wire [31:0] cmp, sll;
    wire eq, neq, lt, lte, gt, gte, slt, slte, sgt, sgte;

    assign sll = (a < b);

    comparators #(32) c (   a, b,
                            eq, neq,
                            lt, lte, 
                            gt, gte, 
                            slt, slte,
                            sgt, sgte);
    
    assign cmp[31:10] = 22'b0;
    assign cmp[4:0] = {lte, slte, lt, slt, eq};
    assign cmp[9:5] = ~cmp[4:0];

    always @(*) begin
        case (alucontrol)
            3'b000: result <= a & b;    
            3'b001: result <= a | b;    
            3'b010: result <= a + b;    // add
            3'b011: result <= cmp;
            3'b110: result <= a - b;    // sub
            3'b111: result <= sll;
        endcase
    end
endmodule