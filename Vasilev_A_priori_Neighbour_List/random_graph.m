%% Generate a random graph 
function graph=random_graph(k,v_1,edge_prob)

% ## graph = [prototype]
% ## 
% ##            v_1: [scalar]       the central vertex
% ##              k: [scalar]       the global number of vertexes
% ##             vl: [k x 4]        the vertex list 
% ##            vld: [{kd<k}x(1+4)] the vertex list dynamics
% ##             kd: 7              the number of vertexes in vld
% ##nl.v(i \in k).v: [vect]         neighbours of vertex i from vl NOT vld
% ##nld.v(i \in k).v: [vect] = nl   neighbours of vertex i from vl dynamic NOT vld


graph.v_1=v_1; % the central vertex

graph.k=k; % the global number of vertexes
%The data model for the vertex list is in sorted order
%graph.vl=[ vertex_index,vertex_atribute1, vertex_atribute2... ]
graph.vl=[transpose(1:graph.k),zeros(graph.k,3) ];


% Create the neighbour list
for i=1:graph.k % for all vertexes
graph.nl.v(i).v=0;
end

% Fill the neighbour list
% k=0;
for i=1:graph.k % loop over all unique posible edges
    for j=i:graph.k 
        if i~=j
             % flip a coin to see if the edge will be present in the graph
             if randsample_vv( [0,1] ,1,'true',[1-edge_prob , edge_prob ])==1
                 % add the edge to vertex i
                 graph.nl.v(i).v=[ graph.nl.v(i).v , j] ;   
                 % add the edge to vertex j
                 graph.nl.v(j).v=[ graph.nl.v(j).v , i] ;                 
             end
%          k=k+1;   
        end
    end
end
% graph.k*(graph.k-1)/2
% k
% 

% Sort the neighbour list and remove the zero
for i=1:graph.k % loop over all vertexes
 graph.nl.v(i).v=sort( graph.nl.v(i).v) ;   
 graph.nl.v(i).v=graph.nl.v(i).v(  graph.nl.v(i).v~=0  );
%  i
%  graph.nl.v(i).v

end




% % check if neighbour relations go both ways
% both_ways=1;
% for i=1:graph.k   
%     if length(graph.nl.v(i).v)>0
%       for j=1 : length(graph.nl.v(i).v)
% i
% graph.nl.v(i).v % neighbours of i
% graph.nl.v(i).v(j) % the j-th neighbour of i
% graph.nl.v( graph.nl.v(i).v(j) ).v % neighbours of the j-th neigh of i
% pause
%          if  ismember( i,  graph.nl.v( graph.nl.v(i).v(j) ).v )
%          else
%              both_ways=0;
%          end
%       end   
%         
%             if both_ways==0
%             break
%             end
%     end
% end
% 
% both_ways



end