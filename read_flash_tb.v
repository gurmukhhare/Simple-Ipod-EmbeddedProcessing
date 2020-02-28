
module readflash_tb();
	reg clk_tb,start_tb,wait_request_tb,data_valid_tb;
	wire finished_tb;
	wire read_tb;
	

read_flash_FSM DUT(.clk(clk_tb),.start(start_tb),.wait_request(wait_request_tb),.data_valid(data_valid_tb),.read(read_tb),.finished(finished_tb));


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

	start_tb=1'b1;
	wait_request_tb=1'b0;
	data_valid_tb=1'b1;
	#20;
	
	start_tb=1'b0;
	wait_request_tb=1'b1;
	data_valid_tb=1'b0;
	#20;
	
	start_tb=1'b1;
	wait_request_tb=1'b0;
	data_valid_tb=1'b0;
	#20;
	
	end
endmodule





