function simp_vert=fi_si_v(graph)

%% Find simplicial vertex
% assume there is no simplicial vertex
simp_vert=0 ;

% select a random permutation of the vertex set dynamics
v_p=randperm(graph.kd);

for i=1:graph.kd
    %v_p(i) % is the  dynamic random vertex label
%     graph.vld( v_p(i) ,1) % is the original random vertex label
    %graph.nld.v( .. ).v % are the vertex neighbours
    neigh_vert_o=graph.nld.v( graph.vld( v_p(i) ,1) ).v  ; % are the neighbours     
    % of the  random dynamic vertex
    % neigh_vert_o is with original labels
    
    count_inter=0; % counts the number of intersections
      
    % In order for a vertex to be simplicial,
    % each of its neighbours neigh_vert_o(j) must have
    % neigh_vert_o as a subset of their neighbours
    %  neigh_neigh_vert_o .
    for j=1:length(neigh_vert_o) 
    % the set of neighbours of neighbours of graph.vld( v_p(i) ,1)
%     neigh_vert_o(j)
    neigh_neigh_vert_o= graph.nld.v( neigh_vert_o(j) ).v   ; % with original labels
    sub_set=is_subset_exc_e(neigh_vert_o,... neighbours of graph.vld( v_p(i) ,1)
                            neigh_neigh_vert_o,...neighbours of neighbours of graph.vld( v_p(i) ,1)
                            neigh_vert_o(j) ); % excluding , because
    % in graph.nld.v(..).v all vertexes ARE NOT neighbours to themselves                        
            if sub_set==1
                % the intersection is a subset 
                count_inter=count_inter+1;
            else
                % vertex is not simplicial
                break
            end
        
    end %j=1:length(neigh_vert_o) % for all neighbours  neigh_vert_o

% After the evaluation of  all intersections, if the graph is simplicial
% the number of intersections count_inter for a vertex will be 
% the same as total number of neighbours of the vertex, 
if count_inter== length(neigh_vert_o)
 simp_vert=   graph.vld( v_p(i) ,1);
 break
end

end % i=1:graph.kd






end