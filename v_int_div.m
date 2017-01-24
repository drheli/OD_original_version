function [q_plus,q_minus,v_int_plus,v_int_minus,test] = v_int_div(compare_frac,w_int_plus,w_int_minus,shift_to_int_plus,shift_to_int_minus) %,wr_addr,rd_addr, ite_input_count)
    v_int_plus = zeros(1,5);
    v_int_minus = zeros(1,5);
    v_int_plus_rev = bin2dec(num2str(w_int_plus))+bin2dec(num2str(shift_to_int_plus));
    v_int_minus_rev = bin2dec(num2str(w_int_minus))+bin2dec(num2str(shift_to_int_minus));
    v_int_plus_reg = dec2bin(v_int_plus_rev)-'0';
    v_int_minus_reg = dec2bin(v_int_minus_rev)-'0';    
    test = length(v_int_plus_reg);
% v_int_plus_reg  
    if length(v_int_plus_reg)==5
        for i=1:5
            v_int_plus(1,i) = v_int_plus_reg(i);
        end
    end
    if length(v_int_plus_reg)==4
        v_int_plus(1,1) = 0;
        for i=1:4
            v_int_plus(1,i+1) = v_int_plus_reg(i);
        end
    end
    if length(v_int_plus_reg)==3
        v_int_plus(1,1:2) = zeros(1,2);
        for i=1:3
            v_int_plus(1,i+2) = v_int_plus_reg(i);
        end
    end
    if length(v_int_plus_reg)==2
        v_int_plus(1,1:3) = zeros(1,3);
        for i=1:2
            v_int_plus(1,i+3) = v_int_plus_reg(i);
        end
    end
    if length(v_int_plus_reg)==1
        v_int_plus(1,1:4) = zeros(1,4);
        v_int_plus(1,5) = v_int_plus_reg(1);
    end
% v_int_minus_reg    
    if length(v_int_minus_reg)==5
        for i=1:5
            v_int_minus(1,i) = v_int_minus_reg(i);
        end
    end
    if length(v_int_minus_reg)==4
        v_int_minus(1,1) = 0;
        for i=1:4
            v_int_minus(1,i+1) = v_int_minus_reg(i);
        end
    end
    if length(v_int_minus_reg)==3
        v_int_minus(1,1:2) = zeros(1,2);
        for i=1:3
            v_int_minus(1,i+2) = v_int_minus_reg(i);
        end
    end
    if length(v_int_minus_reg)==2
        v_int_minus(1,1:3) = zeros(1,3);
        for i=1:2
            v_int_minus(1,i+3) = v_int_minus_reg(i);
        end
    end
    if length(v_int_minus_reg)==1
        v_int_minus(1,1:4) = zeros(1,4);
        v_int_minus(1,5) = v_int_minus_reg(1);
    end
    
    v_upper = v_int_plus_rev - v_int_minus_rev + compare_frac - 1;
    %v_upper = bin2dec(num2str(v_int1-v_int0))-compare_frac; 
    if(v_upper >= 0)
        %v_sample=fix(v_upper/2);
        if fix(v_upper/2) ==0
            v_sample =0;
        else
            v_sample =1;
        end
    end
    if v_upper < 0
        v_sample = 2;
    end
    if v_upper == -1 || v_upper == -2 
        v_sample = 0;
    end
%     if(v_upper <= -1 && v_upper >=-4) %-1:11111,-2:11110,-3:11101,-4:11100
%         v_sample = 7;
%     end
%     if(v_upper <= -5 && v_upper >=-8) %-5:11011,-6:11010;-7:11001,-8:11000
%         v_sample = 6;
%     end
%     if(v_upper <= -9 && v_upper >=-12)%-9:10111,10110,10101,10100
%         v_sample = 5;
%     end        
%     if(v_upper <= -13 &&v_upper >=-16)%-13:10011, -16:10000
%         v_sample = 4;
%     end
%     % Since v_upper > 0 ,p=10; v_upper < 0, p =01;
%     if(v_upper <= -17)
%         p_value1 = 0; p_value0 = 1;   
%     end
        
    switch (v_sample)
        case 0% '1111' or '0000'
            q_plus = 0; q_minus = 0;
        case 2% '< 0'
            q_plus = 0; q_minus = 1;
        case 1% '> 0'
            q_plus = 1; q_minus = 0;
    end
%     p1 = zeros(256,1); p0 = zeros(256,1);
%     p1(pairing(wr_addr, ite_input_count),1)=q_plus;
%     p0(pairing(wr_addr, ite_input_count),1)=q_minus;
%     
% persistent w_int1;
% persistent w_int0;
%     if(isempty(w_int1)&& isempty(w_int0))
%         w_int1=zeros(256,5);  % 64*4
%         w_int0=zeros(256,5);
%     end
%     if(rd_addr == 0)
%         if(bitxor(bitxor(w_int_plus(2),q_plus),bitxor(w_int_minus(2),q_minus)))
%             w_int1(pairing(wr_addr, ite_input_count),1)=bitxor(w_int_plus(2),q_plus);
%             w_int0(pairing(wr_addr, ite_input_count),1)=bitxor(w_int_minus(2),q_minus);
%             %w_int1(pairing(wr_addr, ite_input_count),(1))=bitxor(v_int1(2),p1(pairing(rd_addr, ite_input_count),1));
%             %w_int0(pairing(wr_addr, ite_input_count),(1))=bitxor(v_int0(2),p0(pairing(rd_addr, ite_input_count),1));
%         else
%             w_int1(pairing(wr_addr, ite_input_count),1)=0;
%             w_int0(pairing(wr_addr, ite_input_count),1)=0;
%         end
%         w_int1(pairing(wr_addr, ite_input_count),2:4) = w_int_plus(3:5);
%         w_int0(pairing(wr_addr, ite_input_count),2:4) = w_int_minus(3:5);
%         w_int1(pairing(wr_addr, ite_input_count),5) = shift_to_int_plus;
%         w_int0(pairing(wr_addr, ite_input_count),5) = shift_to_int_minus;
%         v_int_plus = w_int1(pairing(wr_addr, ite_input_count),:);
%         v_int_minus = w_int0(pairing(wr_addr, ite_input_count),:);
%     end
            
end
    
    
%     v_sample = num2str(v_upper(1:3));
%     switch (v_sample)
%         case [0,1,1]
%             p_value1 = 1; p_value0 = 0;
%         case [0,1,0]
%             p_value1 = 1; p_value0 = 0;
%         case [0,0,1]
%             p_value1 = 1; p_value0 = 0;
%         case [0,0,0]
%             p_value1 = 0; p_value0 = 0;
%         case [1,1,1]
%             p_value1 = 0; p_value0 = 0;
%         case [1,1,0]
%             p_value1 = 0; p_value0 = 1;
%         case [1,0,1]
%             p_value1 = 0; p_value0 = 1;
%         case [1,0,0]
%             p_value1 = 0; p_value0 = 1;       
%     end