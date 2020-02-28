`define B 8'h42  
`define D 8'h44 
`define E 8'h45 
`define F 8'h46

`define b 8'h62
`define d 8'h64 
`define e 8'h65 
`define f 8'h66

module keyboardFSM_tb ();

reg clk_tb;
reg [7:0] keyboard_tb;
wire reading_tb;
wire direction_tb;



keyboard_FSM DUT(.clk(clk_tb),.keyboard(keyboard_tb),.start_reading(reading_tb),.direction(direction_tb));
//initiating the clock
initial begin
clk_tb=0;
#1;
forever begin
clk_tb=0;
#1;
clk_tb=1;
#1;
end
end

initial begin
keyboard_tb= `E; //sending in sample keyboard characters to see if fsm cycles through states
#5;
keyboard_tb= `D;
#5;
keyboard_tb= `B;
#5;
keyboard_tb= `E;
#5;
keyboard_tb= `F;
#5;
keyboard_tb= `D;
#5;
keyboard_tb= `F;
#5;
keyboard_tb= `E;
#5;
end
endmodule

