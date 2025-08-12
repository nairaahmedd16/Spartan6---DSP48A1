module DSP_tb();

//stimuls and response 
reg [17:0] A_tb,B_tb,D_tb;
reg [47:0] C_tb;
reg CLK_tb,CARRYIN_tb;
reg [7:0] OPMODE_tb;
reg [17:0] BCIN_tb;
reg RSTA_tb,RSTB_tb,RSTM_tb,RSTP_tb,RSTC_tb,RSTD_tb,RSTCARRYIN_tb,RSTOPMODE_tb;
reg CEA_tb,CEB_tb,CEM_tb,CEP_tb,CEC_tb,CED_tb,CECARRYIN_tb,CEOPMODE_tb;
reg [47:0] PCIN_tb;

wire [17:0] BCOUT_tb;
wire [47:0] PCOUT_tb,P_tb;
wire [35:0] M_tb;
wire CARRYOUT_tb,CARRYOUTF_tb;

reg [17:0] BCOUT_exp;
reg [47:0] PCOUT_exp,P_exp;
reg [35:0] M_exp;
reg CARRYOUT_exp,CARRYOUTF_exp;

integer i;

// Instanriation Dut 
DSP48A1 DUT (.A(A_tb),.B(B_tb),.D(D_tb),.C(C_tb),
.CLK(CLK_tb),.CARRYIN(CARRYIN_tb),
.OPMODE(OPMODE_tb),.BCIN(BCIN_tb),.RSTA(RSTA_tb),.RSTB(RSTB_tb),.RSTM(RSTM_tb),.RSTP(RSTP_tb),.RSTC(RSTC_tb),.RSTD(RSTD_tb),.RSTCARRYIN(RSTCARRYIN_tb),.RSTOPMODE(RSTOPMODE_tb),
.CEA(CEA_tb),.CEB(CEB_tb),.CEM(CEM_tb),.CEP(CEP_tb),.CEC(CEC_tb),.CED(CED_tb),.CECARRYIN(CECARRYIN_tb),.CEOPMODE(CEOPMODE_tb), //clock enable
.PCIN(PCIN_tb),
.BCOUT(BCOUT_tb),.PCOUT(PCOUT_tb),.P(P_tb),.M(M_tb),
.CARRYOUT(CARRYOUT_tb),.CARRYOUTF(CARRYOUTF_tb));

// CLK generation 
initial begin
    CLK_tb =0;
    forever 
        #1 CLK_tb = ~CLK_tb;
end



initial begin 
    // verify reset 
    RSTA_tb =1; 
    RSTB_tb =1;
    RSTM_tb =1;
    RSTP_tb =1;
    RSTC_tb =1;
    RSTD_tb =1;
    RSTCARRYIN_tb =1;
    RSTOPMODE_tb =1;

    A_tb = $random; 
    B_tb = $random;
    D_tb = $random;
    C_tb = $random; 
    CARRYIN_tb = $random; 
    OPMODE_tb = $random;
    BCIN_tb = $random;
    CEA_tb = $random;
    CEB_tb = $random;
    CEM_tb = $random;
    CEP_tb = $random;
    CEC_tb = $random;
    CED_tb = $random;
    CECARRYIN_tb = $random;
    CEOPMODE_tb = $random;
    PCIN_tb = $random;

    repeat(1) @(negedge CLK_tb);
    if (BCOUT_tb != 18'b0 && PCOUT_tb != 48'b0 && P_tb != 48'b0 && M_tb != 36'b0 && CARRYOUT_tb != 1'b0 && CARRYOUTF_tb!= 1'b0) begin
        $display (" Reset is not working ");
        $stop;
    end
    else  
        $display ("Reset is working ");

    RSTA_tb =0; 
    RSTB_tb =0;
    RSTM_tb =0;
    RSTP_tb =0;
    RSTC_tb =0;
    RSTD_tb =0;
    RSTCARRYIN_tb =0;
    RSTOPMODE_tb =0;
    CEA_tb = 1;
    CEB_tb = 1;
    CEM_tb = 1;
    CEP_tb = 1;
    CEC_tb = 1;
    CED_tb = 1;
    CECARRYIN_tb = 1;
    CEOPMODE_tb = 1;

    // verify DSP path 1
    OPMODE_tb = 8'b11011101;
    A_tb = 20;
    B_tb = 10;
    C_tb = 350;
    D_tb = 25;
    BCIN_tb = $random;
    PCIN_tb = $random;
    CARRYIN_tb = $random;
    repeat(4) @(negedge CLK_tb);
    BCOUT_exp = 'hf;
    M_exp = 'h12c;
    P_exp = 'h32;
    PCOUT_exp = 'h32;
    CARRYOUT_exp =0;
    CARRYOUTF_exp =0;

    if(BCOUT_tb != BCOUT_exp || M_tb != M_exp || P_tb != P_exp || PCOUT_tb != PCOUT_exp || CARRYOUT_tb != CARRYOUT_exp || CARRYOUTF_tb != CARRYOUTF_exp) begin 
        $display ("path 1 is not working ");
        $stop;
    end
    else  
        $display ("path 1 is woking");
    
    // verify DSP path 2
    OPMODE_tb = 8'b00010000;
    A_tb = 20;
    B_tb = 10;
    C_tb = 350;
    D_tb = 25;
    BCIN_tb = $random;
    PCIN_tb = $random;
    CARRYIN_tb = $random;
    repeat(3) @(negedge CLK_tb);
    BCOUT_exp = 'h23;
    M_exp = 'h2bc;
    P_exp = 0;
    PCOUT_exp = 0;
    CARRYOUT_exp =0;
    CARRYOUTF_exp =0;
    if(BCOUT_tb != BCOUT_exp || M_tb != M_exp || P_tb != P_exp || PCOUT_tb != PCOUT_exp || CARRYOUT_tb != CARRYOUT_exp || CARRYOUTF_tb != CARRYOUTF_exp) begin 
        $display ("path 2 is not working ");
        $stop;
    end
    else  
        $display ("path 2 is woking");

    // verify DSP path 3
    OPMODE_tb = 8'b00001010;
    A_tb = 20;
    B_tb = 10;
    C_tb = 350;
    D_tb = 25;
    BCIN_tb = $random;
    PCIN_tb = $random;
    CARRYIN_tb = $random;
    repeat(3) @(negedge CLK_tb);
    BCOUT_exp = 'ha;
    M_exp = 'hc8;
    repeat(3) @(negedge CLK_tb);
    if(BCOUT_tb != BCOUT_exp || M_tb != M_exp || P_tb != P_exp || PCOUT_tb != PCOUT_exp || CARRYOUT_tb != CARRYOUT_exp || CARRYOUTF_tb != CARRYOUTF_exp) begin 
        $display ("path 3 is not working ");
        $stop;
    end
    else  
        $display ("path 3 is woking");
    
    // verify DSP path 4
    OPMODE_tb = 8'b10100111;
    A_tb = 5;
    B_tb = 6;
    C_tb = 350;
    D_tb = 25;
    BCIN_tb = $random;
    PCIN_tb = 3000;
    CARRYIN_tb = $random;
    repeat(3) @(negedge CLK_tb);
    BCOUT_exp = 'h6;
    M_exp = 'h1e;
    P_exp = 'hfe6fffec0bb1;
    PCOUT_exp = 'hfe6fffec0bb1;
    CARRYOUT_exp =1;
    CARRYOUTF_exp =1;
    if(BCOUT_tb != BCOUT_exp || M_tb != M_exp || P_tb != P_exp || PCOUT_tb != PCOUT_exp || CARRYOUT_tb != CARRYOUT_exp || CARRYOUTF_tb != CARRYOUTF_exp) begin 
        $display ("path 4 is not working ");
        $stop;
    end
    else  
        $display ("path 4 is woking");
$stop;
end
endmodule

    







     

        


        




    