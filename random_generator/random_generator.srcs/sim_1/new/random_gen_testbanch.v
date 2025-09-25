`timescale 1ns / 1ps

module random_gen_tb;

    // 產生給 DUT 的訊號
    reg clk;
    reg rst;
    reg en; // enable
    integer i;
    
    // 從 DUT 接收訊號
    wire [1:0] rand_num;
    
    // 實例化 DUT
    random_gen DUT (
        .clk(clk),
        .rst(rst),
        .enable(en),
        .random_out(rand_num)
    );
    
    // 產生時脈
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns 週期
    end
    
    // 產生測試流程
    initial begin
        // 1. 重置
        rst = 1;
        en = 0;
        #20;
        rst = 0;
        
        // 2. 根據題目要求，連續產生 10 個隨機數
        //    我們使用 for 迴圈來讓 enable 信號觸發 10 次
        
        for (i = 0; i < 10; i = i + 1) begin
            en = 1; // 拉高 enable
            #10;    // 持續一個時脈週期
        end
        
        // 3. 結束測試
        en = 0; // 拉低 enable
        #50;
        
        $finish;
    end

endmodule