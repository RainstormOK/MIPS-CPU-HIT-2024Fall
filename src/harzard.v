module hazard ( input       [4:0]   RsD, RtD, RsE, RtE,
                input               RegWriteE, RegWriteM, RegWriteW,
                input       [4:0]   WriteRegE, WriteRegM, WriteRegW,
                output reg  [2:0]   ForwardAD, ForwardBD,
                output reg  [1:0]   ForwardAE, ForwardBE,
                input               MemtoRegE, MemtoRegM,
                output              StallF, StallD,
                input               BranchD,
                output              FlushE, FlushD,
                input               HitF, HitD,
                input               PCSrcD, JumpD);

    always @(*) begin
        if      ((RsE != 0) && (RsE == WriteRegM) && RegWriteM)
            ForwardAE <= 2'b10;
        else if ((RsE != 0) && (RsE == WriteRegW) && RegWriteW)
            ForwardAE <= 2'b01;
        else
            ForwardAE <= 2'b00;
    end

    always @(*) begin
        if      ((RtE != 0) && (RtE == WriteRegM) && RegWriteM) 
            ForwardBE <= 2'b10;
        else if ((RtE != 0) && (RtE == WriteRegW) && RegWriteW)
            ForwardBE <= 2'b01;
        else
            ForwardBE <= 2'b00;
    end

    wire LWStall;
    assign LWStall = ((RsD == RtE) || (RtD == RtE)) && MemtoRegE;

    always @(*) begin
        if          ((RsD != 0 && RsD == WriteRegE) && RegWriteE)
            ForwardAD <= 3'b100;
        else if     ((RsD != 0) && (RsD == WriteRegM) && RegWriteM)
            ForwardAD <= 3'b010;
        else if     ((RsD != 0) && (RsD == WriteRegW) && RegWriteW)
            ForwardAD <= 3'b001;
        else
            ForwardAD <= 3'b000;
    end

    always @(*) begin
        if      ((RtD != 0) && (RtD == WriteRegE) && RegWriteE)
            ForwardBD <= 3'b100;
        else if ((RtD != 0) && (RtD == WriteRegM) && RegWriteM)
            ForwardBD <= 3'b010;
        else if ((RtD != 0) && (RtD == WriteRegW) && RegWriteW)
            ForwardBD <= 3'b001;
        else
            ForwardBD <= 3'b000;
    end

    wire BranchStall;
    assign BranchStall = BranchD && MemtoRegM && (RsD == WriteRegM || RtD == WriteRegM);

    assign {StallF, StallD,
            FlushE} = {3{LWStall || BranchStall}};
    
    assign FlushD =
                HitD && (~PCSrcD)
                    ||
                (~HitD) && PCSrcD
                    ||
                (~HitD) && JumpD;
endmodule