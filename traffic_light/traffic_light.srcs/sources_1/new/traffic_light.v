// �ҲզW�١Gtraffic_light
// �\��G�@�Ӹg�媺��B���B���O�`������q���x FSM
//module ��O�@�ثŧi�y�� �i�DVivado�� �{�b�n�Хߤ@�ӷs���Ҳ� �W�r�O����
module traffic_light(
    input clk, //�o��w�q�F��ӿ�J�� �@�ӥs��CLK �ڭ̷�@�ɯ�
    input rst, //�o��w�q��RST�ڭ̷�@���m�H��
    
    // �ϥ� 3-bit ��X�ӥN��T�ؿO��
    // GREEN : 3'b001
    // YELLOW: 3'b010
    // RED   : 3'b100
    output reg [2:0] light_out //�o�̥Τ@�ӽd�� �ݭn3-BIT �ҥH�O2�B1�B0 �@�T�ӡAreg�O�@�ӨϥΪ�conmment
    ); 

    // 1. �w�q FSM �����A
    parameter S_GREEN  = 2'b00;
    parameter S_YELLOW = 2'b01;
    parameter S_RED    = 2'b10;

    // 2. �w�q�C�Ӫ��A�ݭn���򪺮ɯ߶g����
    //    �� 1 �O�]���ڭ̱q 0 �}�l�� (0~7 �@ 8 �Ӽ�)
    parameter GREEN_TIME  = 8 - 1;
    parameter YELLOW_TIME = 2 - 1;
    parameter RED_TIME    = 10 - 1;

    // 3. �ŧi FSM �M�p�ɾ��ݭn���Ȧs��
    reg [1:0] state_reg; // �x�s FSM ����e���A �i�H��@ FSM ���u���A�O����v
    reg [3:0] count_reg; // �p�ɾ��A�]���̤j�n�ƨ� 10�A�ҥH�ݭn 4-bit 2��4���� 

    // 4. �֤��޿�϶�  posedge (�W�ɽt) �� negedge (�U���t)
    always @(posedge clk or posedge rst) begin //always ��O�ΨӴy�z "�`���޿�"�ϥΪ����O @(...)�̭� �ոܤ@�I�N�O�A�� �� clk �� rst ���W�ɫH�����ͮ� �~����ڭ̤U���g��begin to end ���{���޿�
        if (rst) begin
            // --- ���m�޿� ---
            // �p�G���m�A�j��^���O���A�A�p�ɾ��M��X���k�s
            state_reg <= S_GREEN;  //�o�� �N�O��Ĳ�o"rst"�|�j����� �^��"���I"�����A
            count_reg <= 4'd0;
            light_out <= 3'b001; // ���m�᪽���G��O
        end
        else begin
            // --- FSM ���A�ഫ�޿� ---
            case (state_reg)
                S_GREEN: begin
                    light_out <= 3'b001; // �b��O���A�A�����X��O�H��
                    // �ˬd�p�ɾ��O�_��F�]�w���ɶ�
                    if (count_reg == GREEN_TIME) begin
                        state_reg <= S_YELLOW; // �ɶ���A��������O���A
                        count_reg <= 4'd0;     // �p�ɾ��k�s�A���U�Ӫ��A��
                    end
                    else begin
                        count_reg <= count_reg + 1; // �ɶ�����A�p�ɾ��[ 1
                    end
                end
                
                S_YELLOW: begin
                    light_out <= 3'b010; // �b���O���A�A�����X���O�H��
                    if (count_reg == YELLOW_TIME) begin
                        state_reg <= S_RED;    // �ɶ���A��������O���A
                        count_reg <= 4'd0;     // �p�ɾ��k�s
                    end
                    else begin
                        count_reg <= count_reg + 1; // �ɶ�����A�p�ɾ��[ 1
                    end
                end
                
                S_RED: begin
                    light_out <= 3'b100; // �b���O���A�A�����X���O�H��
                    if (count_reg == RED_TIME) begin
                        state_reg <= S_GREEN;  // �ɶ���A�����^��O���A�A�����`��
                        count_reg <= 4'd0;     // �p�ɾ��k�s
                    end
                    else begin
                        count_reg <= count_reg + 1; // �ɶ�����A�p�ɾ��[ 1
                    end
                end

                default: begin
                    // �p�G FSM �N�~�i�J�������A�A�j��^���O���A
                    state_reg <= S_GREEN;
                    count_reg <= 4'd0;
                    light_out <= 3'b001;
                end
            endcase
        end
    end

endmodule