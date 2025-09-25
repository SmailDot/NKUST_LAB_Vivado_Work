// �o�O timescale ���O�A�w�q�F�������ɶ����M���
// #1 �N�� 1ns�A��ר� 1ps
`timescale 1ns / 1ps

// Testbench �Ҳճq�`�S����J�M��X
module traffic_light_tb;

    // 1. ���͵��ݴ���(DUT)���T��
    //    �b testbench ���A�n���ͪ��T�����ŧi�� reg
    reg clk;
    reg rst;
    
    // 2. �q�ݴ���(DUT)�����T��
    //    �b testbench ���A�n�������T�����ŧi�� wire
    wire [2:0] light;
    
    // 3. ��Ҥ�(Instantiate)�A���]�p�A�]�N�O�� traffic_light �Ҳ� "�l��" �i��
    //    ���@�ӹ���W�٥s�� DUT (Device Under Test, �ݴ��˸m)
    traffic_light DUT (
        // �ϥ� .<port_name>(<signal_name>) ���覡�s��
        // .clk �O traffic_light �Ҳժ� clk ���}
        // (clk) �O�ڭ̳o�� testbench �ɮפ��ŧi�� clk �H��
        .clk(clk),
        .rst(rst),
        .light_out(light)
    );
    
    // 4. ���ͮɯ� (clk) �T�����޿�
    //    initial begin ... end �϶������{���X�u�|�q�Y�������@��
    initial begin
        clk = 0; // ��l�ȳ]�� 0
        forever #5 clk = ~clk; // forever �|�L���`���A#5 �N���� 5ns
                               // �ҥH�o�檺�N��O�G�C 5ns�A�N�� clk �H���Ϭ� (0��1�A1��0)
                               // �o�˴N���ͤF�@�Ӷg���� 10ns ���ɯ�
    end
    
    // 5. ���ʹ��լy�{���޿�
    initial begin
        // �@�}�l�A�����@�ӭ��m�T��
        rst = 1;
        #20; // #20 �N���� 20ns
        rst = 0; // �������m�A���ڭ̪���q���x�O�}�l���`�B�@
        
        // �������] 300ns�A���H�[��n�X�ӧ��㪺����O�`��
        // (�@�Ӵ`�� = 8+2+10 = 20 �Ӯɯ� = 20*10ns = 200ns)
        #600; 
        
        $finish; // $finish �O�t�Ϋ��O�A�Ψӵ�������
    end

endmodule