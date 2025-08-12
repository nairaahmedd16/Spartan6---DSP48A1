module reg_mux (d,clk,en,rst,sel,out);

parameter WIDTH = 18;
parameter TYPE = "SYNC";
input [WIDTH-1:0] d;
input clk, rst, en, sel;
output [WIDTH-1:0] out;
reg [WIDTH-1:0] q;

generate
    if (TYPE == "SYNC") begin 
        always @(posedge clk ) begin 
    if(rst)
        q <= 0 ;
    else begin
        if (en)
            q <= d;
    end 
    
        end 
    end 
    else begin 
        always @(posedge clk or posedge rst) begin 
    if(rst)
        q <= 0 ;
    else begin
        if (en)
            q <= d;
    end 
    
        end 
    end

endgenerate

assign out = (sel)? q : d ;

endmodule    
