`timescale 1ns / 1ps

module pwm_gen_tb;

    // ----------- ?生? DUT 的?? -----------
    reg clk;
    reg rst;
    
    // 宣告三?不同的 duty ?入
    reg [3:0] duty_10_percent; // ?第一? DUT，代表 10%
    reg [3:0] duty_30_percent; // ?第二? DUT，代表 30%
    reg [3:0] duty_80_percent; // ?第三? DUT，代表 80%
    
    // ----------- ? DUT 接收?? -----------
    
    // 宣告三??立的 wire ?接收三? DUT 的 pwm ?出
    wire pwm_out_10;
    wire pwm_out_30;
    wire pwm_out_80;
    
    // ----------- ?例化(Instantiate)三? DUT -----------
    
    // 第一? DUT，用于?生 10% 的 PWM
    pwm_gen DUT_10_percent (
        .clk(clk),
        .rst(rst),
        .duty_in(duty_10_percent),
        .pwm_out(pwm_out_10)
    );

    // 第二? DUT，用于?生 30% 的 PWM
    pwm_gen DUT_30_percent (
        .clk(clk),
        .rst(rst),
        .duty_in(duty_30_percent),
        .pwm_out(pwm_out_30)
    );

    // 第三? DUT，用于?生 80% 的 PWM
    pwm_gen DUT_80_percent (
        .clk(clk),
        .rst(rst),
        .duty_in(duty_80_percent),
        .pwm_out(pwm_out_80)
    );
    
    // ----------- ?生?? (clk) -----------
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns 周期
    end
    
    // ----------- ?生??流程 -----------
    initial begin
        // 1. 初始化与重置
        rst = 1;
        duty_10_percent = 4'd0; // 重置?先全部?零
        duty_30_percent = 4'd0;
        duty_80_percent = 4'd0;
        #20;
        rst = 0; // ?束重置
        
        // 2. 在重置?束后，"一次性"地?定好三? DUT 各自的 duty 值
        #10;
        duty_10_percent = 4'd1; // 第一? DUT 的?入永?是 1
        duty_30_percent = 4'd3; // 第二? DUT 的?入永?是 3
        duty_80_percent = 4'd8; // 第三? DUT 的?入永?是 8
        
        // 3. 等待足??的????察波形
        //    一? PWM 周期是 1000ns，我?跑 2 ?周期
        #2000;
        
        $finish; // ?束模?
    end

endmodule