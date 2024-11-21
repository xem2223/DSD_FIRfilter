module DelayChain(
    input iClk12M, iRsn, iEnSample600k, 
    input iEnDelay,
    input [2:0] iFirIn,

    output [2:0] oDelay
);

reg signed [2:0] rDelay [20:0];
reg signed [2:0] rDelaySum;
integer i;

always @(posedge iClk12M) begin
    if(!iRsn) begin
        for(i=0; i<21; i = i+1)begin
            rDelay[i] <= 3'b000;
        end
        rDelaySum <= 3'b000;
    end
    if(iEnDelay) begin
        rDelay[0] <= iFirIn;
    end
    if(iEnSample600k) begin
        rDelay[1]  <= rDelay[0];
        rDelay[2]  <= rDelay[1];
        rDelay[3]  <= rDelay[2];
        rDelay[4]  <= rDelay[3];
        rDelay[5]  <= rDelay[4];
        rDelay[6]  <= rDelay[5];
        rDelay[7]  <= rDelay[6];
        rDelay[8]  <= rDelay[7];
        rDelay[9]  <= rDelay[8];
        rDelay[10] <= rDelay[9];
        rDelay[11] <= rDelay[10];
        rDelay[12] <= rDelay[11];
        rDelay[13] <= rDelay[12];
        rDelay[14] <= rDelay[13];
        rDelay[15] <= rDelay[14];
        rDelay[16] <= rDelay[15];
        rDelay[17] <= rDelay[16];
        rDelay[18] <= rDelay[17];
        rDelay[19] <= rDelay[18];
        rDelay[20] <= rDelay[19];
        
        rDelaySum <= (rDelay[0] + rDelay[20]) + // n±10
                     (rDelay[2] + rDelay[18]) + // n±9
                     (rDelay[3] + rDelay[17]) + // n±8
                     (rDelay[4] + rDelay[16]) + // n±7
                     (rDelay[5] + rDelay[15]) + // n±6
                     (rDelay[6] + rDelay[14]) + // n±5
                     (rDelay[7] + rDelay[13]) + // n±4
                     (rDelay[8] + rDelay[12]) + // n±3
                     (rDelay[9] + rDelay[11]) + // n±2
                     rDelay[10];
    end
end

assign oDelay = rDelaySum; 

endmodule