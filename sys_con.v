module sys_ctrl (
    input  wire        i_clk,           // Input System Clock
    input  wire        i_arst_n,        // Input Async Active Low Reset
    input  wire        i_ff_full,       // Input Full flag from FIFO
    input  wire        i_rd_valid,      // Input Data ready from RF
    input  wire        i_out_valid,     // Input Data ready from ALU
    input  wire        i_rx_d_valid,    // Input Data ready from RX Master
    input  wire [7:0]  i_rd_data,       // Input data from the RF
    input  wire [7:0]  i_p_data,        // Input data from the RX Master
    input  wire [15:0] i_alu_out,       // Input data from the ALU
//------------------------------------------------------------------------
    output reg  [3:0]  o_alu_fun,       // Output ALU function to ALU
    output reg  [3:0]  o_address,       // Output Address to RF
    output reg  [7:0]  o_wr_data,       // Output Data to be written to RF
    output reg  [7:0]  o_tx_p_data,     // Output Data to be written in FIFO
    output reg         o_tx_p_valid,    // Output Valid data flag to fifo, *winc*
    output reg         o_alu_en,        // Output ALU Enable
    output reg         o_clk_en,        // Output Gated clock enable
    output reg         o_wr_en,         // Output RF Write enable
    output reg         o_rd_en,         // Output RF Read enable
    output reg         o_clk_div_en     // Output UART clock divider enable
);
//=========================================================

// Internals
reg        tx_fifo_itr, tx_fifo_itr_ff;
reg [2:0]  state_crnt, state_nxt;
reg [1:0]  frames_cntr_r, frames_cntr_ff;
reg [3:0]  alu_fun_ff, o_address_ff;
reg [7:0]  o_wr_data_ff;
reg [15:0] data_to_save_r, data_to_save_ff; // for fifo
//=========================================================

// state encoding
localparam 
    S_READ       = 3'b000,
    S_ALU        = 3'b001,
    S_ALU_RF     = 3'b010,
    S_REGFILE_WR = 3'b011,
    S_REGFILE_RD = 3'b100,
    S_FIFO       = 3'b101;
//=========================================================

// commands encoding
localparam
    XAA = 8'hAA,
    XBB = 8'hBB,
    XCC = 8'hCC,
    XDD = 8'hDD;
//=========================================================

// FF initialization
always @(posedge i_clk, negedge i_arst_n) begin
    if (!i_arst_n) begin
        data_to_save_ff  <= 16'b0;
        o_wr_data_ff     <= 8'b0;
        alu_fun_ff       <= 4'b0;
        o_address_ff     <= 4'b0;
        frames_cntr_ff   <= 2'b0;
        tx_fifo_itr_ff   <= 1'b0;
    end
    else begin
        data_to_save_ff  <= data_to_save_r;
        alu_fun_ff       <= o_alu_fun;
        o_address_ff     <= o_address;
        o_wr_data_ff     <= o_wr_data;
        frames_cntr_ff   <= frames_cntr_r;
        tx_fifo_itr_ff   <= tx_fifo_itr;
    end
end
//=========================================================

// Current state logic
always @(posedge i_clk, negedge i_arst_n) begin
    if (!i_arst_n) state_crnt <= S_READ;
    else           state_crnt <= state_nxt;
end
//=========================================================

// Next state logic
always @(*) begin
    // defaults
        o_wr_en        = 1'b0;
        o_rd_en        = 1'b0;
        o_alu_en       = 1'b0;
        o_clk_en       = 1'b0;
        o_tx_p_valid   = 1'b0;
        o_clk_div_en   = 1'b1;
        tx_fifo_itr    = tx_fifo_itr_ff; // configure how many itrs to stay in the fifo stage before going to the read stage
        o_address      = o_address_ff;   // as the previous ones are reserved
        o_wr_data      = o_wr_data_ff;
        state_nxt      = state_crnt;
        o_alu_fun      = alu_fun_ff;
        data_to_save_r = data_to_save_ff;
        frames_cntr_r  = frames_cntr_ff;
        o_tx_p_data    = data_to_save_ff[7:0];
    //-------------------------------------------------
    case (state_crnt)
        S_READ : begin
            if (i_rx_d_valid) begin
                case (i_p_data)
                    XAA : state_nxt = S_REGFILE_WR;
                    XBB : state_nxt = S_REGFILE_RD;
                    XCC : begin 
                        state_nxt = S_ALU;
                        o_clk_en = 1'b1;
                    end
                    XDD : begin 
                        state_nxt = S_ALU_RF;
                        o_clk_en = 1'b1;
                    end 
                    default : state_nxt = S_READ;
                endcase
            end
            else state_nxt = S_READ;
        end

        S_REGFILE_WR : begin
            if (frames_cntr_ff == 2'd2) begin
                o_wr_en        = 1'b1;
                o_address      = data_to_save_ff[11:8];
                o_wr_data      = data_to_save_ff[7:0];
                frames_cntr_r  = 2'b0;
                state_nxt      = S_READ;
            end
            else if (i_rx_d_valid) begin
                data_to_save_r = {data_to_save_ff,i_p_data};
                frames_cntr_r  = frames_cntr_ff + 2'b1;
                state_nxt      = S_REGFILE_WR;
            end
        end
        
        S_REGFILE_RD : begin
            if (i_rx_d_valid) begin
                o_rd_en      = 1'b1;
                o_address    = i_p_data[3:0];
                if (i_rd_valid) data_to_save_r = {8'b0, i_rd_data};
                state_nxt    = S_FIFO;
                o_clk_div_en = 1'b1;
                tx_fifo_itr  = 1'b0;
            end
        end
        
        S_ALU : begin
            if (frames_cntr_ff == 2'd3) begin
                if (i_out_valid) data_to_save_r = i_alu_out;
                frames_cntr_r = 2'b0;
                state_nxt     = S_FIFO;
                o_clk_div_en  = 1'b1;
                tx_fifo_itr   = 1'b1;
            end
            else if (i_rx_d_valid) begin
                if (frames_cntr_ff == 2'd2) begin
                    o_alu_en      = 1'b1;
                    o_alu_fun     = i_p_data[3:0];
                    frames_cntr_r = frames_cntr_ff + 2'b1;
                    state_nxt     = S_ALU;
                end
                else if (frames_cntr_ff == 2'd1) begin
                    o_wr_en       = 1'b1;
                    o_wr_data     = i_p_data;
                    o_address     = 4'd1;
                    frames_cntr_r = frames_cntr_ff + 2'b1;
                    state_nxt     = S_ALU;
                end
                else begin
                    o_wr_en       = 1'b1;
                    o_wr_data     = i_p_data;
                    o_address     = 4'd0;
                    frames_cntr_r = frames_cntr_ff + 2'b1;
                    state_nxt     = S_ALU;
                end
            end
            else state_nxt        = S_ALU;
            o_clk_en = 1'b1;
        end

        S_ALU_RF : begin
            if (i_rx_d_valid) begin
                o_alu_en      = 1'b1;
                o_alu_fun     = i_p_data[3:0];
            end
            if (i_out_valid) begin 
                data_to_save_r = i_alu_out;
                state_nxt     = S_FIFO;
                o_clk_div_en  = 1'b1;
                tx_fifo_itr   = 1'b1;
            end
            else state_nxt    = S_ALU_RF;
            o_clk_en = 1'b1;
        end

        S_FIFO : begin
            o_clk_div_en = 1'b1;
            if (i_ff_full) begin
                state_nxt = S_FIFO;
            end
            else begin
                if (tx_fifo_itr_ff) begin
                    if (frames_cntr_ff == 1'b1) begin
                        o_tx_p_valid  = 1'b1;
                        o_tx_p_data   = data_to_save_ff[15:8];
                        frames_cntr_r = 2'b0;
                        state_nxt     = S_READ;
                    end
                    else begin
                        o_tx_p_valid  = 1'b1;
                        o_tx_p_data   = data_to_save_ff[7:0];
                        frames_cntr_r = frames_cntr_ff + 2'b1;
                        state_nxt     = S_FIFO;
                    end
                end
                else begin
                    o_tx_p_valid = 1'b1;
                    o_tx_p_data  = data_to_save_ff[7:0];
                    state_nxt    = S_READ;
                end
            end
        end

        default: state_nxt = S_READ;
    endcase
end

endmodule