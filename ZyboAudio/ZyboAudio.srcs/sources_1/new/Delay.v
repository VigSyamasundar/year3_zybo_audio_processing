//`timescale 1ns / 1ps
module Delay(
    input procclk,
    input signed [23:0] lChannelDelayIn, 
    input signed [23:0] rChannelDelayIn,
    input delay_sw,
    input delay_btn_up,
    input delay_btn_down,
    output reg signed [23:0] lChannelDelayOut, 
    output reg signed [23:0] rChannelDelayOut
    );
    
parameter SIZE=10000;
//parameter DELAY=2500;
reg [13:0] DELAY = 2500;
reg [5:0] delayCount = 0;
wire delayControlClk = delayCount[5];
wire signed [23:0] reduceDelayIn;
reg [13:0] addresspointer;
reg [13:0] readaddress;
reg [23:0] lChannelDelay;
reg [23:0] rChannelDelay;
wire signed [23:0] dpo;
assign reduceDelayIn = lChannelDelayIn/4 + dpo/2;
//assign reduceDelayIn = lChannelDelayIn;

// **Delay Control Start**
always @ (posedge procclk)
begin
    delayCount = delayCount + 1;    
end

always @ (posedge delayControlClk)
begin
    if (delay_sw)
    begin
        if (DELAY > 1750)
        begin
            if (delay_btn_down)
            begin
                DELAY = DELAY - 1;
            end
        end
        if (DELAY < 9500)
        begin
            if (delay_btn_up)
            begin
                DELAY = DELAY + 1;    
            end
        end
    end    
end
// **Delay Control End**

// **Delay Start**
always @ (posedge procclk) 
begin
    if (delay_sw)
    begin
        lChannelDelay=dpo;
        rChannelDelay=dpo;
        lChannelDelayOut = lChannelDelayIn + lChannelDelay;
        rChannelDelayOut = rChannelDelayIn + rChannelDelay;
        addresspointer=addresspointer+1;
        if(addresspointer>=SIZE)
        begin
            addresspointer=0;
        end
        if(addresspointer>=DELAY) 
        begin
            readaddress=addresspointer-DELAY;
        end 
        else 
        begin
            readaddress={0,addresspointer}+SIZE-DELAY;
        end
    end
    else
    begin
        lChannelDelayOut = lChannelDelayIn;
        rChannelDelayOut = rChannelDelayIn;
    end
end
dist_mem_gen_0 (.clk(procclk), .we(1), .a(addresspointer), .d(reduceDelayIn), .dpra(readaddress), .dpo(dpo));
//** Delay End**

endmodule







