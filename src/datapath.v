module datapath (   input           clk, reset,
                    input   [31:0]  InstrF,
                    output  [31:0]  InstrD,
                    input           MemtoRegW, MemWriteM,
                    input           PCSrcD, ALUSrcE,
                    input           RegDstE,
                    input                       RegWriteW,
                    input           JumpD,
                    input   [2:0]   ALUControlE,
                    output  [4:0]       RsD, RtD, RsE, RtE,
                    input               RegWriteE, RegWriteM,
                    output  [4:0]       WriteRegE, WriteRegM, WriteRegW,
                    input   [2:0]       ForwardAD, ForwardBD,
                    input   [1:0]       ForwardAE, ForwardBE,
                    input               MemtoRegE, MemtoRegM,
                    input               StallF, StallD,
                    input                       BranchD,
                    input               FlushE, FlushD,
                    output                  ConditionD,
                    output  [31:0]                  WriteDataM,
                    input   [31:0]                  ReadDataM,
                    output  [31:0]                  PCF,
                    output  [31:0]                      PCW,
                    output  [31:0]                      ResultW, ALUOutM,
                    output  [31:0]                          PCD,
                    output  [31:0]                          PCBranchD, PCJumpD, 
                    input   [31:0]                          PCControls,
                    input   [31:0]                          PCCache);
    
	wire [31:0] PCPlus4F, PCBranchD, PCJumpD, PC;
    mux5 #(32) muxPC (  PCPlus4F, PCCache, PCJumpD, PCBranchD, PCPlus4D,
                        PCControls,
                        PC);
    
	wire [31:0] PCF;
    assign PCPlus4F = PCF + 4;

	wire [4:0] RdD;
    assign {RsD, RtD, RdD} = InstrD[25:11];

	wire [31:0] RsDataD, RtDataD, RsDataPD, RtDataPD;
    regfile rf (clk,
                RegWriteW,
                RsD, RtD, WriteRegW,
                ResultW,
                RsDataPD, RtDataPD);

	wire [31:0] SignImmD, PCBranchD, PCJumpD, PCPlus4D;
    assign SignImmD = {{16{InstrD[15]}},InstrD[15:0]};
    assign PCBranchD = PCPlus4D + (SignImmD << 2);
    assign PCJumpD = {PCPlus4D[31:28], InstrD[25:0], 2'b00};

	wire [31:0] ALUOutM;
    mux4 #(32) muxCompareDataA (RsDataPD, ResultW, ALUOutM, ALUOutE,
                                ForwardAD,
                                RsDataD);
    mux4 #(32) muxCompareDataB (RtDataPD, ResultW, ALUOutM, ALUOutE,
                                ForwardBD,
                                RtDataD);

    branchcond bc ( InstrD[31:26],
                    ConditionD,
                    RsDataD, RtDataD,
                    RtD);
    
	wire [31:0] RsDataE, SrcAE, RtDataE, SrcBPE, SignImmE, SrcBE;
    mux3 #(32) muxSrcAE (   RsDataE, ResultW, ALUOutM,
                            ForwardAE,
                            SrcAE);
    mux3 #(32) muxSrcBPE (  RtDataE, ResultW, ALUOutM,
                            ForwardBE,
                            SrcBPE);
    mux2 #(32) muxSrcBE (   SrcBPE, SignImmE,
                            ALUSrcE,
                            SrcBE);
    
	wire [31:0] ALUOutE;
    alumod am (	SrcAE, SrcBE,
            	ALUControlE,
            	ALUOutE);
    
	wire [4:0] RdE;
    mux2 #(5) muxWriteRegE (RtE, RdE,
                            RegDstE,
                            WriteRegE);
    
	wire [31:0] AluOutW, ReadDataW;
    mux2 #(32) muxResultW ( AluOutW, ReadDataW,
                            MemtoRegW,
                            ResultW);

    flopenr #(32) wf (  clk, reset, ~StallF,
                        PC,
                        PCF);    
    
	wire [31:0] PCD, PCE, PCM;
    flopenrc #(96) fd ( clk, reset, FlushD, ~StallD,
                        {InstrF, PCPlus4F, PCF},
                        {InstrD, PCPlus4D, PCD});
    
    floprc #(143) de (   clk, reset, FlushE,
                        {RsDataD, RtDataD, RsD, RtD, RdD, SignImmD, PCD},
                        {RsDataE, RtDataE, RsE, RtE, RdE, SignImmE, PCE});
    
	wire [31:0] WriteDataE;
    flopr #(101) em (clk, reset,
                    {ALUOutE, WriteDataE, WriteRegE, PCE},
                    {ALUOutM, WriteDataM, WriteRegM, PCM});

    flopr #(101) mw (clk, reset,
                    {ReadDataM, ALUOutM, WriteRegM, PCM},
                    {ReadDataW, AluOutW, WriteRegW, PCW});
endmodule