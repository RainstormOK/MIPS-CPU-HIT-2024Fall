module comparators #(parameter WIDTH = 8)
                    (   input [WIDTH-1:0]   a, b,
                        output              eq, neq,
                        output              lt, lte, 
                        output              gt, gte,
                        output              slt, slte,
                        output              sgt, sgte);
    
    wire signed [WIDTH-1:0] sa, sb;
    assign {sa, sb} = {$signed(a), $signed(b)};
    
    assign {eq, neq} =      {(a == b), (a != b)};
    assign {lt, lte} =      {(a < b), (a <= b)};
    assign {gt, gte} =      {(a > b), (a >= b)};
    assign {slt, slte} =    {(sa < sb), (sa <= sb)};
    assign {sgt, sgte} =    {(sa > sb), (sa >= sb)};
endmodule