module static_box_array ( input Reset,
								  		  Clk,
								  		  frame_clk,
										  Active,
								  input En_New_Static,
								  input [3:0][4:0] New_Static_Row,
								  input [3:0][3:0] New_Static_Column,
								  input [2:0] New_Static_Color,
								  input [9:0] DrawX, DrawY,
								  output [2:0] Color_Static,
								  output [23:0][15:0] Static_Array,
								  output [6:0] Fall_Count,
								  output [5:0] Line_Count, 
								  output [6:0] Score,
								  output Win, Lose
	);
	
	enum logic [2:0] {Halted, Falling, Touchdown}	State, Next_State;

	logic [23:0][15:0][2:0]	Color_Array;

	logic [15:0][9:0]	Box_X_Center;
	logic [23:0][9:0]	Box_Y_Center;
	logic [23:0][5:0] Line_Counter;
	logic [5:0] Line_Count_delayed;
	
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
	
	assign Line_Count = Line_Counter[0]+Line_Counter[1]+Line_Counter[2]+Line_Counter[3]+Line_Counter[4]+Line_Counter[5]+Line_Counter[6]+Line_Counter[7]+Line_Counter[8]+Line_Counter[9]+Line_Counter[10]+Line_Counter[11]+Line_Counter[12]+Line_Counter[13]+Line_Counter[14]+Line_Counter[15]+Line_Counter[16]+Line_Counter[17]+Line_Counter[18]+Line_Counter[19]+Line_Counter[20]+Line_Counter[21]+Line_Counter[22]+Line_Counter[23];
	
	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk)
	begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	
	always_ff @ (posedge Clk)
	begin
		if (Reset)
		begin
			for (int i=0; i<24; i++)
			begin
				Color_Array[i][15] <= 3'b000;
				Color_Array[i][14] <= 3'b000;
				Color_Array[i][13] <= 3'b000;
				Color_Array[i][12] <= 3'b000;
				Color_Array[i][11] <= 3'b000;
				Color_Array[i][10] <= 3'b000;
				Color_Array[i][9] <= 3'b000;
				Color_Array[i][8] <= 3'b000;
				Color_Array[i][7] <= 3'b000;
				Color_Array[i][6] <= 3'b000;
				Color_Array[i][5] <= 3'b000;
				Color_Array[i][4] <= 3'b000;
				Color_Array[i][3] <= 3'b000;
				Color_Array[i][2] <= 3'b000;
				Color_Array[i][1] <= 3'b000;
				Color_Array[i][0] <= 3'b000;
				Static_Array[i] <= 16'b0;
				Line_Counter[i] <= 6'd0;
			end
			Fall_Count <= 7'd0;
			Score <= 7'd0;
		end
		else if (En_New_Static == 1'b1)
		begin
			Color_Array[New_Static_Row[0]][New_Static_Column[0]] <= New_Static_Color;
			Color_Array[New_Static_Row[1]][New_Static_Column[1]] <= New_Static_Color;
			Color_Array[New_Static_Row[2]][New_Static_Column[2]] <= New_Static_Color;
			Color_Array[New_Static_Row[3]][New_Static_Column[3]] <= New_Static_Color;
			Static_Array[New_Static_Row[0]][New_Static_Column[0]] <= 1'b1;
			Static_Array[New_Static_Row[1]][New_Static_Column[1]] <= 1'b1;
			Static_Array[New_Static_Row[2]][New_Static_Column[2]] <= 1'b1;
			Static_Array[New_Static_Row[3]][New_Static_Column[3]] <= 1'b1;
			Fall_Count <= Fall_Count+7'd1;
		end

		for (int k=23; k>0; k--)
		begin
			if ((Static_Array[k]==16'b0) && (Static_Array[k-1]!=16'b0))
			begin
				Static_Array[k] <= Static_Array[k-1];
				Static_Array[k-1] <= 16'b0;
				Color_Array[k][15] <= Color_Array[k-1][15];
				Color_Array[k][14] <= Color_Array[k-1][14];
				Color_Array[k][13] <= Color_Array[k-1][13];
				Color_Array[k][12] <= Color_Array[k-1][12];
				Color_Array[k][11] <= Color_Array[k-1][11];
				Color_Array[k][10] <= Color_Array[k-1][10];
				Color_Array[k][9] <= Color_Array[k-1][9];
				Color_Array[k][8] <= Color_Array[k-1][8];
				Color_Array[k][7] <= Color_Array[k-1][7];
				Color_Array[k][6] <= Color_Array[k-1][6];
				Color_Array[k][5] <= Color_Array[k-1][5];
				Color_Array[k][4] <= Color_Array[k-1][4];
				Color_Array[k][3] <= Color_Array[k-1][3];
				Color_Array[k][2] <= Color_Array[k-1][2];
				Color_Array[k][1] <= Color_Array[k-1][1];
				Color_Array[k][0] <= Color_Array[k-1][0];
				Color_Array[k-1][15] <= 3'b000;
				Color_Array[k-1][14] <= 3'b000;
				Color_Array[k-1][13] <= 3'b000;
				Color_Array[k-1][12] <= 3'b000;
				Color_Array[k-1][11] <= 3'b000;
				Color_Array[k-1][10] <= 3'b000;
				Color_Array[k-1][9] <= 3'b000;
				Color_Array[k-1][8] <= 3'b000;
				Color_Array[k-1][7] <= 3'b000;
				Color_Array[k-1][6] <= 3'b000;
				Color_Array[k-1][5] <= 3'b000;
				Color_Array[k-1][4] <= 3'b000;
				Color_Array[k-1][3] <= 3'b000;
				Color_Array[k-1][2] <= 3'b000;
				Color_Array[k-1][1] <= 3'b000;
				Color_Array[k-1][0] <= 3'b000;
			end
		end
		
		if (frame_clk_rising_edge)
		begin
			Line_Count_delayed <= Line_Count;
			if (Line_Count == Line_Count_delayed+6'd1)
				Score <= Score+7'd1;
			else if (Line_Count == Line_Count_delayed+6'd2)
				Score <= Score+7'd3;
			else if (Line_Count == Line_Count_delayed+6'd3)
				Score <= Score+7'd6;
			else if (Line_Count == Line_Count_delayed+6'd4)
				Score <= Score+7'd10;
				
			for (int i=23; i>3; i--)
			begin
				if ((Static_Array[i]==16'b0) && (Color_Array[i][0]==3'b111))
				begin
					Static_Array[i] <= 16'b0;
					Color_Array[i][15] <= 3'b0;
					Color_Array[i][14] <= 3'b0;
					Color_Array[i][13] <= 3'b0;
					Color_Array[i][12] <= 3'b0;
					Color_Array[i][11] <= 3'b0;
					Color_Array[i][10] <= 3'b0;
					Color_Array[i][9] <= 3'b0;
					Color_Array[i][8] <= 3'b0;
					Color_Array[i][7] <= 3'b0;
					Color_Array[i][6] <= 3'b0;
					Color_Array[i][5] <= 3'b0;
					Color_Array[i][4] <= 3'b0;
					Color_Array[i][3] <= 3'b0;
					Color_Array[i][2] <= 3'b0;
					Color_Array[i][1] <= 3'b0;
					Color_Array[i][0] <= 3'b0;
				end
			
				else if (Color_Array[i][0] == 3'b111 && Static_Array[i]==16'b1111111111111111)
				begin
					Static_Array[i] <= 16'b0;
					Line_Counter[i] <= Line_Counter[i]+6'd1;
				end
				
				else if (Static_Array[i]==16'b1111111111111111)
				begin
					Color_Array[i][15] <= 3'b111;
					Color_Array[i][14] <= 3'b111;
					Color_Array[i][13] <= 3'b111;
					Color_Array[i][12] <= 3'b111;
					Color_Array[i][11] <= 3'b111;
					Color_Array[i][10] <= 3'b111;
					Color_Array[i][9] <= 3'b111;
					Color_Array[i][8] <= 3'b111;
					Color_Array[i][7] <= 3'b111;
					Color_Array[i][6] <= 3'b111;
					Color_Array[i][5] <= 3'b111;
					Color_Array[i][4] <= 3'b111;
					Color_Array[i][3] <= 3'b111;
					Color_Array[i][2] <= 3'b111;
					Color_Array[i][1] <= 3'b111;
					Color_Array[i][0] <= 3'b111;
				end
			end
		end
	end

	int Row,Column;
	assign Row = (DrawY-10'd31)/10'd21+10'd4;
	assign Column = (DrawX-10'd215)/10'd21;
	
   int DistX, DistY, Size;
   assign DistX = DrawX - Box_X_Center[Column];
   assign DistY = DrawY - Box_Y_Center[Row];
   assign Size = 10'd9;
   always_comb
	begin
       if ( (DistX*DistX<=Size*Size) && (DistY*DistY<=Size*Size) )
           Color_Static = Color_Array[Row][Column];
		 
       else
           Color_Static = 3'b000;
			 
		if (Static_Array[3] != 16'b0)
		begin
			Win = 1'b0;
			Lose = 1'b1;
		end
		else if (Line_Count >= 6'd36)
		begin
			Win = 1'b1;
			Lose = 1'b0;
		end
		else
		begin
			Win = 1'b0;
			Lose = 1'b0;
		end
   end
endmodule

module total_dynamic (	input [2:0] Color_O_Block,
								input	En_O,
								input [2:0] State_O,
								input [3:0][4:0] New_Static_Row_O,
								input [3:0][3:0] New_Static_Column_O,
								
								input [2:0] Color_T_Block,
								input	En_T, 
								input [2:0] State_T,
								input [3:0][4:0] New_Static_Row_T,
								input [3:0][3:0] New_Static_Column_T,
								
								
								input [2:0] Color_I_Block,
								input	En_I,
								input [2:0] State_I,
								input [3:0][4:0] New_Static_Row_I,
								input [3:0][3:0] New_Static_Column_I,

								
								input [2:0] Color_RF_Block,
								input	En_RF,
								input [2:0] State_RF,
								input [3:0][4:0] New_Static_Row_RF,
								input [3:0][3:0] New_Static_Column_RF,

																
								input [2:0] Color_RL_Block,
								input	En_RL,
								input [2:0] State_RL,
								input [3:0][4:0] New_Static_Row_RL,
								input [3:0][3:0] New_Static_Column_RL,

								
								input [2:0] Color_LF_Block,
								input	En_LF,
								input [2:0] State_LF,
								input [3:0][4:0] New_Static_Row_LF,
								input [3:0][3:0] New_Static_Column_LF,
								
								
								input [2:0] Color_LL_Block,
								input	En_LL,
								input [2:0] State_LL,
								input [3:0][4:0] New_Static_Row_LL,
								input [3:0][3:0] New_Static_Column_LL,
								
								output En_New_Static,
								output [2:0] Game_State,
								output [2:0] Color_Dynamic,
								output [3:0][4:0] New_Static_Row,
								output [3:0][3:0] New_Static_Column,
								output [2:0] New_Static_Color
	);
	
	
	assign En_New_Static = En_O | En_T | En_I | En_RF | En_RL | En_LF | En_LL;
	
	assign Game_State[2] = State_O[2] | State_T[2] | State_RL[2] | State_RF[2] | State_LL[2] | State_LF[2] | State_I[2];
	assign Game_State[1] = State_O[1] | State_T[1] | State_RL[1] | State_RF[1] | State_LL[1] | State_LF[1] | State_I[1];
	assign Game_State[0] = (~Game_State[2]) && (~Game_State[1]);
	
	always_comb
	begin
		if (En_O)
		begin 
			Color_Dynamic = Color_O_Block;
			New_Static_Color = 3'b111;
			New_Static_Row[0] = New_Static_Row_O[0];
			New_Static_Row[1] = New_Static_Row_O[1];
			New_Static_Row[2] = New_Static_Row_O[2];
			New_Static_Row[3] = New_Static_Row_O[3];
			New_Static_Column[0] = New_Static_Column_O[0];
			New_Static_Column[1] = New_Static_Column_O[1];
			New_Static_Column[2] = New_Static_Column_O[2];
			New_Static_Column[3] = New_Static_Column_O[3];
		end
		
		else if (En_T)
		begin
			Color_Dynamic = Color_T_Block;
			New_Static_Color = 3'b111;
			New_Static_Row[0] = New_Static_Row_T[0];
			New_Static_Row[1] = New_Static_Row_T[1];
			New_Static_Row[2] = New_Static_Row_T[2];
			New_Static_Row[3] = New_Static_Row_T[3];
			New_Static_Column[0] = New_Static_Column_T[0];
			New_Static_Column[1] = New_Static_Column_T[1];
			New_Static_Column[2] = New_Static_Column_T[2];
			New_Static_Column[3] = New_Static_Column_T[3];
		end
		
		else if (En_I)
		begin
			Color_Dynamic = Color_I_Block;
			New_Static_Color = 3'b111;
			New_Static_Row[0] = New_Static_Row_I[0];
			New_Static_Row[1] = New_Static_Row_I[1];
			New_Static_Row[2] = New_Static_Row_I[2];
			New_Static_Row[3] = New_Static_Row_I[3];
			New_Static_Column[0] = New_Static_Column_I[0];
			New_Static_Column[1] = New_Static_Column_I[1];
			New_Static_Column[2] = New_Static_Column_I[2];
			New_Static_Column[3] = New_Static_Column_I[3];
		end
		
		else if (En_LL)
		begin
			Color_Dynamic = Color_LL_Block;
			New_Static_Color = 3'b111;
			New_Static_Row[0] = New_Static_Row_LL[0];
			New_Static_Row[1] = New_Static_Row_LL[1];
			New_Static_Row[2] = New_Static_Row_LL[2];
			New_Static_Row[3] = New_Static_Row_LL[3];
			New_Static_Column[0] = New_Static_Column_LL[0];
			New_Static_Column[1] = New_Static_Column_LL[1];
			New_Static_Column[2] = New_Static_Column_LL[2];
			New_Static_Column[3] = New_Static_Column_LL[3];
		end
		
		else if (En_RL)
		begin
			Color_Dynamic = Color_T_Block;
			New_Static_Color = 3'b111;
			New_Static_Row[0] = New_Static_Row_RL[0];
			New_Static_Row[1] = New_Static_Row_RL[1];
			New_Static_Row[2] = New_Static_Row_RL[2];
			New_Static_Row[3] = New_Static_Row_RL[3];
			New_Static_Column[0] = New_Static_Column_RL[0];
			New_Static_Column[1] = New_Static_Column_RL[1];
			New_Static_Column[2] = New_Static_Column_RL[2];
			New_Static_Column[3] = New_Static_Column_RL[3];
		end
		
		else if (En_LF)
		begin
			Color_Dynamic = Color_T_Block;
			New_Static_Color = 3'b111;
			New_Static_Row[0] = New_Static_Row_LF[0];
			New_Static_Row[1] = New_Static_Row_LF[1];
			New_Static_Row[2] = New_Static_Row_LF[2];
			New_Static_Row[3] = New_Static_Row_LF[3];
			New_Static_Column[0] = New_Static_Column_LF[0];
			New_Static_Column[1] = New_Static_Column_LF[1];
			New_Static_Column[2] = New_Static_Column_LF[2];
			New_Static_Column[3] = New_Static_Column_LF[3];
		end
		
		else if (En_RF)
		begin
			Color_Dynamic = Color_T_Block;
			New_Static_Color = 3'b111;
			New_Static_Row[0] = New_Static_Row_RF[0];
			New_Static_Row[1] = New_Static_Row_RF[1];
			New_Static_Row[2] = New_Static_Row_RF[2];
			New_Static_Row[3] = New_Static_Row_RF[3];
			New_Static_Column[0] = New_Static_Column_RF[0];
			New_Static_Column[1] = New_Static_Column_RF[1];
			New_Static_Column[2] = New_Static_Column_RF[2];
			New_Static_Column[3] = New_Static_Column_RF[3];
		end
		
		else
		begin
			Color_Dynamic = Color_O_Block+Color_T_Block+Color_I_Block+Color_LL_Block+Color_RL_Block+Color_LF_Block+Color_RF_Block;
			New_Static_Color = 3'b000;
			New_Static_Row[0] = 5'd0;
			New_Static_Row[1] = 5'd0;
			New_Static_Row[2] = 5'd0;
			New_Static_Row[3] = 5'd0;
			New_Static_Column[0] = 4'd0;
			New_Static_Column[1] = 4'd0;
			New_Static_Column[2] = 4'd0;
			New_Static_Column[3] = 4'd0;
		end
	end
	
endmodule
