module tx_fsm #(parameter data_width = 8)
(clk,rst,data_valid,ser_done,par_en,mux_sel,busy,ser_en);

input            clk;
input            rst;
input            data_valid;
input            ser_done;
input            par_en;
output reg [1:0] mux_sel;
output reg       busy;
output reg       ser_en;

reg busy_c;
reg [(3 - 1):0] current_state;
reg [(3 - 1):0] next_state;

localparam [2:0] IDLE = 3'b000;
localparam [2:0] START_BIT_TRANSMISSION = 3'b001;
localparam [2:0] SERIAL_DATA_TRANSMISSION = 3'b011;
localparam [2:0] PARTIY_BIT_TRANSMISSION = 3'b010;
localparam [2:0] STOP_BIT_TRANSMISSION = 3'b110;

//state transition
always @(posedge clk, negedge rst)
begin
    if (~rst)
    begin
        current_state <= IDLE; 
    end
    else
    begin
        current_state <= next_state;
    end
end

//next state
always @(*)
begin
    case(current_state)
        IDLE:
        begin
            if(data_valid)
                next_state = START_BIT_TRANSMISSION;
            else
                next_state = IDLE;
        end 

        START_BIT_TRANSMISSION:
        begin
            next_state = SERIAL_DATA_TRANSMISSION;
        end 

        SERIAL_DATA_TRANSMISSION:
        begin
        if(ser_done)
        begin
            if(par_en)
                next_state = PARTIY_BIT_TRANSMISSION;
            else
                next_state = STOP_BIT_TRANSMISSION;
        end
        else
            next_state = SERIAL_DATA_TRANSMISSION;
        end 

        PARTIY_BIT_TRANSMISSION:
        begin
            next_state = STOP_BIT_TRANSMISSION;
        end 

        STOP_BIT_TRANSMISSION:
        begin
            next_state = IDLE;
        end 

        default: next_state = IDLE;
    endcase
end

//output
always @(*)
begin

    ser_en = 1'b0 ;
    busy_c = 1'b0 ;
    mux_sel = 2'b11 ;	

    case(current_state)
        IDLE:
        begin
            mux_sel = 2'b11;
            busy_c    = 1'b0;
            ser_en  = 1'b0;
        end 

        START_BIT_TRANSMISSION:
        begin
            mux_sel = 2'b00;
            busy_c    = 1'b1;
            ser_en  = 1'b0;
        end 

        SERIAL_DATA_TRANSMISSION:
        begin
            mux_sel = 2'b01;
            busy_c  = 1'b1;
            ser_en  = 1'b1;
            if(ser_done)
                ser_en = 1'b0 ;  
			else
                ser_en = 1'b1 ;
        end 

        PARTIY_BIT_TRANSMISSION:
        begin
            mux_sel = 2'b10;
            busy_c  = 1'b1;
        end 

        STOP_BIT_TRANSMISSION:
        begin
            mux_sel = 2'b11;
            busy_c    = 1'b1;
        end 

        default:
        begin             
            mux_sel = 2'b11;
            busy_c  = 1'b0;
            ser_en  = 1'b0;
        end
    endcase
end

always @ (posedge clk or negedge rst)
 begin
  if(!rst)
   begin
    busy <= 1'b0 ;
   end
  else
   begin
    busy <= busy_c ;
   end
 end

endmodule