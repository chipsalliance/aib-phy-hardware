`timescale 1ps/1fs

module aibio_lock_detector
		(
		//-------Supply pins---------//
		input vddcq,
		input vss,
		//-------Input pins---------//
		input i_clkin,
		input i_en,
		input i_up,
		input i_dn,
		input i_upb,
		input i_dnb,
		input [1:0] i_lockthresh,
		input [1:0] i_lockctrl,
		//-------Output pins----------//
		output lock
		);


real time_diff_thersh;
real up_rise_time;
real dn_rise_time;
integer counter =0;
integer count_max;
real time_diff;
real time_diff_latch;
logic flag_lock;

assign time_diff_thersh = (i_lockthresh == 2'b00) ?  0  :
                          (i_lockthresh == 2'b01) ?  15 :
                          (i_lockthresh == 2'b10) ?  30 :
                          (i_lockthresh == 2'b11) ?  45 :
								  0 ;
assign count_max        = (i_lockctrl == 2'b00) ?  16  :
                          (i_lockctrl == 2'b01) ?  32  :
                          (i_lockctrl == 2'b10) ?  64  :
                          (i_lockctrl == 2'b11) ?  128 :
								  10 ;

always @(posedge i_up) begin
	up_rise_time = $realtime;
end
always @(posedge i_dn) begin
	dn_rise_time = $realtime;
end

assign time_diff = (dn_rise_time - up_rise_time);

always @(posedge i_clkin) begin
	time_diff_latch = time_diff;
	if(time_diff_latch <= time_diff_thersh) begin
		flag_lock = 1'b1;
	end
	else begin
		flag_lock = 1'b0;
   end
end
always @(posedge i_clkin or i_en) begin
	if(i_en == 1'b1)
	begin
		if(flag_lock == 1'b0)
		begin
			counter = 0;
		end
		else
		begin
		counter = counter + 1;
		end
	end
	else
	begin
		counter = 0;
	end
end

assign lock = (counter >= count_max && i_en ==1'b1) ? 1'b1 : 1'b0;

endmodule

