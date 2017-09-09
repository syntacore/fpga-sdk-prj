/// Copyright by Syntacore LLC © 2016, 2017. See LICENSE for details
/// @file       <ahb_avalon_bridge.sv>
/// @brief      Avalon to AMBA AHB bridge
///

module ahb_avalon_bridge
(
    // avalon master side
    input   logic           clk,
    input   logic           reset_n,
    output  logic [31:0]    address,
    output  logic           write,
    output  logic           read,
    output  logic [ 3:0]    byteenable,
    output  logic [31:0]    writedata,
    input   logic           waitrequest,
    input   logic           readdatavalid,
    input   logic [31:0]    readdata,
    input   logic  [1:0]    response,

    // ahb slave side
    output  logic [31:0]    HRDATA,
    output  logic           HRESP,
    input   logic [ 2:0]    HSIZE,
    input   logic [ 1:0]    HTRANS,
    input   logic [ 3:0]    HPROT,
    input   logic [31:0]    HADDR,
    input   logic [31:0]    HWDATA,
    input   logic           HWRITE,
    output  logic           HREADY
);

typedef enum logic [1:0] {
    IDLE,
    WRITE,
    READ,
    READ_STALL
} type_state_e;

type_state_e    state;
type_state_e    nextState;
logic [31:0]    haddr_reg;




always_ff @ (posedge clk, negedge reset_n)
begin
  if (!reset_n) state <= IDLE;
  else          state <= nextState;
end

always_ff @ (posedge clk, negedge reset_n)
begin
    if (!reset_n) begin
        haddr_reg <= 32'h0;
    end
    else if ((HTRANS == 2'b10) | (HTRANS == 2'b11)) begin
        haddr_reg <= HADDR;
    end
end

always_ff @ (posedge clk, negedge reset_n)
begin
    if (!reset_n) begin
        byteenable = 4'b1111;
    end
    else if ((HTRANS == 2'b10) | (HTRANS == 2'b11)) begin
        case ({HADDR[1:0],HSIZE})
            {2'b00,SCR1_HSIZE_8B }:     byteenable = 4'b0001;
            {2'b01,SCR1_HSIZE_8B }:     byteenable = 4'b0010;
            {2'b10,SCR1_HSIZE_8B }:     byteenable = 4'b0100;
            {2'b11,SCR1_HSIZE_8B }:     byteenable = 4'b1000;
            {2'b00,SCR1_HSIZE_16B}:     byteenable = 4'b0011;
            {2'b10,SCR1_HSIZE_16B}:     byteenable = 4'b1100;
            {2'b00,SCR1_HSIZE_32B}:     byteenable = 4'b1111;
            default:                    byteenable = 4'b0000;
        endcase
    end
end

assign writedata    = HWDATA;
assign HRDATA       = readdata;
assign address      = haddr_reg;
assign HRESP        = response != 2'b00;

always_comb
begin
    nextState   = state;
    HREADY      = 1'b1;
    case (state)
        IDLE: begin
           if ((HTRANS == 2'b10) | (HTRANS == 2'b11)) begin
               if (HWRITE) begin
                   nextState = WRITE;
               end
               else begin
                   nextState = READ;
               end
            end
         end

        WRITE: begin
            if (!waitrequest) begin
                if ((HTRANS == 2'b10) | (HTRANS == 2'b11)) begin
                    if (!HWRITE) begin
                        nextState = READ;
                    end
                end
                else begin
                    nextState = IDLE;
                end
            end
            else begin
                HREADY = 1'b0;
            end
        end

        READ: begin
            if (readdatavalid) begin
                if ((HTRANS == 2'b10) | (HTRANS == 2'b11)) begin
                    if (HWRITE) begin
                        nextState = WRITE;
                    end
                end
                else begin
                    nextState = IDLE;
                end
            end
            else begin
                HREADY = 1'b0;
                if (!waitrequest) begin
                    nextState = READ_STALL;
                end
            end
        end

        READ_STALL: begin
            if (readdatavalid) begin
                if ((HTRANS == 2'b10) | (HTRANS == 2'b11)) begin
                    if (HWRITE) begin
                        nextState = WRITE;
                    end
                    else begin
                        nextState = READ;
                    end
                end
                else begin
                    nextState = IDLE;
                end
            end
            else begin
                HREADY = 1'b0;
            end
        end
    endcase
end

assign write = (state == WRITE);
assign read  = (state == READ);

endmodule : ahb_avalon_bridge
