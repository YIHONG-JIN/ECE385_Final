// The T-shaped Block
module T_block ( input Clk,
							  frame_clk,
							  Reset,
							  Active,
							  LEFT, RIGHT, UP, DOWN, SPACE,
					  input [9:0] DrawX, DrawY,
					  input [23:0][15:0] Static_Array,
					  output En_New_Static,
					  output [3:0][4:0] New_Static_Row,
					  output [3:0][3:0] New_Static_Column,
					  output [2:0] Color_Dynamic,
					  output [2:0] State_Bit
	);
	
	logic [3:0][4:0] Box_Center_Row_Initial;
	logic [3:0][3:0] Box_Center_Column_Initial;
	logic [3:0][4:0] Box_Center_Row_Current;
	logic [3:0][3:0] Box_Center_Column_Current;
	logic Touched;
	logic [15:0][9:0] Box_X_Center;
	logic [23:0][9:0] Box_Y_Center;
	
	// Initial Position: Need Modify
	assign Box_Center_Row_Initial[0] = 5'd0;
	assign Box_Center_Row_Initial[1] = 5'd1;
	assign Box_Center_Row_Initial[2] = 5'd1;
	assign Box_Center_Row_Initial[3] = 5'd1;
	assign Box_Center_Column_Initial[0] = 4'd7;
	assign Box_Center_Column_Initial[1] = 4'd6;
	assign Box_Center_Column_Initial[2] = 4'd7;
	assign Box_Center_Column_Initial[3] = 4'd8;
	assign New_Static_Row[0] = Box_Center_Row_Current[0];
	assign New_Static_Row[1] = Box_Center_Row_Current[1];
	assign New_Static_Row[2] = Box_Center_Row_Current[2];
	assign New_Static_Row[3] = Box_Center_Row_Current[3];
	assign New_Static_Column[0] = Box_Center_Column_Current[0];
	assign New_Static_Column[1] = Box_Center_Column_Current[1];
	assign New_Static_Column[2] = Box_Center_Column_Current[2];
	assign New_Static_Column[3] = Box_Center_Column_Current[3];
	
	assign Box_X_Center[0] = 10'd225;
	assign Box_X_Center[1] = 10'd246;
	assign Box_X_Center[2] = 10'd267;
	assign Box_X_Center[3] = 10'd288;
	assign Box_X_Center[4] = 10'd309;
	assign Box_X_Center[5] = 10'd330;
	assign Box_X_Center[6] = 10'd351;
	assign Box_X_Center[7] = 10'd372;
	assign Box_X_Center[8] = 10'd393;
	assign Box_X_Center[9] = 10'd414;
	assign Box_X_Center[10] = 10'd435;
	assign Box_X_Center[11] = 10'd456;
	assign Box_X_Center[12] = 10'd477;
	assign Box_X_Center[13] = 10'd498;
	assign Box_X_Center[14] = 10'd519;
	assign Box_X_Center[15] = 10'd540;
	
	assign Box_Y_Center[4] = 10'd41;
	assign Box_Y_Center[5] = 10'd62;
	assign Box_Y_Center[6] = 10'd83;
	assign Box_Y_Center[7] = 10'd104;
	assign Box_Y_Center[8] = 10'd125;
	assign Box_Y_Center[9] = 10'd146;
	assign Box_Y_Center[10] = 10'd167;
	assign Box_Y_Center[11] = 10'd188;
	assign Box_Y_Center[12] = 10'd209;
	assign Box_Y_Center[13] = 10'd230;
	assign Box_Y_Center[14] = 10'd251;
	assign Box_Y_Center[15] = 10'd272;
	assign Box_Y_Center[16] = 10'd293;
	assign Box_Y_Center[17] = 10'd314;
	assign Box_Y_Center[18] = 10'd335;
	assign Box_Y_Center[19] = 10'd356;
	assign Box_Y_Center[20] = 10'd377;
	assign Box_Y_Center[21] = 10'd398;
	assign Box_Y_Center[22] = 10'd419;
	assign Box_Y_Center[23] = 10'd440;
	
	enum logic [2:0] {Halted, Falling, Touchdown}	State, Next_State;
	logic [1:0]R_State;
	
   // Detect rising edge of frame_clk
	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk)
	begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	
	always_ff @ (posedge Clk)
	begin
		if (frame_clk_rising_edge)
			case (State)
				Halted:
				begin
					Box_Center_Row_Current[0] <= Box_Center_Row_Initial[0];
					Box_Center_Row_Current[1] <= Box_Center_Row_Initial[1];
					Box_Center_Row_Current[2] <= Box_Center_Row_Initial[2];
					Box_Center_Row_Current[3] <= Box_Center_Row_Initial[3];
					Box_Center_Column_Current[0] <= Box_Center_Column_Initial[0];
					Box_Center_Column_Current[1] <= Box_Center_Column_Initial[1];
					Box_Center_Column_Current[2] <= Box_Center_Column_Initial[2];
					Box_Center_Column_Current[3] <= Box_Center_Column_Initial[3];
				end
				
				Falling:
					if (~Touched)
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
					end
				
				Touchdown: ;
				default: ;
			endcase
		
		if (State == Halted)
			R_State <= 2'b00;
		else if (State == Falling)
		begin
			if (LEFT)
			begin
				if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]-4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]-4'd1] != 1'b1)
						&& (Box_Center_Column_Current[0] != 4'd0)
						&& (Box_Center_Column_Current[1] != 4'd0)
						&& (Box_Center_Column_Current[2] != 4'd0)
						&& (Box_Center_Column_Current[3] != 4'd0))
				begin
					Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
					Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
					Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
					Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1;
				end
			end
			
			else if (RIGHT)
			begin
				if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]+4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]+4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]+4'd1] != 1'b1)
						&& (Box_Center_Column_Current[0] != 4'd15)
						&& (Box_Center_Column_Current[1] != 4'd15)
						&& (Box_Center_Column_Current[2] != 4'd15)
						&& (Box_Center_Column_Current[3] != 4'd15))
				begin
					Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1;
					Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
					Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
					Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
				end
			end
			
			else if (DOWN)
			begin
				if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
						&& (Box_Center_Row_Current[0] != 5'd23)
						&& (Box_Center_Row_Current[1] != 5'd23)
						&& (Box_Center_Row_Current[2] != 5'd23)
						&& (Box_Center_Row_Current[3] != 5'd23))
				begin
					Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+4'd1;
					Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+4'd1;
					Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+4'd1;
					Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+4'd1;
				end
			end
			
			else if (SPACE)
			begin
				if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
						&& (Box_Center_Row_Current[0] != 5'd23)
						&& (Box_Center_Row_Current[1] != 5'd23)
						&& (Box_Center_Row_Current[2] != 5'd23)
						&& (Box_Center_Row_Current[3] != 5'd23))
				begin
					Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
					Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
					Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
					Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
				end
			end
			
			else if (UP)
			begin
				if (R_State == 2'b00)
				begin
					// row 1 and column 2 is the middle key block
					if ((Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
					&& (Box_Center_Row_Current[2] != 5'd23)
					)
						begin  // first next state, only move 1 to right and down
							Box_Center_Row_Current[0] <= Box_Center_Row_Current[0];
							Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
							Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
							Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
							Box_Center_Column_Current[0] <= Box_Center_Column_Current[0];
							Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
							Box_Center_Column_Current[2] <= Box_Center_Column_Current[2];
							Box_Center_Column_Current[3] <= Box_Center_Column_Current[3];
							R_State <= 2'b01;
						end
				end
					
	
				else if (R_State == 2'b01)
				// as the left side is three, consider sliding through the wall
				begin 
					if ((Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-5'd1] != 1'b1)
					&& (Box_Center_Column_Current[2] >= 1)
//				   && (Box_Center_Row_Current[2]) != 5'd23
					)
						begin  // first next state, only move 1 to right and down
							Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
							Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
							Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
							Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
							Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
							Box_Center_Column_Current[1] <= Box_Center_Column_Current[1];
							Box_Center_Column_Current[2] <= Box_Center_Column_Current[2];
							Box_Center_Column_Current[3] <= Box_Center_Column_Current[3];
							R_State <= 2'b10;
						end
					else if ((Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]+5'd1] != 1'b1)
					&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
					&& (Box_Center_Column_Current[2] < 1)
//				   && (Box_Center_Row_Current[2]) != 5'd23
					)
						begin
							Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
							Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
							Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
							Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
							Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1+4'd1;
							Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
							Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
							Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
							R_State <= 2'b10;								
						
						end
					
					else if ((Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]+5'd1] != 1'b1)
					&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
					&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-5'd1] == 1'b1)
					&& (Box_Center_Column_Current[2] <= 7)
//				   && (Box_Center_Row_Current[2]) != 5'd23
					)
						begin
							Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
							Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
							Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
							Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
							Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1+4'd1;
							Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
							Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
							Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
							R_State <= 2'b10;								
						
						end
				end
						
						
				else if (R_State == 2'b10)
				begin
					if ((Static_Array[Box_Center_Row_Current[2]-5'd1][Box_Center_Column_Current[2]] != 1'b1)
//				   && (Box_Center_Row_Current[2]) != 5'd23
					)
						begin  // first next state, only move 1 to right and down
							Box_Center_Row_Current[0] <= Box_Center_Row_Current[0];
							Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
							Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
							Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]-5'd1;
							Box_Center_Column_Current[0] <= Box_Center_Column_Current[0];
							Box_Center_Column_Current[1] <= Box_Center_Column_Current[1];
							Box_Center_Column_Current[2] <= Box_Center_Column_Current[2];
							Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1;
							R_State <= 2'b11;
						end
				end
				
				else
				begin 
					if ((Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]+5'd1] != 1'b1)
					&& (Box_Center_Column_Current[2]<= 8)
//				   && (Box_Center_Row_Current[2]) != 5'd23
					)
						begin  // first next state, only move 1 to right and down
							Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd1;
							Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]-5'd1;
							Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
							Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
							Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1;
							Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
							Box_Center_Column_Current[2] <= Box_Center_Column_Current[2];
							Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
							R_State <= 2'b00;
						end
					else if ((Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]-5'd1] != 1'b1)
					&& (Static_Array[Box_Center_Row_Current[3]-5'd1][Box_Center_Column_Current[3]] != 1'b1)					
					&& (Box_Center_Column_Current[2] > 8)
//				   && (Box_Center_Row_Current[2]) != 5'd23
					)
						begin  // first next state, only move 1 to right and down
							Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd1;
							Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]-5'd1;
							Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
							Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
							Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1-4'd1;
							Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1-4'd1;
							Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
							Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1-4'd1;
							R_State <= 2'b00;
						end
					
					else if ((Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]-5'd1] != 1'b1)
					&& (Static_Array[Box_Center_Row_Current[3]-5'd1][Box_Center_Column_Current[3]] != 1'b1)
					&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]+5'd1] == 1'b1)

					&& (Box_Center_Column_Current[2] >= 2)
//				   && (Box_Center_Row_Current[2]) != 5'd23
					)
						begin  // first next state, only move 1 to right and down
							Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd1;
							Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]-5'd1;
							Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
							Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
							Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1-4'd1;
							Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1-4'd1;
							Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
							Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1-4'd1;
							R_State <= 2'b00;
						end
				end	
			end
		end
		
		if (Reset)
			begin
				State <= Halted;
			end
		else 
			State <= Next_State;			
		
	end

	
	logic [3:0][4:0] NextRow;
	assign NextRow[0] = Box_Center_Row_Current[0]+5'd1;
	assign NextRow[1] = Box_Center_Row_Current[1]+5'd1;
	assign NextRow[2] = Box_Center_Row_Current[2]+5'd1;
	assign NextRow[3] = Box_Center_Row_Current[3]+5'd1;
	
	int  Row,Column;
	assign Row = (DrawY-10'd31)/10'd21+10'd4;
	assign Column = (DrawX-10'd215)/10'd21;
	
   int DistX, DistY, Size;
   assign Size = 10'd9;
	
	always_comb
	begin
		unique case (State)
			Halted:
			begin
				if (Active)
					Next_State = Falling;
				else
					Next_State = Halted;
			end
			
			Falling:
			begin
				if (Touched)
				begin
					if (frame_clk_rising_edge)
						Next_State = Touchdown;
					else
						Next_State = Falling;
				end
				else
					Next_State = Falling;
			end
			
			Touchdown:
			begin
				Next_State = Halted;
			end
			
			default:
				Next_State = Halted;
		endcase

		
		if (Static_Array[NextRow[0]][Box_Center_Column_Current[0]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[1]][Box_Center_Column_Current[1]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[2]][Box_Center_Column_Current[2]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[3]][Box_Center_Column_Current[3]] == 1'b1)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[0] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[1] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[2] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[3] == 5'd23)
			Touched = 1'b1;
		else
			Touched = 1'b0;
			
		case (State)
			Halted:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b001;
			end
			Falling:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b010;
			end
			Touchdown:
			begin
				En_New_Static = 1'b1;
				State_Bit = 3'b100;
			end
			default: ;
		endcase

		if ((Box_Center_Column_Current[0]==Column)&&(Box_Center_Row_Current[0]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[1]==Column)&&(Box_Center_Row_Current[1]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[2]==Column)&&(Box_Center_Row_Current[2]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[3]==Column)&&(Box_Center_Row_Current[3]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else
		begin
			DistX = 20;
			DistY = 20;
		end
	end
	
   always_comb
	begin
       if ( (DistX*DistX<=Size*Size) && (DistY*DistY<=Size*Size) )
			  // Need Modify
           Color_Dynamic = 3'b011;
       else
           Color_Dynamic = 3'b000;
       /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
          the single line is quite powerful descriptively, it causes the synthesis tool to use up three
          of the 12 available multipliers on the chip! */
   end
	
endmodule

// The L-shaped Block Right
module RL_block ( input Clk,
							  frame_clk,
							  Reset,
							  Active,
							  LEFT, RIGHT, UP, DOWN, SPACE,
					  input [9:0] DrawX, DrawY,
					  input [23:0][15:0] Static_Array,
					  output En_New_Static,
					  output [3:0][4:0] New_Static_Row,
					  output [3:0][3:0] New_Static_Column,
					  output [2:0] Color_Dynamic,
					  output [2:0] State_Bit
	);
	
	logic [3:0][4:0] Box_Center_Row_Initial;
	logic [3:0][3:0] Box_Center_Column_Initial;
	logic [3:0][4:0] Box_Center_Row_Current;
	logic [3:0][3:0] Box_Center_Column_Current;
	logic Touched;
	logic [15:0][9:0] Box_X_Center;
	logic [23:0][9:0] Box_Y_Center;
	
	// Initial Position: Need Modify
	assign Box_Center_Row_Initial[0] = 5'd0;
	assign Box_Center_Row_Initial[1] = 5'd1;
	assign Box_Center_Row_Initial[2] = 5'd2;
	assign Box_Center_Row_Initial[3] = 5'd2;
	assign Box_Center_Column_Initial[0] = 4'd8;
	assign Box_Center_Column_Initial[1] = 4'd8;
	assign Box_Center_Column_Initial[2] = 4'd7;
	assign Box_Center_Column_Initial[3] = 4'd8;
	assign New_Static_Row[0] = Box_Center_Row_Current[0];
	assign New_Static_Row[1] = Box_Center_Row_Current[1];
	assign New_Static_Row[2] = Box_Center_Row_Current[2];
	assign New_Static_Row[3] = Box_Center_Row_Current[3];
	assign New_Static_Column[0] = Box_Center_Column_Current[0];
	assign New_Static_Column[1] = Box_Center_Column_Current[1];
	assign New_Static_Column[2] = Box_Center_Column_Current[2];
	assign New_Static_Column[3] = Box_Center_Column_Current[3];
	
	assign Box_X_Center[0] = 10'd225;
	assign Box_X_Center[1] = 10'd246;
	assign Box_X_Center[2] = 10'd267;
	assign Box_X_Center[3] = 10'd288;
	assign Box_X_Center[4] = 10'd309;
	assign Box_X_Center[5] = 10'd330;
	assign Box_X_Center[6] = 10'd351;
	assign Box_X_Center[7] = 10'd372;
	assign Box_X_Center[8] = 10'd393;
	assign Box_X_Center[9] = 10'd414;
	assign Box_X_Center[10] = 10'd435;
	assign Box_X_Center[11] = 10'd456;
	assign Box_X_Center[12] = 10'd477;
	assign Box_X_Center[13] = 10'd498;
	assign Box_X_Center[14] = 10'd519;
	assign Box_X_Center[15] = 10'd540;
	
	assign Box_Y_Center[4] = 10'd41;
	assign Box_Y_Center[5] = 10'd62;
	assign Box_Y_Center[6] = 10'd83;
	assign Box_Y_Center[7] = 10'd104;
	assign Box_Y_Center[8] = 10'd125;
	assign Box_Y_Center[9] = 10'd146;
	assign Box_Y_Center[10] = 10'd167;
	assign Box_Y_Center[11] = 10'd188;
	assign Box_Y_Center[12] = 10'd209;
	assign Box_Y_Center[13] = 10'd230;
	assign Box_Y_Center[14] = 10'd251;
	assign Box_Y_Center[15] = 10'd272;
	assign Box_Y_Center[16] = 10'd293;
	assign Box_Y_Center[17] = 10'd314;
	assign Box_Y_Center[18] = 10'd335;
	assign Box_Y_Center[19] = 10'd356;
	assign Box_Y_Center[20] = 10'd377;
	assign Box_Y_Center[21] = 10'd398;
	assign Box_Y_Center[22] = 10'd419;
	assign Box_Y_Center[23] = 10'd440;
	
	enum logic [2:0] {Halted, Falling, Touchdown}	State, Next_State;
	logic [1:0] R_State;
	
   // Detect rising edge of frame_clk
	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk)
	begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	
	always_ff @ (posedge Clk)
	begin
		if (frame_clk_rising_edge)
			case (State)
				Halted:
				begin
					Box_Center_Row_Current[0] <= Box_Center_Row_Initial[0];
					Box_Center_Row_Current[1] <= Box_Center_Row_Initial[1];
					Box_Center_Row_Current[2] <= Box_Center_Row_Initial[2];
					Box_Center_Row_Current[3] <= Box_Center_Row_Initial[3];
					Box_Center_Column_Current[0] <= Box_Center_Column_Initial[0];
					Box_Center_Column_Current[1] <= Box_Center_Column_Initial[1];
					Box_Center_Column_Current[2] <= Box_Center_Column_Initial[2];
					Box_Center_Column_Current[3] <= Box_Center_Column_Initial[3];
				end
				
				Falling:
					if (~Touched)
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
					end
				
				Touchdown: ;
				default: ;
			endcase

		if (State == Halted)
			R_State <= 2'b00;
		else if (State == Falling)
			begin
				if (LEFT)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]-4'd1] != 1'b1)
							&& (Box_Center_Column_Current[0] != 4'd0)
							&& (Box_Center_Column_Current[1] != 4'd0)
							&& (Box_Center_Column_Current[2] != 4'd0)
							&& (Box_Center_Column_Current[3] != 4'd0))
					begin
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1;
					end
				end
				
				else if (RIGHT)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]+4'd1] != 1'b1)
							&& (Box_Center_Column_Current[0] != 4'd15)
							&& (Box_Center_Column_Current[1] != 4'd15)
							&& (Box_Center_Column_Current[2] != 4'd15)
							&& (Box_Center_Column_Current[3] != 4'd15))
					begin
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1;
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
					end
				end
				
				else if (DOWN)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
							&& (Box_Center_Row_Current[0] != 5'd23)
							&& (Box_Center_Row_Current[1] != 5'd23)
							&& (Box_Center_Row_Current[2] != 5'd23)
							&& (Box_Center_Row_Current[3] != 5'd23))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+4'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+4'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+4'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+4'd1;
					end
				end
				
				else if (SPACE)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
							&& (Box_Center_Row_Current[0] != 5'd23)
							&& (Box_Center_Row_Current[1] != 5'd23)
							&& (Box_Center_Row_Current[2] != 5'd23)
							&& (Box_Center_Row_Current[3] != 5'd23))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
					end
				end
				
				else if (UP)
					begin						
						if (R_State == 2'b00)
						// as the right side is three, consider sliding through the wall
						begin
							if ((Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]+5'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]-5'd1][Box_Center_Column_Current[2]] != 1'b1)
							&& (Box_Center_Column_Current[1]<= 8)						
							)
							
								begin  // first next state, only move 1 to right and down
									Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+4'd2;
									Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+4'd1;
									Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]-4'd1;
									Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
									Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1;
									Box_Center_Column_Current[1] <= Box_Center_Column_Current[1];
									Box_Center_Column_Current[2] <= Box_Center_Column_Current[2];
									Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1;
									R_State <= 1'b01;
								end
								
							else if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd2] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-5'd1] != 1'b1)
							&& (Box_Center_Column_Current[1] > 8)
//							&& (Box_Center_Row_Current[3]) != 5'd23
							)
								begin 
									Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+4'd2;
									Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+4'd1;
									Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]-4'd1;
									Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
									Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1-4'd1;
									Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
									Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
									Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1-4'd1;
									R_State <= 1'b01;
								end
							else if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd2] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-5'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd1] == 1'b1)
							&& (Box_Center_Column_Current[1] >= 2)
							)
								begin 
									Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+4'd2;
									Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+4'd1;
									Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]-4'd1;
									Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
									Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1-4'd1;
									Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
									Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
									Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1-4'd1;
									R_State <= 1'b01;
								end	
						end
							
	
						else if (R_State == 2'b01)
						
							begin 
								if ((Static_Array[Box_Center_Row_Current[1]-5'd1][Box_Center_Column_Current[1]] != 1'b1)
								&&  (Static_Array[Box_Center_Row_Current[1]-5'd2][Box_Center_Column_Current[1]] != 1'b1)
								&&  (Static_Array[Box_Center_Row_Current[1]-5'd2][Box_Center_Column_Current[1]+5'd1] != 1'b1)
//								&&  (Box_Center_Row_Current[3] != 5'd23)
								)
								begin  
									Box_Center_Row_Current[0] <= Box_Center_Row_Current[0];
									Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]-4'd1;
									Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]-4'd1;
									Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]-4'd2;
									Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
									Box_Center_Column_Current[1] <= Box_Center_Column_Current[1];
									Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd2;
									Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
									R_State <= 2'b10;
								end
							end
								
						// consider sliding through the right
						else if (R_State == 2'b10)
							begin
								if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd1] != 1'b1)
									&& (Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]+5'd1] != 1'b1)
									&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd1] != 1'b1)							
									&& (Box_Center_Column_Current[1] >= 1)
//									&& (Box_Center_Row_Current[0] != 5'd23)
									)
									begin  
										Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd1;
										Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
										Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd2;
										Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
										Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
										Box_Center_Column_Current[1] <= Box_Center_Column_Current[1];
										Box_Center_Column_Current[2] <= Box_Center_Column_Current[2];
										Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
										R_State <= 2'b11;
									end
								else if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd1] != 1'b1)
									&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd2] != 1'b1)
									&& (Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]+5'd2] != 1'b1)
									&& (Box_Center_Column_Current[1] < 1)
//									&& (Box_Center_Row_Current[0] != 5'd23)
									)
									begin  
										Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-4'd1;
										Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
										Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+4'd2;
										Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+4'd1;
										Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1+4'd1;
										Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
										Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
										Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1+4'd1;
										R_State <= 2'b11;
									end
									
								else if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd1] != 1'b1)
									&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd2] != 1'b1)
									&& (Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]+5'd2] != 1'b1)									
									&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd1] == 1'b1)
									&& (Box_Center_Column_Current[1] <=7 )
									)
									begin  
										Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd1;
										Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
										Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd2;
										Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
										Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1+4'd1;
										Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
										Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
										Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1+4'd1;
										R_State <= 2'b11;
									end
							end
						
						

						else
							begin 
								if ((Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-5'd1] != 1'b1)
									&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-5'd2] != 1'b1)
									&& (Static_Array[Box_Center_Row_Current[1]-5'd1][Box_Center_Column_Current[1]] != 1'b1)
									)
									begin  // first next state, only move 1 to right and down
										Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd1;
										Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
										Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
										Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
										Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1;
										Box_Center_Column_Current[1] <= Box_Center_Column_Current[1];
										Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd2;
										Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1;
										R_State <= 2'b00;
									end
							end
					
					end // up								
			end
			
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_State;			
		
	end
	
	logic [3:0][4:0] NextRow;
	assign NextRow[0] = Box_Center_Row_Current[0]+5'd1;
	assign NextRow[1] = Box_Center_Row_Current[1]+5'd1;
	assign NextRow[2] = Box_Center_Row_Current[2]+5'd1;
	assign NextRow[3] = Box_Center_Row_Current[3]+5'd1;
	
	int  Row,Column;
	assign Row = (DrawY-10'd31)/10'd21+10'd4;
	assign Column = (DrawX-10'd215)/10'd21;
	
   int DistX, DistY, Size;
   assign Size = 10'd9;
	
	always_comb
	begin
		unique case (State)
			Halted:
			begin
				if (Active)
					Next_State = Falling;
				else
					Next_State = Halted;
			end
			
			Falling:
			begin
				if (Touched)
				begin
					if (frame_clk_rising_edge)
						Next_State = Touchdown;
					else
						Next_State = Falling;
				end
				else
					Next_State = Falling;
			end
			
			Touchdown:
			begin
				Next_State = Halted;
			end
			
			default:
				Next_State = Halted;
		endcase

		
		if (Static_Array[NextRow[0]][Box_Center_Column_Current[0]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[1]][Box_Center_Column_Current[1]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[2]][Box_Center_Column_Current[2]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[3]][Box_Center_Column_Current[3]] == 1'b1)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[0] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[1] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[2] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[3] == 5'd23)
			Touched = 1'b1;
		else
			Touched = 1'b0;
			
		case (State)
			Halted:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b001;
			end
			Falling:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b010;
			end
			Touchdown:
			begin
				En_New_Static = 1'b1;
				State_Bit = 3'b100;
			end
			default: ;
		endcase

		if ((Box_Center_Column_Current[0]==Column)&&(Box_Center_Row_Current[0]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[1]==Column)&&(Box_Center_Row_Current[1]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[2]==Column)&&(Box_Center_Row_Current[2]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[3]==Column)&&(Box_Center_Row_Current[3]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else
		begin
			DistX = 20;
			DistY = 20;
		end
	end
	
   always_comb
	begin
       if ( (DistX*DistX<=Size*Size) && (DistY*DistY<=Size*Size) )
			  // Need Modify
           Color_Dynamic = 3'b011;
       else
           Color_Dynamic = 3'b000;
       /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
          the single line is quite powerful descriptively, it causes the synthesis tool to use up three
          of the 12 available multipliers on the chip! */
   end
	
endmodule

// The Left-folding Block
module RF_block ( input Clk,
							  frame_clk,
							  Reset,
							  Active,
							  LEFT, RIGHT, UP, DOWN, SPACE,
					  input [9:0] DrawX, DrawY,
					  input [23:0][15:0] Static_Array,
					  output En_New_Static,
					  output [3:0][4:0] New_Static_Row,
					  output [3:0][3:0] New_Static_Column,
					  output [2:0] Color_Dynamic,
					  output [2:0] State_Bit
	);

	
	logic [3:0][4:0] Box_Center_Row_Initial;
	logic [3:0][3:0] Box_Center_Column_Initial;
	logic [3:0][4:0] Box_Center_Row_Current;
	logic [3:0][3:0] Box_Center_Column_Current;
	logic Touched;
	logic [15:0][9:0] Box_X_Center;
	logic [23:0][9:0] Box_Y_Center;
	
	// Initial Position: Need Modify
	assign Box_Center_Row_Initial[0] = 5'd0;
	assign Box_Center_Row_Initial[1] = 5'd0;
	assign Box_Center_Row_Initial[2] = 5'd1;
	assign Box_Center_Row_Initial[3] = 5'd1;
	assign Box_Center_Column_Initial[0] = 4'd7;
	assign Box_Center_Column_Initial[1] = 4'd8;
	assign Box_Center_Column_Initial[2] = 4'd6;
	assign Box_Center_Column_Initial[3] = 4'd7;
	assign New_Static_Row[0] = Box_Center_Row_Current[0];
	assign New_Static_Row[1] = Box_Center_Row_Current[1];
	assign New_Static_Row[2] = Box_Center_Row_Current[2];
	assign New_Static_Row[3] = Box_Center_Row_Current[3];
	assign New_Static_Column[0] = Box_Center_Column_Current[0];
	assign New_Static_Column[1] = Box_Center_Column_Current[1];
	assign New_Static_Column[2] = Box_Center_Column_Current[2];
	assign New_Static_Column[3] = Box_Center_Column_Current[3];
	
	assign Box_X_Center[0] = 10'd225;
	assign Box_X_Center[1] = 10'd246;
	assign Box_X_Center[2] = 10'd267;
	assign Box_X_Center[3] = 10'd288;
	assign Box_X_Center[4] = 10'd309;
	assign Box_X_Center[5] = 10'd330;
	assign Box_X_Center[6] = 10'd351;
	assign Box_X_Center[7] = 10'd372;
	assign Box_X_Center[8] = 10'd393;
	assign Box_X_Center[9] = 10'd414;
	assign Box_X_Center[10] = 10'd435;
	assign Box_X_Center[11] = 10'd456;
	assign Box_X_Center[12] = 10'd477;
	assign Box_X_Center[13] = 10'd498;
	assign Box_X_Center[14] = 10'd519;
	assign Box_X_Center[15] = 10'd540;
	
	assign Box_Y_Center[4] = 10'd41;
	assign Box_Y_Center[5] = 10'd62;
	assign Box_Y_Center[6] = 10'd83;
	assign Box_Y_Center[7] = 10'd104;
	assign Box_Y_Center[8] = 10'd125;
	assign Box_Y_Center[9] = 10'd146;
	assign Box_Y_Center[10] = 10'd167;
	assign Box_Y_Center[11] = 10'd188;
	assign Box_Y_Center[12] = 10'd209;
	assign Box_Y_Center[13] = 10'd230;
	assign Box_Y_Center[14] = 10'd251;
	assign Box_Y_Center[15] = 10'd272;
	assign Box_Y_Center[16] = 10'd293;
	assign Box_Y_Center[17] = 10'd314;
	assign Box_Y_Center[18] = 10'd335;
	assign Box_Y_Center[19] = 10'd356;
	assign Box_Y_Center[20] = 10'd377;
	assign Box_Y_Center[21] = 10'd398;
	assign Box_Y_Center[22] = 10'd419;
	assign Box_Y_Center[23] = 10'd440;
	
	enum logic [2:0] {Halted, Falling, Touchdown}	State, Next_State;
	logic R_State;
	
   // Detect rising edge of frame_clk
	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk)
	begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	
	always_ff @ (posedge Clk)
	begin
		if (frame_clk_rising_edge)
			case (State)
				Halted:
				begin
					Box_Center_Row_Current[0] <= Box_Center_Row_Initial[0];
					Box_Center_Row_Current[1] <= Box_Center_Row_Initial[1];
					Box_Center_Row_Current[2] <= Box_Center_Row_Initial[2];
					Box_Center_Row_Current[3] <= Box_Center_Row_Initial[3];
					Box_Center_Column_Current[0] <= Box_Center_Column_Initial[0];
					Box_Center_Column_Current[1] <= Box_Center_Column_Initial[1];
					Box_Center_Column_Current[2] <= Box_Center_Column_Initial[2];
					Box_Center_Column_Current[3] <= Box_Center_Column_Initial[3];
				end
				
				Falling:
					if (~Touched)
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
					end
				
				Touchdown: ;
				default: ;
			endcase
		
		if (State == Halted)
			R_State <= 1'b0;
		else if (State == Falling)
			begin
				if (LEFT)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]-4'd1] != 1'b1)
							&& (Box_Center_Column_Current[0] != 4'd0)
							&& (Box_Center_Column_Current[1] != 4'd0)
							&& (Box_Center_Column_Current[2] != 4'd0)
							&& (Box_Center_Column_Current[3] != 4'd0))
					begin
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1;
					end
				end
				
				else if (RIGHT)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]+4'd1] != 1'b1)
							&& (Box_Center_Column_Current[0] != 4'd15)
							&& (Box_Center_Column_Current[1] != 4'd15)
							&& (Box_Center_Column_Current[2] != 4'd15)
							&& (Box_Center_Column_Current[3] != 4'd15))
					begin
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1;
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
					end
				end

				else if (DOWN)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
							&& (Box_Center_Row_Current[0] != 5'd23)
							&& (Box_Center_Row_Current[1] != 5'd23)
							&& (Box_Center_Row_Current[2] != 5'd23)
							&& (Box_Center_Row_Current[3] != 5'd23))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+4'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+4'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+4'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+4'd1;
					end
				end
				
				else if (SPACE)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
							&& (Box_Center_Row_Current[0] != 5'd23)
							&& (Box_Center_Row_Current[1] != 5'd23)
							&& (Box_Center_Row_Current[2] != 5'd23)
							&& (Box_Center_Row_Current[3] != 5'd23))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
					end
				end
				
				else if (UP)
					begin						
						if (R_State == 1'b0)						
						// as the right side is three, consider sliding through the wall
						begin
							if ((Static_Array[Box_Center_Row_Current[2]-5'd1][Box_Center_Column_Current[2]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]-5'd2][Box_Center_Column_Current[2]] != 1'b1)							
//						&& (Box_Center_Row_Current[3] != 5'd23)
						)
						
							begin  // first next state, only move 1 to right and down
								Box_Center_Row_Current[0] <= Box_Center_Row_Current[0];
								Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+4'd1;
								Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]-4'd2;
								Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]-4'd1;
								Box_Center_Column_Current[0] <= Box_Center_Column_Current[0];
								Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
								Box_Center_Column_Current[2] <= Box_Center_Column_Current[2];
								Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1;
								R_State <= 1'b01;
							end
						end																				
						

						else
						begin 
							if ((Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]+5'd1] != 1'b1)
							&& (Box_Center_Column_Current[0] <=8 )
//							&& (Box_Center_Row_Current[1] != 5'd23)
							)
							begin  // first next state, only move 1 to right and down
								Box_Center_Row_Current[0] <= Box_Center_Row_Current[0];
								Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]-4'd1;
								Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+4'd2;
								Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+4'd1;
								Box_Center_Column_Current[0] <= Box_Center_Column_Current[0];
								Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
								Box_Center_Column_Current[2] <= Box_Center_Column_Current[2];
								Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
								R_State <= 1'b0;
							end
					
							
							else if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd2] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd1] != 1'b1)
							&& (Box_Center_Column_Current[0] > 8 )
//							&& (Box_Center_Row_Current[1] != 5'd23)
							)
							begin 
								Box_Center_Row_Current[0] <= Box_Center_Row_Current[0];
								Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]-4'd1;
								Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+4'd2;
								Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+4'd1;
								Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
								Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1-4'd1;
								Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
								Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1-4'd1;
								R_State <= 1'b0;
							end
							
							else if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd2] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]+5'd1] == 1'b1)
							&& (Box_Center_Column_Current[0] >=2  )
							)
							begin 
								Box_Center_Row_Current[0] <= Box_Center_Row_Current[0];
								Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]-4'd1;
								Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+4'd2;
								Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+4'd1;
								Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
								Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1-4'd1;
								Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
								Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1-4'd1;
								R_State <= 1'b0;
							end 			
						end
										
					end															
		end 
		
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_State;			
		
	end
	
	
	logic [3:0][4:0] NextRow;
	assign NextRow[0] = Box_Center_Row_Current[0]+5'd1;
	assign NextRow[1] = Box_Center_Row_Current[1]+5'd1;
	assign NextRow[2] = Box_Center_Row_Current[2]+5'd1;
	assign NextRow[3] = Box_Center_Row_Current[3]+5'd1;
	
	int  Row,Column;
	assign Row = (DrawY-10'd31)/10'd21+10'd4;
	assign Column = (DrawX-10'd215)/10'd21;
	
   int DistX, DistY, Size;
   assign Size = 10'd9;
	
	always_comb
	begin
		unique case (State)
			Halted:
			begin
				if (Active)
					Next_State = Falling;
				else
					Next_State = Halted;
			end
			
			Falling:
			begin
				if (Touched)
				begin
					if (frame_clk_rising_edge)
						Next_State = Touchdown;
					else
						Next_State = Falling;
				end
				else
					Next_State = Falling;
			end
			
			Touchdown:
			begin
				Next_State = Halted;
			end
			
			default:
				Next_State = Halted;
		endcase

		if (Static_Array[NextRow[0]][Box_Center_Column_Current[0]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[1]][Box_Center_Column_Current[1]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[2]][Box_Center_Column_Current[2]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[3]][Box_Center_Column_Current[3]] == 1'b1)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[0] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[1] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[2] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[3] == 5'd23)
			Touched = 1'b1;
		else
			Touched = 1'b0;
			
		case (State)
			Halted:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b001;
			end
			Falling:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b010;
			end
			Touchdown:
			begin
				En_New_Static = 1'b1;
				State_Bit = 3'b100;
			end
			default: ;
		endcase
			
		if ((Box_Center_Column_Current[0]==Column)&&(Box_Center_Row_Current[0]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[1]==Column)&&(Box_Center_Row_Current[1]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[2]==Column)&&(Box_Center_Row_Current[2]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[3]==Column)&&(Box_Center_Row_Current[3]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else
		begin
			DistX = 20;
			DistY = 20;
		end
	end
	
   always_comb
	begin
       if ( (DistX*DistX<=Size*Size) && (DistY*DistY<=Size*Size) )
			  // Need Modify
           Color_Dynamic = 3'b011;
       else
           Color_Dynamic = 3'b000;
       /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
          the single line is quite powerful descriptively, it causes the synthesis tool to use up three
          of the 12 available multipliers on the chip! */
   end
	
endmodule

// The L-shaped Block Left
module LL_block ( input Clk,
							  frame_clk,
							  Reset,
							  Active,
							  LEFT, RIGHT, UP, DOWN, SPACE,
					  input [9:0] DrawX, DrawY,
					  input [23:0][15:0] Static_Array,
					  output En_New_Static,
					  output [3:0][4:0] New_Static_Row,
					  output [3:0][3:0] New_Static_Column,
					  output [2:0] Color_Dynamic,
					  output [2:0] State_Bit
	);
	
	logic [3:0][4:0] Box_Center_Row_Initial;
	logic [3:0][3:0] Box_Center_Column_Initial;
	logic [3:0][4:0] Box_Center_Row_Current;
	logic [3:0][3:0] Box_Center_Column_Current;
	logic Touched;
	logic [15:0][9:0] Box_X_Center;
	logic [23:0][9:0] Box_Y_Center;
	
	// Initial Position: Need Modify
	assign Box_Center_Row_Initial[0] = 5'd0;
	assign Box_Center_Row_Initial[1] = 5'd1;
	assign Box_Center_Row_Initial[2] = 5'd2;
	assign Box_Center_Row_Initial[3] = 5'd2;
	assign Box_Center_Column_Initial[0] = 4'd7;
	assign Box_Center_Column_Initial[1] = 4'd7;
	assign Box_Center_Column_Initial[2] = 4'd7;
	assign Box_Center_Column_Initial[3] = 4'd8;
	assign New_Static_Row[0] = Box_Center_Row_Current[0];
	assign New_Static_Row[1] = Box_Center_Row_Current[1];
	assign New_Static_Row[2] = Box_Center_Row_Current[2];
	assign New_Static_Row[3] = Box_Center_Row_Current[3];
	assign New_Static_Column[0] = Box_Center_Column_Current[0];
	assign New_Static_Column[1] = Box_Center_Column_Current[1];
	assign New_Static_Column[2] = Box_Center_Column_Current[2];
	assign New_Static_Column[3] = Box_Center_Column_Current[3];
	
	assign Box_X_Center[0] = 10'd225;
	assign Box_X_Center[1] = 10'd246;
	assign Box_X_Center[2] = 10'd267;
	assign Box_X_Center[3] = 10'd288;
	assign Box_X_Center[4] = 10'd309;
	assign Box_X_Center[5] = 10'd330;
	assign Box_X_Center[6] = 10'd351;
	assign Box_X_Center[7] = 10'd372;
	assign Box_X_Center[8] = 10'd393;
	assign Box_X_Center[9] = 10'd414;
	assign Box_X_Center[10] = 10'd435;
	assign Box_X_Center[11] = 10'd456;
	assign Box_X_Center[12] = 10'd477;
	assign Box_X_Center[13] = 10'd498;
	assign Box_X_Center[14] = 10'd519;
	assign Box_X_Center[15] = 10'd540;
	
	assign Box_Y_Center[4] = 10'd41;
	assign Box_Y_Center[5] = 10'd62;
	assign Box_Y_Center[6] = 10'd83;
	assign Box_Y_Center[7] = 10'd104;
	assign Box_Y_Center[8] = 10'd125;
	assign Box_Y_Center[9] = 10'd146;
	assign Box_Y_Center[10] = 10'd167;
	assign Box_Y_Center[11] = 10'd188;
	assign Box_Y_Center[12] = 10'd209;
	assign Box_Y_Center[13] = 10'd230;
	assign Box_Y_Center[14] = 10'd251;
	assign Box_Y_Center[15] = 10'd272;
	assign Box_Y_Center[16] = 10'd293;
	assign Box_Y_Center[17] = 10'd314;
	assign Box_Y_Center[18] = 10'd335;
	assign Box_Y_Center[19] = 10'd356;
	assign Box_Y_Center[20] = 10'd377;
	assign Box_Y_Center[21] = 10'd398;
	assign Box_Y_Center[22] = 10'd419;
	assign Box_Y_Center[23] = 10'd440;
	
	enum logic [2:0] {Halted, Falling, Touchdown}	State, Next_State;
	logic [1:0] R_State;
	
   // Detect rising edge of frame_clk
	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk)
	begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	
	always_ff @ (posedge Clk)
	begin
		if (frame_clk_rising_edge)
			case (State)
				Halted:
				begin
					Box_Center_Row_Current[0] <= Box_Center_Row_Initial[0];
					Box_Center_Row_Current[1] <= Box_Center_Row_Initial[1];
					Box_Center_Row_Current[2] <= Box_Center_Row_Initial[2];
					Box_Center_Row_Current[3] <= Box_Center_Row_Initial[3];
					Box_Center_Column_Current[0] <= Box_Center_Column_Initial[0];
					Box_Center_Column_Current[1] <= Box_Center_Column_Initial[1];
					Box_Center_Column_Current[2] <= Box_Center_Column_Initial[2];
					Box_Center_Column_Current[3] <= Box_Center_Column_Initial[3];
				end
				
				Falling:
					if (~Touched)
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
					end
				
				Touchdown: ;
				default: ;
			endcase

		if (State == Halted)
			R_State = 2'b00;
		else if (State == Falling)
		begin
			if (LEFT)
			begin
				if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]-4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]-4'd1] != 1'b1)
						&& (Box_Center_Column_Current[0] != 4'd0)
						&& (Box_Center_Column_Current[1] != 4'd0)
						&& (Box_Center_Column_Current[2] != 4'd0)
						&& (Box_Center_Column_Current[3] != 4'd0))
				begin
					Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
					Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
					Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
					Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1;
				end
			end
			
			else if (RIGHT)
			begin
				if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]+4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]+4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]+4'd1] != 1'b1)
						&& (Box_Center_Column_Current[0] != 4'd15)
						&& (Box_Center_Column_Current[1] != 4'd15)
						&& (Box_Center_Column_Current[2] != 4'd15)
						&& (Box_Center_Column_Current[3] != 4'd15))
				begin
					Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1;
					Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
					Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
					Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
				end
			end
			
			else if (DOWN)
			begin
				if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
						&& (Box_Center_Row_Current[0] != 5'd23)
						&& (Box_Center_Row_Current[1] != 5'd23)
						&& (Box_Center_Row_Current[2] != 5'd23)
						&& (Box_Center_Row_Current[3] != 5'd23))
				begin
					Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+4'd1;
					Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+4'd1;
					Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+4'd1;
					Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+4'd1;
				end
			end
			
			else if (SPACE)
			begin
				if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
						&& (Box_Center_Row_Current[0] != 5'd23)
						&& (Box_Center_Row_Current[1] != 5'd23)
						&& (Box_Center_Row_Current[2] != 5'd23)
						&& (Box_Center_Row_Current[3] != 5'd23))
				begin
					Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
					Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
					Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
					Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
				end
			end
			
			else if (UP)
				begin
					
					if (R_State == 2'b00)
					
					// as the right side is three, consider sliding through the wall
					begin
						if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd2] != 1'b1)
						&& (Box_Center_Column_Current[3] <=5'd8)
						)
						
							begin  // first next state, only move 1 to right and down
								Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
								Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
								Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]-5'd1;
								Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
								Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd2;
								Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
								Box_Center_Column_Current[2] <= Box_Center_Column_Current[2];
								Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1;
								R_State <= 1'b01;
							end
						else if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-5'd1] != 1'b1)
						&& (Box_Center_Column_Current[3] > 5'd8)
						)
							begin 
								Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
								Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
								Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]-5'd1;
								Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
								Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd2-4'd1;
								Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1-4'd1;
								Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
								Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1-4'd1;
								R_State <= 1'b01;
							end
							
						else if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd1] != 1'b1)
//						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-5'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd2] == 1'b1)
						&& (Box_Center_Column_Current[3] >= 5'd2)
						)
							begin 
								Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
								Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
								Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]-5'd1;
								Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
								Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd2-4'd1;
								Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1-4'd1;
								Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
								Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1-4'd1;
								R_State <= 1'b01;
							end	
						
					end
						

					else if (R_State == 2'b01)
					
					begin 
						if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]+5'd1] != 1'b1)
						)
							begin  
								Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd2;
								Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
								Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
								Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]-5'd1;
								Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
								Box_Center_Column_Current[1] <= Box_Center_Column_Current[1];
								Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
								Box_Center_Column_Current[3] <= Box_Center_Column_Current[3];
								R_State <= 2'b10;
							end
					end
							
					// consider sliding through the right
					else if (R_State == 2'b10)
					begin
						if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]+5'd1] != 1'b1)
						&& (Box_Center_Column_Current[1] <= 8)
						)
							begin  
								Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd1;
								Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
								Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
								Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
								Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
								Box_Center_Column_Current[1] <= Box_Center_Column_Current[1];
								Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
								Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd2;
								R_State <= 2'b11;
							end
							
						else if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd2] != 1'b1)
						&& (Box_Center_Column_Current[1] >= 9)
//					   && (Box_Center_Row_Current[0] != 5'd23)
						)
							begin  
								Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd1;
								Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
								Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
								Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
								Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1-4'd1;
								Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
								Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1-4'd1;
								Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd2-4'd1;
								R_State <= 2'b11;
							end
														
						else if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-5'd2] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd1] == 1'b1)
						&& (Box_Center_Column_Current[1] >= 2)
						)
							begin  
								Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd1;
								Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
								Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
								Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
								Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1-4'd1;
								Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
								Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1-4'd1;
								Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd2-'d1;
								R_State <= 2'b11;
							end
							
					end
					
					

					else
					begin 
						if ((Static_Array[Box_Center_Row_Current[1]-5'd1][Box_Center_Column_Current[1]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]-5'd2][Box_Center_Column_Current[1]] != 1'b1)
						)
							begin  // first next state, only move 1 to right and down
								Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd2;
								Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]-5'd1;
								Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
								Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
								Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1;
								Box_Center_Column_Current[1] <= Box_Center_Column_Current[1];
								Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
								Box_Center_Column_Current[3] <= Box_Center_Column_Current[3];
								R_State <= 2'b00;
							end
					end
				
				end
				
			end
			
		if (Reset) 	
				State <= Halted;
		else 
			State <= Next_State;			
		
	end
	
	logic [3:0][4:0] NextRow;
	assign NextRow[0] = Box_Center_Row_Current[0]+5'd1;
	assign NextRow[1] = Box_Center_Row_Current[1]+5'd1;
	assign NextRow[2] = Box_Center_Row_Current[2]+5'd1;
	assign NextRow[3] = Box_Center_Row_Current[3]+5'd1;
	
	int  Row,Column;
	assign Row = (DrawY-10'd31)/10'd21+10'd4;
	assign Column = (DrawX-10'd215)/10'd21;
	
   int DistX, DistY, Size;
   assign Size = 10'd9;
	
	always_comb
	begin
		unique case (State)
			Halted:
			begin
				if (Active)
					Next_State = Falling;
				else
					Next_State = Halted;
			end
			
			Falling:
			begin
				if (Touched)
				begin
					if (frame_clk_rising_edge)
						Next_State = Touchdown;
					else
						Next_State = Falling;
				end
				else
					Next_State = Falling;
			end
			
			Touchdown:
			begin
				Next_State = Halted;
			end
			
			default:
				Next_State = Halted;
		endcase

		
		if (Static_Array[NextRow[0]][Box_Center_Column_Current[0]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[1]][Box_Center_Column_Current[1]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[2]][Box_Center_Column_Current[2]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[3]][Box_Center_Column_Current[3]] == 1'b1)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[0] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[1] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[2] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[3] == 5'd23)
			Touched = 1'b1;
		else
			Touched = 1'b0;
			
		case (State)
			Halted:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b001;
			end
			Falling:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b010;
			end
			Touchdown:
			begin
				En_New_Static = 1'b1;
				State_Bit = 3'b100;
			end
			default: ;
		endcase

		if ((Box_Center_Column_Current[0]==Column)&&(Box_Center_Row_Current[0]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[1]==Column)&&(Box_Center_Row_Current[1]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[2]==Column)&&(Box_Center_Row_Current[2]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[3]==Column)&&(Box_Center_Row_Current[3]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else
		begin
			DistX = 20;
			DistY = 20;
		end
	end
	
   always_comb
	begin
       if ( (DistX*DistX<=Size*Size) && (DistY*DistY<=Size*Size) )
			  // Need Modify
           Color_Dynamic = 3'b011;
       else
           Color_Dynamic = 3'b000;
       /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
          the single line is quite powerful descriptively, it causes the synthesis tool to use up three
          of the 12 available multipliers on the chip! */
   end
	
endmodule

// The Left-folding Block

module LF_block ( input Clk,
							  frame_clk,
							  Reset,
							  Active,
							  LEFT, RIGHT, UP, DOWN, SPACE,
					  input [9:0] DrawX, DrawY,
					  input [23:0][15:0] Static_Array,
					  output En_New_Static,
					  output [3:0][4:0] New_Static_Row,
					  output [3:0][3:0] New_Static_Column,
					  output [2:0] Color_Dynamic,
					  output [2:0] State_Bit
	);

	
	logic [3:0][4:0] Box_Center_Row_Initial;
	logic [3:0][3:0] Box_Center_Column_Initial;
	logic [3:0][4:0] Box_Center_Row_Current;
	logic [3:0][3:0] Box_Center_Column_Current;
	logic Touched;
	logic [15:0][9:0] Box_X_Center;
	logic [23:0][9:0] Box_Y_Center;
	
	// Initial Position: Need Modify
	assign Box_Center_Row_Initial[0] = 5'd0;
	assign Box_Center_Row_Initial[1] = 5'd0;
	assign Box_Center_Row_Initial[2] = 5'd1;
	assign Box_Center_Row_Initial[3] = 5'd1;
	assign Box_Center_Column_Initial[0] = 4'd6;
	assign Box_Center_Column_Initial[1] = 4'd7;
	assign Box_Center_Column_Initial[2] = 4'd7;
	assign Box_Center_Column_Initial[3] = 4'd8;
	assign New_Static_Row[0] = Box_Center_Row_Current[0];
	assign New_Static_Row[1] = Box_Center_Row_Current[1];
	assign New_Static_Row[2] = Box_Center_Row_Current[2];
	assign New_Static_Row[3] = Box_Center_Row_Current[3];
	assign New_Static_Column[0] = Box_Center_Column_Current[0];
	assign New_Static_Column[1] = Box_Center_Column_Current[1];
	assign New_Static_Column[2] = Box_Center_Column_Current[2];
	assign New_Static_Column[3] = Box_Center_Column_Current[3];
	
	assign Box_X_Center[0] = 10'd225;
	assign Box_X_Center[1] = 10'd246;
	assign Box_X_Center[2] = 10'd267;
	assign Box_X_Center[3] = 10'd288;
	assign Box_X_Center[4] = 10'd309;
	assign Box_X_Center[5] = 10'd330;
	assign Box_X_Center[6] = 10'd351;
	assign Box_X_Center[7] = 10'd372;
	assign Box_X_Center[8] = 10'd393;
	assign Box_X_Center[9] = 10'd414;
	assign Box_X_Center[10] = 10'd435;
	assign Box_X_Center[11] = 10'd456;
	assign Box_X_Center[12] = 10'd477;
	assign Box_X_Center[13] = 10'd498;
	assign Box_X_Center[14] = 10'd519;
	assign Box_X_Center[15] = 10'd540;
	
	assign Box_Y_Center[4] = 10'd41;
	assign Box_Y_Center[5] = 10'd62;
	assign Box_Y_Center[6] = 10'd83;
	assign Box_Y_Center[7] = 10'd104;
	assign Box_Y_Center[8] = 10'd125;
	assign Box_Y_Center[9] = 10'd146;
	assign Box_Y_Center[10] = 10'd167;
	assign Box_Y_Center[11] = 10'd188;
	assign Box_Y_Center[12] = 10'd209;
	assign Box_Y_Center[13] = 10'd230;
	assign Box_Y_Center[14] = 10'd251;
	assign Box_Y_Center[15] = 10'd272;
	assign Box_Y_Center[16] = 10'd293;
	assign Box_Y_Center[17] = 10'd314;
	assign Box_Y_Center[18] = 10'd335;
	assign Box_Y_Center[19] = 10'd356;
	assign Box_Y_Center[20] = 10'd377;
	assign Box_Y_Center[21] = 10'd398;
	assign Box_Y_Center[22] = 10'd419;
	assign Box_Y_Center[23] = 10'd440;
	
	enum logic [2:0] {Halted, Falling, Touchdown}	State, Next_State;
	logic R_State;
	
   // Detect rising edge of frame_clk
	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk)
	begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	
	always_ff @ (posedge Clk)
	begin
		if (frame_clk_rising_edge)
			case (State)
				Halted:
				begin
					Box_Center_Row_Current[0] <= Box_Center_Row_Initial[0];
					Box_Center_Row_Current[1] <= Box_Center_Row_Initial[1];
					Box_Center_Row_Current[2] <= Box_Center_Row_Initial[2];
					Box_Center_Row_Current[3] <= Box_Center_Row_Initial[3];
					Box_Center_Column_Current[0] <= Box_Center_Column_Initial[0];
					Box_Center_Column_Current[1] <= Box_Center_Column_Initial[1];
					Box_Center_Column_Current[2] <= Box_Center_Column_Initial[2];
					Box_Center_Column_Current[3] <= Box_Center_Column_Initial[3];
				end
				
				Falling:
					if (~Touched)
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
					end
				
				Touchdown: ;
				default: ;
			endcase
		
		if (State == Halted)
			R_State <= 1'b0;
		else if (State == Falling)
			begin
				if (LEFT)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]-4'd1] != 1'b1)
							&& (Box_Center_Column_Current[0] != 4'd0)
							&& (Box_Center_Column_Current[1] != 4'd0)
							&& (Box_Center_Column_Current[2] != 4'd0)
							&& (Box_Center_Column_Current[3] != 4'd0))
					begin
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1;
					end
				end
				
				else if (RIGHT)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]+4'd1] != 1'b1)
							&& (Box_Center_Column_Current[0] != 4'd15)
							&& (Box_Center_Column_Current[1] != 4'd15)
							&& (Box_Center_Column_Current[2] != 4'd15)
							&& (Box_Center_Column_Current[3] != 4'd15))
					begin
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1;
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
					end
				end
				
				else if (DOWN)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
							&& (Box_Center_Row_Current[0] != 5'd23)
							&& (Box_Center_Row_Current[1] != 5'd23)
							&& (Box_Center_Row_Current[2] != 5'd23)
							&& (Box_Center_Row_Current[3] != 5'd23))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+4'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+4'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+4'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+4'd1;
					end
				end
				
				else if (SPACE)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
							&& (Box_Center_Row_Current[0] != 5'd23)
							&& (Box_Center_Row_Current[1] != 5'd23)
							&& (Box_Center_Row_Current[2] != 5'd23)
							&& (Box_Center_Row_Current[3] != 5'd23))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
					end
				end
			
				else if (UP)
					begin
						
						if (R_State == 1'b0)						
						// as the right side is three, consider sliding through the wall
						begin
							if ((Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+5'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]-5'd2][Box_Center_Column_Current[3]] != 1'b1))
								begin  // first next state, only move 1 to right and down                                                                                                                   
									Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-4'd1;
									Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
									Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]-4'd1;
									Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
									Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd2;
									Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
									Box_Center_Column_Current[2] <= Box_Center_Column_Current[2];
									Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1;
									R_State <= 1'b01;
								end
						end																				
						

						else
						begin 
							if ((Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-5'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]+5'd2][Box_Center_Column_Current[0]] != 1'b1)
							&& (Box_Center_Column_Current[2] >= 4'd1 ))
								begin  
									Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+4'd1;
									Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
									Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+4'd1;
									Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
									Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd2;
									Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
									Box_Center_Column_Current[2] <= Box_Center_Column_Current[2];
									Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
									R_State <= 1'b0;
								end
								
							else if ((Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]+5'd2] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
							&& (Box_Center_Column_Current[2] < 4'd1 ))
								begin 
									Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+4'd1;
									Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
									Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+4'd1;
									Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
									Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd2+4'd1;
									Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1+4'd1;
									Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
									Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1+4'd1;
									R_State <= 1'b0;
								end 
							
							else if ((Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]+5'd2] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-5'd1] == 1'b1)
							&& (Box_Center_Column_Current[2] <= 4'd7 ))
								begin 
									Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+4'd1;
									Box_Center_Row_Current[1] <= Box_Center_Row_Current[1];
									Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+4'd1;
									Box_Center_Row_Current[3] <= Box_Center_Row_Current[3];
									Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd2+4'd1;
									Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1+4'd1;
									Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
									Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1+4'd1;
									R_State <= 1'b0;
								end 
							
							
						end
					
				end
				
			end
			
		if (Reset)
			State <= Halted;
		else 
			State <= Next_State;			
		
	end
	
	logic [3:0][4:0] NextRow;
	assign NextRow[0] = Box_Center_Row_Current[0]+5'd1;
	assign NextRow[1] = Box_Center_Row_Current[1]+5'd1;
	assign NextRow[2] = Box_Center_Row_Current[2]+5'd1;
	assign NextRow[3] = Box_Center_Row_Current[3]+5'd1;
	
	int  Row,Column;
	assign Row = (DrawY-10'd31)/10'd21+10'd4;
	assign Column = (DrawX-10'd215)/10'd21;
	
   int DistX, DistY, Size;
   assign Size = 10'd9;
	
	always_comb
	begin
		unique case (State)
			Halted:
			begin
				if (Active)
					Next_State = Falling;
				else
					Next_State = Halted;
			end
			
			Falling:
			begin
				if (Touched)
				begin
					if (frame_clk_rising_edge)
						Next_State = Touchdown;
					else
						Next_State = Falling;
				end
				else
					Next_State = Falling;
			end
			
			Touchdown:
			begin
				Next_State = Halted;
			end
			
			default:
				Next_State = Halted;
		endcase

		if (Static_Array[NextRow[0]][Box_Center_Column_Current[0]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[1]][Box_Center_Column_Current[1]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[2]][Box_Center_Column_Current[2]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[3]][Box_Center_Column_Current[3]] == 1'b1)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[0] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[1] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[2] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[3] == 5'd23)
			Touched = 1'b1;
		else
			Touched = 1'b0;
			
		case (State)
			Halted:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b001;
			end
			Falling:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b010;
			end
			Touchdown:
			begin
				En_New_Static = 1'b1;
				State_Bit = 3'b100;
			end
			default: ;
		endcase

			
		if ((Box_Center_Column_Current[0]==Column)&&(Box_Center_Row_Current[0]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[1]==Column)&&(Box_Center_Row_Current[1]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[2]==Column)&&(Box_Center_Row_Current[2]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[3]==Column)&&(Box_Center_Row_Current[3]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else
		begin
			DistX = 20;
			DistY = 20;
		end
	end
	
   always_comb
	begin
       if ( (DistX*DistX<=Size*Size) && (DistY*DistY<=Size*Size) )
			  // Need Modify
           Color_Dynamic = 3'b011;
       else
           Color_Dynamic = 3'b000;
       /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
          the single line is quite powerful descriptively, it causes the synthesis tool to use up three
          of the 12 available multipliers on the chip! */
   end
	
endmodule

// The I-shaped Block
module I_block ( input Clk,
							  frame_clk,
							  Reset,
							  Active,
							  LEFT, RIGHT, UP, DOWN, SPACE,
					  input [9:0] DrawX, DrawY,
					  input [23:0][15:0] Static_Array,
					  output En_New_Static,
					  output [3:0][4:0] New_Static_Row,
					  output [3:0][3:0] New_Static_Column,
					  output [2:0] Color_Dynamic,
					  output [2:0] State_Bit
	);
	
	logic [3:0][4:0] Box_Center_Row_Initial;
	logic [3:0][3:0] Box_Center_Column_Initial;
	logic [3:0][4:0] Box_Center_Row_Current;
	logic [3:0][3:0] Box_Center_Column_Current;
	logic Touched;
	logic [15:0][9:0] Box_X_Center;
	logic [23:0][9:0] Box_Y_Center;
	
	// Initial Position: Need Modify
	assign Box_Center_Row_Initial[0] = 5'd1;
	assign Box_Center_Row_Initial[1] = 5'd1;
	assign Box_Center_Row_Initial[2] = 5'd1;
	assign Box_Center_Row_Initial[3] = 5'd1;
	assign Box_Center_Column_Initial[0] = 4'd6;
	assign Box_Center_Column_Initial[1] = 4'd7;
	assign Box_Center_Column_Initial[2] = 4'd8;
	assign Box_Center_Column_Initial[3] = 4'd9;
	assign New_Static_Row[0] = Box_Center_Row_Current[0];
	assign New_Static_Row[1] = Box_Center_Row_Current[1];
	assign New_Static_Row[2] = Box_Center_Row_Current[2];
	assign New_Static_Row[3] = Box_Center_Row_Current[3];
	assign New_Static_Column[0] = Box_Center_Column_Current[0];
	assign New_Static_Column[1] = Box_Center_Column_Current[1];
	assign New_Static_Column[2] = Box_Center_Column_Current[2];
	assign New_Static_Column[3] = Box_Center_Column_Current[3];
	
	assign Box_X_Center[0] = 10'd225;
	assign Box_X_Center[1] = 10'd246;
	assign Box_X_Center[2] = 10'd267;
	assign Box_X_Center[3] = 10'd288;
	assign Box_X_Center[4] = 10'd309;
	assign Box_X_Center[5] = 10'd330;
	assign Box_X_Center[6] = 10'd351;
	assign Box_X_Center[7] = 10'd372;
	assign Box_X_Center[8] = 10'd393;
	assign Box_X_Center[9] = 10'd414;
	assign Box_X_Center[10] = 10'd435;
	assign Box_X_Center[11] = 10'd456;
	assign Box_X_Center[12] = 10'd477;
	assign Box_X_Center[13] = 10'd498;
	assign Box_X_Center[14] = 10'd519;
	assign Box_X_Center[15] = 10'd540;
	
	assign Box_Y_Center[4] = 10'd41;
	assign Box_Y_Center[5] = 10'd62;
	assign Box_Y_Center[6] = 10'd83;
	assign Box_Y_Center[7] = 10'd104;
	assign Box_Y_Center[8] = 10'd125;
	assign Box_Y_Center[9] = 10'd146;
	assign Box_Y_Center[10] = 10'd167;
	assign Box_Y_Center[11] = 10'd188;
	assign Box_Y_Center[12] = 10'd209;
	assign Box_Y_Center[13] = 10'd230;
	assign Box_Y_Center[14] = 10'd251;
	assign Box_Y_Center[15] = 10'd272;
	assign Box_Y_Center[16] = 10'd293;
	assign Box_Y_Center[17] = 10'd314;
	assign Box_Y_Center[18] = 10'd335;
	assign Box_Y_Center[19] = 10'd356;
	assign Box_Y_Center[20] = 10'd377;
	assign Box_Y_Center[21] = 10'd398;
	assign Box_Y_Center[22] = 10'd419;
	assign Box_Y_Center[23] = 10'd440;
	
	enum logic [2:0] {Halted, Falling, Touchdown}	State, Next_State;
	logic R_State;
	
   // Detect rising edge of frame_clk
	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk)
	begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	
	always_ff @ (posedge Clk)
	begin
		if (frame_clk_rising_edge)
			case (State)
				Halted:
				begin
					Box_Center_Row_Current[0] <= Box_Center_Row_Initial[0];
					Box_Center_Row_Current[1] <= Box_Center_Row_Initial[1];
					Box_Center_Row_Current[2] <= Box_Center_Row_Initial[2];
					Box_Center_Row_Current[3] <= Box_Center_Row_Initial[3];
					Box_Center_Column_Current[0] <= Box_Center_Column_Initial[0];
					Box_Center_Column_Current[1] <= Box_Center_Column_Initial[1];
					Box_Center_Column_Current[2] <= Box_Center_Column_Initial[2];
					Box_Center_Column_Current[3] <= Box_Center_Column_Initial[3];
				end
				
				Falling:
					if (~Touched)
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
					end
				
				Touchdown: ;
				default: ;
			endcase
		
		if (State == Halted)
			R_State <= 1'b0;
		else if (State == Falling)
		begin
			if (LEFT)
			begin
				if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]-4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]-4'd1] != 1'b1)
						&& (Box_Center_Column_Current[0] != 4'd0)
						&& (Box_Center_Column_Current[1] != 4'd0)
						&& (Box_Center_Column_Current[2] != 4'd0)
						&& (Box_Center_Column_Current[3] != 4'd0))
				begin
					Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
					Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
					Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
					Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1;
				end
			end
			
			else if (RIGHT)
			begin
				if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]+4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]+4'd1] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]+4'd1] != 1'b1)
						&& (Box_Center_Column_Current[0] != 4'd15)
						&& (Box_Center_Column_Current[1] != 4'd15)
						&& (Box_Center_Column_Current[2] != 4'd15)
						&& (Box_Center_Column_Current[3] != 4'd15))
				begin
					Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1;
					Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
					Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
					Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
				end
			end
			
			else if (DOWN)
			begin
				if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
						&& (Box_Center_Row_Current[0] != 5'd23)
						&& (Box_Center_Row_Current[1] != 5'd23)
						&& (Box_Center_Row_Current[2] != 5'd23)
						&& (Box_Center_Row_Current[3] != 5'd23))
				begin
					Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
					Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
					Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
					Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
				end
			end
			
			else if (SPACE)
			begin
				if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
						&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
						&& (Box_Center_Row_Current[0] != 5'd23)
						&& (Box_Center_Row_Current[1] != 5'd23)
						&& (Box_Center_Row_Current[2] != 5'd23)
						&& (Box_Center_Row_Current[3] != 5'd23))
				begin
					Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
					Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
					Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
					Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
				end
			end
			
			else if (UP)
			begin
				if (R_State == 1'b0)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]-5'd2][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]-5'd1][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
							&& (Box_Center_Row_Current[0]) != 5'd23)
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd2;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[0]-5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[0];
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[1];
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[1];
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[1];
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[1];
						R_State <= 1'b1;
					end
					
					else if ((Static_Array[Box_Center_Row_Current[0]-5'd2][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]-5'd1][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
							&& (Box_Center_Row_Current[0]) != 5'd23)
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd2;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[0]-5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[0];
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[2];
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[2];
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[2];
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[2];
						R_State <= 1'b1;
					end
					
					else if ((Static_Array[Box_Center_Row_Current[0]-5'd3][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]-5'd2][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]-5'd1][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[1]] != 1'b1))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd3;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[0]-5'd2;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[0]-5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[0];
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[1];
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[1];
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[1];
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[1];
						R_State <= 1'b1;
					end
					
					else if ((Static_Array[Box_Center_Row_Current[0]-5'd3][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]-5'd2][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]-5'd1][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[2]] != 1'b1))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]-5'd3;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[0]-5'd2;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[0]-5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[0];
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[2];
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[2];
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[2];
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[2];
						R_State <= 1'b1;
					end
				end
					
				else
				begin
					if ((Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]+4'd2] != 1'b1)
							&& (Box_Center_Column_Current[0] >= 4'd1)
							&& (Box_Center_Column_Current[0] <= 4'd7))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[2];
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[2];
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[2];
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[0];
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[0]+4'd1;
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[0]+4'd2;
						R_State <= 1'b0;
					end
					
					else if ((Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]-4'd2] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]+4'd1] != 1'b1)
							&& (Box_Center_Column_Current[0] >= 4'd2)
							&& (Box_Center_Column_Current[0] <= 4'd8))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[2];
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[2];
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[2];
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd2;
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[0]-4'd1;
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[0];
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[0]+4'd1;
						R_State <= 1'b0;
					end
						
					else if ((Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]+4'd2] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]+4'd3] != 1'b1)
							&& (Box_Center_Column_Current[0] <= 4'd6))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[2];
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[2];
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[2];
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[0];
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[0]+4'd1;
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[0]+4'd2;
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[0]+4'd3;
						R_State <= 1'b0;
					end
					
					else if ((Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]-4'd3] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]-4'd2] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[0]] != 1'b1)
							&& (Box_Center_Column_Current[0] >= 4'd3))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[2];
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[2];
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2];
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[2];
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd3;
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[0]-4'd2;
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[0]-4'd1;
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[0];
						R_State <= 1'b0;
					end
				end
			end
		end
			
		if (Reset)
		begin
			State <= Halted;
		end
		else
			State <= Next_State;	
		
	end
	
	logic [3:0][4:0] NextRow;
	assign NextRow[0] = Box_Center_Row_Current[0]+5'd1;
	assign NextRow[1] = Box_Center_Row_Current[1]+5'd1;
	assign NextRow[2] = Box_Center_Row_Current[2]+5'd1;
	assign NextRow[3] = Box_Center_Row_Current[3]+5'd1;
	
	int  Row,Column;
	assign Row = (DrawY-10'd31)/10'd21+10'd4;
	assign Column = (DrawX-10'd215)/10'd21;
	
   int DistX, DistY, Size;
   assign Size = 10'd9;
	
	always_comb
	begin
		unique case (State)
			Halted:
			begin
				if (Active)
					Next_State = Falling;
				else
					Next_State = Halted;
			end
			
			Falling:
			begin
				if (Touched)
				begin
					if (frame_clk_rising_edge)
						Next_State = Touchdown;
					else
						Next_State = Falling;
				end
				else
					Next_State = Falling;
			end
			
			Touchdown:
			begin
				Next_State = Halted;
			end
			
			default:
				Next_State = Halted;
		endcase

		
		if (Static_Array[NextRow[0]][Box_Center_Column_Current[0]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[1]][Box_Center_Column_Current[1]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[2]][Box_Center_Column_Current[2]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[3]][Box_Center_Column_Current[3]] == 1'b1)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[0] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[1] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[2] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[3] == 5'd23)
			Touched = 1'b1;
		else
			Touched = 1'b0;
			
		case (State)
			Halted:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b001;
			end
			Falling:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b010;
			end
			Touchdown:
			begin
				En_New_Static = 1'b1;
				State_Bit = 3'b100;
			end
			default: ;
		endcase

		if ((Box_Center_Column_Current[0]==Column)&&(Box_Center_Row_Current[0]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[1]==Column)&&(Box_Center_Row_Current[1]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[2]==Column)&&(Box_Center_Row_Current[2]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[3]==Column)&&(Box_Center_Row_Current[3]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else
		begin
			DistX = 20;
			DistY = 20;
		end
	end
	
   always_comb
	begin
       if ( (DistX*DistX<=Size*Size) && (DistY*DistY<=Size*Size) )
			  // Need Modify
           Color_Dynamic = 3'b011;
       else
           Color_Dynamic = 3'b000;
       /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
          the single line is quite powerful descriptively, it causes the synthesis tool to use up three
          of the 12 available multipliers on the chip! */
   end
	
endmodule

// The Square-shaped Block
module O_block ( input Clk,
							  frame_clk,
							  Reset,
							  Active,
							  LEFT, RIGHT, UP, DOWN, SPACE,
					  input [9:0] DrawX, DrawY,
					  input [23:0][15:0] Static_Array,
					  output En_New_Static,
					  output [3:0][4:0] New_Static_Row,
					  output [3:0][3:0] New_Static_Column,
					  output [2:0] Color_Dynamic,
					  output [2:0] State_Bit
	);

	
	logic [3:0][4:0] Box_Center_Row_Initial;
	logic [3:0][3:0] Box_Center_Column_Initial;
	logic [3:0][4:0] Box_Center_Row_Current;
	logic [3:0][3:0] Box_Center_Column_Current;
	logic Touched;
	logic [15:0][9:0] Box_X_Center;
	logic [23:0][9:0] Box_Y_Center;
	
	// Initial Position: Need Modify
	assign Box_Center_Row_Initial[0] = 5'd0;
	assign Box_Center_Row_Initial[1] = 5'd0;
	assign Box_Center_Row_Initial[2] = 5'd1;
	assign Box_Center_Row_Initial[3] = 5'd1;
	assign Box_Center_Column_Initial[0] = 4'd7;
	assign Box_Center_Column_Initial[1] = 4'd8;
	assign Box_Center_Column_Initial[2] = 4'd7;
	assign Box_Center_Column_Initial[3] = 4'd8;
	assign New_Static_Row[0] = Box_Center_Row_Current[0];
	assign New_Static_Row[1] = Box_Center_Row_Current[1];
	assign New_Static_Row[2] = Box_Center_Row_Current[2];
	assign New_Static_Row[3] = Box_Center_Row_Current[3];
	assign New_Static_Column[0] = Box_Center_Column_Current[0];
	assign New_Static_Column[1] = Box_Center_Column_Current[1];
	assign New_Static_Column[2] = Box_Center_Column_Current[2];
	assign New_Static_Column[3] = Box_Center_Column_Current[3];
	
	assign Box_X_Center[0] = 10'd225;
	assign Box_X_Center[1] = 10'd246;
	assign Box_X_Center[2] = 10'd267;
	assign Box_X_Center[3] = 10'd288;
	assign Box_X_Center[4] = 10'd309;
	assign Box_X_Center[5] = 10'd330;
	assign Box_X_Center[6] = 10'd351;
	assign Box_X_Center[7] = 10'd372;
	assign Box_X_Center[8] = 10'd393;
	assign Box_X_Center[9] = 10'd414;
	assign Box_X_Center[10] = 10'd435;
	assign Box_X_Center[11] = 10'd456;
	assign Box_X_Center[12] = 10'd477;
	assign Box_X_Center[13] = 10'd498;
	assign Box_X_Center[14] = 10'd519;
	assign Box_X_Center[15] = 10'd540;
	
	assign Box_Y_Center[4] = 10'd41;
	assign Box_Y_Center[5] = 10'd62;
	assign Box_Y_Center[6] = 10'd83;
	assign Box_Y_Center[7] = 10'd104;
	assign Box_Y_Center[8] = 10'd125;
	assign Box_Y_Center[9] = 10'd146;
	assign Box_Y_Center[10] = 10'd167;
	assign Box_Y_Center[11] = 10'd188;
	assign Box_Y_Center[12] = 10'd209;
	assign Box_Y_Center[13] = 10'd230;
	assign Box_Y_Center[14] = 10'd251;
	assign Box_Y_Center[15] = 10'd272;
	assign Box_Y_Center[16] = 10'd293;
	assign Box_Y_Center[17] = 10'd314;
	assign Box_Y_Center[18] = 10'd335;
	assign Box_Y_Center[19] = 10'd356;
	assign Box_Y_Center[20] = 10'd377;
	assign Box_Y_Center[21] = 10'd398;
	assign Box_Y_Center[22] = 10'd419;
	assign Box_Y_Center[23] = 10'd440;
	
	enum logic [2:0] {Halted, Falling, Touchdown}	State, Next_State;
	
   // Detect rising edge of frame_clk
	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk)
	begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	
	always_ff @ (posedge Clk)
	begin
		if (frame_clk_rising_edge)
			case (State)
				Halted:
				begin
					Box_Center_Row_Current[0] <= Box_Center_Row_Initial[0];
					Box_Center_Row_Current[1] <= Box_Center_Row_Initial[1];
					Box_Center_Row_Current[2] <= Box_Center_Row_Initial[2];
					Box_Center_Row_Current[3] <= Box_Center_Row_Initial[3];
					Box_Center_Column_Current[0] <= Box_Center_Column_Initial[0];
					Box_Center_Column_Current[1] <= Box_Center_Column_Initial[1];
					Box_Center_Column_Current[2] <= Box_Center_Column_Initial[2];
					Box_Center_Column_Current[3] <= Box_Center_Column_Initial[3];
				end
				
				Falling:
					if (~Touched)
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
					end
				
				Touchdown: ;
				default: ;
			endcase
			
		if (State == Falling)
			begin
				if (LEFT)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]-4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]-4'd1] != 1'b1)
							&& (Box_Center_Column_Current[0] != 4'd0)
							&& (Box_Center_Column_Current[1] != 4'd0)
							&& (Box_Center_Column_Current[2] != 4'd0)
							&& (Box_Center_Column_Current[3] != 4'd0))
					begin
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]-4'd1;
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]-4'd1;
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]-4'd1;
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]-4'd1;
					end
				end
				
				else if (RIGHT)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]][Box_Center_Column_Current[0]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]][Box_Center_Column_Current[1]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]][Box_Center_Column_Current[2]+4'd1] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]][Box_Center_Column_Current[3]+4'd1] != 1'b1)
							&& (Box_Center_Column_Current[0] != 4'd15)
							&& (Box_Center_Column_Current[1] != 4'd15)
							&& (Box_Center_Column_Current[2] != 4'd15)
							&& (Box_Center_Column_Current[3] != 4'd15))
					begin
						Box_Center_Column_Current[0] <= Box_Center_Column_Current[0]+4'd1;
						Box_Center_Column_Current[1] <= Box_Center_Column_Current[1]+4'd1;
						Box_Center_Column_Current[2] <= Box_Center_Column_Current[2]+4'd1;
						Box_Center_Column_Current[3] <= Box_Center_Column_Current[3]+4'd1;
					end
				end
				
				else if (DOWN)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
							&& (Box_Center_Row_Current[0] != 5'd23)
							&& (Box_Center_Row_Current[1] != 5'd23)
							&& (Box_Center_Row_Current[2] != 5'd23)
							&& (Box_Center_Row_Current[3] != 5'd23))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
					end
				end
				
				else if (SPACE)
				begin
					if ((Static_Array[Box_Center_Row_Current[0]+5'd1][Box_Center_Column_Current[0]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[1]+5'd1][Box_Center_Column_Current[1]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[2]+5'd1][Box_Center_Column_Current[2]] != 1'b1)
							&& (Static_Array[Box_Center_Row_Current[3]+5'd1][Box_Center_Column_Current[3]] != 1'b1)
							&& (Box_Center_Row_Current[0] != 5'd23)
							&& (Box_Center_Row_Current[1] != 5'd23)
							&& (Box_Center_Row_Current[2] != 5'd23)
							&& (Box_Center_Row_Current[3] != 5'd23))
					begin
						Box_Center_Row_Current[0] <= Box_Center_Row_Current[0]+5'd1;
						Box_Center_Row_Current[1] <= Box_Center_Row_Current[1]+5'd1;
						Box_Center_Row_Current[2] <= Box_Center_Row_Current[2]+5'd1;
						Box_Center_Row_Current[3] <= Box_Center_Row_Current[3]+5'd1;
					end
				end
			end

		
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_State;			
		
	end
	
	logic [3:0][4:0] NextRow;
	assign NextRow[0] = Box_Center_Row_Current[0]+5'd1;
	assign NextRow[1] = Box_Center_Row_Current[1]+5'd1;
	assign NextRow[2] = Box_Center_Row_Current[2]+5'd1;
	assign NextRow[3] = Box_Center_Row_Current[3]+5'd1;
	
	int  Row,Column;
	assign Row = (DrawY-10'd31)/10'd21+10'd4;
	assign Column = (DrawX-10'd215)/10'd21;
	
   int DistX, DistY, Size;
   assign Size = 10'd9;
	
	always_comb
	begin
		unique case (State)
			Halted:
			begin
				if (Active)
					Next_State = Falling;
				else
					Next_State = Halted;
			end
			
			Falling:
			begin
				if (Touched)
				begin
					if (frame_clk_rising_edge)
						Next_State = Touchdown;
					else
						Next_State = Falling;
				end
				else
					Next_State = Falling;
			end
			
			Touchdown:
			begin
				Next_State = Halted;
			end
			
			default:
				Next_State = Halted;
		endcase

		if (Static_Array[NextRow[0]][Box_Center_Column_Current[0]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[1]][Box_Center_Column_Current[1]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[2]][Box_Center_Column_Current[2]] == 1'b1)
			Touched = 1'b1;
		else if (Static_Array[NextRow[3]][Box_Center_Column_Current[3]] == 1'b1)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[0] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[1] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[2] == 5'd23)
			Touched = 1'b1;
		else if (Box_Center_Row_Current[3] == 5'd23)
			Touched = 1'b1;
		else
			Touched = 1'b0;
			
		case (State)
			Halted:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b001;
			end
			Falling:
			begin
				En_New_Static = 1'b0;
				State_Bit = 3'b010;
			end
			Touchdown:
			begin
				En_New_Static = 1'b1;
				State_Bit = 3'b100;
			end
			default: ;
		endcase
		
			
		if ((Box_Center_Column_Current[0]==Column)&&(Box_Center_Row_Current[0]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[1]==Column)&&(Box_Center_Row_Current[1]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[2]==Column)&&(Box_Center_Row_Current[2]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else if ((Box_Center_Column_Current[3]==Column)&&(Box_Center_Row_Current[3]==Row))
		begin
			DistX = DrawX - Box_X_Center[Column];
			DistY = DrawY - Box_Y_Center[Row];
		end
		else
		begin
			DistX = 20;
			DistY = 20;
		end
	end
	
   always_comb
	begin
       if ( (DistX*DistX<=Size*Size) && (DistY*DistY<=Size*Size) )
           Color_Dynamic = 3'b011;
       else
           Color_Dynamic = 3'b000;
   end
	
endmodule
