//`timescale 1ns / 1ps
module Octave(
    input procclk,
    input signed [23:0] lChannelOctaveIn, 
    input signed [23:0] rChannelOctaveIn,
    input octave_sw,
    input octave_btn_up,
    input octave_btn_down,
    output reg signed [23:0] lChannelOctaveOut, 
    output reg signed [23:0] rChannelOctaveOut
    );

//** Octave down via memory start
//reg [9:0] addresspointer;
//reg [9:0] readaddress;
//reg signed [23:0] lOctaveBelow;
//reg signed [23:0] rOctaveBelow;
//wire signed [23:0] dpo;
//reg readCount = 0;
//dist_mem_gen_1 (.clk(procclk), .we(1), .a(addresspointer), .d(lChannelOctaveIn), .dpra(readaddress), .dpo(dpo));

//always @ (posedge procclk)
//begin
//    if (readCount)
//    begin
//        readaddress = readaddress + 1;
//    end
//    lOctaveBelow = dpo;
//    rOctaveBelow = dpo;
//    addresspointer = addresspointer + 1;
//    readCount = readCount + 1;
//    if (readaddress == 480)
//    begin
//        readCount = 0;
//        readaddress = 0;
//        addresspointer = 0;
//    end  
//end

//half mem
reg [9:0] addresspointer;
reg [9:0] readaddress;
reg signed [23:0] lOctaveBelow;
reg signed [23:0] rOctaveBelow;
wire signed [23:0] dpo;
reg readCount = 0;
reg we = 1;
dist_mem_gen_1 (.clk(procclk), .we(we), .a(addresspointer), .d(lChannelOctaveIn), .dpra(readaddress), .dpo(dpo));

always @ (posedge procclk)
begin
    if (readCount)
    begin
        readaddress = readaddress + 1;
    end
    lOctaveBelow = dpo;
    rOctaveBelow = dpo;
    if (addresspointer < 480)
    begin
        we = 1;
        addresspointer = addresspointer + 1;
    end
    if (addresspointer == 480)
    begin
        we = 0;
    end
    readCount = readCount + 1;
    if (readaddress == 480)
    begin
        readCount = 0;
        readaddress = 0;
        addresspointer = 0;
    end  
end
//half mem
//** Octave down via memory start

//** Octave Button Control
reg [12:0] selCount = 0;
wire selClk = selCount[12];
reg octSel = 0;
always @ (posedge procclk)
begin
    selCount = selCount + 1;
end

always @ (posedge selClk)
begin
    if (octave_btn_up)
    begin
        octSel = 1;
    end
    else if(octave_btn_down)
    begin
        octSel = 0;
    end
end
//** Octave Button Control


//** Octave up Start
reg [1:0] lFlip = 0;
reg [1:0] rFlip = 0;
reg signed [23:0] lOctaveAbove = 0;
reg signed [23:0] rOctaveAbove = 0;

always @ (posedge procclk)
begin
    if (lChannelOctaveIn == 0)
    begin
        lFlip = lFlip + 1;
    end
    if (~lFlip[1])
    begin
        if (lChannelOctaveIn < 0)
        begin
            lOctaveAbove = -(lChannelOctaveIn);
        end
        else
        begin
            lOctaveAbove = lChannelOctaveIn;    
        end
    end
    if (lFlip[1])
    begin
        if (lChannelOctaveIn > 0)
        begin
            lOctaveAbove = -(lChannelOctaveIn);
        end
        else
        begin
            lOctaveAbove = lChannelOctaveIn;
        end
    end
    if (rChannelOctaveIn == 0)
    begin
        rFlip = rFlip + 1;
    end
    if (~rFlip[1])
    begin
        if (rChannelOctaveIn < 0)
        begin
            rOctaveAbove = -(rChannelOctaveIn);
        end
        else
        begin
            rOctaveAbove = rChannelOctaveIn;    
        end
    end
    if (rFlip[1])
    begin
        if (rChannelOctaveIn > 0)
        begin
            rOctaveAbove = -(rChannelOctaveIn);
        end
        else
        begin
            rOctaveAbove = rChannelOctaveIn;
        end
    end
end
//** Octave up End


//** Octave up rectification start
//reg [23:0] lOctaveAbove2;
//reg [23:0] rOctaveAbove2;
//always @ (posedge procclk)
//begin
//    if (lChannelOctaveIn < 0)
//    begin
//        lOctaveAbove2 = -(lChannelOctaveIn);
//    end
//    if (rChannelOctaveIn < 0)
//    begin
//        rOctaveAbove2 = -(lChannelOctaveIn);
//    end
//    else 
//    begin
//        lOctaveAbove2 = lChannelOctaveIn;
//        rOctaveAbove2 = rChannelOctaveIn;
//    end
//end
//** Octave up rectification end

always @ (posedge procclk)
begin
    if (octave_sw)
    begin
        if (octSel)
        begin
            lChannelOctaveOut = (lOctaveAbove) + (lChannelOctaveIn*5) / 6;
            rChannelOctaveOut = (rOctaveAbove) + (rChannelOctaveIn *5) /6;
        end
        else if (~octSel)
        begin
            lChannelOctaveOut = (lOctaveBelow) + (lChannelOctaveIn*5)/6;
            rChannelOctaveOut = (rOctaveBelow) + (rChannelOctaveIn*5)/6;
        end
    end
    else
    begin
        lChannelOctaveOut = lChannelOctaveIn;
        rChannelOctaveOut = rChannelOctaveIn;
    end
end
        
endmodule
