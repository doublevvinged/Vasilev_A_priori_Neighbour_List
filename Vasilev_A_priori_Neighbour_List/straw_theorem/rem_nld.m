function graph=rem_nld(vert_set_o,graph)


% ## Remove set of vertexes from Neighbour List Dynamics
% ## graph = [prototype]
% ## 
% ##            v_1: [scalar]       the central vertex
% ##              k: [scalar]       the global number of vertexes
% ##             vl: [k x 4]        the vertex list 
% ##            vld: [{kd<=k} x 2 ] the vertex list dynamics
% ##             kd: 7              the number of vertexes in vld
% ##nl.v(i \in k).v: [vect]         neighbours of vertex i from vl NOT vld
% ##nld.v(i \in k).v: [vect] = nl    neighbours of vertex i from vl dynamic NOT vld
% ## Note that the vertex set vert_set that is beeing removed is with 
% ## its original vertex labels.

if graph.kd >0 % the graph is not empty?
% %% Note: vert_set must be sorted in increasing order
% vert_set_o=sort(vert_set_o)  ; % and with its original labeles

%% I. Fix graph.vld
for i=1:length(vert_set_o) % for all vertexes that are to be removed
% original -> dynamic vertex label position in graph.vld
yes_d=bin_inc_ss( vert_set_o(i) , graph.vld(:,1) )   ; % dynamic position
rem_vert_d= graph.vld(yes_d,2)  ; % dynamic label

% does such a vertex exist
    if rem_vert_d ~=0   
    % remove the vertex from vertex dynamics list
    graph.vld(yes_d,:)=  zeros(1,5)   ;
    % for all vertexes bellow  graph.vld(yes,:)
    % decrease the vertexes' labels
    graph.vld( yes_d:graph.kd , 2)=graph.vld( yes_d:graph.kd , 2)-1   ;
    
    end %rem_vert ~=0           
    
end% i=1:length(vert_set) % for all vertexes that are to be removed


% select the non empty emtries
graph.vld= graph.vld(   graph.vld(:,1)~=0   ,:)   ;
% count the number of all vertexes
graph.kd =  size( graph.vld ,1) ; 


%% II. Fix graph.nld.v(i).v
% At this point graph.vld(:,1) contains all original vertex labels
% that are NOT deleted.
for i=1:graph.kd % for all vertexes that are NOT removed
% graph.nld.v(..).v should contain only vertexes that are NOT removed
% graph.nld.v(..).v % is sorted
% The original label of the vertex is graph.vld(i,1)
%, therefore the neighbours of the vertex i are:
% graph.nld.v( graph.vld(i,1) ).v  
% With this for loop one only fixes the neighbours of vertexes
% that are in graph.vld(:,1)

% all neighbours are with original labels
% display('For all original label vertexes that are present')
% graph.vld(i,1) 
% graph.nld.v( graph.vld(i,1) ).v 

vert_neigh_o =  graph.nld.v( graph.vld(i,1) ).v   ;% original labels

if length(vert_neigh_o)>0 % is the neigubour list of a vertex i empty?
    for j=1:length(vert_set_o) % for all vertexes that ARE removed & original labels
        % in graph.nld.v(i).v look for  vert_set(j)
        yes_o=bin_inc_ss( vert_set_o(j) , graph.nld.v( graph.vld(i,1) ).v  )  ; 
        if yes_o~=0
           vert_neigh_o( yes_o ) =0;
        end
    end %j=1:length(vert_set) % for all vertexes that ARE removed

% remove the empty etries of graph.nld.v(i).v
graph.nld.v( graph.vld(i,1) ).v=vert_neigh_o(  vert_neigh_o~=0  )  ;

end % length(vert_neigh)>0 % is the neigubour list of a vertex i empty?
end% i=1:graph.kd % for all vertexes that are NOT removed

%%
end %graph.kd >0 % the graph is not empty?

end