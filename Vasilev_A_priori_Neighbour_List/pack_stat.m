function q=pack_stat(q,stat_opt)

% This function returs the statistics of the simulation.,
% in an efficient way.

switch stat_opt
    case 'preprocess', 
    % This step reorders the packet in the queue 
    % in order to make the packet look up efficient,
    % throught the use of binary search.
    
    % Sort the packet q with respect to the sender vertex
    [~,ind_p]=sort( q.pack(:,1) ); % and return the indexes.
    % Indermediate matrix for reordering of the q.pack.
    pack=zeros(size(q.pack));
    
    for i=1:size(pack,1)
       pack(i,:) =  q.pack( ind_p(i) ,:) ;
    end
    
    % now sort the reciever vertexes with respect to all senders
    % NOTE pack(:,1) is sorted
    un_vert= unique( pack(:,1) );
    k_start=1; % position start unque sender in pack
    k_end=1; % position end unque sender in pack
    for i=1 : length(un_vert)
        while (pack(k_end,1)-un_vert(i))==0            
            k_end=k_end+1;
            if k_end == q.k 
                break
            end
        end
    q.start_end(i,:)= [ k_start, k_end-1]  ;
    
    
    pack_1=pack(k_start:k_end-1,:);
    pack_2=pack_1;
    
    [~,ind_p]=sort( pack_1(:,2) ) ;
    for j=1:size(pack_1,1)
       pack_2(j,:) =  pack_1(  ind_p(j) ,:) ;
    end    
    
    pack(k_start:k_end-1,:)=pack_2;

    
    k_start=k_end ;
    end %i=1 : length(un_vert)
    
    
    q.start_end    ;
    q.pack= pack   ;
        
    case 'conditional_prob', 

    

    
    otherwise,
end


end