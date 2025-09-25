`timescale 1ns / 1ps

module pwm_gen_tb;

    // ----------- ?��? DUT ��?? -----------
    reg clk;
    reg rst;
    
    // �ŧi�T?���P�� duty ?�J
    reg [3:0] duty_10_percent; // ?�Ĥ@? DUT�A�N�� 10%
    reg [3:0] duty_30_percent; // ?�ĤG? DUT�A�N�� 30%
    reg [3:0] duty_80_percent; // ?�ĤT? DUT�A�N�� 80%
    
    // ----------- ? DUT ����?? -----------
    
    // �ŧi�T??�ߪ� wire ?�����T? DUT �� pwm ?�X
    wire pwm_out_10;
    wire pwm_out_30;
    wire pwm_out_80;
    
    // ----------- ?�Ҥ�(Instantiate)�T? DUT -----------
    
    // �Ĥ@? DUT�A�Τ_?�� 10% �� PWM
    pwm_gen DUT_10_percent (
        .clk(clk),
        .rst(rst),
        .duty_in(duty_10_percent),
        .pwm_out(pwm_out_10)
    );

    // �ĤG? DUT�A�Τ_?�� 30% �� PWM
    pwm_gen DUT_30_percent (
        .clk(clk),
        .rst(rst),
        .duty_in(duty_30_percent),
        .pwm_out(pwm_out_30)
    );

    // �ĤT? DUT�A�Τ_?�� 80% �� PWM
    pwm_gen DUT_80_percent (
        .clk(clk),
        .rst(rst),
        .duty_in(duty_80_percent),
        .pwm_out(pwm_out_80)
    );
    
    // ----------- ?��?? (clk) -----------
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns �P��
    end
    
    // ----------- ?��??�y�{ -----------
    initial begin
        // 1. ��l���O���m
        rst = 1;
        duty_10_percent = 4'd0; // ���m?������?�s
        duty_30_percent = 4'd0;
        duty_80_percent = 4'd0;
        #20;
        rst = 0; // ?�����m
        
        // 2. �b���m?���Z�A"�@����"�a?�w�n�T? DUT �U�۪� duty ��
        #10;
        duty_10_percent = 4'd1; // �Ĥ@? DUT ��?�J��?�O 1
        duty_30_percent = 4'd3; // �ĤG? DUT ��?�J��?�O 3
        duty_80_percent = 4'd8; // �ĤT? DUT ��?�J��?�O 8
        
        // 3. ���ݨ�??��????��i��
        //    �@? PWM �P���O 1000ns�A��?�] 2 ?�P��
        #2000;
        
        $finish; // ?����?
    end

endmodule