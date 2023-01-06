//`timescale 1ns / 1ps
module Tremolo(
    input procclk,
    input signed [23:0] lChannelTremoloIn, 
    input signed [23:0] rChannelTremoloIn,
    input tremolo_sw,
    input tremolo_btn_up,
    input tremolo_btn_down,
    output reg signed [23:0] lChannelTremoloOut, 
    output reg signed [23:0] rChannelTremoloOut
    );

reg signed [15:0] tremCount = 0;
reg signed [15:0] tremComp = 5000;
reg [4:0] tremClkCount = 0;
wire tremClk = tremClkCount[4];
reg tremFlag = 1;
reg signed [39:0] lTremInt = 0;
reg signed [39:0] rTremInt = 0;

//tremCount control
always  @ (posedge procclk)
begin
    tremClkCount = tremClkCount + 1;
end

always @ (posedge tremClk)
begin
    if (tremolo_sw)
    begin
        if (tremolo_btn_up)
        begin
            if (tremComp > 1000)
            begin
                tremComp = tremComp - 1;
            end
        end
        if (tremolo_btn_down)
        begin
            if (tremComp < 65000)
            begin
                tremComp = tremComp + 1;
            end
        end
    end
end
//tremCount control

//** Tremolo Start
always @ (posedge procclk)
begin
    if (tremolo_sw)
    begin
        if (tremCount == tremComp)
        begin
            tremFlag = 0;
        end
        if (tremCount == 0)
        begin
            tremFlag = 1;
        end
        if (tremFlag)
        begin
            tremCount = tremCount + 1;
        end
        if (~tremFlag)
        begin
            tremCount = tremCount - 1;
        end
        lTremInt = (lChannelTremoloIn * tremCount) / tremComp;
        rTremInt = (rChannelTremoloIn * tremCount) / tremComp;
        lChannelTremoloOut = {lTremInt[39],lTremInt[22:0]};                                                          
        rChannelTremoloOut = {rTremInt[39],rTremInt[22:0]};
    end
    else
    begin
        lChannelTremoloOut = lChannelTremoloIn;
        rChannelTremoloOut = rChannelTremoloIn;
    end
end
//** Tremolo End
    
endmodule

