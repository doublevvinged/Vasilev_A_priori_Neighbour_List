function tree=cmf_wsn(x,y,train_pred,step_param,num_iterations)

%% A conditional Markov field is a graph model
% 
% for a graph_x and a graph_y
%  Clique_I
% X_I---X_J
% X_I---X_J
% .
% .
% .
%  Clique_II
% X_I---X_J
% X_I---X_J
% Here graph_x is latticed
% P(x)=exp[ sum(a_ij*x_i*x_j)+ sum(b_i*x_i) ]

% Conditioning
% X_I--Y_j
% The conditinal distribution is:
% P(Y|X)=1/norm* exp[ sum(theta_x_y*F(X,Y)) ]
% Joint distribution
% P(x,y)=p(y|x)P(x)
% P(x,y)=exp[ sum(a_ij*x_i*x_j)+ sum(b_i*x_i)+ sum(theta_x_y*F(X,Y))]

% P(x,y)=exp[ sum(a_ij*x_i*x_j)+ sum(b_i*x_i)+ sum(g_ik* x_i*y_k) ]

%d_ln[p(x,y)]/d_b_i=x_i
%d_ln[p(x,y)]/d_a_ij=x_i*x_j
%d_ln[p(x,y)]/d_g_ij=x_i*y_j


%% Specify 
% x-examples x features 
% y =label of the data, - examples x 1
% train_pred 1 train theta ,2 estimate
% step_param, for gradient descent a,b,g
% num_iterations
       
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



switch  train_pred,
    case 'train',
%% Train theta 

% tree=cmf_doublevvinged(x,y,1,[10^-3,10^-3,10^-3],100) 

% y- exaples x 1;
% x- examples x features
tree.feat_y=unique(y); % the vertexes of the labels
tree.feat_x=size(x,2); % the vertexes of the data
 % initialise alpna - features x features
tree.alpha=ones(tree.feat_x,tree.feat_x);
tree.alpha_next=tree.alpha;
% initialise betta - features x 1
tree.betta=ones(tree.feat_x,1);
tree.betta_next=tree.betta;
% initialise gamma- feature x labels
tree.gamma=ones(tree.feat_x,length(tree.feat_y));
tree.gamma_next=tree.gamma;
% Train using gradient descent
for t=1:num_iterations
      for i=1:tree.feat_x % for all features x_i
          % update betta
tree.betta_next(i,1)=tree.betta(i,1)-sum(x(:,i))*step_param(2);
          % update alpha
           for j=1:tree.feat_x % for all features x_i*x_j
tree.alpha_next(i,j)=tree.alpha(i,j)-sum( x(:,i).*x(:,j) )*step_param(1);
           end
            % update gamma
           for k=1:length(tree.feat_y) %for all features x_i*y_k
tree.gamma_next(i,k)=tree.gamma(i,k)-sum( x(:,i).*(y==tree.feat_y(k)) )*step_param(3);               
           end
     tree.alpha=tree.alpha_next;   
     tree.betta= tree.betta_next;
     tree.gamma=tree.gamma_next;
      end
     
end
tree.x_trained=x;
tree.y_trained=y;

        save('res_cmf_wsn.mat','tree')
    case 'predict', 
%% predict on x
%    tree=cmf_doublevvinged([0 1 0 ],[0 1],2,[10^-1,10^-1,10^-1],100)
%           tree=cmf_doublevvinged([1 0 1 ],[0 1],2,[10^-1,10^-1,10^-1],100)
        load('res_cmf_wsn.mat','tree')
        if exist('tree')
        tree.predict_y=zeros(length(tree.feat_y),2);
        % predict label
        for k=1:length(tree.feat_y) %for all features x_i*y_k
        tree.predict_y(k,1)=x*tree.gamma(:,k);
        end
       % Compute likelihood of the data 
%         tree.predict_y(1,2)=x*tree.betta;
          % update alpha
          for i=1:tree.feat_x
           tree.predict_y(1,2)=x(i)* tree.betta(i)+tree.predict_y(1,2);  
           for j=1:tree.feat_x % for all features x_i*x_j
        tree.predict_y(1,2)=tree.alpha(i,j)*x(i)*x(j) +tree.predict_y(1,2);
           end
          end
% tree.predict_y(:,2)=tree.predict_y(:,1)/tree.predict_y(1,2);
tree.predict_y(:,1)=tree.predict_y(:,1)==max(tree.predict_y(:,1));
%         save('cmf_doublevvinged.mat','tree')
        else
            display('train the data first')
        end
        
    case 'evidence',
        %% compute likelihood of the trained data
%         tree=cmf_doublevvinged(3,1,3,[1,1,1],1)
        load('res_cmf_wsn.mat','tree')
        if exist('tree')
        tree.evidence=zeros(size(tree.x_trained,1),1);
       % Compute likelihood of the data 
%         tree.predict_y(1,2)=tree.x_trained*tree.betta;
for k=1:size(tree.x_trained,1) % for all data
          for i=1:tree.feat_x
           tree.evidence(k)=tree.x_trained(i)* tree.betta(i)+tree.evidence(k);  
           for j=1:tree.feat_x % for all features x_i*x_j
        tree.evidence(k)=tree.alpha(i,j)*tree.x_trained(i)*tree.x_trained(j) +tree.evidence(k);
           end
          end
end
        save('res_cmf_wsn.mat','tree')
        else
            display('train the data first')
        end
end    


end