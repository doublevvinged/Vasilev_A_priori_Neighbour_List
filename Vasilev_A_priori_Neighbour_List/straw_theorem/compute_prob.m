function pr=compute_prob(v_1, v_2 ,q)



       % for sender , find any position  in the q.pack
        r_posit= bin_inc_ss( v_1 , q.pack(:,1) )  ;
            if  r_posit>0
                yes=closest_match_miss(r_posit ,q.start_end(:,1) ) ;  
                if yes==0
                 sender_pack=...
                 q.pack(q.start_end(1,1):q.start_end(1,2),:); 
                else  % yes>0
                        if yes>=size(q.start_end,1)
                         sender_pack=...
                         q.pack(q.start_end(size(q.start_end,1),1):q.start_end(size(q.start_end,1),2),:);                             
                        else % yes is in range
                         sender_pack=q.pack(q.start_end(yes,1):q.start_end(yes,2),:);
                        end
                end
%                 sender_pack(:,2)==straw.tree(i,2) 
                % count successfull packets
                p=sum(sender_pack( sender_pack(:,2)== v_2 , 5)==1) ;
                % count total packets
                p_norm=sum( sender_pack(:,2)==v_2 ) ;
                if p_norm==0
                    pr=-1;% no stats on this edge
                else
                pr=p/p_norm;
                end
            end



end