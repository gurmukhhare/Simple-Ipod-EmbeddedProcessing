`define MAX_ADDRESS 23'h7FFFF //definingt the max address in memorey module

module address_designator(clk,address_direction,changing_address,reading_address);
	input clk;
	input address_direction;
	input changing_address;
	output reg[22:0] reading_address;
	reg [22:0] next;


	always @(*) begin  //used to be if(holding_address)
			
		if(!changing_address) //if this flag is 0, we want to remain @ same address because each address has 2 reads from it, so we read both before continuing
		begin
			next = reading_address;
		end
		

		else begin 
			
			if(address_direction) begin //if moving in the forward direction
				if(reading_address <= `MAX_ADDRESS) begin //reading address must stay below the max address
				next = reading_address +1;
				end
				else next = 0;
			end
			else begin
				if(reading_address > 0) begin //for backwards playing, once address equals or falls below 0 we set the next address to the max
				next = reading_address -1;
				end
				else next = `MAX_ADDRESS;
			end
		
		end
	end
	
	always@(posedge clk) begin //logic for next reading address
		reading_address <= next;
	end

endmodule 
				

