`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2026 15:08:27
// Design Name: 
// Module Name: tb_32x1mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//module tb_32x1mux;
//reg [4:0]addr;
//reg [0:31]channel_in;
//reg en1_n;
//reg en2_n;
//reg en3;
//reg rs_n;
//wire final_analog_out;
//reg [0:7]s1,s2,s3,s4;

//always@(*)begin
// s1=channel_in[0:7];
// s2=channel_in[8:15];
// s3=channel_in[16:23];
// s4=channel_in[24:31];
// end

//mux32x1_top dut(addr,channel_in,en1_n,en2_n,en3,rs_n,final_analog_out);


//initial begin
//addr=5'b00000;
//channel_in=32'b0;
//en1_n=1'b0;
//en2_n=1'b0;
//en3=1'b1;
//rs_n=1'b1;
//#5;
//channel_in=32'hfedcba98;
//addr=5'b10101;
//$display("addr=%0b,channel=%0b",addr,s1);
//channel_in=32'hfedcba98;
//addr=5'b11111;
//#10;
//$display("addr=%0b,channel=%0b",addr,s2);
//#200;
//$finish;
//end
//endmodule


module tb_32x1mux;

    reg  [4:0]  addr;
    reg  [0:31] channel_in;
    reg         en1_n, en2_n, en3, rs_n;
    wire        final_analog_out;

    integer i;

    // Instantiate the complete 32:1 MUX
    mux32x1_top dut (
        .addr(addr),
        .channel_in(channel_in),
        .en1_n(en1_n),
        .en2_n(en2_n),
        .en3(en3),
        .rs_n(rs_n),
        .final_analog_out(final_analog_out)
    );

    initial begin
        // Initialize inputs
        addr       = 5'b00000;
        channel_in = 32'b0;

        // Enable the decoder: active-low, active-low, active-high
        en1_n = 1'b0;
        en2_n = 1'b0;
        en3   = 1'b1;

        // Keep reset inactive, assuming rs_n is active-low
        rs_n = 1'b1;

        #10;

        // Test each of the 32 input channels
        for (i = 0; i < 32; i = i + 1) begin

            // Set all inputs to zero
            channel_in = 32'b0;

            // Set only the selected channel to one
            channel_in[i] = 1'b1;

            // Select the same channel using the address
            addr = i;

            #10;

            $display(
                "Time=%0t | Address=%05b | selected_channel=channel_in[%0d] | Input channel=%0d | Output=%b",
                $time, addr, i,channel_in[i], final_analog_out
            );

            // Check the output
            if (final_analog_out !== 1'b1)
                $display("ERROR: Channel %0d was not selected correctly!", i);
            else
                $display("PASS: Channel %0d selected correctly.", i);
        end

        // Test when all inputs are zero
        channel_in = 32'b0;
        addr = 5'b00000;
        #10;

        $display("All inputs zero | Output=%b", final_analog_out);

        // Disable the decoder
        en1_n = 1'b1;
        #10;

        $display("Decoder disabled | Output=%b", final_analog_out);

        $finish;
    end

endmodule
