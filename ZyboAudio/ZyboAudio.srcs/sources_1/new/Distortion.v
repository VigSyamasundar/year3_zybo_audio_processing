//`timescale 1ns / 1ps
module Distortion(
    input procclk,
    input signed [23:0] lChannelGainIn, 
    input signed [23:0] rChannelGainIn,
    input dist_sw,
    input dist_btn_up,
    input dist_btn_down,
    output reg signed [23:0] lChannelGainOut, 
    output reg signed [23:0] rChannelGainOut
    );

reg signed [23:0] distVal = 80000;
reg distCount = 0;
wire distControlClk = distCount;

// **Gain start**
//always @ (posedge procclk)
//begin
//    if(gain_sw)
//    begin
//        gain_LED = 1;
//        lChannelGainOut = lChannelGainIn/4;
//        rChannelGainOut = rChannelGainIn/4;    
//    end
//    else
//    begin
//        gain_LED = 0;
//        lChannelGainOut = lChannelGainIn;
//        rChannelGainOut = rChannelGainIn;
//    end
//end
// **Gain end**

// **Distortion Control Start**
always @ (posedge procclk)
begin
    distCount = distCount + 1;
end

always @ (posedge distControlClk)
begin
    if (dist_sw)
    begin
        if (distVal >= 10000)
        begin
            if (dist_btn_up)
            begin
                distVal = distVal - 2;
            end    
        end
        if (distVal <= 8000000)
        begin
            if(dist_btn_down)
            begin
                distVal = distVal + 2;
            end
        end
    end
end
// **Distortion Control End**

//**Heavy Clipping Start**
always @ (posedge procclk)
begin
    if (dist_sw)
    begin
        if (lChannelGainIn > distVal)
        begin
            lChannelGainOut = distVal;
        end
        if (lChannelGainIn < -distVal)
        begin
            lChannelGainOut = -distVal;    
        end
        if (rChannelGainIn > distVal)
        begin
            rChannelGainOut = distVal;
        end
        if (rChannelGainIn < -distVal)
        begin
            rChannelGainOut = -distVal;    
        end
        if (lChannelGainIn > -distVal && lChannelGainIn < distVal)
        begin
            lChannelGainOut = lChannelGainIn;
        end
        if (rChannelGainIn > -distVal && rChannelGainIn < distVal)
        begin
            rChannelGainOut = rChannelGainIn;
        end
    end
    else
    begin
        lChannelGainOut = lChannelGainIn;
        rChannelGainOut = rChannelGainIn;  
    end
end
//**Heavy Clipping End**

//**Light Clipping Start**
//always @ (posedge procclk)
//begin
//    if (dist_sw)
//    begin
//        if (lChannelGainIn > distVal)
//        begin
//            lChannelGainOut = distVal + ((lChannelGainIn - distVal) / 4);
//        end
//        if (lChannelGainIn < -distVal)
//        begin
//            lChannelGainOut = -distVal +((lChannelGainIn + distVal) / 4);      
//        end
//        if (rChannelGainIn > distVal)
//        begin
//            rChannelGainOut = distVal + ((rChannelGainIn - distVal) / 4);
//        end
//        if (rChannelGainIn < -distVal)
//        begin
//            rChannelGainOut = -distVal +((rChannelGainIn + distVal) / 4);    
//        end
//        if (lChannelGainIn > -distVal && lChannelGainIn < distVal)
//        begin
//            lChannelGainOut = lChannelGainIn;
//        end
//        if (rChannelGainIn > -distVal && rChannelGainIn < distVal)
//        begin
//            rChannelGainOut = rChannelGainIn;
//        end 
//    end
//    else
//    begin
//        lChannelGainOut = lChannelGainIn;
//        rChannelGainOut = rChannelGainIn;  
//    end
//end
//**Light Clipping End**

endmodule
