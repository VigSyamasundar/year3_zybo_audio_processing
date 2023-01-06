module I2SAudio(
    input clk,
    output reg [23:0] lChannelREC, rChannelREC, 
//    output reg [23:0] prelChannelIn, prerChannelIn,
    input [23:0] lChannelPB, rChannelPB,
    input RECDAT,
    output BCLK, 
    output PBLRC, RECLRC, 
    output MCLK, reg PBDAT
    );

reg [23:0] shiftIn;
reg [23:0] shiftOut;
reg [6:0] phasecount=103;
reg [5:0] phasecountDiv=0;
reg enable = 0;
assign MCLK=clk;
//assign BCLK = phasecount[0];
assign RECLRC = (phasecount>51)? 1:0;
assign PBLRC = (phasecount>51)? 1:0;

reg [1:0] MCLKcount = 3;
assign BCLK = MCLKcount[1];

always @ (posedge MCLK)
begin
    MCLKcount = MCLKcount + 1;
    if (MCLKcount % 2 == 0)
    begin
        phasecount = phasecount + 1;
        if (phasecount == 104)
        begin
            phasecount = 0;
        end
        if (phasecount %2 != 0)
        begin
            if ((phasecount >= 2 && phasecount < 50) || (phasecount >= 54 && phasecount < 102))
            begin
                shiftIn[23:1] = shiftIn[22:0];
                shiftIn[0] = RECDAT;
            end
            if (phasecount == 51)
            begin
                lChannelREC = shiftIn;
                // Since guitar has only one channel
                rChannelREC = shiftIn;
            end
//            if (phasecount == 103)
//            begin
//                rChannelREC = shiftIn;
//            end    
        end
        else if (phasecount %2 == 0)
        begin
//            if(phasecount >= 0 && phasecount <2)
            if(phasecount == 0)
            begin
                shiftOut = lChannelPB;
            end
//            if(phasecount >= 52 && phasecount <54)
            if(phasecount == 52)
            begin
                shiftOut = rChannelPB;
            end
            if ((phasecount >= 2 && phasecount < 50) || (phasecount >= 54 && phasecount < 102))
            begin
                PBDAT = shiftOut[23];
                shiftOut[23:1] = shiftOut[22:0];
            end
        end
    end

end


endmodule