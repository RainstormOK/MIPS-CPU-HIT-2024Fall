module branchcond ( input   [5:0]   OpD,
                    output          ConditionD,
                    input   [31:0]  RsDataD, RtDataD,
                    input   [4:0]   RtD);
    
    assign ConditionD = 
                    (OpD == 6'b000100) && (RsDataD == RtDataD)      // bne
                        ||
                    (OpD == 6'b111111) && (RsDataD[RtD] == 1'b1);   // bbt
endmodule