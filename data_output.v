/*`define STATE1 2'b00
`define STATE2 2'b01
`define STATE3 2'b10

module data_output(clk22, clk50, direction, data_valid,song_data, audio_out);
	input clk22, clk50, direction, data_valid;
	reg [1:0] state,next_state;
	input [31:0] song_data;
	output reg [7:0] audio_out;

	reg flag=1'b0;


	reg [7:0] next_audio_out;
	

	
	always @(*) begin 

		if (data_valid) begin //SHOULDN'T IT BE "IF (READ) HERE SO IT STARTS READING WHEN THE ADDRESS INCREMENT MODULE SAYS TO READ??

		case(state) 
			`STATE1: begin
				if(direction) begin 
				     	next_audio_out = song_data[15:8]; 
				     	next_state = `STATE2;
				end
				else begin 
					next_audio_out = song_data[31:24];
					next_state = `STATE3;
				end
				end

			`STATE2: begin
				next_audio_out = song_data[31:24];
				next_state = `STATE1;
				
				end
					
			
			`STATE3: begin
				next_audio_out = song_data[15:8];
				next_state=`STATE1;
				end

			default: begin 
				 next_audio_out = audio_out; 
				 next_state=state;
				 end
		endcase
	
	end 

	else begin 
		next_audio_out=audio_out; 
		next_state=state;
	end
end
	

	always @(posedge clk22) begin
		audio_out <= next_audio_out;
		flag <= !flag;
	end

	always @(posedge clk50) begin
		state <= next_state;
	end

endmodule 
*/




`define state1 3'b000   
`define state2 3'b001
`define state3 3'b010
`define state4 3'b011 
`define state5 3'b100
`define state6 3'b101
`define state7 3'b110
`define state8 3'b111

//defining states
//using synchronized clk22 for this module
module data_output(clk50, clk22, finished, direction, play, change, audio_data_in, audio_output);
input clk50, clk22,direction, play; 
input finished;
input [31:0] audio_data_in;

//defining regs to be used in this fsm
reg [7:0] audio_output_temp;//temp audio out variable used in logic
reg [3:0] next_state,state;

output reg [7:0] audio_output;//output audio from module to be determined
output reg change; //flag to determine if address will remain same for 2 reads or change to the next address




always @(*) begin

case (state)

`state1: begin 
	change=0;
	audio_output_temp = audio_output; 
	
//if in forward or backward play based on inputs from keyboard, move on to state 2 which will output correct audio
	if(play) 
	next_state = `state2;
	else 
	next_state = `state1;
	end
	

`state2: begin 

	change=0;
	audio_output_temp = audio_output; //setting the temp variable to next audio output

	if(finished) //finished is being sent in from flash read module. if flash fsm has iterated through to the final state, this fsm moves to state 3
	next_state = `state3;
	else 
	next_state = `state2;
	end

`state3: begin 
	change=0;
	audio_output_temp = audio_output;

	if(clk22) //when the synchronized 22hz clock is high, we want to move to the 4th state otherwise if low, next state will be state 3
	next_state = `state4;
	else 
	next_state = `state3;
	end

`state4: begin 

	change=0;
	next_state = `state5; 

	if(direction) 
	audio_output_temp = audio_data_in[15:8];
	else 
	audio_output_temp = audio_data_in[31:24];
	end

`state5: begin 
	change=0;
	next_state = `state6; 
	audio_output_temp = audio_output; 
	end

`state6: begin 

	change=0;
	audio_output_temp = audio_output; 

	if(clk22) //again checking if 22hz clock is high when moving to state 7  
	next_state = `state7;
	else 
	next_state = `state6;
	end

`state7: begin 
	change=0;
	next_state = `state8; 

	if(direction) 
	audio_output_temp = audio_data_in[31:24];	//setting data audio out based on correct bits of audio_data_in being sent into module
	else 
	audio_output_temp = audio_data_in[15:8]; //setting bits based on direction again
	end

`state8: begin 
	next_state = `state1; 
	change=1;//change is 1 because we already read both parts of address data and want it to increment/decrement to next address
	audio_output_temp = audio_output;                          //so that we can read from that next address
	end



default: begin 

	change=0;
	next_state = `state1; //default case sending it to the first state where it is checking
	audio_output_temp = 8'b0;  //just setting audio out tempto zero as default
	
	 end
	
endcase 
end


always @(posedge clk50) begin//want to be changing the state at the clk50hz because other modules states also change at posedge clock50
state <= next_state; //using flip flop for output and setting states
audio_output<=audio_output_temp; 
end




endmodule 	


