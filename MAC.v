module MAC(
    input iClk12M, iRsn,
    // Add&ACC enable together @ timing diagram
    input iEnMul, iEnAddAcc, // Enable at 1, group add & acc
    input signed [2:0] iDelay, // Delay chain input
    input signed [15:0] iCoeff, // Coeff from SpSram output

    output [15:0] oMac
);

wire signed [15:0] wMulResult;
reg signed [15:0] rAccOut;
reg signed [15:0] rMul;
wire signed [15:0] wAccSum;
wire wSatFlagP, wSatFlagN; //Saturation check flag
wire [15:0] wAccNext; //Next accumulation check

assign wMulResult = iDelay * iCoeff; //Get delay*coeff
// 1 if current (Acc MSB)==0 && (Mul MSB)==0, but (adding result) == 1
assign wAccSum = rAccOut + rMul;
assign wSatFlagP = (!rAccOut[15] && !rMul[15] && wAccSum[15]) ? 1'b1 : 1'b0;
assign wSatFlagN = (rAccOut[15] && rMul[15] && !wAccSum[15]) ? 1'b1 : 1'b0;
assign wAccNext = wSatFlagP ? 16'h7FFF :
                  wSatFlagN ? 16'h8000 :
                  rAccOut + rMul;

always @(posedge iClk12M) begin
    if(!iRsn) begin
        rAccOut <= 16'h0000;
        rMul <= 16'h0000;
    end
    else begin
        if(iEnMul) begin
            rMul <= wMulResult;
        end
        if(iEnAddAcc) begin
            rAccOut <= wAccNext;
        end
    end
end

assign oMac = rAccOut;

endmodule