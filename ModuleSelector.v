module ModuleSelector(
    input [1:0] iModuleSel,
    // Sig to SpSram
    input iCsnRam, iWrnRam,
    input [3:0] iAddrRam,
    input [15:0] iWtDtRam,
    // Sig to MAC
    input iEnMul, iEnAddAcc,

    // Sig to SpSram
    output oCsnRam1, oCsnRam2, oCsnRam3, oCsnRam4,
    output oWrnRam1, oWrnRam2, oWrnRam3, oWrnRam4, 
    output [3:0] oAddrRam1, oAddrRam2, oAddrRam3, oAddrRam4,
    output [15:0] oWtDtRam1, oWtDtRam2, oWtDtRam3, oWtDtRam4,
    // Sig to MAC
    output oEnMul1, oEnMul2, oEnMul3, oEnMul4, 
    output oEnAddAcc1, oEnAddAcc2, oEnAddAcc3, oEnAddAcc4
);

assign oCsnRam1 = (iModuleSel == 2'b00) ? iCsnRam : 1'b1;
assign oCsnRam2 = (iModuleSel == 2'b01) ? iCsnRam : 1'b1;
assign oCsnRam3 = (iModuleSel == 2'b10) ? iCsnRam : 1'b1;
assign oCsnRam4 = (iModuleSel == 2'b11) ? iCsnRam : 1'b1;

assign oWrnRam1 = (iModuleSel == 2'b00) ? iWrnRam : 1'b1;
assign oWrnRam2 = (iModuleSel == 2'b01) ? iWrnRam : 1'b1;
assign oWrnRam3 = (iModuleSel == 2'b10) ? iWrnRam : 1'b1;
assign oWrnRam4 = (iModuleSel == 2'b11) ? iWrnRam : 1'b1;

assign oAddrRam1 = (iModuleSel == 2'b00) ? iAddrRam : 4'b0000;
assign oAddrRam2 = (iModuleSel == 2'b01) ? iAddrRam : 4'b0000;
assign oAddrRam3 = (iModuleSel == 2'b10) ? iAddrRam : 4'b0000;
assign oAddrRam4 = (iModuleSel == 2'b11) ? iAddrRam : 4'b0000;

assign oWtDtRam1 = (iModuleSel == 2'b00) ? iWtDtRam : 16'h0000;
assign oWtDtRam2 = (iModuleSel == 2'b01) ? iWtDtRam : 16'h0000;
assign oWtDtRam3 = (iModuleSel == 2'b10) ? iWtDtRam : 16'h0000;
assign oWtDtRam4 = (iModuleSel == 2'b11) ? iWtDtRam : 16'h0000;

assign oEnMul1 = (iModuleSel == 2'b00) ? iEnMul : 1'b0;
assign oEnMul2 = (iModuleSel == 2'b01) ? iEnMul : 1'b0;
assign oEnMul3 = (iModuleSel == 2'b10) ? iEnMul : 1'b0;
assign oEnMul4 = (iModuleSel == 2'b11) ? iEnMul : 1'b0;

assign oEnAddAcc1 = (iModuleSel == 2'b00) ? iEnAddAcc : 1'b0;
assign oEnAddAcc2 = (iModuleSel == 2'b01) ? iEnAddAcc : 1'b0;
assign oEnAddAcc3 = (iModuleSel == 2'b10) ? iEnAddAcc : 1'b0;
assign oEnAddAcc4 = (iModuleSel == 2'b11) ? iEnAddAcc : 1'b0;
/*
always @(*) begin
    //default
    {oCsnRam1, oCsnRam2, oCsnRam3, oCsnRam4} = 4'b1111;
    {oWrnRam1, oWrnRam2, oWrnRam3, oWrnRam4} = 4'b1111;
    {oAddrRam1, oAddrRam2, oAddrRam3, oAddrRam4} = {4{4'b0000}};
    {oWtDtRam1, oWtDtRam2, oWtDtRam3, oWtDtRam4} = {4{16'h0000}};
    {oEnMul1, oEnMul2, oEnMul3, oEnMul4} = 4'b0000;
    {oEnAddAcc1, oEnAddAcc2, oEnAddAcc3, oEnAddAcc4} = 4'b0000;
    case (iModuleSel)
        2'b00: begin
            oCsnRam1 <= iCsnRam;
            oWrnRam1 <= iWrnRam;
            oAddrRam1 <= iAddrRam;
            oWtDtRam1 <= iWtDtRam;
            oEnMul1 <= iEnMul;
            oEnAddAcc1 <= iEnAddAcc;
        end
        2'b01: begin
            oCsnRam2 <= iCsnRam;
            oWrnRam2 <= iWrnRam;
            oAddrRam2 <= iAddrRam;
            oWtDtRam2 <= iWtDtRam;
            oEnMul2 <= iEnMul;
            oEnAddAcc2 <= iEnAddAcc;
        end
        2'b10: begin
            oCsnRam3 <= iCsnRam;
            oWrnRam3 <= iWrnRam;
            oAddrRam3 <= iAddrRam;
            oWtDtRam3 <= iWtDtRam;
            oEnMul3 <= iEnMul;
            oEnAddAcc3 <= iEnAddAcc;
        end
        2'b11: begin
            oCsnRam4 <= iCsnRam;
            oWrnRam4 <= iWrnRam;
            oAddrRam4 <= iAddrRam;
            oWtDtRam4 <= iWtDtRam;
            oEnMul4 <= iEnMul;
            oEnAddAcc4 <= iEnAddAcc;
        end
    endcase
end
*/
endmodule