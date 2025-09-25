// 這是 timescale 指令，定義了模擬的時間單位和精度
// #1 代表 1ns，精度到 1ps
`timescale 1ns / 1ps

// Testbench 模組通常沒有輸入和輸出
module traffic_light_tb;

    // 1. 產生給待測物(DUT)的訊號
    //    在 testbench 中，要產生的訊號都宣告為 reg
    reg clk;
    reg rst;
    
    // 2. 從待測物(DUT)接收訊號
    //    在 testbench 中，要接收的訊號都宣告為 wire
    wire [2:0] light;
    
    // 3. 實例化(Instantiate)你的設計，也就是把 traffic_light 模組 "召喚" 進來
    //    取一個實體名稱叫做 DUT (Device Under Test, 待測裝置)
    traffic_light DUT (
        // 使用 .<port_name>(<signal_name>) 的方式連接
        // .clk 是 traffic_light 模組的 clk 接腳
        // (clk) 是我們這個 testbench 檔案中宣告的 clk 信號
        .clk(clk),
        .rst(rst),
        .light_out(light)
    );
    
    // 4. 產生時脈 (clk) 訊號的邏輯
    //    initial begin ... end 區塊內的程式碼只會從頭到尾執行一次
    initial begin
        clk = 0; // 初始值設為 0
        forever #5 clk = ~clk; // forever 會無限循環，#5 代表延遲 5ns
                               // 所以這行的意思是：每 5ns，就把 clk 信號反相 (0變1，1變0)
                               // 這樣就產生了一個週期為 10ns 的時脈
    end
    
    // 5. 產生測試流程的邏輯
    initial begin
        // 一開始，先給一個重置訊號
        rst = 1;
        #20; // #20 代表等待 20ns
        rst = 0; // 結束重置，讓我們的交通號誌燈開始正常運作
        
        // 讓模擬跑 300ns，足以觀察好幾個完整的紅綠燈循環
        // (一個循環 = 8+2+10 = 20 個時脈 = 20*10ns = 200ns)
        #600; 
        
        $finish; // $finish 是系統指令，用來結束模擬
    end

endmodule