
module clock_divider(clkIn,clkOut,countToValue);
	//defining inputs and outputs
	input [31:0] countToValue; 
	input clkIn;
	reg [31:0] count; //declaring a local count variable to keep track of current count
	output reg clkOut=0; //setting initial clkOut value before always block begins
	

	always@(posedge clkIn) begin
		

		if (count<(countToValue-1)) begin //if the counter has not reached the countToValue, keep counting
			count=count+1;
		end
		else if (count>=(countToValue-1))begin //once the count value reaches the countToValue, set the outClk signal
			clkOut=!clkOut;
			count=0;
		end
		else //if the counter has exceeded the designated countToValue, reset the count to 0
			count=0;

	end
endmodule