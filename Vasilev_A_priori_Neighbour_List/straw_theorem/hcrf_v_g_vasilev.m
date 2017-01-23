% function hcrf_v_g_vasilev
function straw=hcrf_v_g_vasilev(v_1_o)

addpath(genpath('C:\Octave\Vasilev_Octave_Scripts\Neighbour_List'))


[~,q,data_set]=graph_nl;
% rmpath('C:\Octave\Vasilev_Octave_Scripts\Neighbour_List\straw_theorem')

% clear 
% close
% clc

load('C:\Octave\Vasilev_Octave_Scripts\Neighbour_List\results\data_set.mat','data_set','q','-mat')


%% Requires (example of data_set.s(1))
%                  v_1: 1
%                    k: 7
%                   vl: [7x4 double]
%                   nl: [1x1 struct]
%            area_size: 10
%     coordinates_edge: [7x2 double]
%               states: 2
%       wireless_range: [7 8 9]
%        transition_pr: [2x2 double]
%                    p: [0.7311 0.2689]
%         state_vertex: [1 1 1 1 1 2 1]
%         range_vertex: [7 7 7 7 7 8 7]


%% Initial straw process with graph_to_dynamic
% 1. Create the dynamic structure that is used by the simplicial decomposition
%      data_set.time=T ;
%      data_set.s(j).v_1= graph.v_1  ;      
%        data_set.s(j).kd= data_set.s(j).k ;     
%        data_set.s(j).nld= data_set.s(j).nl ;      
%        data_set.s(j).vld =...
%        [data_set.s(j).vl(:,1) , data_set.s(j).vl(:,1),...
%         zeros(data_set.s(j).k,3)]       ;
data_set= straw_1(data_set,0,0,0,'graph_to_dynamic') ;

% 2. Create trees rooted at v_1_o.
% v_1_o=1;
straw=straw_1(data_set,q,v_1_o,0,'tree_vertex');

% 3. Make inference based on the probability tree
v_2_o=3;
straw=straw_1(data_set,q,v_2_o, straw ,'inference');
straw.pr_v_2_o

pr=compute_prob(v_1_o, v_2_o ,q)
% straw.pr_v_2_o == shoud be the same as pr
% straw.pr_v_2_o is the worst case probability

save('C:\Octave\Vasilev_Octave_Scripts\Neighbour_List\results\data_set.mat','data_set','q','straw','-mat')

end