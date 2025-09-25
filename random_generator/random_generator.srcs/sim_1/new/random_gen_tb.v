`timescale 1ns / 1ps

module random_gen_tb;

    // --- �N�Ҧ��ŧi�����b�Ҳն}�Y ---
    reg clk;
    reg rst;
    reg en;
    wire [1:0] rand_num;
    integer i; // <--- ��ŧi����o�̨ӡI
    
    // ��Ҥ� DUT
    random_gen DUT (
        .clk(clk),
        .rst(rst),
        .enable(en),
        .random_out(rand_num)
    );
    
    // ���ͮɯ�
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // ���ʹ��լy�{
    initial begin
        // 1. ���m
        rst = 1;
        en = 0;
        #20;
        rst = 0;
        
        // 2. for �j�饻�����Χ�A�]�� i �w�g�b�~���ŧi�n�F
        for (i = 0; i < 10; i = i + 1) begin
            en = 1;
            #10;
        end
        
        // 3. ��������
        en = 0;
        #50;
        $finish;
    end

endmodule
