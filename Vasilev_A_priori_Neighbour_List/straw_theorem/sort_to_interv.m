function int_mat=sort_to_interv(x)

% From the sorted vector x
% create a matrix specifying intervals in which x is the same


if length(x)<=1
    int_mat=0 ;
else % if length(x) > 1
    % unique labels
    uni_s= unique(x) ;
     k_start=1; % position start 
     k_end=1; % position end unque
     int_mat = zeros( length(uni_s),2 ) ;
        % for all unique labels
        for i=1: length(uni_s)
            % find the position where the label ends

                while( x(k_end)-uni_s(i) ) ==0 
                    k_end=k_end+1;
                    if k_end>= length(x)
                        % if this is the last entry
                        break
                    end
                end % while( x(k_end)-uni_s(i) ) ==0 

                    % k_end now specifies the FIRST position in x, 
                    % that is NO longer uni_s(i)
                    % is this the last unique entry
                    if  i== length(uni_s)
                        % add it to the output
                        int_mat(i,:) = [ k_start, length(x)] ;
                    else
                        % this is not the last unique entry
                        % then the previous position was the last match
                        int_mat(i,:) = [ k_start, k_end-1] ;
                        % the start of the new label is the previous end
                        k_start = k_end ;
                    end % k_end== length(x)                
        end % i=1: length(uni_s)
end % if length(x)<=1





% test

%  int_mat=sort_to_interv(x)


%    x=[2 3 3 3 3  3 4]

%    x=[2 3 3 3 3  3 4]

%    x=[2 3 3   4 4 4]





end