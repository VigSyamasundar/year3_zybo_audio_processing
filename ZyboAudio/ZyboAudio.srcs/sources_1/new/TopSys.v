module TopSys(
    input clk,
    //Control
    input effect_sel_btn_left,
    input effect_sel_btn_right,
    input param_btn_up,
    input param_btn_down,
    //Distortion
    input dist_sw,
    output dist_LED,
    //Delay
    input delay_sw,
    output delay_LED,
    //Octave
    input octave_sw,
    output octave_LED,
    //Tremolo
    input tremolo_sw,
    output tremolo_LED,
	//I2S
	input ac_recdat,
    output ac_bclk, ac_pbdat, ac_pblrc, ac_mclk, ac_reclrc, ac_muten,
	//I2C
	inout ac_scl,
	inout ac_sda
    );

assign ac_muten = 1; 
   
wire [23:0] lChannelREC, rChannelREC; 
wire [23:0] lChannelPB, rChannelPB;
wire [23:0] lChannelGainOut, rChannelGainOut;
wire [23:0] lChannelDelayOut, rChannelDelayOut;
wire [23:0] lChannelOctaveOut, rChannelOctaveOut;
wire [23:0] lChannelTremoloOut, rChannelTremoloOut;
wire I2Sclk;

//processing clock
reg [7:0] procCount = 0;
wire procclk = procCount[7];
always @ (posedge I2Sclk)
begin
    procCount <= procCount + 1;
end
//processing clock

//btn wires
wire dist_btn_up;
wire dist_btn_down;
wire delay_btn_up;
wire delay_btn_down;
wire octave_btn_up;
wire octave_btn_down;
wire tremolo_btn_up;
wire tremolo_btn_down;
//btn wires

Distortion (.procclk(procclk), .dist_sw(dist_sw), .dist_btn_up(dist_btn_up), .dist_btn_down(dist_btn_down), .lChannelGainIn(lChannelREC), .rChannelGainIn(rChannelREC), .lChannelGainOut(lChannelGainOut), .rChannelGainOut(rChannelGainOut));

Delay (.procclk(procclk), .delay_sw(delay_sw), .delay_btn_up(delay_btn_up), .delay_btn_down(delay_btn_down), .lChannelDelayIn(lChannelGainOut), .rChannelDelayIn(rChannelGainOut), .lChannelDelayOut(lChannelDelayOut), .rChannelDelayOut(rChannelDelayOut));

Octave (.procclk(procclk), .octave_sw(octave_sw), .octave_btn_up(octave_btn_up), .octave_btn_down(octave_btn_down), .lChannelOctaveIn(lChannelDelayOut), .rChannelOctaveIn(rChannelDelayOut), .lChannelOctaveOut(lChannelOctaveOut), .rChannelOctaveOut(rChannelOctaveOut));

Tremolo (.procclk(procclk), .tremolo_btn_up(tremolo_btn_up), .tremolo_btn_down(tremolo_btn_down), .tremolo_sw(tremolo_sw), .lChannelTremoloIn(lChannelOctaveOut), .rChannelTremoloIn(rChannelOctaveOut), .lChannelTremoloOut(lChannelTremoloOut), .rChannelTremoloOut(rChannelTremoloOut));

Control (.procclk(procclk), .param_btn_up(param_btn_up), .param_btn_down(param_btn_down), .effect_sel_btn_left(effect_sel_btn_left), .effect_sel_btn_right(effect_sel_btn_right), .dist_btn_up(dist_btn_up), .dist_btn_down(dist_btn_down), .delay_btn_up(delay_btn_up), .delay_btn_down(delay_btn_down),
         .octave_btn_up(octave_btn_up), .octave_btn_down(octave_btn_down), .tremolo_btn_up(tremolo_btn_up), .tremolo_btn_down(tremolo_btn_down),
         .dist_LED(dist_LED), .delay_LED(delay_LED), .octave_LED(octave_LED), .tremolo_LED(tremolo_LED));

clk_wiz_0 (.clk_out1(I2Sclk), .clk_in1(clk));     

I2SAudio (.clk(I2Sclk), .RECDAT(ac_recdat), .BCLK(ac_bclk),
             .PBLRC(ac_pblrc), .RECLRC(ac_reclrc), .MCLK(ac_mclk),
             .PBDAT(ac_pbdat), .lChannelPB(lChannelPB), 
             .rChannelPB(rChannelPB), .lChannelREC(lChannelREC),
             .rChannelREC(rChannelREC));

I2CConfig (.clk(clk), .ac_scl(ac_scl), .ac_sda(ac_sda));

assign lChannelPB=lChannelTremoloOut;
assign rChannelPB=rChannelTremoloOut;

endmodule
