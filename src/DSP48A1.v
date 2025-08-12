module DSP48A1(A,B,D,C,
CLK,CARRYIN,
OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE, //clock enable
PCIN,
BCOUT,PCOUT,P,M,
CARRYOUT,CARRYOUTF);

parameter A0REG = 0; // no register 
parameter A1REG = 1; // registrered
parameter B0REG = 0; // no register 
parameter B1REG = 1; // registered 
parameter CREG = 1; // registered
parameter DREG = 1; // registered
parameter MREG = 1; // registered
parameter PREG = 1; // registered
parameter CARRYINREG = 1; // registered
parameter CARRYOUTREG = 1; // registered
parameter OPMODEREG = 1; // registered
parameter CARRYINSEL = "OPMODE5" ;    
parameter B_INPUT = " DIRECT";
parameter RSTTYPE = "SYNC";


input [17:0] A,B,D;
input [47:0] C;
input CLK,CARRYIN;
input [7:0] OPMODE;
input [17:0] BCIN;
input RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
input CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
input [47:0] PCIN;

output [17:0] BCOUT;
output [47:0] PCOUT,P;
output [35:0] M;
output CARRYOUT,CARRYOUTF;

wire [17:0] A1,B1,D1, B0, W2, W3, W4;
wire [35:0] W5, W6;
wire [47:0] C1;
wire W7, W8;
wire sel_dreg = DREG;
wire sel_areg0 = A0REG;
wire sel_areg1 = A1REG;
wire sel_creg = CREG;
wire sel_breg0 = B0REG;
wire sel_breg1 = B1REG;
wire sel_mreg = MREG;
wire sel_preg = PREG;
wire sel_carryinreg = CARRYINREG;
wire sel_carryoutreg = CARRYOUTREG;
wire sel_opmodereg = OPMODEREG;
wire Cout;
wire [47:0] post_adder, WP;
wire [17:0] W1;
wire [48:0] W9;
wire CARRY_SEL = 0;
wire BSELECT = 0;

reg [47:0] WX, WZ;

assign CARRY_SEL = (CARRYINSEL == "OPMODE5")? 1:0;    
assign BSELECT = ( B_INPUT == "DIRECT")? 1:0;


reg_mux #(18, RSTTYPE) registerD(D, CLK, CED, RSTD, sel_dreg, D1 );     // DREG Instantiation
reg_mux #(18, RSTTYPE) registerA0(A, CLK, CEA, RSTA, sel_areg0, A1);     // A0REG Instantiation
reg_mux #(48, RSTTYPE) registerC(C, CLK, CEC, RSTC, sel_creg, C1);      // CREG Instantiation
mux #(18) BMUX(BCIN, B, BSELECT, B0);                // BMUX Instantiation
reg_mux #(18, RSTTYPE) registerB0(B, CLK, CEB, RSTB, sel_breg0, B1);     // B0REG Instantiation

//opmode6 (adder_subtractor)
assign W1 = (OPMODE[6])? (D1 - B1) : (D1 + B1);

mux #(18) muxb1 (B1, W1, OPMODE[4], W2); //opmode4 
reg_mux #(18, RSTTYPE) registerB1(W2, CLK, CEOPMODE, RSTB,sel_breg1, W3); // B1REG Instantiation
reg_mux #(18, RSTTYPE) registerA1(A1, CLK, CEOPMODE, RSTA,sel_areg1, W4); // A1REG Instantiation

assign W5 = (W3*W4);

reg_mux #(36, RSTTYPE) registerm(W5, CLK, CEM, RSTM, sel_mreg, W6);

//opmode[1:0]
always @(*) begin 
    case (OPMODE[1:0])
        2'b00 : WX = 48'b0;
        2'b01 : WX = {12'b0,W6};
        2'b10 : WX = P;
        2'b11 : WX = {D1[11:0], W4[17:0], W3[17:0]};
        default : WX = 48'b0;
        endcase 
end 
    
//opmode[3:2]
always @(*) begin 
    case (OPMODE[3:2])
        2'b00 : WZ = 48'b0;
        2'b01 : WZ = PCIN;
        2'b10 : WZ = P;
        2'b11 : WZ = C1;
        default : WX = 48'b0;
        endcase 
end 

mux #(1)  carry(CARRYIN, OPMODE[5], CARRY_SEL, W7 );

reg_mux #(1, RSTTYPE) registercarryin(W7, CLK, CECARRYIN, RSTCARRYIN, sel_carryinreg, W8);

assign W9 = (OPMODE[7])? (WZ - (WX + W8)) : (WX + WZ + W8);

assign {Cout, post_adder} = {W9[48], W9[47:0]}; 

reg_mux #(48, RSTTYPE) registerp(post_adder, CLK, CEP, RSTP, sel_preg, WP);

assign P = WP;
assign PCOUT = P;
assign BCOUT = W3;
assign M = W6;

reg_mux #(.WIDTH(1),.TYPE(RSTTYPE)) registerout(Cout, CLK, CECARRYIN, RSTCARRYIN, sel_carryoutreg, CARRYOUT);

assign CARRYOUTF = CARRYOUT;

endmodule 















