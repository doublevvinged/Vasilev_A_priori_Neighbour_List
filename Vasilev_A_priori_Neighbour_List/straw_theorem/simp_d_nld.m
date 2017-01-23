function sigma=simp_d_nld(graph,opt_sim,vertex_set)


% ## Simplicial Decomposition from Neighbour List Dynamics
% ## graph = [prototype]
% ## 
% ##            v_1: [scalar]       the central vertex
% ##              k: [scalar]       the global number of vertexes
% ##             vl: [k x 4]        the vertex list 
% ##            vld: [{kd<=k} x 2 ] the vertex list dynamics
% ##             kd: 7              the number of vertexes in vld
% ##nl.v(i \in k).v: [vect]         neighbours of vertex i from vl NOT vld
% ##nld.v(i \in k).v: [vect] = nl    neighbours of vertex i from vl dynamic NOT vld
% ## Decomposition is done on the connected component of v_1 vertex.
% ## The function uses  rem_nld ,simp_find, bin_inc_s, bfs_nld.

% ALL FUNCTIONS TAKE AS INPUT ORIGINAL UNIQUE LABELS
% AND TRANSLATE TO DYNAMIC AND BACK TO ORGINAL INTERNALLY IF NEEDED

% The simplicial decomposition function operates on copies of
% k, vl and nl, namely 
% kd,vld,   nld.

% There  are custom function that emplement
% removal of a vertex set from vl to vld and from nl to nld - rem_nld
% finding a simplicial vertex - simp_find
% binary serach in increasing order for speed - bin_inc_s
% bfs_nld on nld and vld to check connectivity and plot


switch opt_sim
    case 'full_decomp',
% First one resets the dynamic part of the structure
% graph.kd=graph.k  ; % reset the number of vertexes
% graph.vld=[ graph.vl(:,1), graph.vl ]  ;% reset the vertex list dynamics
% graph.nld=graph.nl   ; % reset the neighbour list dynamics

% graph.sigma(i,:)=
% [simplicial_vertex, number of neighbours simplicial_vertex has]

% Selec the connected component, to which the cetral 
% vertex graph.v_1 belongs.

% graph.v_1 % is the original label of the central vertex

% It is important to note at this point that both
% graph.vl and grapg.vld are sorted increasingly column wise,
% therefore each translation from original to dynamic label and
% backwards is done efficienlty in logarithmic time
% with binary search ( bin_inc_s).

%%
% original -> dynamic vertex label position in graph.vld
% yes=bin_inc_s( graph.v_1 , graph.vld(:,1) )
% graph.vld(yes,2)

% dynamic -> original vertex label position in graph.vld
% yes=bin_inc_s( graph.v_1 , graph.vld(:,2) )
% graph.vld(yes,1)
%%

graph_bfs=bfs_nld(graph, graph.v_1 ,graph.kd+1,'cover_tree');

% The set of vertexes, to which graph.v_1 has a path to is the connected
% component. The compliment of that set must be removed.
com_con=graph_bfs.vl(graph_bfs.vld(:,3)==0 ,1)  ;

% Note that the vertex set that is beeing removed is with 
% its original vertex labels .
% Remove the vertexes that are not in the connected component of graph.v_1
graph=rem_nld(com_con,graph) ;
% Set the decomposition matrix
sigma=zeros(graph.kd ,2 )   ;

for i=1:graph.kd % for all vertexes
% %% test the simplicial decomposition
% close all
% if size(graph.vld,1)>1
%  plot_wsn_nld(graph,'Decomposition')
%  pause
% end
% %%
    % find a simplicial vertex    
    simp_vert=fi_si_v(graph);
    if simp_vert~=0
        % For A reason one wants the central vertex to be the
        % last vertex in the decomposition
            % If the graph is not chordal then there might be 
            % only one simplicial vertex then try a bunch of times
            a_bunch_of_times=1;
            for kk=1:a_bunch_of_times %  
                if ~and(simp_vert==graph.v_1 , i < size(sigma,1))
                % each chordal graph has at least 2 simplicial vertexes
                % because the order on which each vertex is tested is random
                % one expects this while loop to end quickly.
                break
                end
                simp_vert=fi_si_v(graph)    ;
            end
            % no other that the central vertex was found
            if kk>= a_bunch_of_times
                simp_vert=fi_nons(graph) ;
            end
        
        % add the vertex to the decomposition
        sigma(i,:)=...
        [simp_vert,  length(graph.nld.v(simp_vert).v )]   ;
        % remove the vertex 
        graph=rem_nld(simp_vert,graph) ;
    else
        % there is no simplicial vertex
        % find a non siplicial vertex with the lowest degree
        simp_vert=fi_nons(graph) ;
        % add the vertex to the decomposition
        sigma(i,:)=...
        [simp_vert,  length(graph.nld.v(simp_vert).v )]   ;
        % remove the vertex 
        graph=rem_nld(simp_vert,graph) ;                
    end
end

%% Test the full simplicial decomposition 
% Plots the graph
% plot_wsn_nld(graph,strcat('net','\','Network'))
% find simplicial vertex
% simp_vert=0;
% while or( simp_vert==0 ,simp_vert==graph.v_1)
% simp_vert=fi_si_v(graph);
% end
% simp_vert
% % remove simplicial vertex
% graph=rem_nld(simp_vert,graph);
% close all
% plot_wsn_nld(graph,strcat('net','\','Network'))
%%

        
    case 'part_decomp',
        sigma=0 ;
        % First remove the compliment of the desired vertex set
        vertex_labels= graph.vld(:,1) ;
        compl_vertex_set=logical(zeros( graph.kd,1 ))  ;
        for i=1:  graph.kd
            if  bin_inc_ss( graph.vld(i,1)  , vertex_set  )==0
            compl_vertex_set(i)=  logical(1) ;
            end
        end
        % remove the compliment
        graph=rem_nld(  graph.vld(compl_vertex_set,1) ,graph) ;
        % check if the new graph is connected        
        graph_bfs=bfs_nld(graph, vertex_set(1) ,graph.kd+1,'no_cover_tree');
        if sum(graph_bfs.vld(:,3)==0)>0
        % graph is disconnected
%         display('graph is disconnected')
        else
            if size(graph_bfs.vld,1)>1 % has more than 1 vertex
        % then call the decomposition function with full decomp option       
         sigma=simp_d_nld(graph_bfs,'full_decomp',1) ;            
            end
        end
        
    otherwise ,
        display('Unknown option for simplicial decomposition')
end






end