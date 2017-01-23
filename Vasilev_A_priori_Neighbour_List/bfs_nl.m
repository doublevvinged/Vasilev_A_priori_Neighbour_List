function graph_bfs=bfs_nl(graph,v_start,v_final,cover_tree)

% ##% This function implements breadth first search 
% ##% using the graph's vertex_list and neighbour_list
% ## graph = [prototype]
% ## 
% ##            v_1: [scalar]       the central vertex
% ##              k: [scalar]       the global number of vertexes
% ##             vl: [k x 4]        the vertex list 
% ##            vld: [{kd<=k} x 2 ] the vertex list dynamics
% ##             kd: 7              the number of vertexes in vld
% ##nl.v(i \in k).v: [vect]         neighbours of vertex i from vl NOT vld
% ##nld.v(i \in k).v: [vect] = nl    neighbours of vertex i from vl dynamic NOT vld
% ## Author: doubblevvinged

%Initial vertex
graph.vl( v_start,2)=1;
% Current state of seen vertexes is
bfs_stage=0; %max(graph.vertex(:,2));
% Is there a next stage ?
next_bfs=1;
% This function can also build a cove tree
if exist('cover_tree')
graph.cover_tree=zeros(graph.k-1,2) ;% cover_tree=[edges]
k_edge=1; % counts the edges
end

while( next_bfs==1 )
  %  Current state of bfs iterations
  bfs_stage= bfs_stage+1  ;
  %  The set of vertexes that are explored at stage bfs_stage
  vertex=graph.vl(  graph.vl(:,2)==bfs_stage ,1);
  
  % Check if the final have been reached
  final_reached=0;
  if sum(vertex==v_final) %final reached?
  final_reached=1;
  next_bfs=0 ;
  break  
  else%sum(vertex==v_final) %final reached? final NOT reached?
    no_new_vert=zeros(length(vertex),1)  ;% accounts for the remaining unexplored vertexes
       for i = 1:length(vertex)  % for all current vertexes
            % the vertexes that are neighbours to the cerrent vertex vertex(i)     
              neigh_vert=graph.nl.v(  vertex(i) ).v   ;    
              % One needs to keep track of how many vertexes are remaining 
              neigh_vert_no_new=0 ;
              for j =1:length(neigh_vert) % for all neighbours of the current vertex(i)
                if graph.vl(neigh_vert(j),2)==0  % if the neighbour is unexplored set for the next stage
                  graph.vl(neigh_vert(j),2)=bfs_stage+1   ;  
                      % If needed add an edge to the cover tree
                      if exist('cover_tree')
                      graph.cover_tree(k_edge,:)=[ vertex(i), neigh_vert(j) ];% cover_tree=[edges]
                      k_edge=k_edge+1; % counts the edges
                      end
                else 
                neigh_vert_no_new=neigh_vert_no_new+1 ;
                end
              end
%             # If all neighbours of vertex(i) were already explored ,then   
            if neigh_vert_no_new==length(neigh_vert)
             no_new_vert(i)=1 ; %vertex(i) adds no new neighbours            
             end %of for all current vertexes
          %after all vertex(i)'s neighbours were explored
          %check if there were any vertexes left for the next bfs_stage
          if(sum(no_new_vert)==length(vertex) )
%          no_new_vert
            next_bfs=0 ;
            break
          end
      end % i = 1:length(vertex)  % for all current vertexes
  end %sum(vertex==v_final) %final reached?
  

end % while( next_bfs==1 )

% graph.cover_tree

if exist('cover_tree')
k_edge=k_edge-1;
% graph.cover_tree(k_edge+1,1)==0
%graph.n
% If the graph is disconnected disselect empty edges
  if k_edge< graph.k-1
  graph.cover_tree=graph.cover_tree(1:k_edge,:) ;
  end
 % Note that graph.cover_tree(:,2) has unique entries
  % Next, sort the tree by graph.cover_tree(:,2)
  [~,ind_tree]=sort( graph.cover_tree(:,2) );
  cover_tree=graph.cover_tree  ;
  for i=1:size(graph.cover_tree,1)
  graph.cover_tree(i,:)=cover_tree(ind_tree(i),: ) ;
  end
        if k_edge>0 % is the component trivial?
        else
            % component has only one vertex
            graph.cover_tree=[0,0];
        end  
end

graph_bfs=graph;




end