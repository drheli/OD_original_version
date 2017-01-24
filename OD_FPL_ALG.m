% Digit-vector: x[P] = x_in(1,2,...,P); y[P] = y_in(1,2,...,P);
% x(j) = x(j)_plus - x(j)_minus; y(j) = y(j)_plus - y(j)_minus 
% if j > delta
% p = p(j-delta)
function [test,CAq_plus,CAq_minus,CAd_plus,CAd_minus,CAq_plus_sel, CAq_minus_sel,CAd_plus_sel, CAd_minus_sel, shift_to_int_plus,shift_to_int_minus,v_frac_plus,v_frac_minus,compare_frac,w_frac_plus,w_frac_minus,shift_out_plus,shift_out_minus,count_one_plus,count_one_minus,q_plus,q_minus,v_int_plus,v_int_minus,w_int_plus,w_int_minus] = OD_FPL_ALG(x_in_plus, x_in_minus, d_in_plus, d_in_minus, k,u_r,n_r)
% initialization step
% time_step: j
unrolling = 8;
delta = 4;
persistent j;
if isempty(j)
	j = 0;
end
persistent flag;
%persistent p_count;
% BRAM: w_frac
persistent w_plus_wr_frac;
persistent w_minus_wr_frac;
    if(isempty(w_plus_wr_frac)&& isempty(w_minus_wr_frac))
        w_plus_wr_frac=zeros(1024,unrolling);  
        w_minus_wr_frac=zeros(1024,unrolling);
    end
% BRAM: w_int
persistent w_plus_wr_int;
persistent w_minus_wr_int;
    if(isempty(w_plus_wr_int)&& isempty(w_minus_wr_int))
        w_plus_wr_int=zeros(1024,5);  
        w_minus_wr_int=zeros(1024,5);
    end
%persistent cin_one_plus; persistent cin_one_minus; persistent cin_two_plus; persistent cin_two_minus;
persistent q_plus_rev; persistent q_minus_rev;
persistent q_plus_comp; persistent q_minus_comp;
if isempty (q_plus_comp) || isempty(q_minus_comp)
    q_plus_comp = zeros(1024,1);
    q_minus_comp = zeros(1024,1);
end
persistent CAw_frac_plus; persistent CAw_frac_minus;
persistent CAw_plus_int; persistent CAw_minus_int;
persistent q_out_plus; persistent q_out_minus;
%persistent p_v_plus; persistent p_v_minus;

%for j = 1:18
        j = j + 1;
        % x delay 3 clks in Aaron
		x_plus_rev = x_in_plus;
        x_minus_rev = x_in_minus;
        d_plus_rev = d_in_plus;
        d_minus_rev = d_in_minus;
        enable = 1; % only valid when a new digit valid
        res_enable = 1;          
        for i = n_r:-1:0
            if i == n_r
                enable = 1;
            else
                enable = 0;
            end
                % enable =1, write/read new digit, enable =0, read other chunk digits 
                % In OD, q[j] <=> x[j], y[j+1] <=> d[j+1]
                % BRAM: q read
                q_plus_rev = q_plus_comp(pairing(i,k),:);
                q_minus_rev = q_minus_comp(pairing(i,k),:);
                [CAq_plus,CAq_minus,CAd_plus,CAd_minus] = CA_gen(q_plus_rev,q_minus_rev,d_plus_rev,d_minus_rev,i,i,u_r,k,enable);        
			    % Algorithm: CAx_sel = x[j]*y(j); CAy_sel = y[j+1]*x(j) 
                % in Aaron's verilog, there is a delta delay for CAq, may be ....  
			    [CAq_plus_sel, CAq_minus_sel]=SDVM_d(~d_plus_rev,~d_minus_rev,CAq_plus,CAq_minus);
			    [CAd_plus_sel, CAd_minus_sel]=SDVM_d(~q_plus_rev,~q_minus_rev,CAd_plus,CAd_minus);
                
                if isempty(flag)
                    %cin_one_plus = 0; cin_one_minus = 0; cin_two_plus = 0; cin_two_minus = 0; 
                    CAw_frac_plus=zeros(1,unrolling); CAw_frac_minus=zeros(1,unrolling);
                    q_out_plus = zeros(1,4*unrolling); q_out_minus = zeros(1,4*unrolling); 
                    flag = 0;
                end
                % Algorithm: v[j] =...; qj =...;
                % BRAM: w_frac read
                CAw_frac_plus = w_plus_wr_frac(pairing(i,k),:);
                CAw_frac_minus = w_minus_wr_frac(pairing(i,k),:);
                [shift_to_int_plus,shift_to_int_minus,v_frac_plus,v_frac_minus,compare_frac] = v_frac_div(CAq_plus_sel,CAq_minus_sel,CAw_frac_plus,CAw_frac_minus,x_plus_rev,x_minus_rev,  i,n_r);
                
                % BRAM: w_int read
                CAw_plus_int=w_plus_wr_int(pairing(i,k),:);
                CAw_minus_int=w_minus_wr_int(pairing(i,k),:);   
                [q_plus,q_minus,v_int_plus,v_int_minus,test] = v_int_div(compare_frac,CAw_plus_int,CAw_minus_int,shift_to_int_plus,shift_to_int_minus);
                
                % BRAM: q write
                q_plus_comp(pairing(i,k),:) = q_plus;
                q_minus_comp(pairing(i,k),:) = q_minus;       
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
                % Algorithm: 2*w[j]=...; 
                % BRAM_frac write: 
                [w_frac_plus,w_frac_minus,shift_out_plus,shift_out_minus,count_one_plus,count_one_minus] = w_frac_div(CAd_plus_sel,CAd_minus_sel,v_frac_plus, v_frac_minus, i,i,n_r,k);
                %CAw_frac_plus = w_frac_plus;
                %CAw_frac_minus = w_frac_minus;
                w_plus_wr_frac(pairing(i,k),:)=w_frac_plus;
                w_minus_wr_frac(pairing(i,k),:)=w_frac_minus;
                % BRAM_int write
                [w_int_plus,w_int_minus] = w_int_div(v_int_plus, v_int_minus,i, shift_out_plus,shift_out_minus,count_one_plus,count_one_minus,k);
                w_plus_wr_int(pairing(i,k),:)=w_int_plus;
                w_minus_wr_int(pairing(i,k),:)=w_int_minus;
        end
                
                flag = flag + 1;
                count = j;
                q_out_plus(1,j)=q_plus;
                q_out_minus(1,j)=q_plus;
                q1_out=q_out_plus;
                q0_out=q_out_minus;

end
    %end
%end
			

