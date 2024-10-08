module alu_me (
    input [3:0]         ctl,
    input [31:0]        a, b,
    input [4:0]         sa,
    output wire         movz_filter,
    output reg [31:0]   out,
    output              zero);

    wire [31:0] sub_ab;
    wire [31:0] add_ab;
    wire        oflow_add;
    wire        oflow_sub;
    wire        oflow;
    wire        slt;

    assign zero = (0 == out);

    assign sub_ab = a - b;
    assign add_ab = a + b;

    // overflow occurs (with 2s complement numbers) when
    // the operands have the same sign, but the sign of the result is 
    // different. The actual sign is the opposite of the result.
    // It is also dependent on whether addition or subtraction is performed.
    assign oflow_add = (a[31] == b[31] && add_ab[31] != a[31]) ? 1 : 0;
    assign oflow_sub = (a[31] == b[31] && sub_ab[31] != a[31]) ? 1 : 0;

    assign oflow = (ctl == 4'b0010) ? oflow_add : oflow_sub;

    // set if less then, 2s compliment 32-bit numbers
    assign slt = oflow_sub ? ~(a[31]) : a[31];

    assign movz_filter = (b != 0 && ctl == 4'd4) ? 1'b0 : 1'b1; 

    always @(*) begin
        case (ctl)
            4'd2:  out <= add_ab;               /* add */
            4'd0:  out <= a & b;                /* and */
            4'd12: out <= ~(a | b);             /* nor */
            4'd1:  out <= a | b;                /* or */
            4'd7:  out <= {{31{1'b0}}, slt};    /* slt */
            4'd6:  out <= sub_ab;               /* sub */
            4'd13: out <= a ^ b;                /* xor */
            4'd3:  out <= b << {27'b0, sa};     /* sll */
            4'd4:  out <= a;                    /* movz */
            4'd11: out <= cmp;                  /* cmp */
            default: out <= 0;
        endcase
    end

    reg [31:0] cmp;
    always @ (*) begin
        if ($signed(a) == $signed(b)) begin
            cmp[0] <= 1'b1;
        end
        else begin
            cmp[0] <= 1'b0;
        end

        if ($signed(a) < $signed(b)) begin
            cmp[1] <= 1'b1;
        end
        else begin
            cmp[1] <= 1'b0;
        end

        if ($unsigned(a) < $unsigned(b)) begin
            cmp[2] <= 1'b1;
        end
        else begin
            cmp[2] <= 1'b0;
        end

        if ($signed(a) <= $signed(b)) begin
            cmp[3] <= 1'b1;
        end
        else begin
            cmp[3] <= 1'b0;
        end

        if ($unsigned(a) <= $unsigned(b)) begin
            cmp[4] <= 1'b1;
        end
        else begin
            cmp[4] <= 1'b0;
        end

        cmp[9:5] <= ~cmp[4:0];
        cmp[31:10] <= 22'b0;
    end

endmodule