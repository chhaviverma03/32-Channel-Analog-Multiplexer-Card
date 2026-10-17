`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2026 11:22:39
// Design Name: 
// Module Name: mux32x1_top
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


module mux32x1_top(
input [4:0] addr ,
input [0:31]channel_in,
input en1_n,
input en2_n,
input en3,
input rs_n,
output final_analog_out
    );
    wire [2:0]A={1'b0,addr[4:3]};
    wire [7:0]Y;
    wire [2:0]A_mux=addr[2:0];
    wire [0:7]s1,s2,s3,s4;
    wire bus0,bus1,bus2,bus3;
    wire analog_bus;
    assign s1=channel_in[0:7];
    assign s2=channel_in[8:15];
    assign s3=channel_in[16:23];
    assign s4=channel_in[24:31];
   
    decoder dut(A,en1_n,en2_n,en3,Y);
    mux_8x1 m1(A_mux,Y[0],rs_n,1,s1,bus0);
    mux_8x1 m2(A_mux,Y[1],rs_n,2,s2,bus1);
    mux_8x1 m3(A_mux,Y[2],rs_n,3,s3,bus2);
    mux_8x1 m4(A_mux,Y[3],rs_n,4,s4,bus3);
    
    assign analog_bus=Y[0]?bus0:
                      Y[1]?bus1:
                      Y[2]?bus2:
                      Y[3]?bus3:1'bz;
    buffer uut(.analog_bus(analog_bus),.analog_out(final_analog_out));
    
endmodule
