`timescale 1ns/1ps

module tb_packet_admission_ctrl;

    reg clk;
    reg rst;
    reg sop;
    reg eop;
    reg error;

    wire in_packet;
    wire accept;
    wire drop;

    packet_admission_ctrl dut (
        .clk(clk),
        .rst(rst),
        .sop(sop),
        .eop(eop),
        .error(error),
        .in_packet(in_packet),
        .accept(accept),
        .drop(drop)
    );

    always #5 clk = ~clk;

    task check_outputs;
        input exp_in_packet;
        input exp_accept;
        input exp_drop;
        begin
            #1;
            if ((in_packet !== exp_in_packet) ||
                (accept    !== exp_accept) ||
                (drop      !== exp_drop)) begin
                $display("FAIL @ %0t: in_packet=%b accept=%b drop=%b | expected %b %b %b",
                         $time, in_packet, accept, drop,
                         exp_in_packet, exp_accept, exp_drop);
            end else begin
                $display("PASS @ %0t: in_packet=%b accept=%b drop=%b",
                         $time, in_packet, accept, drop);
            end
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        sop = 0;
        eop = 0;
        error = 0;

        // Reset
        @(negedge clk);
        rst = 1;
        @(posedge clk);
        check_outputs(0,0,0);

        // Start a valid packet
        @(negedge clk);
        rst = 0;
        sop = 1;
        eop = 0;
        error = 0;
        @(posedge clk);
        check_outputs(1,0,0);

        // End valid packet
        @(negedge clk);
        sop = 0;
        eop = 1;
        error = 0;
        @(posedge clk);
        check_outputs(0,1,0);

        // Return to idle
        @(negedge clk);
        eop = 0;
        @(posedge clk);
        check_outputs(0,0,0);

        // Start erroneous packet
        @(negedge clk);
        sop = 1;
        @(posedge clk);
        check_outputs(1,0,0);

        // Error -> DROP
        @(negedge clk);
        sop = 0;
        error = 1;
        @(posedge clk);
        check_outputs(0,0,1);

        // Return to idle
        @(negedge clk);
        error = 0;
        @(posedge clk);
        check_outputs(0,0,0);

        $display("Simulation completed.");
        $finish;
    end

endmodule
