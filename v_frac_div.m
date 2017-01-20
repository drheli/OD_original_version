function [shift_to_int_plus,shift_to_int_minus,v_frac_plus,v_frac_minus,compare] = v_frac_div(q_plus,q_minus,w_frac_plus,w_frac_minus,x_plus,x_minus,  i,n_r)
persistent cin_one_plus;
persistent cin_one_minus;
persistent shift_plus;
persistent shift_minus;
if isempty(shift_plus) || isempty(shift_minus)
    shift_plus = zeros(1,2);
    shift_minus = zeors(1,2);
end
if i == n_r  % n > 0
    cin_one_plus = 0;  
    cin_one_minus = 0;
end

[temp_frac_plus,temp_frac_minus,cout_one_plus,cout_one_minus] = fourbitadder(q_plus, q_minus, w_frac_plus, w_frac_minus, cin_one_plus, cin_one_minus);
    
if i>=1  % n > 0
    cin_one_plus = cout_one_plus;  
    cin_one_minus = cout_one_minus;
else
    cin_one_plus = 0;
    cin_one_minus = 0;
end
    
if i == 0  % different shift_ena =1(i=n_r) in OM
    v_frac_plus(2:unrolling) = temp_frac_plus(2:unrolling);
    v_frac_minus(2:unrolling) = temp_frac_minus(2:unrolling);
    %shift_plus(1,1) = fix((temp_frac_plus(1)+cout_one_plus*2+x_plus) / 4);  %carry   
    %v_frac_plus(1) = mod((temp_frac_plus(1)+cout_one_plus*2+x_plus),2);    %sum
    sum_plus = dec2bin(temp_frac_plus(1)+cout_one_plus*2+x_plus);  %carry   
    if sum_plus == 4
        shift_plus = sum_plus(1:2);
        v_frac_plus(1) = sum_plus(3);    %sum
    else
        if sum_plus > 1
            shift_plus(1,1) = 0;
            shift_plus(1,2) = sum_plus(1);
            v_frac_plus(1) = sum_plus(3);    %sum
        else
            shift_plus = 0;
            v_frac_plus(1) = sum_plus;
        end
    end
    %shift_to_int_minus = fix((temp_frac_minus(1)+cout_one_minus*2+x_minus) / 2);  %carry    
    %v_frac_minus(1) = mod((temp_frac_minus(1)+cout_one_minus*2+x_minus),2);    %sum
    sum_minus = dec2bin(temp_frac_minus(1)+cout_one_minus*2+x_minus);  %carry   
    if sum_minus == 4
        shift_minus = sum_minus(1:2);
        v_frac_minus(1) = sum_minus(3);    %sum
    else
        if sum_minus > 1
            shift_minus(1,1) = 0;
            shift_minus(1,2) = sum_minus(1);
            v_frac_minus(1) = sum_minus(3);    %sum
        else
            shift_minus = 0;
            v_frac_minus(1) = sum_minus;
        end
    end
    shift_to_int_plus = shift_plus;
    shift_to_int_minus = shift_minus;
else
    shift_to_int_plus = zeros(1,2);
    shift_to_int_minus = zeros(1,2);
    v_frac_plus = temp_frac_minus;
    v_frac_minus = temp_frac_minus;
end

if bin2dec(num2str(v_frac_plus)) >= bin2dec(num2str(v_frac_minus))
    compare = 1;  % in OM = 0
else
    compare = 0;  % in OM = 1
end
end