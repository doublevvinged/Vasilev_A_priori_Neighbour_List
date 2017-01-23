function f_out=f_x_h_y(x,h,y,y_labels)

%% Example Specify the function F(H_I,X) for
% A Hidden conditional Markov field 
% with  Hidden Variables where 
%  
% X_1-->Hidden_1-->Y_1
% X_2-->Hidden_2-->Y_2
% .
% X_I-->Hidden_K-->Y_J
% [I,K,J] = R3

%In total
% d_ln[p(y|x)]/d_theta=sum_h[ f(x,h,y)) p(h|x,y) ]-sum_y[sum_h[ f(x,h,y)) p(y,h|x) ]]
% the difference of 2 conditional expectations
% d_ln[p(y|x)]/d_theta=E_(h|x,y)[f(x,h,y))]-E_(y,h|x)[f(x,h,y))]

% The function is scalar: 
f_comp=@(x,h,y_labels,y) x* (abs(y-y_labels)) * (abs(h-y_labels));

% x_features x  hidden labels x y_labels x time
f_out=zeros(size(x,2),length(h),length(y_labels),length(y));
f_out=zeros(size(x,2),length(h),length(y_labels),size(x,1));

for i=1:size(f_out,1) % features
    for j=1:size(f_out,2) % hiddne
        for k=1:size(f_out,3) % y_labels
            for t=1:size(f_out,4) % time
   f_out(i,j,k,t)=f_comp( x(t,i),h(j), y_labels(k),y(t) );
            end
        end
    end
end








end