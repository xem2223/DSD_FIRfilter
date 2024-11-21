module FSM(
    input iClk12M, iRsn, iEnSample600k,
    input iCoeffUpdateFlag,
    input iCsnRam, iWrnRam,
    input [5:0] iAddrRam,
    input [15:0] iWtDtRam,
    //input [5:0] iNumOfCoeff, //Not used in this project

    // To SpSram
    output reg oCsnRam, oWrnRam,
    output reg [3:0] oAddrRam,
    output reg [1:0] oModuleSel, //[5:4] iAddr
    output reg [15:0] oWtDtRam,
    // To MAC
    output reg oEnMul,
    output reg oEnAddAcc,
    //EnDelay
    output reg oEnDelay
);

parameter   p_Idle = 2'b00,
            p_Update = 2'b01,
            p_MemRd = 2'b10,
            p_Out = 2'b11;
/* State Params = {iCoeffUpdateFlag: C, wLastRd: L}

                Next cycle
else <=> p_Idle<----------------p_Out
            |                   ^
        C=1 |                   | L=1
            Y       C=0         |
else <=> p_Update------------>p_MemRd <=> else

*/

reg [1:0] rCurState, rNxtState;
reg [3:0] rAddrRam; // Sequential address counter, Max = 10

// Last address check with explicit condition
wire wLastRd;
assign wLastRd = (rAddrRam == 4'HA) ? 1'b1 : 1'b0;

// State register
always @(posedge iClk12M) begin
    if(!iRsn)
        rCurState <= p_Idle;
    else
        rCurState <= rNxtState;
end

// Next state logic
always @(*) begin
    case(rCurState)
        p_Idle: begin
            if(iCoeffUpdateFlag)
                rNxtState = p_Update;
            else
                rNxtState = p_Idle;
        end
        
        p_Update: begin
            if(!iCoeffUpdateFlag)
                rNxtState = p_MemRd;
            else
                rNxtState = p_Update;
        end
        
        p_MemRd: begin
            if(wLastRd)
                rNxtState = p_Out;
            else
                rNxtState = p_MemRd;
        end
        
        p_Out: begin
            rNxtState = p_Idle;
        end
        
        default: rNxtState = p_Idle;
    endcase
end

// Address controler
always @(posedge iClk12M) begin
    if(!iRsn) begin
        rAddrRam <= 4'b0000; // Max addr = 9
    end
    else begin
        // Initial condition
        if(rCurState == p_Out || rCurState == p_Idle) begin
            rAddrRam <= 4'd0;
        end
        // Update & Memory read condition
        else if(rCurState == p_Update || rCurState == p_MemRd) begin
            if(!wLastRd)
                rAddrRam <= rAddrRam + 4'd1;
            else
                rAddrRam <= 4'd0;
        end
    end
end

// Module selection and data input
always @(posedge iClk12M) begin
    if(!iRsn) begin
        oModuleSel <= 2'b00;
        oWtDtRam <= 16'h0000;
    end
    else begin
        oModuleSel <= iAddrRam[5:4];
        oWtDtRam <= iWtDtRam;
    end
end

// Control signals
always @(*) begin
    // Default values
    oCsnRam = 1'b1;
    oWrnRam = 1'b1;
    oAddrRam = rAddrRam;
    oEnMul = 1'b0;
    oEnAddAcc = 1'b0;
    oEnDelay = 1'b0;
    
    case(rCurState)
        p_Update: begin
            oCsnRam = 1'b0;
            oWrnRam = 1'b0;
        end
        p_MemRd: begin
            oCsnRam = 1'b0;
            oWrnRam = 1'b1;
            oEnMul = 1'b1;
            oEnAddAcc = 1'b1;
            oEnDelay = 1'b1;
        end
        p_Out: begin
            oEnAddAcc = 1'b1;
        end
    endcase
end

endmodule