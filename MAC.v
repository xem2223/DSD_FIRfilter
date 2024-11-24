module MAC(
    input iClk12M, iRsn,
    // Add&ACC enable together @ timing diagram
    input iEnMul, iEnAddAcc, // Enable at 1, group add & acc
    input signed [29:0] iDelay, // Delay chain input
    input signed [15:0] iCoeff, // Coeff from SpSram output

    output [15:0] oMac
);

reg [15:0] rMul, rAcc [9:0];
reg [3:0] rDelayIndex; // max 1001;
/*
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
*/
always @(posedge iClk12M) begin
    if(!iRsn) begin
        rAccOut <= 16'h0000;
        rMul[0] <= 16'h0000;
        rMul[1] <= 16'h0000;
        rMul[2] <= 16'h0000;
        rMul[3] <= 16'h0000;
        rMul[4] <= 16'h0000;
        rMul[5] <= 16'h0000;
        rMul[6] <= 16'h0000;
        rMul[7] <= 16'h0000;
        rMul[8] <= 16'h0000;
        rMul[9] <= 16'h0000;
        rDelayIndex <= 4'b000;
    end
    else begin
        if(iEnMul) begin
            rMul[rDelayIndex] <= iCoeff * iDelay[(rDelayIndex+1)*3:rDelayIndex];
            rDelayIndex <= rDelayIndex + 1;
            if(rDelayIndex == 4'b1010)
                rDelayIndex <= 4'b0000;
        end
        if(iEnAddAcc) begin
            if(rDelayIndex == 4'b0000) begin
                rAcc[0] = rMul[0] + 16'h0000;
            end
            else begin
                rAcc[rDelayIndex] = rMul[rDelayIndex] + rAcc[rDelayIndex - 1];
            end
        end
    end
end

assign oMac = rAcc[9];

endmodule