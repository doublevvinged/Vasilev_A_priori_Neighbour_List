function q=remove_from_q(q,k,h,r_opt)
% This function removes a packet specified by k,h from
% q.v(k).rout(h,:) and/or
% q.v(k).init(h,:)
% and fixes the position to the first empty vector in the queues

switch r_opt
    case 'rout',
        % remove a packet only from rout queue
        if q.v( k ).r>1 % is it the only packet in the queu?
        % reduce the packet position
        q.v( k ).r=q.v( k ).r-1;
        % the position r now points to the last NON empty element
        % overwrite j with r
        q.v( k ).rout( h ,1:6)=...
        q.v( k ).rout(  q.v( k ).r  ,1:6)   ;
        % set the last NON empty packet to a zero vector
        q.v( k ).rout(  q.v( k ).r  ,1:6)=zeros(1,6);
        else
        % this is the only packet in the rout queue
        q.v( k ).rout( h ,1:6)=zeros(1,6);
        end      
        
    case 'rout_init',
% remove a packet from BOTH rout and init queues
% the packet for deletion is
del_pack=q.v( k ).rout(  h ,1:6) ;

        % remove the packet from rout queue
        if q.v( k ).r>1 % is it the only packet in the queu?
        % reduce the packet position
        q.v( k ).r=q.v( k ).r-1;
        % the position r now points to the last NON empty element
        % overwrite j with r
        q.v( k ).rout( h ,1:6)=...
        q.v( k ).rout(  q.v( k ).r  ,1:6)   ;
        % set the last NON empty packet to a zero vector
        q.v( k ).rout(  q.v( k ).r  ,1:6)=zeros(1,6);
        else
        % this is the only packet in the rout queue
        q.v( k ).rout( h ,1:6)=zeros(1,6);
        end
        
        % remove the packet from init queue
        % this is a bit trickier since the loop is over all rout packets
        % therefore one first needs to match the global packet identifiers
        % q.v( v_p(i) ).rout(j,5) % and
        %  q.v( source_vertex ).rout(j,5)
        % the source vertex of the packet is
        s_ver=  del_pack(1) ;
        % q.v(  s_ver  ).init(:,5) % has the source
        % vertexs' global packet indetifiers
        % match the sourve vertex and current packet identifiers
        init_ident=q.v( s_ver ).init(:,5) ==...
        del_pack( 5) ;    
        if sum(init_ident)==1
            if q.v( s_ver ).i>1 % is it the only packet in the queu?
            % reduce the packet position
            q.v( s_ver ).i=q.v( s_ver ).i-1;
            % the position r now points to the last NON empty element
            % overwrite init_ident with .i
            q.v( s_ver ).init( init_ident  ,1:5)=...
            q.v( s_ver ).init(  q.v( s_ver ).i  ,1:5)   ;
            % set the last NON empty packet to a zero vector
            q.v( s_ver ).init(  q.v( s_ver ).i  ,1:5)=zeros(1,5);
            else
            % this is the only packet in the rout queue
            q.v( s_ver ).init( init_ident ,1:5)=zeros(1,5);
            end 
        else
            display('Warning non unique global packet identifier')
        end        
        
        
        
    otherwise
end


% % testing 
% q.v( v_p(i) ).rout
% % q.v( v_p(i) ).r
% 
% q.v( v_p(i) ).init
% % q.v( v_p(i) ).i
%         
% % remove the packet from rout and init queues
% % This function removes a packet specified by k,h from
% % q.v(k).rout(h,:) and
% % q.v(k).init(h,:)
% q=remove_from_q(q,v_p(i) , j  ,'rout_init');
% 
% q.v( v_p(i) ).rout
% % q.v( v_p(i) ).r
% 
% q.v( v_p(i) ).init
% % q.v( v_p(i) ).i
% 
% q=remove_from_q(q,v_p(i) , j  ,'rout');
% 
% q.v( v_p(i) ).rout
% % q.v( v_p(i) ).r
% 
% q.v( v_p(i) ).init
% % q.v( v_p(i) ).i
       
end %function q=remove_from_q(q,k,h)
    