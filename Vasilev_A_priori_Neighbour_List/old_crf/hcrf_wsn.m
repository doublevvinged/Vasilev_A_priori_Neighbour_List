function tree=hcrf_wsn(x,y,gauss,train_predict,accuracy,iterations)
% clc
%% A Hidden conditional Markov field is a graph model
% with  Hidden Variables where 
 
% X_1-->Hidden_1-->Y_1
% X_2-->Hidden_2-->Y_2
% .
% X_I-->Hidden_K-->Y_J
% [I,K,J] = R3
 
%REQUIRE randsample_vv

%% The distribution
% begin with the marginl distribution of the hidden variable
% p(x,y)=sum_h[P(x,h,y)] (2)
% Use bayes formula to find the conditional label|data
% p(x,y)=p(x)p(y|x) 
% p(y|x)=p(x,y) / p(x)  (1)
% Evaluate the normalising p(x)
% p(x)=sum_y[p(x,y)]=sum_y[sum_h[p(x,h,y)]] (3)
% Define the joint distribution of the field
% p(x,h,y)=exp(Theta*f(x,h,y))
% Substitude in (1) -> (2),(3)
% p(y|x)=sum_h[P(x,h,y)]  / sum_y[sum_h[p(x,h,y)]]
% Find log likelihood
% ln[p(y|x)]= ln[sum_h[P(x,h,y)]]-ln[sum_y[sum_h[p(x,h,y)]]];
% ln[p(y|x)]= ln[sum_h[ exp(Theta*f(x,h,y)) ]]-ln[sum_y[sum_h[  exp(Theta*f(x,h,y)) ]]];
% ln[p(y|x)]_A=ln[sum_h[ exp(Theta*f(x,h,y))]]
% ln[p(y|x)]_B=-ln[sum_y[sum_h[  exp(Theta*f(x,h,y)) ]]];

% the derivtives with respect to the log likelihood
% d_ln[p(y|x)]_A/d_theta=(1 /exp_ln[p(y|x)]_A )* ln[p(y|x)]_A'
% d_ln[p(y|x)]_A/d_theta=(1 /sum_h[ exp(Theta*f(x,h,y))] )* exp_ln[p(y|x)]_A'
% d_ln[p(y|x)]_A/d_theta=sum_h[ f(x,h,y))*exp(Theta*f(x,h,y)) ]/sum_h[ exp(Theta*f(x,h,y))]
% exp(Theta*f(x,h,y)) /sum_h[exp(Theta*f(x,h,y))]=p(h|x,y)
% d_ln[p(y|x)]_A/d_theta=sum_h[ f(x,h,y)) p(h|x,y) ]

% -ln[p(y|x)]_B=(1 /exp_ln[p(y|x)]_B )* exp_ln[p(y|x)]_B'
% -d_ln[p(y|x)]_B/d_theta=(1 /sum_y[sum_h[exp(Theta*f(x,h,y))]] )* sum_y[sum_h[ Theta exp(Theta*f(x,h,y)) ]]
% sum_y[sum_h[ Theta exp(Theta*f(x,h,y)) ]]/sum_y[sum_h[exp(Theta*f(x,h,y))]]=p(y,h|x)
% -d_ln[p(y|x)]_B/d_theta=sum_y[sum_h[ f(x,h,y)) p(y,h|x) ]]

%In total
% d_ln[p(y|x)]/d_theta=sum_h[ f(x,h,y)) p(h|x,y) ]-sum_y[sum_h[ f(x,h,y)) p(y,h|x) ]]
% the difference of 2 conditional expectations
% d_ln[p(y|x)]/d_theta=E_(h|x,y)[f(x,h,y))]-E_(y,h|x)[f(x,h,y))]


%% Example Specify the function F(H_I,X) 
% a=1;
% f=@(x) x/2;
% c=f(a)
% % or
% g=inline('x/2');
% e=g(a)
% The function is: 
% f=@(x,h,y) ((y.*h)+1).* x;
%% Specify 
% x-examples x features 
% y =label of the data, - examples x 1
% gauss- [mu sigma] is the proposal distribution parameters
% train_pred 1 train theta ,2 estimate
% step_param, for gradient descent

%% Exact inference
% x = [ 1 0 1;
%       1 0 1;
%       1 0 1;
%       0 1 0;
%       0 1 0;
%       0 1 0;
%       ]
%  
% y =[ 0;
%     0;
%     0;
%     1;
%     1;
%      1]
% tree=hcmf_doublevvinged(x,y,gauss,train_predict,step,iterations)


%   tree=hcmf_doublevvinged(x,y,[0, 2],'train',10^-4,10000)

%     tree=hcmf_doublevvinged(x(1,:),y,[0, 1],'predict',10^-4,100); tree.predict

%    tree=hcmf_doublevvinged(x(4,:),y,[0, 1],'predict',10^-4,100);tree.predict

switch train_predict
    case 'train',   
%% The hidden variables are the unique labels
h=unique(y);
% y_labels hold the end labels
y_labels=h;
%%
% Theta_i_k_j- features x hidden x labels
the_i_k_j =  ones( size(x,2),length(h),length(y_labels) ) ;
% Theta_i_j=sum_k[Theta_i_k_j]- features x hidden x labels
% the_i_j =  ones( size(x,2),length(y_labels) ) ;  
% the current gradient is
% d_ln_p_y_x_d_the- x_i x y_j
d_ln_p_y_x_d_the=zeros( size(x,2),length(y_labels) ) ;
% d_ln[p(y_j|x_i)]/d_theta=...
% sum_h[ f(x,h,y)) p(h|x,y) ]-sum_y[sum_h[ f(x,h,y)) p(y,h|x) ]]
% One gadient function in 2D is not enough to  train 3D Theta
% Hence stochastic gradient descent
    
% The energy function is scalar: 
% f_comp=@(x,h,y_labels,y) x* (abs(y-y_labels)) * (abs(h-y_labels));
% x_features x  hidden labels x y_labels x time
f_energy=f_x_h_y(x,h,y,y_labels);
% marginalize time/data input
f_energy=squeeze(sum(f_energy,4));
% size(f_energy)
% Initialise the current gradient
d_ln_p_y_x_d_the=...
   squeeze( sum( f_energy.*exp(the_i_k_j.*f_energy),2 )... % first term of the derivative
    ./sum(exp(the_i_k_j.*f_energy),2))... % first term of the derivative
- repmat(  squeeze( sum(sum( f_energy.*exp(the_i_k_j.*f_energy),2 )...
    ./sum(exp(the_i_k_j.*f_energy),2),3)) ,1,length(y_labels))  ;
running_gradient=abs(sum(sum(d_ln_p_y_x_d_the)));
% the_i_j=squeeze(sum(the_i_k_j,2));
% size(squeeze( sum( f_energy.*exp(the_i_k_j.*f_energy),2 )... % first term of the derivative
%     ./sum(exp(the_i_k_j.*f_energy),2)))
% size(  squeeze( sum(sum( f_energy.*exp(the_i_k_j.*f_energy),2 )... %2nd
%     ./sum(exp(the_i_k_j.*f_energy),2),3))   )

% proposed theta -prop_the_i_k_j
prop_the_i_k_j =  ones( size(x,2),length(h),length(y_labels) ) ;
% proposed theta -prop_the_i_j
% prop_the_i_j =  ones( size(x,2),length(y_labels) ) ;  
% proposed  gradient is
% prop_d_ln_p_y_x_d_the- x_i x y_j
prop_d_ln_p_y_x_d_the=zeros( size(x,2),length(y_labels) ) ;
% propose theta
prop_the_i_k_j= the_i_k_j+...
                gauss(1)+gauss(2)*randn(size(x,2),length(h),length(h) );
% prop_the_i_j=squeeze(sum(prop_the_i_k_j) ) ; 


for iter=1:iterations % look for better candidates 
if running_gradient>accuracy
    % Compute the proposal gradient and theta
prop_d_ln_p_y_x_d_the=...
   squeeze( sum( f_energy.*exp(prop_the_i_k_j.*f_energy),2 )... % first term of the derivative
    ./sum(exp(prop_the_i_k_j.*f_energy),2))... % first term of the derivative
- repmat(  squeeze( sum(sum( f_energy.*exp(prop_the_i_k_j.*f_energy),2 )...
    ./sum(exp(prop_the_i_k_j.*f_energy),2),3)) ,1,length(y_labels))  ;    
% prop_the_i_j=squeeze(sum(prop_the_i_k_j,2));

% true     grad the=the- d_p/d_the;
% proposed grad the_p=the_p- d_p_p/d_the_p;
% the gradient is true if^
% the_p is close to the
%  d_p_p/d_the_p is close to d_p/d_the;

proposed_gradient= abs(sum(sum(prop_d_ln_p_y_x_d_the)));
 
running_gradient=abs(sum(sum(d_ln_p_y_x_d_the)))

if  proposed_gradient<running_gradient
    %acept the jump
    display('running gardinet')
    running_gradient
   the_i_k_j= prop_the_i_k_j;
   % Recalculate current gradient
d_ln_p_y_x_d_the=...
   squeeze( sum( f_energy.*exp(the_i_k_j.*f_energy),2 )... % first term of the derivative
    ./sum(exp(the_i_k_j.*f_energy),2))... % first term of the derivative
- repmat(  squeeze( sum(sum( f_energy.*exp(the_i_k_j.*f_energy),2 )...
    ./sum(exp(the_i_k_j.*f_energy),2),3)) ,1,length(y_labels))  ;

% the_i_j=squeeze(sum(the_i_k_j,2));    

end
% propose new
prop_the_i_k_j= the_i_k_j+...
                gauss(1)+gauss(2)*randn(size(x,2),length(h),length(h) );
% prop_the_i_j=squeeze(sum(prop_the_i_k_j) ) ; 
end
end

  tree.the_i_k_j=the_i_k_j;
  tree.x=x;
  tree.h=h;
  tree.y=y;
  tree.y_labels=y_labels;
  tree.f_energy=f_energy;
% tree=1;
        save('res_chmf_wsn.mat','tree')
%%        
    case 'predict',
%       tree=hcmf_doublevvinged(x(2,:),y,[0, 1],'predict',10^-1,100);tree.predict
        load('res_chmf_wsn.mat','tree')
        if exist('tree')
tree.predict=zeros(length(tree.y_labels),1);
% The energy function is scalar: 
% f_comp=@(x,h,y_labels,y) x* (abs(y-y_labels)) * (abs(h-y_labels));
% x_features x  hidden labels x y_labels x time
f_predict=f_x_h_y(x,tree.h,tree.y,tree.y_labels);
% marginalize time/data input
% f_predict=squeeze(sum(f_predict,4));
% size(f_predict)
% f_predict.*exp(tree.the_i_k_j.*f_predict)
% squeeze( sum(sum( f_predict.*exp(tree.the_i_k_j.*f_predict),1 ),2) )
% sum(sum(sum(exp(tree.the_i_k_j.*f_predict))))
tree.predict=...
squeeze( sum(sum( f_predict.*exp(tree.the_i_k_j.*f_predict),1 ),2) )...
 ./sum(sum(sum(exp(tree.the_i_k_j.*f_predict))));
tree.predict=tree.predict==max(tree.predict);

        save('res_chmf_wsn.mat','tree')
        end
end




end