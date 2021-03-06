//291,344
module RGB_SUCCESS (input Clk,success,
                  input [9:0]   DrawX, DrawY,       // Current pixel coordinates
                  output logic [23:0]  success_rgb,
                  output logic show_success);
logic[1:0] mem [0:100000];
logic[17:0] address;
int DistX, DistY;
logic[1:0] rgb_index,index_buffer;
always_comb begin
address=DistX+145+(DistY+172)*(291);
show_success=1'b0; 
DistX = DrawX - 300;
DistY = DrawY - 200; 
if(success && (DistX*DistX) < (145 *145) &&  (DistY*DistY) < (172*172))
    show_success=1'b1; 
end 


initial
begin
$readmemb("sprite_bytes/v.txt", mem);
end


always_ff @ (posedge Clk) begin
	rgb_index<= index_buffer;
end

assign index_buffer=mem[address];
always_comb
	begin
    unique case (rgb_index)
        2'h0:  success_rgb=24'hc71f22;
        2'h1:  success_rgb=24'hc6c6c6;
        2'h2:  success_rgb=24'h000000;
		default : success_rgb = 24'h000000; //by default, black
		endcase
    end
endmodule




//313 228
module RGB_FAIL (input Clk,fail,
                  input [9:0]   DrawX, DrawY,       // Current pixel coordinates
                  output logic [23:0] fail_rgb,
                  output logic show_fail);
logic[2:0] mem [0:75000];
logic[17:0] address;
int DistX, DistY;
logic[2:0] rgb_index,index_buffer;
always_comb begin
//address=DistX+DistY*(11'd313);
address=DistX+156+(DistY+114)*(313);
show_fail=1'b0; 
DistX = DrawX - 11'd300;
DistY = DrawY - 11'd200; 
if(fail && DistX*DistX < 156*156 &&  DistY*DistY < 114*114)
    show_fail=1'b1; 
end 

initial
begin
$readmemb("sprite_bytes/g.txt", mem);
end


always_ff @ (posedge Clk) begin
	rgb_index<= index_buffer;
end

assign index_buffer=mem[address];
always_comb
	begin
    unique case (rgb_index)
        3'h0: fail_rgb=24'h7a7a7a;
        3'h1: fail_rgb=24'he0e0e0;
        3'h2: fail_rgb=24'hb6b6b6;
        3'h3: fail_rgb=24'h4d4d4d;
        3'h4: fail_rgb=24'hffffff;
        3'h5: fail_rgb=24'h000000;
		default : fail_rgb = 24'h000000; //by default, black
		endcase
    end
endmodule