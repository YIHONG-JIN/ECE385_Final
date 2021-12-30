module kbinput (
							input Clk,
									frame_clk,
									En_New_Static,
							input [7:0] keycode,
							input	[2:0] randnum,
							input [2:0] Game_State,
									
							output Active_O, Active_T, Active_RL, Active_RF, Active_LL, Active_LF, Active_I,
							output LEFT, RIGHT, UP, DOWN, SPACE, ENTER
	);
	
	logic [2:0] randnew;
	logic [7:0] keycode_delayed;
	logic frame_clk_delayed;
	logic Z,X,C,V,B,N,M;
	always_ff @ (posedge Clk)
	begin
		keycode_delayed <= keycode;
		frame_clk_delayed <= frame_clk;
		LEFT <= (keycode == 8'd80) && (keycode_delayed != 8'd80);
		RIGHT <= (keycode == 8'd79) && (keycode_delayed != 8'd79);
		UP <= (keycode == 8'd82) && (keycode_delayed != 8'd82);
		DOWN <= (keycode == 8'd81) && (keycode_delayed != 8'd81);
		SPACE <= (keycode == 8'd44);
		ENTER <= (keycode == 8'd40) && (keycode_delayed != 8'd40);

		if ((frame_clk_delayed==1'b1) && (frame_clk==1'b0))
			randnew <= randnum;
		else if ((frame_clk_delayed==1'b0) && (frame_clk==1'b1) && (Game_State == 3'b001))
		begin
			case (randnew)
				3'd1:
				begin
					Active_O <= 1'b1;
					Active_T <= 1'b0;
					Active_RL <= 1'b0;
					Active_RF <= 1'b0;
					Active_LL <= 1'b0;
					Active_LF <= 1'b0;
					Active_I <= 1'b0;
				end
				
				3'd2:
				begin
					Active_O <= 1'b0;
					Active_T <= 1'b1;
					Active_RL <= 1'b0;
					Active_RF <= 1'b0;
					Active_LL <= 1'b0;
					Active_LF <= 1'b0;
					Active_I <= 1'b0;
				end
		
				3'd3:
				begin
					Active_O <= 1'b0;
					Active_T <= 1'b0;
					Active_RL <= 1'b1;
					Active_RF <= 1'b0;
					Active_LL <= 1'b0;
					Active_LF <= 1'b0;
					Active_I <= 1'b0;
				end
				
				3'd4:
				begin
					Active_O <= 1'b0;
					Active_T <= 1'b0;
					Active_RL <= 1'b0;
					Active_RF <= 1'b1;
					Active_LL <= 1'b0;
					Active_LF <= 1'b0;
					Active_I <= 1'b0;
				end
				
				3'd5:
				begin
					Active_O <= 1'b0;
					Active_T <= 1'b0;
					Active_RL <= 1'b0;
					Active_RF <= 1'b0;
					Active_LL <= 1'b1;
					Active_LF <= 1'b0;
					Active_I <= 1'b0;
				end
		
				3'd6:
				begin
					Active_O <= 1'b0;
					Active_T <= 1'b0;
					Active_RL <= 1'b0;
					Active_RF <= 1'b0;
					Active_LL <= 1'b0;
					Active_LF <= 1'b1;
					Active_I <= 1'b0;
				end
				
				3'd7:
				begin
					Active_O <= 1'b0;
					Active_T <= 1'b0;
					Active_RL <= 1'b0;
					Active_RF <= 1'b0;
					Active_LL <= 1'b0;
					Active_LF <= 1'b0;
					Active_I <= 1'b1;
				end
				
				default:
				begin
					Active_O <= 1'b0;
					Active_T <= 1'b0;
					Active_RL <= 1'b0;
					Active_RF <= 1'b0;
					Active_LL <= 1'b0;
					Active_LF <= 1'b0;
					Active_I <= 1'b0;
				end
			endcase
		end
		
		else
		begin
			Active_O <= 1'b0;
			Active_T <= 1'b0;
			Active_RL <= 1'b0;
			Active_RF <= 1'b0;
			Active_LL <= 1'b0;
			Active_LF <= 1'b0;
			Active_I <= 1'b0;
		end
	end
endmodule

			
			