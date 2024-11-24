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
        rDelaySum <= 5'b00000;
    end else if (iEnSample600k) begin
        // Shift the delay chain
        for (i = 20; i > 0; i = i - 1) begin
            rDelay[i] <= rDelay[i - 1];
        end
        rDelay[0] <= iFirIn; // New input sample

        // Update the delay sum based on symmetry
        rDelaySum <= (rDelay[0] + rDelay[20]) + // n±10
                     (rDelay[1] + rDelay[19]) + // n±9
                     (rDelay[2] + rDelay[18]) + // n±8
                     (rDelay[3] + rDelay[17]) + // n±7
                     (rDelay[4] + rDelay[16]) + // n±6
                     (rDelay[5] + rDelay[15]) + // n±5
                     (rDelay[6] + rDelay[14]) + // n±4
                     (rDelay[7] + rDelay[13]) + // n±3
                     (rDelay[8] + rDelay[12]) + // n±2
                     (rDelay[9] + rDelay[11]) + // n±1
                     rDelay[10];                // Center tap
    end
end
    
assign oDelay = rDelaySum; 

endmodule
