function test_wsn



addpath(genpath('C:\Octave\Vasilev_Octave_Scripts\Neighbour_List'))
% [~,q,data_set]=graph_nl;
% rmpath('C:\Octave\Vasilev_Octave_Scripts\Neighbour_List\straw_theorem')


close
clear
clc

n=40;

for k=1:n
display('simulation % complete')    
k/n
    
v_1_o=1;
straw=hcrf_v_g_vasilev(v_1_o) ;


% clear 
% close
% clc


load('C:\Octave\Vasilev_Octave_Scripts\Neighbour_List\results\data_set.mat','data_set','q','straw','-mat')
straw.v_1_o
straw.tree
straw.edge_prob

% 1.create data samples x
x= (randsample_vv( straw.tree(:,2),10,'true'  ))' ;
% find their respective y
y=zeros( length(x),1 );
for i=1:length(x)
y(i)=compute_prob(straw.v_1_o, x(i) ,q);
end



% 2. Make inference based on the probability tree
y_prob=zeros( length(x) ,1) ;
for i=1:length(x)
straw=straw_1(data_set,q,x(i), straw ,'inference');
y_prob(i)=straw.pr_v_2_o;
end
display('One expects that, the larger the metric')
display(' the lower the abs err must be.')
straw.metric
tree_err_abs=abs(y_prob-y)
display('y_prob should be alwmost always less than y')
sum(y_prob <= y)/length(y)

s_metric(k)=straw.metric
s_tree_err(k)= sum( tree_err_abs )/length(tree_err_abs)
s_pr_larger(k)= sum(y_prob <= y)/length(y)
end



close

figure(1)
plot( s_metric, s_tree_err ,'or','MarkerSize',10)

xlabel('Chromatic metric')
ylabel('Prob. error')
title('Chromatic metric vs Prob. error')
% print('-f1',strcat('C:\Octave\Vasilev_Octave_Scripts\Neighbour_List\results\','chromatic_metric'),'-dpdf')
print('-f1',strcat('D:\PhD_Vasilev\Dissertation_Vasilev\Dissertation_Latex_Vasilev_v1\figures\ethic_wsn\','chromatic_metric'),'-dpdf')



figure(2)
plot( s_metric, s_pr_larger ,'o','MarkerSize',10)
xlabel('Chromatic metric')
ylabel('Prob. of prob. is larger')
title('Chromatic metric vs Prob. of prob. is larger')
% print('-f2',strcat('C:\Octave\Vasilev_Octave_Scripts\Neighbour_List\results\','prob_larger'),'-dpdf')
print('-f2',strcat('D:\PhD_Vasilev\Dissertation_Vasilev\Dissertation_Latex_Vasilev_v1\figures\ethic_wsn\','prob_larger'),'-dpdf')



% plot(x,y,'--gs',...
%     'LineWidth',2,...
%     'MarkerSize',10,...
%     'MarkerEdgeColor','b',...
%     'MarkerFaceColor',[0.5,0.5,0.5])

% 
% % 3. Real HCRF
% % transform edge vertexes to path
% x_hcrf=zeros(length(x),max(straw.tree(:,3)-1)) ;
% 
% for i=1:length(x)
% vect=trace_edges(x(i),straw) ;
% x_hcrf(i, 1:length(vect) )=vect;
% end
% % y will have to be a class variable
% for i=1:length(x)
% y_hcrf(i) = randsample( [1,0],1,'true',[ y(i), 1-y(i) ] );
% end
% 
% tree=hcrf_wsn(x_hcrf,y_hcrf,[0, 2],'train',10^-4,1000)
% 
% for i=1:length(x)
% tree=hcrf_wsn(x_hcrf(i,:),y_hcrf,[0, 1],'predict',10^-4,100);
% tree.predict
% end

% test 

% x=[     -1    -1    -1    -1     1    -1    -1     1 ;
%          1     1     1     1    -1     1    -1    -1 ;
%          1     1     1    -1    -1    -1    -1    -1 ;
%          1     1    -1     1    -1     1    -1    -1  ]
%      
% y =[ 1 ;
%      1 ;
%     -1 ;
%     -1 ] 


end