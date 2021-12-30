//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module final_toplevel( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
				 output		  [3:0]	LEDG,
             output logic [6:0]  HEX0, HEX1,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,      //SDRAM Clock
				 input AUD_ADCDAT,
				 input AUD_DACLRCK,
				 input AUD_ADCLRCK,
				 input AUD_BCLK,
				 output logic AUD_DACDAT,
				 output logic AUD_XCK,
				 output logic I2C_SCLK,
				 output logic I2C_SDAT
                    );
    
    logic Reset_h, Clk;
    logic [7:0] keycode;
    logic is_ball;
	 logic [9:0] DrawX,DrawY;
	 logic [2:0] Color_Static, Color_Dynamic, Color, New_Static_Color, Color_UI;
	 logic [23:0][15:0] Static_Array;
	 logic frame_clk_1;
	 logic INIT,data_over,INIT_FINISH;
	 logic [16:0]Add;
	 logic [16:0]music_content;
	 logic adc_full;
	 
	 
	 
	 // Need Modify
	 logic [2:0] Color_O_Block, Color_T_Block, Color_RL_Block, Color_LL_Block, Color_RF_Block, Color_LF_Block, Color_I_Block;
	 logic En_New_Static, En_O, En_T, En_RL, En_RF, En_LL, En_LF, En_I;	 
	 logic [3:0][4:0] New_Static_Row, New_Static_Row_O, New_Static_Row_T, New_Static_Row_RL, New_Static_Row_RF, New_Static_Row_LL, New_Static_Row_LF, New_Static_Row_I;
	 logic [3:0][3:0] New_Static_Column, New_Static_Column_O, New_Static_Column_T, New_Static_Column_RL, New_Static_Column_RF, New_Static_Column_LL, New_Static_Column_LF, New_Static_Column_I;
	 logic Active_O, Active_T, Active_RL, Active_RF, Active_LL, Active_LF, Active_I, Active;
	 logic LEFT, RIGHT, UP, DOWN, SPACE, ENTER, START;
	 logic Win, Lose;
	 logic [2:0] randnum;
	 logic [5:0] Line_Count;
	 logic [6:0] Fall_Count, Score;
	 logic [2:0] Game_State, State_O, State_T, State_RL, State_RF, State_LL, State_LF, State_I;
	 
	 assign Color = Color_Static | Color_Dynamic | Color_UI;
	 assign LEDG[3:1] = randnum;
	 assign LEDG[0] = frame_clk_1;
	 
    assign Clk = CLOCK_50;
	 
	 logic [28:0] loss_counter = 29'b0;  // since the CLK frequency is 50MHz, the "loss" sign will stay for 2^28 / 50M = 5.3687s
	 
    always_ff @ (posedge Clk) 
	 begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
		  if (Lose) begin
		      loss_counter = loss_counter + 1;
		  end
		  if (loss_counter[28] == 1'b1) begin
				Reset_h <= 1'b1;
				loss_counter = 29'b0;
		  end
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     final_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.*, .Reset(Reset_h));
    
    // Which signal should be frame_clk?
	 
	 kbinput as_instance (.*, .frame_clk(frame_clk_1));
	 
	 O_block o_instance(
								.*,
								.Active(Active_O),
								.Reset(Reset_h),
								.State_Bit(State_O),
								.frame_clk(frame_clk_1),
								.Color_Dynamic(Color_O_Block),
								.En_New_Static(En_O),
								.New_Static_Row(New_Static_Row_O),
								.New_Static_Column(New_Static_Column_O)
	 );
	 
	 T_block t_instance(
								.*,
								.Active(Active_T),
								.Reset(Reset_h),
								.State_Bit(State_T),
								.frame_clk(frame_clk_1),
								.Color_Dynamic(Color_T_Block),
								.En_New_Static(En_T),
								.New_Static_Row(New_Static_Row_T),
								.New_Static_Column(New_Static_Column_T)
	 );
	 
	 
	 I_block i_instance(
								.*,
								.Active(Active_I),
								.Reset(Reset_h),
								.State_Bit(State_I),
								.frame_clk(frame_clk_1),
								.Color_Dynamic(Color_I_Block),
								.En_New_Static(En_I),
								.New_Static_Row(New_Static_Row_I),
								.New_Static_Column(New_Static_Column_I)
	 );
	 
	 LL_block ll_instance(
								.*,
								.Active(Active_LL),
								.Reset(Reset_h),
								.State_Bit(State_LL),
								.frame_clk(frame_clk_1),
								.Color_Dynamic(Color_LL_Block),
								.En_New_Static(En_LL),
								.New_Static_Row(New_Static_Row_LL),
								.New_Static_Column(New_Static_Column_LL)
	 );
	 
	 RL_block rl_instance(
								.*,
								.Active(Active_RL),
								.Reset(Reset_h),
								.State_Bit(State_RL),
								.frame_clk(frame_clk_1),
								.Color_Dynamic(Color_RL_Block),
								.En_New_Static(En_RL),
								.New_Static_Row(New_Static_Row_RL),
								.New_Static_Column(New_Static_Column_RL)
	 );
	 
	 LF_block lf_instance(
								.*,
								.Active(Active_LF),
								.Reset(Reset_h),
								.State_Bit(State_LF),
								.frame_clk(frame_clk_1),
								.Color_Dynamic(Color_LF_Block),
								.En_New_Static(En_LF),
								.New_Static_Row(New_Static_Row_LF),
								.New_Static_Column(New_Static_Column_LF)
	 );
	 	 
	 RF_block rf_instance(
								.*,
								.Active(Active_RF),
								.Reset(Reset_h),
								.State_Bit(State_RF),
								.frame_clk(frame_clk_1),
								.Color_Dynamic(Color_RF_Block),
								.En_New_Static(En_RF),
								.New_Static_Row(New_Static_Row_RF),
								.New_Static_Column(New_Static_Column_RF)
	 );
	 static_box_array static_instance(
													.*,
													.Reset(Reset_h),
													.frame_clk(frame_clk_1)
	 );
	 
	 audio Audio_istance (.*, .Reset(Reset_h));
	 
	 music music_instance(.*);
	 
	 audio_interface music ( .LDATA (music_content),
									 .RDATA (music_content),
									 .Clk(Clk),
									 .Reset(Reset_h),
									 .INIT(INIT),
									 .INIT_FINISH(INIT_FINISH),
									 .adc_full (adc_full),
									 .data_over(data_over),
									 .AUD_MCLK(AUD_XCK),
									 .AUD_BCLK(AUD_BCLK),
									 .AUD_ADCDAT(AUD_ADCDAT),
									 .AUD_DACDAT(AUD_DACDAT),
									 .AUD_DACLRCK(AUD_DACLRCK),
									 .AUD_ADCLRCK(AUD_ADCLRCK),
									 .I2C_SDAT(I2C_SDAT),
									 .I2C_SCLK(I2C_SCLK),
									 .ADCDATA(ADCDATA),
									 
	 );
	 
	 
	 
	 total_dynamic total_dynamic_instance(.*);

	 userinterface ui_instance(.*);
	 
	 color_mapper color_instance(.*);
	 

	 
	 frame_clk_generator frameclk_instance(.*, .Reset(Reset_h), .frame_clk_in(VGA_VS), .frame_clk_out(frame_clk_1));
	 
	 randnumbergenerator randnumbergenerator_instance (.*, .Reset(Reset_h), .frame_clk(frame_clk_1));
 
    // Display keycode on hex display
    HexDriver hex_inst_0 (Line_Count%7'd10, HEX0);
    HexDriver hex_inst_1 (Line_Count/7'd10, HEX1);
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
