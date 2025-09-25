`timescale 1ns / 1ps

module random_gen_tb;

    // --- 將所有宣告集中在模組開頭 ---
    reg clk;
    reg rst;
    reg en;
    wire [1:0] rand_num;
    integer i; // <--- 把宣告移到這裡來！
    
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
        forever #5 clk = ~clk;
    end
    
    // 產生測試流程
    initial begin
        // 1. 重置
        rst = 1;
        en = 0;
        #20;
        rst = 0;
        
        // 2. for 迴圈本身不用改，因為 i 已經在外面宣告好了
        for (i = 0; i < 10; i = i + 1) begin
            en = 1;
            #10;
        end
        
        // 3. 結束測試
        en = 0;
        #50;
        $finish;
    end

endmodule
