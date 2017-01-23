function straw= straw_1(data_set,q,v_1_o,straw,opt_straw)




%% Requires
%  data_set.time=T ;
%    data_set.s(i).v_1=graph.v_1  ;      
%    data_set.s(i).k=graph.k  ; 
%    data_set.s(i).vl=graph.vl  ;  
%    data_set.s(i).nl=graph.nl ;    
%    data_set.s(i).kd=graph.kd  ;   
%    data_set.s(i).vld=graph.vld  ;
%    data_set.s(i).nld=graph.nld  ;

% addpath(genpath('C:\Octave\Vasilev_Octave_Scripts\Neighbour_List'))


switch opt_straw
    case 'graph_to_dynamic'
% ## graph = [prototype]
% ## 
% ##            v_1: [scalar]       the central vertex
% ##              k: [scalar]       the global number of vertexes
% ##             vl: [k x 4]        the vertex list 
% ##            vld: [{kd<k}x(1+4)] the vertex list dynamics
% ##             kd: 7              the number of vertexes in vld
% ##nl.v(i \in k).v: [vect]         neighbours of vertex i from vl NOT vld
% ##nld.v(i \in k).v: [vect] = nl   neighbours of vertex i from vl dynamic NOT vld
 
% A vertex list dynamic  will keep track of the deleted vertexe's indecies is sorted order
%graph.vld=[ original_vertex_index, current_vertex_index,...]
% graph.vld=[transpose(1:graph.k), graph.vl ];
% graph.kd=graph.k; % is the number of vertexes in the lvd        


for i=1:data_set.time
    % total number of vertexes
    data_set.s(i).kd = data_set.s(i).k ;
    % vertex list dynamic
    data_set.s(i).vld= [ data_set.s(i).vl(:,1),data_set.s(i).vl(:,1),...
        zeros(data_set.s(i).k,3)] ;
    % save the original graph structure
    data_set.s(i).nld=data_set.s(i).nl;
    straw=data_set;
end

 
    case 'tree_vertex', % Find the II grapf of v_1
        
 straw = struct('v_1_o',v_1_o,'time',data_set.time) ; % initilise root
 
% 1. Compute cover trees for all data sets rooted at   v_1_o
for i=1:straw.time      
 x = ...
     bfs_nld (data_set.s(i),v_1_o,data_set.s(1).k+1,'cover_tree') ;
% update straw
 straw.s(i).cover_tree = [x.cover_tree, zeros(size(x.cover_tree,1),1) ] ;
% straw.s(i).cover_tree 3-dr column will contain the bfs stages of an ege
 for j=1: data_set.s(i).kd
     if and (x.vld(j,1) ~= v_1_o , x.vld(j,3)~=0 )
         yes=bin_inc_ss( x.vld(j,1) , x.cover_tree(:,2) ) ;
         if yes ~=0
        straw.s(i).cover_tree( yes ,3 )= x.vld(j,3) ;
         end
     end
 end

%  straw.s(i).cover_tree= [edge_from , edge_to, bfs_stage]
% straw.s(i).cover_tree % is sorted by  edge_to

end % for i=1:data_set.time



% 2. Next sort each tree with respect to the bfs stage 
straw.max_bfs_stage=0;
 for i=1:size(straw.s,2)
     [~,ind_s]=sort( straw.s(i).cover_tree(:,3)  ) ;
     cover_tree=zeros(size(straw.s(i).cover_tree));
     for j=1: size( straw.s(i).cover_tree ,1 )
         cover_tree( j,1:3 )= straw.s(i).cover_tree( ind_s(j) ,1:3) ;
     end
     straw.s(i).cover_tree=cover_tree;
          
     % map the position of each bfs stage in the cover tree
    straw.s(i).stages = sort_to_interv( straw.s(i).cover_tree(:,3) ) ;
    if size( straw.s(i).stages , 1 ) > straw.max_bfs_stage
        straw.max_bfs_stage = size( straw.s(i).stages , 1 );
    end
 end %  for i=1:size(straw.s,2)

 



 
 % 3 Most probable sub-tree 
 same_trees = 1 : straw.time ; 
for j=1: straw.max_bfs_stage  % for all possible stages
    same_at_bfs_j=[0,0]; % indicates if two subtrees rooted at j are the same
    for i=1: length(same_trees) % for all time
       if size(straw.s(same_trees(i)).stages,1) >= j % if the tree i has such a stage
        for k=i:length(same_trees) % for all time
            if size(straw.s(same_trees(k)).stages,1) >= j % if the tree  k has such a stage
                if i~=k   
                %      straw.s(i).cover_tree 
                %      straw.s(i).stages
                % a subtree i rooted at bfs stage j
        %         straw.s(i).cover_tree( 1:straw.s(i).stages(j,2), :  )
                % another sub-tree k rooted at bfs j       
        %         straw.s(k).cover_tree( 1:straw.s(k).stages(j,2), :  )

%                     straw.s(same_trees(i)).stages
%                     straw.s(same_trees(k)).stages

                % if the size of the subtrees is the same
                    if size(  straw.s(same_trees(i)).cover_tree( 1:straw.s(same_trees(i)).stages(j,2), :  )  ,1)...
                            ==size( straw.s(same_trees(k)).cover_tree( 1:straw.s(same_trees(k)).stages(j,2), :  ) ,1)
                        % if the trees are the same
                        if sum(sum( straw.s(same_trees(i)).cover_tree( 1:straw.s(same_trees(i)).stages(j,2), :  ) ...
                        - straw.s(same_trees(k)).cover_tree( 1:straw.s(same_trees(k)).stages(j,2), :  ) ))==0
                        same_at_bfs_j=[same_at_bfs_j; same_trees(i), same_trees(k) ];
                        end % same                
                    end % is size is the same        
                end % if i~=k
            end % if size(straw.s(k).stages,1) >= j
        end % k=i:length(same_trees) % for all time
       end % if size(straw.s(i).stages,1) >= j 
    end % i=1: length(same_trees)  % for all time
    % remove zero entry
    if size(same_at_bfs_j,1)>1
    % there are matches
    same_at_bfs_j = same_at_bfs_j ( 2: size(same_at_bfs_j,1) ,:);
    % most probable sub-tree   so far
    [ind  , same_trees]=most_prob_tree( same_at_bfs_j) ;    
    straw.tree =  straw.s(ind).cover_tree( 1:straw.s(ind).stages(j,2), :  ) ;
    straw.ind_tree=ind ;


        % the trees that matched the most probable trees are
%         same_trees
    else
        %no matches found
    end % if size(same_at_bfs_j,1)>1

    % MOST PROBABLE TREE SEARCHES CAN BE SPEAD UP BY KEEPING TRACK
    % OF THE TREES THAT CAN BE THE SAME. 
    % THIS IS DINE USING same_trees

    
end  % for j=1: size(straw.s(i).stages,1)   
 % save also the intervals of the most probable tree
 straw.s_tree=sort_to_interv(straw.tree(:,3));

% 4. Backtrack BFS
%  straw.tree % =[vert_from , vert_to, bfs_stage]
 straw.tree=[straw.tree , zeros(size(straw.tree,1),1 )];
 %  straw.tree % =[vert_from , vert_to, bfs_stage, hyper_edge_identifier]
%  straw.ind_tree  
%  straw.s_tree
% keep track of the straw mettric
straw.metric=0 ;

 count_edges=1;
 % find the hyper-edges
 for i=1: size(straw.s_tree,1) % for all stages
     % a probable hyper edge with given bfs_stage is
     prob_edge=straw.tree( straw.s_tree(i,1):straw.s_tree(i,2)  ,1:2 ) ;
     % the actual  hyper edges are defiend by the previous vertex prob_edge(i,1)
     un_edge=unique(prob_edge(:,1));     
     for j=1:length(un_edge)
      % the positions of an unique hyper edge   
%     (straw.tree(:,1)==un_edge(j))
      % indetify a new hyper_edge
 straw.tree( straw.tree(:,1)==un_edge(j) ,4 )= count_edges ;
count_edges=count_edges+1 ;

hyper_edge= prob_edge( prob_edge(:,1)==un_edge(j),1:2 );
        hyper_edge= unique(hyper_edge(:)) ;
            for t = 1: straw.time
            data_set.s(t).v_1= hyper_edge(1) ;
%             print_neigh(data_set.s(t))
            sigma=simp_d_nld(data_set.s(t),'part_decomp',hyper_edge)    ;       
            metric=chrom_metric(sigma, data_set.s(t).k); % chromatic polynomial                      
            straw.metric= metric + straw.metric;
            end %t = 1: straw.time          
     end %j=1:length(un_edge)
 end % i=1: size(straw.s_tree,1) % for all stages


%     straw.tree    
    % compute the edge probabilities
    straw.edge_prob=zeros( size(straw.tree,1),1 );
    for i=1:size(straw.edge_prob,1)
        % for all edges
%         straw.tree(i,1:2)
        straw.edge_prob(i)=compute_prob(straw.tree(i,1), straw.tree(i,2) ...
            ,q);
        
    end % i=1:size(straw.edge_prob,1)
    % also make a pointer to sorted edges to speed up backtrack
      straw.look_up_edge = zeros( size(straw.tree,1) ,2) ;
      [straw.look_up_edge(:,1) ,straw.look_up_edge(:,2) ] = ...
          sort( straw.tree(:,2) ) ;
      
%     q.pack
%     q.start_end
%     straw.edge_prob
straw = rmfield(straw , {'time', 's', 'max_bfs_stage', 'ind_tree'});
                  
     
    case 'inference'
        % in this case the input to the function is with a new wertex
        v_2_o=v_1_o;
        straw.pr_v_2_o=1;
%         straw.v_1_o % is the vertex with respect to which on trained the tree
        path=trace_edges(v_2_o,straw) ;
        if path(1)>0
            for i=1: length(path)
                straw.pr_v_2_o=straw.pr_v_2_o*...
              straw. edge_prob(  path(i) ) ;
            end
        end


    otherwise,

end % switch opt_straw




end % function straw= straw_2(data_set,v_1_o,straw,opt_straw)

