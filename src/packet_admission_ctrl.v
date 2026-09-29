`timescale 1ns/1ps
// Packet Admission Controller
// Clean synthesizable RTL reference matching the project-level FSM behavior.
// States: IDLE, RECEIVE, ACCEPT, DROP.
//
// Inputs:
//   clk   - system clock
//   rst   - active-high synchronous reset
//   sop   - start of packet
//   eop   - end of packet
//   error - packet error indication
//
// Outputs:
//   in_packet - asserted while a packet is being received
//   accept    - asserted for one cycle when a valid packet ends
//   drop      - asserted for one cycle when an error is detected

module packet_admission_ctrl (
    input  wire clk,
    input  wire rst,
    input  wire sop,
    input  wire eop,
    input  wire error,
    output reg  in_packet,
    output reg accept,
    output reg drop
);

    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam ACCEPT  = 2'b10;
    localparam DROP    = 2'b11;

    reg [1:0] state, next_state;

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (sop)
                    next_state = RECEIVE;
            end

            RECEIVE: begin
                if (error)
                    next_state = DROP;
                else if (eop)
                    next_state = ACCEPT;
            end

            ACCEPT: begin
                next_state = IDLE;
            end

            DROP: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        in_packet = (state == RECEIVE);
        accept    = (state == ACCEPT);
        drop      = (state == DROP);
    end

endmodule
