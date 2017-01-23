function path=trace_edges(vert,s)

        % First of all check if the vertex is in the tree
        pos_v = bin_inc_ss( vert , s.look_up_edge(:,1) ) ; %(1)
        if pos_v>0
            % the vertex is in the tree
            % straw.look_up_edge(pos_v,2) ;% positio in straw.tree
            % path holds the indexes of each edge of the tree
            % that form a path   from v_1 to v_2
            i=1;
            path(i)= s.look_up_edge(pos_v,2) ; %(2)
            % the real position of the vertex in tree
            %  (1) in the place of pos in (2)
            %  s.look_up_edge(bin_inc_ss( vert ,s.look_up_edge(:,1)) ,2)             
            edge= s.tree(path(i),1:2)  ;% edge
                i=2;
                while edge(1)~= s.v_1_o                  
                  path(i)= s.look_up_edge(bin_inc_ss( edge(1) ,s.look_up_edge(:,1)) ,2)  ; 
                  edge= s.tree( path(i) ,1:2)  ;% edge
                    i=i+1;
                end
            for i=1: length(path)
                s.pr_v_2_o= s.pr_v_2_o*...
                    s.edge_prob(path(i)) ;
            end
        else
            % vertex is not in the tree 
            % set output prob to lowest possible
            path(1)=0;
        end % if pos_v>0


end