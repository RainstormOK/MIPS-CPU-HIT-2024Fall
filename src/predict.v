module predict (input           clk,
                input   [31:0]  PCF, PCD,
                input           HitF, HitD,
                input           PCSrcD, JumpD,
                input   [31:0]  PCBranchD, PCJumpD,
                output  [3:0]   PCControls,
                output  [31:0]  PCCache);
    
    reg [32:0] btb [0:255];

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            btb[i] = 33'b0;
        end
    end

    assign HitF = btb[PCF[9:2]][32];
    assign PCCache = btb[PCF[9:2]][31:0];

    always @(posedge clk) begin
        if      (HitD && (~PCSrcD))     btb[PCD[9:2]] <= 33'b0;
        else if ((~HitD) && PCSrcD)     btb[PCD[9:2]] <= {1'b1, PCBranchD};
        else if ((~HitD) && JumpD)      btb[PCD[9:2]] <= {1'b1, PCJumpD};
    end

    assign PCControls = {   HitD && (~PCSrcD),
                            (~HitD) && PCSrcD,
                            (~HitD) && JumpD,
                            HitF};
endmodule