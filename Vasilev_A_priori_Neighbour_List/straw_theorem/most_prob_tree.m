function [ ind , y ]=most_prob_tree( x )

% save the input
y=x ;

% Remove all duplicate trees from x      
% by replacing all matches mith its first occurance
for i=1: size(x ,1)
x(:,1)  = rep_all_bin_mat( x(i,2),  x(i,1) , x(:,1) ) ;
x(i,2)=x(i,1);
end % for i=1: size(x ,1)

% all elements of x(:,1) and x(:,2) contain the unique trees' indexes
% the unique trees are
t_un= unique(x(:,1)) ;

% intermediate calculations
appear_t=t_un;

for i=1:length(t_un) % for all trees
    % how many times does a tree appear in the data set?
    appear_t(i)= sum(x(:,1)==t_un(i));
end

% the most probable tree is then
[~,k]=max(appear_t);
ind = t_un(k) ;

% return also the indexes of the input, where 
% the trees are the same
y= y(x(:,1) == ind , :) ;
y= unique( y(:) ) ;



%Test
%  [ test_ind , y_test]=most_prob_tree( x )

% x=[  1     2;
%      1     3;
%      1     4;
%      1     6;
%      2     3;
%      2     4;
%      2     6;
%      3     4;
%      3     6;
%      4     6  ]

% x=[  1     2;
%      1     3;
%      1     4;
%        6 7;
%        6 8;
%        6 9 ;
%        6 10 ;]



   




end % function ind=most_prob_ind( i_mat)