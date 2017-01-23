function graph=prop_states(graph)


% ## graph = [prototype]
% ## 
% ##            v_1: [scalar]       the central vertex
% ##              k: [scalar]       the global number of vertexes
% ##             vl: [k x 4]        the vertex list 
% ##            vld: [{kd<=k} x 2 ] the vertex list dynamics
% ##             kd: 7              the number of vertexes in vld
% ##nl.v(i \in k).v: [vect]         neighbours of vertex i from vl NOT vld
% ##nld.v(i \in k).v: [vect] = nl    neighbours of vertex i from vl dynamic NOT vld
% ##
% ## AFTER initialise_wsn
% ##       area_size: [scalar]  size of the sqauare areas
% ##coordinates_edge: [k x 2 ]   2D coordinates of each vertex
% ##          states: [scalar] h number of possible covarage states
% ##  wireless_range: [1 x h]    the actual coverate states
% ##   transition_pr: [h x h] transisiton probabilities between  between covarage states
% ##               p: [1 x h] steady state of the % coverage states
% ##    state_vertex: [1 x k] current coverage state of each vertex
% ##    range_vertex: [1 x k] actual current range of each vertex




% i=1;
% graph.state_vertex(i)
% % graph.transition_pr(i,:)
% graph.transition_pr(graph.state_vertex(i),:)

% Propagathe the state of each vertex
for i=1:graph.k
graph.state_vertex(i)=randsample_vv(1:(graph.states),1,'true', ...
graph.transition_pr(graph.state_vertex(i)   ,:)     );
end

% Transform the state of the range to the actual range
function z=state2range(x,y)
% z=state2range(graph.state_vertex,graph.wireless_range)
for k=1:length(x)
    z(k)=y(x(k));
end
end %function
graph.range_vertex=state2range(graph.state_vertex,graph.wireless_range);

% Find the vertexes that are pairwise in each others range
function d=vert_dist(vert_1,vert_2,range_1,range_2)
d=(  (vert_1(1)-vert_2(1) )^2+ (vert_1(2)-vert_2(2))^2 )^0.5 ;%Eucleadan distance
d=d<range_1 & d< range_2;
end % function vert_dist

% Empty the neighbour list
for i=1:graph.k % for all vertexes
graph.nl.v(i).v=0;
end

% Fill the neighbour list
for i=1:graph.k % loop over all unique posible edges
    for j=i:graph.k 
        if i~=j
% if the vertexes are in each other's range then set them as neighbours
d=vert_dist(...
 graph.coordinates_edge( i ,:) ,... vert_1
 graph.coordinates_edge( j ,:) ,... vert_2
 graph.range_vertex( i )            ,...  range_1
 graph.range_vertex(j )            ) ;% range_2            
             
             if d
                 % add the edge to vertex i
                 graph.nl.v(i).v=[ graph.nl.v(i).v , j] ;   
                 % add the edge to vertex j
                 graph.nl.v(j).v=[ graph.nl.v(j).v , i] ;                 
             end
  
        end
    end
end


% Sort the neighbour list and remove the zero
for i=1:graph.k % loop over all vertexes
 graph.nl.v(i).v=sort( graph.nl.v(i).v) ;   
 graph.nl.v(i).v=graph.nl.v(i).v(  graph.nl.v(i).v~=0  );
end



% % check if neighbour relations go both ways
% both_ways=1;
% for i=1:graph.k   
%     if length(graph.nl.v(i).v)>0
%       for j=1 : length(graph.nl.v(i).v)
% % i
% % graph.nl.v(i).v % neighbours of i
% % graph.nl.v(i).v(j) % the j-th neighbour of i
% % graph.nl.v( graph.nl.v(i).v(j) ).v % neighbours of the j-th neigh of i
% % pause
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
% both_ways


end %function graph=propagate_markov_states(graph)

