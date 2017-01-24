function [w_plus_int,w_minus_int] = w_int_div(v_int_plus, v_int_minus,wr_addr, shift_out_plus,shift_out_minus,cout_one_plus,count_one_minus,k)
persistent shift_in_plus;
persistent shift_in_minus;
if isempty(shift_in_plus) || isempty(shift_in_minus)
    shift_in_plus = zeros(1,2);
    shift_in_minus = zeros(1,2);
end
persistent w_int_plus;
persistent w_int_minus;
    if(isempty(w_int_plus)&& isempty(w_int_minus))
        w_int_plus=zeros(256,5);  % 64*4
        w_int_minus=zeros(256,5);
    end
    
if wr_addr == 0
    shift_in_plus(1) = shift_out_plus; 
    shift_in_plus(2) = cout_one_plus;
    shift_in_minus(1) = shift_out_minus;
    shift_in_minus(2) = count_one_minus;
else
    shift_in_plus = zeros(1,2);
    shift_in_minus = zeros(1,2);
end

%if wr_enable ==1
    if wr_addr == 0
        w_int_plus(pairing(wr_addr,k),5) = shift_in_plus(1);
        temp_plus = dec2bin(bin2dec(num2str(v_int_plus(2:5))) + shift_in_plus(2))-'0';     
        %temp_plus = str2num(temp_plus_rev);
            if length(temp_plus)==5  % overflow
                for i=1:4
                    w_int_plus(pairing(wr_addr,k),i) = temp_plus(i+1);
                end
            end
            if length(temp_plus)==4
                for i=1:4
                    w_int_plus(pairing(wr_addr,k),i) = temp_plus(i);
                end
            end    
            if length(temp_plus)==3
                w_int_plus(pairing(wr_addr,k),1) = 0;
                for i=1:3
                    w_int_plus(pairing(wr_addr,k),i+1) = temp_plus(i);
                end
            end
            if length(temp_plus)==2
                 w_int_plus(pairing(wr_addr,k),1) = 0;
                 w_int_plus(pairing(wr_addr,k),2) = 0;
                for i=1:2
                    w_int_plus(pairing(wr_addr,k),i+2) = temp_plus(i);
                end               
            end
            if length(temp_plus)==1
                w_int_plus(pairing(wr_addr,k),4) = temp_plus(1);
                for i=1:3
                    w_int_plus(pairing(wr_addr,k),i) = 0;
                end 
            end
        w_int_minus(pairing(wr_addr,k),5) = shift_in_minus(1);
        temp_minus = dec2bin(bin2dec(num2str(v_int_minus(2:5))) + shift_in_minus(2))-'0';     
        %temp_minus = str2num(temp_minus_rev);
            if length(temp_minus)==5
                for i=1:4
                    w_int_minus(pairing(wr_addr,k),i) = temp_minus(i+1);
                end
            end
            if length(temp_minus)==4
                for i=1:4
                    w_int_minus(pairing(wr_addr,k),i) = temp_minus(i);
                end
            end    
            if length(temp_minus)==3
                w_int_minus(pairing(wr_addr,k),1) = 0;
                for i=1:3
                    w_int_minus(pairing(wr_addr,k),i+1) = temp_minus(i);
                end
            end
            if length(temp_minus)==2
                 w_int_minus(pairing(wr_addr,k),1) = 0;
                 w_int_minus(pairing(wr_addr,k),2) = 0;
                for i=1:2
                    w_int_minus(pairing(wr_addr,k),i+2) = temp_minus(i);
                end               
            end
            if length(temp_minus)==1
                w_int_minus(pairing(wr_addr,k),4) = temp_minus(1);
                for i=1:3
                    w_int_minus(pairing(wr_addr,k),i) = 0;
                end 
            end
            if temp_minus == 0
               for i=1:4
                   w_int_minus(pairing(wr_addr,k),i) = 0;
               end 
            end
        w_plus_int = w_int_plus(pairing(wr_addr,k),:);
        w_minus_int = w_int_minus(pairing(wr_addr,k),:);
    else
        w_plus_int = zeros(1,5);
        w_minus_int = zeros(1,5);
    end
%end
        