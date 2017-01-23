
function vertex=cover_tree2next_vertex(graph, v_srart, v_end)
% This function finds the the next edge  in the path of a cover tree
% from v_srart to v_end
% and returns the next vertex in the path after v_start. 0 if no path exists

% Note that the output of bfs has a cover tree graph.cover_tree,
% where graph.cover_tree(:,2) is sorted and with unique entries
yes=bin_inc_s(v_end,  graph.cover_tree(:,2) ) ;

if  yes
% there is a path to that vertex
v_current=v_end ;
v_prev= graph.cover_tree(yes,1)  ;
  while v_prev~=v_srart
  yes=bin_inc_s(v_prev,  graph.cover_tree(:,2) ) ;
    v_current=v_prev  ;
    v_prev= graph.cover_tree(yes,1)  ;
  end
  vertex=v_current  ;
else
% no such path exists
vertex=0;
end
end