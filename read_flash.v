
`define idle 3'b000
`define check_wait 3'b001
`define reading 3'b010
`define check_data_valid 3'b011
`define finish 3'b100

//defining required states
module read_flash_FSM (clk,start,wait_request,data_valid,read,finished);

	input clk,start,wait_request,data_valid;
	output reg read;
	reg [2:0] next_state;
	reg [2:0] state;		//originally read and finished had initial values set here, removed them now
	output reg finished; //flag that tells other module when finished

	always@(*) begin
		case(state)
			`idle: begin
				read =1'b0;
				finished = 1'b0;
				if(start) next_state = `check_wait; //when start flag is 1 which comes from keyboard module, move on to check wait
				else next_state = state;
			end
			
			`check_wait: begin
				read = 1'b0;
				finished = 1'b0;
				if(!wait_request) next_state = `reading;
				else next_state = state;
			end

			`reading: begin
				read=1'b1; //reading is set to 1 in this state, this will be sent to flash mem
				finished = 1'b0;
				next_state = `check_data_valid;
			end
			`check_data_valid: begin
				read = 1'b0;
				finished = 1'b0;
				if(!data_valid) next_state = `finish;
				else next_state = state;
			end
			
			`finish: begin
				read = 1'b0;
				finished = 1'b1;
				next_state = `idle;
			end
			default: begin //default case
				 next_state = `idle;
				 read=1'b0;
				 finished=1'b0;
			end
			
		endcase
	end

always@(posedge clk) begin //flip flop for next state logic
	state <= next_state;
end


endmodule

				

		