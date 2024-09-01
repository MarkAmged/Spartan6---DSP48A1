module DSP_tb ();

parameter A0REG = 0,
          A1REG = 1, 
          B0REG = 0,
          B1REG = 1,
          CREG = 1, 
          DREG = 1, 
          MREG = 1,
          PREG = 1, 
          CARRYINREG = 1, 
          CARRYOUTREG = 1, 
          OPMODEREG = 1,
          CARRYINSEL = "OPMODE5",
          B_INPUT = "DIRECT",
          RSTTYPE = "SYNC";

 reg [17:0] A,B,D,BCIN;
 reg [47:0] C,PCIN;
 reg [7:0] OPMODE;
 reg CLK,CARRYIN;
 reg RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
 reg CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
 wire [17:0] BCOUT;
 wire [47:0] PCOUT,P;
 wire [35:0] M;
 wire CARRYOUT,CARRYOUTF;


////////instantiation
 DSP #(A0REG,A1REG,B0REG,B1REG,CREG,DREG,MREG,PREG,CARRYINREG,CARRYOUTREG,OPMODEREG,CARRYINSEL,B_INPUT,RSTTYPE) DUT(
    A,B,D,BCIN,C,PCIN,OPMODE,CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);


    //////////clock generation    
 initial begin
    CLK=0;
    forever
        #1 CLK=~CLK;
 end



 
integer i;
initial begin
// Initialize and reset signals
    RSTA = 1; RSTB = 1; RSTM = 1; RSTP = 1; RSTC = 1; RSTD = 1; RSTCARRYIN = 1; RSTOPMODE = 1;
    CEA = 1; CEB = 1; CEM = 1; CEP = 1; CEC = 1; CED = 1; CECARRYIN = 1; CEOPMODE = 1;
    A = 0; B = 0; C = 0; D = 0; CARRYIN = 0; BCIN = 0; PCIN = 0;
    OPMODE = 8'b00000000;
    repeat(5)
     @(negedge CLK);
    
    // reset signal
    RSTA = 0; RSTB = 0;
    RSTM = 0;
    RSTP = 0;
    RSTC = 0;
    RSTD = 0;
    RSTCARRYIN = 0;
    RSTOPMODE = 0;


    //B*A+C+opmode[5] =41
    OPMODE=8'b01101101;
    A=15;B=2;C=10;
    repeat(5)
    @(negedge CLK);
    


    //C-((D-B)*A)=1000-((13-3)*10)=900
    OPMODE=8'b11011101;
    D=13;B=3;A=10;C=1000;
    repeat(5)
    @(negedge CLK);



    //X_m=P,Z_m=P:x+z=900+900=1800
    OPMODE=8'b01011010;
    repeat(2)
    @(negedge CLK);


    //P=PCIN=12345;
    OPMODE=8'b01010100;
    PCIN=12345;
    repeat(2)
    @(negedge CLK);



    //(D+B)*A=25
    OPMODE=8'b00010001;
    D=3;B=2;A=5;
    repeat(5)
    @(negedge CLK);


    OPMODE = 8'b00010011;
    D=20'b10101010101001010101;
    B=0;
    A=20'b10101010101001010101;
    repeat(5)
    @(negedge CLK);
    $display("P=%b",P);

    
    OPMODE = 8'b00110101;
    for(i=0;i<5;i=i+1) begin
        A=$urandom_range(1,50);
        B=$urandom_range(1,50);
        D=$urandom_range(1,50);
        PCIN=$urandom_range(1,50);
        repeat(5)
        @(negedge CLK);           
    end

    $stop;
end

initial begin
    $monitor("A=%d, B=%d, C=%d, D=%d, CARRYIN=%d ,PCIN=%d , OPMODE=%b, P=%d,BCOUT=%d ,M=%d ,CARRYOUT=%d", A, B, C, D,CARRYIN ,PCIN , OPMODE, P,BCOUT ,M , CARRYOUT);
end
endmodule  
