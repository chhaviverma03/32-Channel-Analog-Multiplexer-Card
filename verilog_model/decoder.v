`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2026 12:25:39
// Design Name: 
// Module Name: decoder
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


module decoder(
input [2:0]A,input en1_n,en2_n,en3,output reg [7:0]Y
    );
    always@(*)begin
    Y=8'b00000000;
    if((en1_n==0) && (en2_n==0) && (en3==1))begin
     case(A)
       3'b000: Y=8'b00000001;
       3'b001:Y=8'b00000010;
       3'b010:Y=8'b00000100;
       3'b011:Y=8'b00001000;
       3'b100:Y=8'bz;
       3'b101:Y=8'bz;
       3'b110:Y=8'bz;
       3'b111:Y=8'bz;
       default:Y=8'bz;
       endcase
       end
    else begin
      Y=8'b00000000;
    end
    end   
    
    always@(en1_n or en2_n or en3)begin
     if((en1_n==0) && (en2_n==0) && (en3==1))
        $display("DECODER ACTIVATED");
     else
        $display("DECODER DEACTIVATED");
     end  
endmodule
