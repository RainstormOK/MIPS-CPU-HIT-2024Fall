module alu_control(
    input wire cmpflag,
    input wire [5:0] funct,
    input wire [1:0] aluop,
    output reg [3:0] aluctl);

    reg [3:0] _funct;
    
    always @(*) begin
        case(funct[5:0])
            6'b100000: _funct <= 4'd2;    /* add */
            6'b100010: _funct <= 4'd6;    /* sub */
            6'b100101: _funct <= 4'd1;    /* or */
            6'b100110: _funct <= 4'd13;   /* xor */
            6'b100111: _funct <= 4'd12;   /* nor */
            6'b101010: _funct <= 4'd7;    /* slt */
            6'b000000: _funct <= 4'd3;    /* sll */
            6'b001010: _funct <= 4'd4;    /* movz */
            default: _funct <= 4'd0;
        endcase   
        if (cmpflag)
            _funct <= 4'd11;
    end

    always @(*) begin
        case(aluop)
            2'd0: aluctl = 4'd2;    /* add */
            2'd1: aluctl = 4'd6;    /* sub */
            2'd2: aluctl = _funct;
            2'd3: aluctl = 4'd2;    /* add */
            default: aluctl = 0;
        endcase
    end
endmodule