`timescale 1ns / 1ps

module Control(
    input procclk,
    input param_btn_up,
    input param_btn_down,
    input effect_sel_btn_left,
    input effect_sel_btn_right,
    output reg dist_LED,
    output reg delay_LED,
    output reg octave_LED,
    output reg tremolo_LED,
    output reg dist_btn_up,
    output reg dist_btn_down,
    output reg delay_btn_up,
    output reg delay_btn_down,
    output reg octave_btn_up,
    output reg octave_btn_down,
    output reg tremolo_btn_up,
    output reg tremolo_btn_down
    );

// Effects cycle clk
reg [12:0] selCount = 0;
always @ (posedge procclk)
begin
    selCount = selCount + 1;
end
wire effects_sec_clk = selCount[12];
// Effects cycle clk

// Effects select, param switch and LED toggle
reg [1:0] effect_sel;
always @ (posedge effects_sec_clk)
begin
    if (effect_sel_btn_left)
    begin
        effect_sel = effect_sel + 1;
    end
    else if (effect_sel_btn_right)
    begin
        effect_sel = effect_sel - 1;
    end  
end

always @ (posedge procclk)
begin
    if (effect_sel == 0)
    begin
        //switch off other buttons
        delay_btn_up = 0;
        delay_btn_down = 0;
        octave_btn_up = 0;
        octave_btn_down = 0;
        tremolo_btn_up = 0;
        tremolo_btn_down = 0;
        //switch off other buttons
        
        dist_LED = 1;
        delay_LED = 0;
        octave_LED = 0;
        tremolo_LED = 0;
        if (param_btn_up)
        begin
            dist_btn_up = param_btn_up;
            dist_btn_down = 0;
        end
        else if (param_btn_down)
        begin
            dist_btn_up = 0;
            dist_btn_down = param_btn_down;
        end
        else
        begin
            dist_btn_up = 0;
            dist_btn_down = 0;
        end
    end
    
    else if (effect_sel == 1)
    begin
        //switch off other buttons
        dist_btn_up = 0;
        dist_btn_down = 0;
        octave_btn_up = 0;
        octave_btn_down = 0;
        tremolo_btn_up = 0;
        tremolo_btn_down = 0;
        //switch off other buttons
        delay_LED = 1;
        dist_LED = 0;
        octave_LED = 0;
        tremolo_LED = 0;
        if (param_btn_up)
        begin
            delay_btn_up = param_btn_up;
            delay_btn_down = 0;
        end
        else if (param_btn_down)
        begin
            delay_btn_up = 0;
            delay_btn_down = param_btn_down;
        end
        else
        begin
            delay_btn_up = 0;
            delay_btn_down = 0;
        end
    end
    
    else if (effect_sel == 2)
    begin
        //switch off other buttons
        dist_btn_up = 0;
        dist_btn_down = 0;
        delay_btn_up = 0;
        delay_btn_down = 0;
        tremolo_btn_up = 0;
        tremolo_btn_down = 0;
        //switch off other buttons
        octave_LED = 1;
        dist_LED = 0;
        delay_LED = 0;
        tremolo_LED = 0;
        if (param_btn_up)
        begin
            octave_btn_up = param_btn_up;
            octave_btn_down = 0;
        end
        else if (param_btn_down)
        begin
            octave_btn_up = 0;
            octave_btn_down = param_btn_down;
        end
        else
        begin
            octave_btn_up = 0;
            octave_btn_down = 0;
        end
    end
    
    else if (effect_sel == 3)
    begin
        //switch off other buttons
        dist_btn_up = 0;
        dist_btn_down = 0;
        delay_btn_up = 0;
        delay_btn_down = 0;
        octave_btn_up = 0;
        octave_btn_down = 0;
        //switch off other buttons
        tremolo_LED = 1; 
        dist_LED = 0;
        delay_LED = 0;
        octave_LED = 0;
        if (param_btn_up)
        begin
            tremolo_btn_up = param_btn_up;
            tremolo_btn_down = 0;
        end
        else if (param_btn_down)
        begin
            tremolo_btn_up = 0;
            tremolo_btn_down = param_btn_down;
        end 
        else
        begin
            tremolo_btn_up = 0;
            tremolo_btn_down = 0;
        end
    end
end
// Effects select, param switch and LED toggle


endmodule
