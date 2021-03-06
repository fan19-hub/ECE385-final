module  Little_Boss ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,level,          // The clock indicating a new frame (~60Hz)
					input [7:0] state,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input logic [9:0] main_X_Pos,main_Y_Pos,
               output logic  is_enemy,
					output logic[15:0]  relative_address					// Whether current pixel belongs to ball or background
              );
   
    logic [1:0] da;
	 logic  enemy_left;
    parameter [9:0] Screen_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Screen_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Screen_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Screen_X_Max = 10'd639;     // DASUmost point on the X axis
    parameter [9:0] Screen_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Screen_Y_Max = 10'd400;     // Bottommost point on the Y axis 479
    parameter [9:0] Ball_X_Step = 10'd2;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Ball_X_Size = 10'd30;        // Ball size
    parameter [9:0] Ball_Y_Size = 10'd46;        // Ball size
    parameter [9:0] zero=10'd0;
		enum logic [20:0] {RIGHT,LEFT,DA,DA_1,DA_2,DA_3,DA_4,DA_5,DA_6,DA_7,DA_8,DA_9,DA_10,DA_11,DA_12} curr_state, next_state;
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
		logic[1:0] enemy_left_in,enemy_left_in_1,da_in,da_in_1;
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 	always_ff @ (posedge Clk)  
   begin
        if (Reset)
            curr_state<=RIGHT;
        else 
            curr_state<=next_state;
   end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Ball_X_Pos <= Screen_X_Center;
            Ball_Y_Pos <= Screen_Y_Center;
            Ball_X_Motion <= Ball_X_Step;
            Ball_Y_Motion <= Ball_Y_Step;
				enemy_left_in_1<=2'b0;
				da_in_1<=2'b0;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
				enemy_left_in_1<=enemy_left_in;
				da_in_1<=da_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
	 next_state=curr_state;
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
        enemy_left_in=enemy_left_in_1;
		  da_in=da_in_1;
        // Update position and motion only at rising edge of frame clock
		 if (frame_clk_rising_edge)
		 begin
        if ((Ball_Y_Pos>main_Y_Pos-Ball_X_Size&&Ball_Y_Pos<main_Y_Pos+Ball_X_Size)&&(Ball_X_Pos>main_X_Pos-Ball_X_Size&&Ball_X_Pos<main_X_Pos+Ball_X_Size))
        begin
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;		
			da_in=2'b1;  
        end
		  else
		  begin
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_X_Size <= Screen_Y_Min 
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_X_Size will not be -4, but rather a large positive number.
				da_in=2'b0;
//				if( Ball_Y_Pos + Ball_Y_Size >= Screen_Y_Max)  // Ball is at the bottom edge, BOUNCE!
//				begin
//                Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.  
////					 Ball_X_Motion_in = 10'd0;
//				end
//            else if ( Ball_Y_Pos <= Screen_Y_Min + Ball_Y_Size)  // Ball is at the top edge, BOUNCE!
//				begin
//                Ball_Y_Motion_in = Ball_Y_Step;
////					 Ball_X_Motion_in = 10'd0;
//				end
//            // TODO: Add other boundary detections and handle keypress here.
//            else if( Ball_X_Pos + Ball_X_Size >= Screen_X_Max)  // Ball is at the DASU edge, BOUNCE!
//				begin
//                Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1); 
//					 enemy_left_in=2'b1;
////					 Ball_Y_Motion_in = 10'd0;
//				end
//            else if ( Ball_X_Pos <= Screen_X_Min +  Ball_X_Size) // Ball is at the left edge, BOUNCE!
//				begin
//                Ball_X_Motion_in = Ball_X_Step;
//					 enemy_left_in=2'b0;
////					 Ball_Y_Motion_in = 10'd0;
//				end
				Ball_Y_Motion_in = 10'd0;
				Ball_X_Motion_in = 10'd0;
				if(main_X_Pos>Ball_X_Pos)
					Ball_X_Motion_in=Ball_X_Step;
				if(main_Y_Pos>Ball_Y_Pos)
					Ball_Y_Motion_in=Ball_Y_Step;
				if(main_X_Pos<Ball_X_Pos)
					Ball_X_Motion_in=(~(Ball_X_Step) + 1'b1);
				if(main_Y_Pos<Ball_Y_Pos)
					Ball_Y_Motion_in=(~(Ball_Y_Step) + 1'b1);
            // Update the ball's position with its motion
				Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
				Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
		  end
		  
		  end
	unique case (curr_state)
		RIGHT: 
		begin
		if(da_in==2'b1)
			next_state=DA;
		else if (enemy_left_in==2'b1)
			next_state=LEFT;
//	    else if(counter>=15)
//			 next_state=
		end
		LEFT: 
		begin
		if(da_in==2'b1)
			next_state=DA;
		else if(enemy_left_in==2'b0)
			next_state=RIGHT;
			end
		
		DA:
		next_state=DA_1;
		DA_1:
		next_state=DA_2;
		DA_2:
		next_state=DA_3;
		DA_3:
		next_state=DA_4;
		DA_4:
		next_state=DA_5;
		DA_5:
		next_state=DA_6;
		DA_6:
		next_state=DA_7;
		DA_7:
		next_state=DA_8;
		DA_8:
		next_state=DA_9;
		DA_9:
		next_state=DA_10;
		DA_10:
		next_state=DA_11;
		DA_11:
		next_state=DA_12;
		DA_12:
		begin
		if(enemy_left_in==2'b0)
			next_state=RIGHT;
		else if(enemy_left_in==2'b1)
			next_state=LEFT;
		end
		endcase
	case (curr_state) 
		RIGHT:
		begin
			da=2'b0;
			enemy_left=1'b0;
		end
		LEFT:
		begin
			da=2'b0;
			enemy_left=1'b1;
		end
		DA_1:
		begin
			da=2'b1;
			enemy_left=1'b0;
		end
		DA:
		begin
			da=2'b1;
			enemy_left=1'b0;
		end
		DA_2:
		begin
			da=2'b1;
			enemy_left=1'b0;
		end
		DA_3:
		begin
			da=2'b1;
			enemy_left=1'b0;
		end
		DA_4:
		begin
			da=2'b1;
			enemy_left=1'b0;
		end
		DA_5:
		begin
			da=2'b1;
			enemy_left=1'b0;
		end
		DA_6:
		begin
			da=2'b1;
			enemy_left=1'b0;
		end
		DA_7:
		begin
			da=2'b11;
			enemy_left=1'b0;
		end
		DA_8:
		begin
			da=2'b11;
			enemy_left=1'b0;
		end
		DA_9:
		begin
			da=2'b11;
			enemy_left=1'b0;
		end
		DA_10:
		begin
			da=2'b11;
			enemy_left=1'b0;
		end
		DA_11:
		begin
			da=2'b11;
			enemy_left=1'b0;
		end
		DA_12:
		begin
			da=2'b11;
			enemy_left=1'b0;
		end
		endcase
		  
    end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    //60*93
    always_comb begin
        if ( DistX*DistX < 900 &&  DistY*DistY < 2116  ) 
            is_enemy = 1'b1;
        else
            is_enemy = 1'b0;
        relative_address=9'b0;
        if(is_enemy)
            relative_address=(DrawX-Ball_X_Pos+Ball_X_Size)+ (DrawY- Ball_Y_Pos+Ball_Y_Size)*10'd60; 
	 end

    
    
endmodule
