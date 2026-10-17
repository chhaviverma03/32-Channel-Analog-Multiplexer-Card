`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2026 13:23:34
// Design Name: 
// Module Name: mux_8x1
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


module mux_8x1(
input [2:0]A,input en,rs_n,input [2:0]mux_num,[0:7]s,output reg analog_bus
    );
    always@(*)begin
    if(!en)begin 
        analog_bus=1'bz;
    end
    else if(!rs_n)begin
       analog_bus=1'bz;
    end
    //mux is enabled and reset is inactive as reset is active low 
    else begin
     case(A)
     3'b000:analog_bus=s[0];
     3'b001:analog_bus=s[1];
     3'b010:analog_bus=s[2];
     3'b011:analog_bus=s[3];
     3'b100:analog_bus=s[4];
     3'b101:analog_bus=s[5];
     3'b110:analog_bus=s[6];
     3'b111:analog_bus=s[7];
     //default:analog_bus=s[0];
     endcase 
     end
  end   
  //enable message
  always@(negedge en)begin
      $display("NO ENABLE SIGNAL RECIVED FOR MUX[%0d] FROM DECODER | MUX[%0d] DEACTIVATED",mux_num,mux_num);
  end
  always@(posedge en)begin
      $display("MUX[%0d] ACTIVATED",mux_num);
  end
  
  //reset message
  always@(negedge rs_n)begin
    if(rs_n==0)
      $display("RESET ON",mux_num);//OUTPUT PIN OF MUX DISCONNECTED
  end  
endmodule




























