`timescale 1ns / 1ps
//0x06:
//0 0 0 1 0 0 0 0 0 

//0X00:
//0 0 0 010111

//0x01:
//0 0 0 010111

//0x04:
//0 00 0 1 0 0 1 0

//0x05:
//0 0 0 0 0 0 00 0

//0x06:
//0 0 0 0 0 0 0 0 0 

//device address:
//0011010

module I2CConfig(
    input clk,
    inout ac_scl,
    inout ac_sda
    );

reg temp_ac_scl = 1;
reg temp_ac_sda = 1;

reg [6:0] R0Add = 7'b0000000;
reg [8:0] R0Dat = 9'b000010111;

reg [6:0] R1Add = 7'b0000001;
reg [8:0] R1Dat = 9'b000010111;

reg [6:0] R4Add = 7'b0000100;
reg [8:0] R4Dat = 9'b000010010;

reg [6:0] R5Add = 7'b0000101;
reg [8:0] R5Dat = 9'b000000000;

reg [6:0] R6Add =  7'b0000110;
reg [8:0] R6Dat1 = 9'b000010000;
reg [8:0] R6Dat2 = 9'b000000000; 

reg [6:0] R9Add = 7'b0001001;
reg [8:0] R9Dat = 9'b000000001; 

reg [6:0] R12Add = 7'b0001100;
reg [8:0] R12Dat = 9'b000000001;

reg [6:0] devAdd = 7'b0011010;

reg [8:0] clkDiv = 0;     
reg [1:0] sclCount = 3;
reg [2:0] regSel = 0;
reg [7:0] phasecount = 0; 
reg [15:0] bigCount = 0;
reg enable = 1;
reg overflowC = 0;

always @ (posedge clk) 
begin
    clkDiv=clkDiv+1;
end

always @ (posedge clkDiv[8]) 
begin
	if (enable)
	begin
        if (regSel == 6)
        begin
           bigCount = bigCount + 1;
        end
        if (regSel == 0 || regSel == 1 || regSel == 2 || regSel == 3 || regSel == 4 || regSel == 5 || regSel == 7  || (regSel == 6 && bigCount > 50000))
        begin
            phasecount=phasecount+1;
            //**ac_scl begin**
            if (phasecount < 5 || phasecount > 126)
            begin
                temp_ac_scl = 1;
            end 
            if (phasecount > 4 && phasecount < 127)
            begin
                sclCount = sclCount + 1;
                if ((phasecount > 42 && phasecount < 45) || (phasecount > 74 && phasecount < 77) || (phasecount > 122 && phasecount < 125))
                begin
                    temp_ac_scl = 0;  
                end
                else
                begin
                    temp_ac_scl = sclCount[1];
                end
            end
            //**ac_scl end**
            
            //**ac_sda begin**
            if (phasecount < 2)
            begin
                temp_ac_sda = 1;   
            end
            if (phasecount > 1 && phasecount < 6)
            begin
                temp_ac_sda = 0;
            end
            //ac_sda device address begin
            if (phasecount > 5 && phasecount < 34)
            begin
                temp_ac_sda = devAdd[6-((phasecount - 6)/4)];
            end
            //ac_sda device address end
            //ac_sda write bit start
            if (phasecount > 33 && phasecount < 38)	
            begin
                temp_ac_sda = 0;
            end
            //ac_sda write bit end
            //ac_sda delay 1 start
            if (phasecount > 41 && phasecount < 46)
            begin
                temp_ac_sda = 1;
    //            temp_ac_sda = 0;
            end
            //ac_sda delay 1 end
            //R6-1
            if (regSel == 0)
            begin
                //ac_sda R6 address begin
                if (phasecount > 45 && phasecount < 74)
                begin
                    temp_ac_sda = R6Add[6-((phasecount - 46)/4)];
                end
                //ac_sda delay 2
                if (phasecount > 73 && phasecount < 78)
                begin
                    temp_ac_sda = 1;
    //                temp_ac_sda = 0;
                end
                //ac_sda R6 address end
                //ac_sda R6 data 1 begin
                if (phasecount > 77 && phasecount < 82)
                begin
                    temp_ac_sda = R6Dat1[8];
                end
                if (phasecount > 85 && phasecount < 118)
                begin
                    temp_ac_sda = R6Dat1[7-((phasecount - 86)/4)];
                end
                //ac_sda R6 data 1 end
                //ac_sda delay 3 start
                if (phasecount > 121 && phasecount < 126)
                begin    
                    temp_ac_sda = 1;
    //                temp_ac_sda = 0;
                end
                //ac_sda dekat 3 end
                if (phasecount > 125 && phasecount < 130)
                begin
                    temp_ac_sda = 0;
                end
                if(phasecount > 129)
                begin
                    temp_ac_sda = 1; 
                end
                //**ac_sda end**
                if (phasecount == 135)
                begin
                    regSel = regSel + 1;
                    phasecount = 0;
                    sclCount = 3;
                end
            end	
    //		//R0
            if (regSel == 1)
            begin
                //ac_sda R0 address begin
                if (phasecount > 45 && phasecount < 74)
                begin
                    temp_ac_sda = R0Add[6-((phasecount - 46)/4)];
                end
                //ac_sda delay 2
                if (phasecount > 73 && phasecount < 78)
                begin
                    temp_ac_sda = 1;
    //			    temp_ac_sda = 0;
                end
                //ac_sda R0 address end
                //ac_sda R0 data begin
                if (phasecount > 77 && phasecount < 82)
                begin
                    temp_ac_sda = R0Dat[8];
                end
                if (phasecount > 85 && phasecount < 118)
                begin
                    temp_ac_sda = R0Dat[7-((phasecount - 86)/4)];
                end
                //ac_sda R0 data end
                //ac_sda delay 3 start
                if (phasecount > 121 && phasecount < 126)
                begin    
                    temp_ac_sda = 1;
    //                temp_ac_sda = 0;
                end
                //ac_sda dekat 3 end
                if (phasecount > 125 && phasecount < 130)
                begin
                    temp_ac_sda = 0;
                end
                if(phasecount > 129)
                begin
                    temp_ac_sda = 1; 
                end
                //**ac_sda end**
                if (phasecount == 135)
                begin
                    regSel = regSel + 1;
                    phasecount = 0;
                    sclCount = 3;
                end
            end	    
    //		//R1
            if (regSel == 2)
            begin
                //ac_sda R1 address begin
                if (phasecount > 45 && phasecount < 74)
                begin
                    temp_ac_sda = R1Add[6-((phasecount - 46)/4)];
                end
                //ac_sda delay 2
                if (phasecount > 73 && phasecount < 78)
                begin
                    temp_ac_sda = 1;
    //			    temp_ac_sda = 0;
                end
                //ac_sda R1 address end
                //ac_sda R1 data begin
                if (phasecount > 77 && phasecount < 82)
                begin
                    temp_ac_sda = R1Dat[8];
                end
                if (phasecount > 85 && phasecount < 118)
                begin
                    temp_ac_sda = R1Dat[7-((phasecount - 86)/4)];
                end
                //ac_sda R1 data end
                //ac_sda delay 3 start
                if (phasecount > 121 && phasecount < 126)
                begin    
                    temp_ac_sda = 1;
    //                temp_ac_sda = 0;
                end
                //ac_sda dekat 3 end
                if (phasecount > 125 && phasecount < 130)
                begin
                    temp_ac_sda = 0;
                end
                if(phasecount > 129)
                begin
                    temp_ac_sda = 1; 
                end
                //**ac_sda end**
                if (phasecount == 135)
                begin
                    regSel = regSel + 1;
                    phasecount = 0;
                    sclCount = 3;
                end
            end	    
    //		//R4
            if (regSel == 3)
            begin
                //ac_sda R4 address begin
                if (phasecount > 45 && phasecount < 74)
                begin
                    temp_ac_sda = R4Add[6-((phasecount - 46)/4)];
                end
                //ac_sda delay 2
                if (phasecount > 73 && phasecount < 78)
                begin
                    temp_ac_sda = 1;
    //			    temp_ac_sda = 0;
                end
                //ac_sda R4 address end
                //ac_sda R4 data begin
                if (phasecount > 77 && phasecount < 82)
                begin
                    temp_ac_sda = R4Dat[8];
                end
                if (phasecount > 85 && phasecount < 118)
                begin
                    temp_ac_sda = R4Dat[7-((phasecount - 86)/4)];
                end
                //ac_sda R4 data end
                //ac_sda delay 3 start
                if (phasecount > 121 && phasecount < 126)
                begin    
                    temp_ac_sda = 1;
    //                temp_ac_sda = 0;
                end
                //ac_sda dekat 3 end
                if (phasecount > 125 && phasecount < 130)
                begin
                    temp_ac_sda = 0;
                end
                if(phasecount > 129)
                begin
                    temp_ac_sda = 1; 
                end
                //**ac_sda end**
                if (phasecount == 135)
                begin
                    regSel = regSel + 1;
                    phasecount = 0;
                    sclCount = 3;
                end
            end	    
    //		//R5
            if (regSel == 4)
            begin
                //ac_sda R5 address begin
                if (phasecount > 45 && phasecount < 74)
                begin
                    temp_ac_sda = R5Add[6-((phasecount - 46)/4)];
                end
                //ac_sda delay 2
                if (phasecount > 73 && phasecount < 78)
                begin
                    temp_ac_sda = 1;
    //			    temp_ac_sda = 0;
                end
                //ac_sda R5 address end
                //ac_sda R5 data begin
                if (phasecount > 77 && phasecount < 82)
                begin
                    temp_ac_sda = R5Dat[8];
                end
                if (phasecount > 85 && phasecount < 118)
                begin
                    temp_ac_sda = R5Dat[7-((phasecount - 86)/4)];
                end
                //ac_sda R5 data 1 end
                //ac_sda delay 3 start
                if (phasecount > 121 && phasecount < 126)
                begin    
                    temp_ac_sda = 1;
    //                temp_ac_sda = 0;
                end
                //ac_sda dekat 3 end
                if (phasecount > 125 && phasecount < 130)
                begin
                    temp_ac_sda = 0;
                end
                if(phasecount > 129)
                begin
                    temp_ac_sda = 1; 
                end
                //**ac_sda end**
                if (phasecount == 135)
                begin
                    regSel = regSel + 1;
                    phasecount = 0;
                    sclCount = 3;
                end
            end	
            //R12
            if (regSel == 5)
            begin
                //ac_sda R12 address begin
                if (phasecount > 45 && phasecount < 74)
                begin
                    temp_ac_sda = R12Add[6-((phasecount - 46)/4)];
                end
                //ac_sda delay 2
                if (phasecount > 73 && phasecount < 78)
                begin
                    temp_ac_sda = 1;
    //                temp_ac_sda = 0;
                end
                //ac_sda R12 address end
                //ac_sda R12 data begin
                if (phasecount > 77 && phasecount < 82)
                begin
                    temp_ac_sda = R12Dat[8];
                end
                if (phasecount > 85 && phasecount < 118)
                begin
                    temp_ac_sda = R12Dat[7-((phasecount - 86)/4)];
                end
                //ac_sda R12 data 1 end
                //ac_sda delay 3 start
                if (phasecount > 121 && phasecount < 126)
                begin    
                    temp_ac_sda = 1;
    //                temp_ac_sda = 0;
                end
                //ac_sda dekat 3 end
                if (phasecount > 125 && phasecount < 130)
                begin
                    temp_ac_sda = 0;
                end
                if(phasecount > 129)
                begin
                    temp_ac_sda = 1; 
                end
                //**ac_sda end**
                if (phasecount == 135)
                begin
                    regSel = regSel + 1;
                    phasecount = 0;
                    sclCount = 3;
                end
            end    
            //R9
            if (regSel == 6)
            begin
                //ac_sda R9 address begin
                if (phasecount > 45 && phasecount < 74)
                begin
                    temp_ac_sda = R9Add[6-((phasecount - 46)/4)];
                end
                //ac_sda delay 2
                if (phasecount > 73 && phasecount < 78)
                begin
                    temp_ac_sda = 1;
    //                temp_ac_sda = 0;
                end
                //ac_sda R9 address end
                //ac_sda R9 data begin
                if (phasecount > 77 && phasecount < 82)
                begin
                    temp_ac_sda = R9Dat[8];
                end
                if (phasecount > 85 && phasecount < 118)
                begin
                    temp_ac_sda = R9Dat[7-((phasecount - 86)/4)];
                end
                //ac_sda R9 data end
                //ac_sda delay 3 start
                if (phasecount > 121 && phasecount < 126)
                begin    
                    temp_ac_sda = 1;
    //                temp_ac_sda = 0;
                end
                //ac_sda dekat 3 end
                if (phasecount > 125 && phasecount < 130)
                begin
                    temp_ac_sda = 0;
                end
                if(phasecount > 129)
                begin
                    temp_ac_sda = 1; 
                end
                //**ac_sda end**
                if (phasecount == 135)
                begin
                    regSel = regSel + 1;
                    phasecount = 0;
                    sclCount = 3;
                end
            end            
            //R6-2
            if (regSel == 7)
            begin
                //ac_sda R6 address begin
                if (phasecount > 45 && phasecount < 74)
                begin
                    temp_ac_sda = R6Add[6-((phasecount - 46)/4)];
                end
                //ac_sda delay 2
                if (phasecount > 73 && phasecount < 78)
                begin
                    temp_ac_sda = 1;
    //			    temp_ac_sda = 0;
                end
                //ac_sda R6 address end
                //ac_sda R6 data 2 begin
                if (phasecount > 77 && phasecount < 82)
                begin
                    temp_ac_sda = R6Dat2[8];
                end
                if (phasecount > 85 && phasecount < 118)
                begin
                    temp_ac_sda = R6Dat2[7-((phasecount - 86)/4)];
                end
                //ac_sda R6 data 2 end
                //ac_sda delay 3 start
                if (phasecount > 121 && phasecount < 126)
                begin    
                    temp_ac_sda = 1;
    //                temp_ac_sda = 0;
                end
                //ac_sda delay 3 end
                if (phasecount > 125 && phasecount < 130)
                begin
                    temp_ac_sda = 0;
                end
                if(phasecount > 129)
                begin
                    temp_ac_sda = 1; 
                end
                //**ac_sda end**
                if (phasecount == 135)
                begin
                    regSel = regSel + 1;
                    phasecount = 0;
                    sclCount = 3;
                    enable = 0;
                end
            end
		end	
	end
end

assign ac_scl = (temp_ac_scl)? 1'bZ:0;
assign ac_sda = (temp_ac_sda)? 1'bZ:0;

endmodule

